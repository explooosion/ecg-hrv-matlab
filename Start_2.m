clc;
close all;
clear;

%% 整合匯出資料
% 請先跑完 Start_1.m
% 將每人的所有階段資料整併成一份資料

PATH = './export/';

getNames = dir(PATH);

for s=1:length(getNames)
    if(length(getNames(s).name) == 3)
    % ======================================================
    NAME = getNames(s).name;
    getFiles = dir([PATH NAME '/']);
    files = {};
    HRVAll = [];
    for s=1:length(getFiles)
        if(length(getFiles(s).name) == 17)
            files{end+1} = getFiles(s).name;
        end
    end
    for f=1:length(files)  
        HRVAll = [ HRVAll ; readtable(['./export/' NAME '/' cell2mat(files(f)) ])];
    end
    
    HRVAll = cell2mat(table2cell(HRVAll));
    
    % min-max scaling
    % TP
    HRVAll(:,10) = rescale(HRVAll(:,10),1,100);
    % HF
    HRVAll(:,11) = rescale(HRVAll(:,11),1,100);
    % LF
    HRVAll(:,12) = rescale(HRVAll(:,12),1,100);
    % VLF
    HRVAll(:,13) = rescale(HRVAll(:,13),1,100);
    % ULF
    HRVAll(:,14) = rescale(HRVAll(:,14),1,100);
    
    Header = {'Stage','NNAvg','NN','MeanRR','SDNN','NN50','pNN50','RMSSD','SDRM','TP','HF','LF','VLF','ULF','nLF','nHF','LFHF_Ratio'};

    HRVAll = array2table(HRVAll, 'VariableNames', Header);

    writetable(HRVAll, [PATH NAME '/' 'HRV.csv']);
    % ======================================================
    end
end



