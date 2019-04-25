function [HRV, Header] = getHRV(Stage, RRI, chartHist, chartPSD, convert2table)
%HRV 計算時域與頻域指標

%% Input
% RRI = RRI R波心律間隔
% chartHist = 顯示 RRI 累計次數表, 1=顯示, 0=不顯示
% chartPSD = 顯示 PSD 圖表, 1=顯示, 0=不顯示
% convert2table = 是否將輸出結果轉換成表格(含表頭)

%% Output
% HRV = 所有心律指標
% Header = 表格表頭

%% Data Pre-Processing

% 將離異值改成剔除後的平均值，以保留NN個數
% 檢驗公式 1000/N*60 = 每分鐘心跳次數
tmpRRI = RRI(RRI >= 600 & RRI <= 1000);
mRRI = mean(tmpRRI);
errCounter = 0;
for i=1:length(RRI)
    if RRI(i) < 600
        disp([ '異常值(過小) - ' num2str(RRI(i)) ] );
        RRI(i) = mRRI;
        errCounter = errCounter + 1;
    end
    
    if RRI(i) > 1000
        disp([ '異常值(過大) - ' num2str(RRI(i)) ] );
        RRI(i) = mRRI;
        errCounter = errCounter + 1;
    end
end

disp([ '異常值共計 - ' num2str(errCounter) '/' num2str(i) ] );

%% ======================= Time Domain =======================
% MeanRR, SDNN, NN50, pNN50, RMSSD, SDRM

NNAvg = length(RRI)/5;

% NN

NN = length(RRI);

% MeanRR
MeanRR = mean(RRI);

% SDNN
SDNN = std(RRI);

% NN50, pNN50
[NN50, pNN50] = HRV_pNN50(RRI);

% RMSSD
for j=2:length(RRI)
RMSSD(j-1) = (RRI(j)-RRI(j-1)).^2;
end
RMSSD = sqrt(sum(RMSSD)/length(RRI));

% SDRM
SDRM = SDNN / RMSSD;  

% 心律RRI累積次數表
if chartHist
    figure, hist(RRI), grid
    xlabel('Sampling interval (s)')
    ylabel('RR distribution');
end


%% ======================= Frequency Domain ==================
% VLF, LF, HF, TP

time = cumsum(RRI);

tGrid = 1:512;

bps = interp1(time,RRI,tGrid,'spline');

[Pxx,F] = periodogram(bps,[],numel(bps),1);

Pxx(1) = 0;

% disp('-----------------------------');
% disp(['RRI - max ' num2str(max(RRI)) ' , min ' num2str(min(RRI))]);
% disp(['time - max ' num2str(max(time)) ' , min ' num2str(min(time))]);
% disp(['bps - max ' num2str(max(bps)) ' , min ' num2str(min(bps))]);
% disp(['pxx - max ' num2str(max(Pxx)) ' , min ' num2str(min(Pxx))]);

TP  = bandpower(Pxx,F,'psd');
HF  = bandpower(Pxx,F,[0.15 0.4],'psd');
LF  = bandpower(Pxx,F,[0.04 0.15],'psd');
VLF = bandpower(Pxx,F,[0.003 0.04],'psd');
ULF = bandpower(Pxx,F,[0 0.003],'psd');

nLF = LF/(TP-VLF)*1000;
nHF = HF/(TP-VLF)*1000;

LFHF_Ratio = LF/HF;

% PSD 功率頻譜圖
if chartPSD
    figure, plot(F,Pxx)
    xlabel('Normalized Frequency')
    ylabel('Power/frequeny');
end


%% ======================= Result ==================
% HRV 指標
HRV = [ Stage NNAvg NN MeanRR SDNN NN50 pNN50 RMSSD SDRM TP HF LF VLF ULF nLF nHF LFHF_Ratio ];
Header = {'Stage','NNAvg','NN','MeanRR','SDNN','NN50','pNN50','RMSSD','SDRM','TP','HF','LF','VLF','ULF','nLF','nHF','LFHF_Ratio'};

% HRV 指標(包含表頭)
if convert2table
    HRV = array2table(HRV, 'VariableNames', Header);
end

end

