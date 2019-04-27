clc;
close all;
clear;

%% 個人每日變化表
% Summary of example objective

PATH = './export/';

% 請輸入姓名
NAME = '周冠瑜';

HRV =  cell2mat(table2cell(readtable([ PATH '/' NAME '/HRV.csv' ])));

stage = unique(HRV(:,1));

Header = {'Stage','NNAvg','NN','MeanRR','SDNN','NN50','pNN50','RMSSD','SDRM','TP','HF','LF','VLF','ULF','nLF','nHF','LFHF_Ratio'};

% 輸入要看的指標
chartType = 2;

figure,
for s=1:length(stage)
    
    % filter by Stage 1~n
    hrv = HRV((HRV(:,1) == s),:);
    
    % 頭尾去掉 n 個五分鐘，避免不準確
    removeHead = 1; % 頭移除筆數
    removeEnd = 1;  % 尾移除筆數
    hrv = hrv([removeHead+1:end-removeEnd],:);
    
    x = 5:5:length(hrv(:,1))*5;
    y = hrv(:,chartType);
    
    %x = [1,2];
    %y = [hrv(1,chartType), hrv(end,chartType)];
    
    plot(x,y,'DisplayName',['第' num2str(s) '天'])
    title(['HRV 時域指標 ' Header{chartType} ' - 共' num2str(length(stage)) '天'])
    xlabel('分鐘(min)')
    ylabel('毫秒(ms)')
    
    hold on
end


legend()
hold off
