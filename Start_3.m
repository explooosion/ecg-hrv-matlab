clc;
close all;
clear;

%% 計算每人每天的起始與終值, 並轉成橫式
% 請先跑完 Start_2.m
% 將每人的所有階段資料整併成一份資料

PATH = './export/';

getNames = dir(PATH);
Groups = [{'李雅婷';'周冠瑜';'黃若雅';'賈希謙';'劉仁恩'},{'王郁鈞';'林家安';'張孝睿';'陳柏杰';'廖俊皓'}];

newHRVByName = [];

for g=1:length(Groups(1,:))
    
    % ======================================================
    People = Groups(:,g);
    for p=1:length(People)
        NAME = cell2mat(People(p));
        HRV = cell2mat(table2cell(readtable([PATH NAME '/' 'HRV.csv'])));
        
        % 每人當日的起始與終值(抓當前與下一筆的平均值)
        % 抓取開始後與結束前十分鐘
        IndexS = 2; % mean(2 * 2+1)
        IndexE = 1;

        pointer = length(HRV(1,end));
        
        newHRVPointer = [];
        % 根據不同組的進行計算平均
        for s=1:length(unique(HRV(:,1)))
            hrv = HRV((HRV(:,1) == s),:);
            % 指標個數, 計算每個指標的起始與結束
            meanPointer{1} = g; % Group
            meanPointer{2} = NAME; % Name
            meanPointer{3} = s % Stage
            for p=2:pointer
                meanStart = mean(hrv(IndexS:IndexS+1, p));
                meanEnd =  mean(hrv(end-IndexE-1:end-IndexE, p));
                meanPointer{p+2} = [meanStart, meanEnd];
            end
           newHRVPointer = [ newHRVPointer; meanPointer ];
        end
        
        newHRVByName = [ newHRVByName ; cell2mat(newHRVPointer)];
    end
    
    % 新增欄位「Name」

%     for f=1:length(files)  
%         HRVAll = [ HRVAll ; readtable(['./export/' NAME '/' cell2mat(files(f)) ])];
%     end
    % writetable(HRVAll, [PATH NAME '/' 'HRV.csv']);
    % ======================================================

end



