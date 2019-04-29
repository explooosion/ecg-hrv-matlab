clc;
close all;
clear;

%% 每組每日平均變化表
% Summary of example objective

PATH = './export/';

Groups = [{'李雅婷';'周冠瑜';'黃若雅';'賈希謙';'劉仁恩'},{'王郁鈞';'林家安';'張孝睿';'陳柏杰';'廖俊皓'}];

Group1Data = [];
Group2Data = [];
for g=1:length(Groups(1,:))

    % 共計兩組
    Group = cell2mat(Groups(:,g));

    for n=1:length(Group)

        % 請輸入姓名
        NAME = Group(n,:);

        HRV =  cell2mat(table2cell(readtable([ PATH '/' NAME '/HRV.csv' ])));

        stage = unique(HRV(:,1));

        Header = {'Stage','NNAvg','NN','MeanRR','SDNN','NN50','pNN50','RMSSD','SDRM','TP','HF','LF','VLF','ULF','nLF','nHF','LFHF_Ratio'};

        % 輸入要看的指標
        chartType = 17;

        % 總天數，第一組四天，第二組八天
        if g==1
            stageLen = 4;
        end
        if g==2
            stageLen = 7;
        end
        HRV_mean = zeros(stageLen,1);

        % 個人的平均
        for s=1:stageLen
            % filter by Stage 1~n
            hrv = HRV((HRV(:,1) == s),:);

            % 頭尾去掉 n 個五分鐘，避免不準確
            removeHead = 1; % 頭移除筆數
            removeEnd = 1;  % 尾移除筆數
            hrv = hrv([removeHead+1:end-removeEnd],:);

            % 每天平均值
            HRV_mean(s) = mean(hrv(:,chartType));
        end

        % 每人每日平均資料，共計 stage 天
        % 直排4orN天，橫排每人
        if g==1
            Group1Data = [ Group1Data , HRV_mean];
        end
        if g==2
            Group2Data = [ Group2Data , HRV_mean];
        end
    end
end

% 繪製兩組每日平均圖

% group1
x1 = [1,2,3,4];
y1 = zeros(1,length(x1));
% 計算每組每天組員平均
for g=1:length(x1)
  y1(g) = mean(Group1Data(g,:));
end

% group2
x2 = [1,2,3,4,5,6,7];
y2 = zeros(1,length(x2));
% 計算每組每天組員平均
for g=1:length(x2)
  y2(g) = mean(Group2Data(g,:));
end

figure,
plot(x1,y1,'DisplayName','第一組')
title(['各組每日平均變化表 ' Header{chartType} ' - 共' num2str(length(stage)) '天'])
xlabel('天(day)')
ylabel('毫秒(ms)')
hold on

plot(x2,y2,'DisplayName','第二組')
title(['各組每日平均變化表 ' Header{chartType} ' - 共' num2str(length(stage)) '天'])
xlabel('天(day)')
ylabel('毫秒(ms)')
legend()

hold off
