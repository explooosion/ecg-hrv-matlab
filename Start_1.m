clc;
close all;
clear;

%% 將指定的人切割計算出所有指標 
% 讀取檔案 (data, time), 每個檔案為五分鐘
disp('讀取檔案...');

PATH = './export/';

% 請輸入姓名
NAME = '劉仁恩';

% 請提供共有幾個階段
STAGES = {'a' , 'b' , 'c' , 'd' };

for s=1:length(STAGES)
    
    STAGE = STAGES{s};

    getFiles = dir(['./data/' NAME '/' STAGE '/ecg/']);

    HRVAll5Mins = [];
    HRVAll = [];

    for f=3:length(getFiles)

        FILE = strrep(getFiles(f).name,'.dat','');

        disp([ '轉換資料 ' num2str(f-2) '/' num2str(length(getFiles)-2) ' : ' FILE ]);

        ECGFILE = table2cell(readtable(['./data/' NAME '/' STAGE '/ecg/' FILE '.dat'], 'Format', '%f%s' ));

        disp('切割資料...');
        % 切割成五分鐘後的資料
        % t5ECG = 每段五分鐘的時間與資料, t5Lens = 共幾段五分鐘
        [t5ECG, t5Lens] = DataSplit(ECGFILE, 5);

        %% 計算五分鐘一段的 QRS, RRI
        % 堆疊、分群資料
        DataCells = {t5Lens}; % 五分鐘的電位資料，用於計算每段五分鐘的
        TimeCells = {t5Lens}; % 五分鐘的時間資料，用於計算每段五分鐘的 RRI
        for i=1:t5Lens
            ECG = t5ECG{:,i};
            DataCells{i} = cell2mat(ECG(:,1));
            TimeCells{i} = ECG(:,2);
        end

        HRV5Mins = zeros(t5Lens, 17);
        for i=1:t5Lens %t5Lens
            % 採樣
            FS = 200;

            % 取出電位差資料
            dc = DataCells{:,i};
            dc = dc(:,1);

            % 利用 pan_tompkin 演算法找到 QRS
            [map, r, delay] = pan_tompkin(dc, FS, 0);

            % 指標 - 總平均心跳次數
            % 總心跳數 / 總分鐘數 (beat/min)
            HRV(i) = length(r)/5;

            % 取出時間軸資料
            tc = TimeCells{:,i}; tc = tc(:,1);

            % 計算 HRV 指標
            [HRV5Mins(i,:), Header] = getHRV(s, RR_Interval(r, tc), 0, 0, 0);
            
        end

        % For debug
        % HRV5MinsTable = array2table(HRV5Mins, 'VariableNames', Header);

        % 將五分鐘一段的資料累計起來
        HRVAll5Mins = [ HRVAll5Mins ; HRV5Mins ];

        %% Export 5mins Data
        if ~exist([ PATH NAME ], 'dir')
            mkdir([ PATH NAME ]);
        end
        % writetable(HRV5MinsTable, [PATH NAME STAGE FILE '.csv']);
    end


    %% Export All 5mins Data

    HRVAll5MinsTable = array2table(HRVAll5Mins, 'VariableNames', Header);

    % Export All Day Data
    writetable(HRVAll5MinsTable, [PATH NAME '/' STAGE '-HRVAll5Mins.csv']);

    % 一天 Time Domain 變化圖表
    showTDchart = 0;
    if showTDchart
        for k=1:length(HRVAll5Mins(1,:))
            time = 0:5:length(HRVAll5Mins(:,1))*5;
            % 第一筆補0
            data = vertcat(0, HRVAll5Mins(:,k));
            figure, plot(time, data)
            title(['HRV 時域指標 - ' Header{k}])
            xlabel('分鐘(min)')
            ylabel('毫秒(ms)');
        end
    end


    %% 一天一個指標的資料 
    % 指標 - SDANN index(ms) 先平均值再標準差
    % SDANN index (standard deviation of average normal to normal intervals index)
    %disp('計算 SDANN index');
    SDANN_index = std(HRVAll5Mins(:,1));

    % 指標 - SDNN index(ms) 先標準差再平均值
    % SDNN index (standard deviation of all normal to normal intervals index)
    %disp('計算 SDNN index');
    SDNN_index = mean(HRVAll5Mins(:,2));


    HRVAll = [ SDANN_index SDNN_index ];
    HRVAllTable = array2table(HRVAll, 'VariableNames', {'SDANN_index', 'SDNN_index'});

    writetable(HRVAllTable, [PATH NAME '/' STAGE '-HRVAll.csv']);


end


