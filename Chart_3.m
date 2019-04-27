clc;
close all;
clear;

%% �C�H�C�饭���ܤƪ�
% Summary of example objective

PATH = './export/';

NAMES = {'�����v';'�����@';'�P�a��';'�L�a�w';'�i����';'���f�N';'���Y��';'�����';'���T�q';'�B����'};

figure,

for n=1:length(NAMES)


    % �п�J�m�W
    NAME = cell2mat(NAMES(n));

    HRV =  cell2mat(table2cell(readtable([ PATH '/' NAME '/HRV.csv' ])));

    stage = unique(HRV(:,1));

    Header = {'Stage','NNAvg','NN','MeanRR','SDNN','NN50','pNN50','RMSSD','SDRM','TP','HF','LF','VLF','ULF','nLF','nHF','LFHF_Ratio'};

    % ��J�n�ݪ�����
    chartType = 2;

    HRV_mean = zeros(length(stage),1);

    for s=1:length(stage)
        % filter by Stage 1~n
        hrv = HRV((HRV(:,1) == s),:);
        
        % �Y���h�� n �Ӥ������A�קK���ǽT
        removeHead = 1; % �Y��������
        removeEnd = 1;  % ����������
        hrv = hrv([removeHead+1:end-removeEnd],:);
    
        % ��X�C��_�l��
        HRV_mean(s) = mean(hrv(:,chartType));
    end

    x = 1:1:length(stage);
    y = HRV_mean;
    plot(x,y,'DisplayName', NAME)
    title(['�C�饭���ܤƪ� ' Header{chartType} ' - �@' num2str(length(stage)) '��'])
    xlabel('��(day)')
    ylabel('�@��(ms)')
    hold on

end


legend()
hold off

