clc;
close all;
clear;

%% 個人每日的起始與結尾變化表
% Summary of example objective

PATH = './export/';

% 請輸入姓名
NAME = '李雅婷';

HRV =  cell2mat(table2cell(readtable([ PATH '/' NAME '/HRV.csv' ])));

stage = unique(HRV(:,1));

Header = {'Stage','NNAvg','NN','MeanRR','SDNN','NN50','pNN50','RMSSD','SDRM','TP','HF','LF','VLF','ULF','nLF','nHF','LFHF_Ratio'};

% 輸入要看的指標
chartType = 4;

HRV_start = zeros(length(stage),1);
HRV_end = zeros(length(stage),1);

for s=1:length(stage)
    % filter by Stage 1~n
    hrv = HRV((HRV(:,1) == s),:);
    
    % 頭尾去掉 n 個五分鐘，避免不準確
    removeHead = 1; % 頭移除筆數
    removeEnd = 1;  % 尾移除筆數
    hrv = hrv([removeHead+1:end-removeEnd],:);
    
    % 找出每日起始值
    HRV_start(s) = hrv(1,chartType);
    % 找出每日結束值
    HRV_end(s) = hrv(end,chartType);
end

figure,

x = 1:1:length(stage);
y = HRV_start;
plot(x,y,'DisplayName', '每日起始值')
title(['HRV 起始值變化 ' Header{chartType} ' - 共' num2str(length(stage)) '天'])
xlabel('天(day)')
ylabel('毫秒(ms)')
hold on

x = 1:1:length(stage);
y = HRV_end;
plot(x,y,'DisplayName', '每日結束值')
title(['HRV 結束值變化 ' Header{chartType} ' - 共' num2str(length(stage)) '天'])
xlabel('天(day)')
ylabel('毫秒(ms)')

legend()
hold off



