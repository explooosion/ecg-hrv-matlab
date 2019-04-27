clc;
close all;
clear;

%% 每人每日平均變化表
% Summary of example objective

PATH = './export/';

NAMES = {'王郁鈞';'李雅婷';'周冠瑜';'林家安';'張孝睿';'陳柏杰';'黃若雅';'賈希謙';'廖俊皓';'劉仁恩'};

figure,

for n=1:length(NAMES)


    % 請輸入姓名
    NAME = cell2mat(NAMES(n));

    HRV =  cell2mat(table2cell(readtable([ PATH '/' NAME '/HRV.csv' ])));

    stage = unique(HRV(:,1));

    Header = {'Stage','NNAvg','NN','MeanRR','SDNN','NN50','pNN50','RMSSD','SDRM','TP','HF','LF','VLF','ULF','nLF','nHF','LFHF_Ratio'};

    % 輸入要看的指標
    chartType = 2;

    HRV_mean = zeros(length(stage),1);

    for s=1:length(stage)
        % filter by Stage 1~n
        hrv = HRV((HRV(:,1) == s),:);
        
        % 頭尾去掉 n 個五分鐘，避免不準確
        removeHead = 1; % 頭移除筆數
        removeEnd = 1;  % 尾移除筆數
        hrv = hrv([removeHead+1:end-removeEnd],:);
    
        % 找出每日起始值
        HRV_mean(s) = mean(hrv(:,chartType));
    end

    x = 1:1:length(stage);
    y = HRV_mean;
    plot(x,y,'DisplayName', NAME)
    title(['每日平均變化表 ' Header{chartType} ' - 共' num2str(length(stage)) '天'])
    xlabel('天(day)')
    ylabel('毫秒(ms)')
    hold on

end


legend()
hold off

