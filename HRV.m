close all;
clear;

%% 讀取檔案 (data, time), 每個檔案為五分鐘
ECGFILE = table2cell(readtable('./datas/20190411-210637.dat', 'Format', '%f%s' ));

% 切割成五分鐘後的資料 (總資料, 共幾段五分鐘)
[t5MINS, Len] = DataSplit(ECGFILE, 5);


%% 計算全體 QRS, RRI
% 從 cell 解構出來並指定取得第一欄所有資料
Datas     = []; % 用於整體計算 QRS
Times     = []; % 用於整體計算 RRI
DataCells = []; % 用於個別計算 QRS
TimeCells = []; % 用於個別計算 RRI
for i=1:Len
    Data = t5MINS{:,i};
    DataCells{i} = cell2mat(Data(:,1));
    Datas = [ Datas ; cell2mat(Data(:,1)) ];
    TimeCells{i} = Data(:,2);
    Times = [ Times ; Data(:,2)];
end

% 利用 pan_tompkin 演算法找到 QRS
% map = 濾波後的電位差, r = R峰索引值
[map, r, delay] = pan_tompkin(Datas, 200, 0);


% s = abs(fft(map));
% subplot(2,1,1), plot(s);    % 顯示頻譜
% subplot(2,1,2), plot(map);    % 顯示波形

%%
% 指標 - 總平均心跳次數 Len*5分鐘, Len 為五分鐘的個數
[a, len] = size(r);
HR = len/(Len*5);

% 指標 - RRI
RRI = RR_Interval(r, Times);

% 指標 - NN50
[NN50, pNN50]= HRV_pNN50(RRI);

% 指標 - r-MSSD
[a, rrLen]=size(RRI);
for i=2:rrLen
  rMSSD_ARR(i-1) = abs(RRI(i) - RRI(i-1));
end
rMSSD = sqrt(sum(rMSSD_ARR.^2));

% 指標 - Mean NN(ms) Normal-to-Normal (NN) intervals
MeanNN = mean(RRI);

% 指標 - SDNN(ms) standard deviation of all normal to normal intervals
SDNN = std(RRI);

%% 個別的 SDNN, SDANN_Index
for i=1:Len
    dc = DataCells{:,i};
    dc = dc(:,1);
    [map, r, delay] = pan_tompkin(dc, 200, 0);
    
    tc = TimeCells{:,i};
    tc = tc(:,1);
    RRICell = RR_Interval(r, tc);
    MeanNNCells(i) = mean(RRICell);
    SDNNCells(i) = std(RRICell);
    
    [a, len] = size(r);
    HRCells(i) = len/5;
    
    RRICells{i} = RRICell;
    
    y=interp1(r(2:209),RRICell(2:209),r(2):1:r(209),'spline');  %利用插值法求出以原ecg信?的采?率fs的?合函?
    
    %plot(y);hold on,
    %scatter(r(2:19)-r(2),RRICell(2:19));

    N=length(y);
    N1=210; %確定頻率軸的範圍 每一單元為fs/N=0.06Hz
    AF=fft(y);
    AF=abs(AF); %求出傅立葉變換後的幅頻特性
    
    f=(0:N1-1)*200/N; 
    figure,plot(f,AF(1:N1))
    title(['HRV 頻譜分析 - ' num2str(i)])
    xlabel('Frequency [Hz]')
    ylabel('Power [ms^{2}]');

end

% 指標 - SDANN_Index(ms) 先平均值再標準差
SDANN = std(MeanNNCells);
%

% 指標 - SDANN_Index(ms) 先標準差再平均值
SDANNIndex = mean(SDNNCells);
