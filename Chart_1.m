clc;
close all;
clear;

%% �ӤH�C���ܤƪ�
% Summary of example objective

PATH = './export/';

% �п�J�m�W
NAME = '�B����';

HRV =  cell2mat(table2cell(readtable([ PATH '/' NAME '/HRV.csv' ])));

stage = unique(HRV(:,1));

Header = {'Stage','NNAvg','NN','MeanRR','SDNN','NN50','pNN50','RMSSD','SDRM','TP','HF','LF','VLF','ULF','nLF','nHF','LFHF_Ratio'};

% ��J�n�ݪ�����
chartType = 2;

figure,
for s=1:length(stage)
    
    % filter by Stage 1~n
    hrv = HRV((HRV(:,1) == s),:);
    
    % �Y���h�� n �Ӥ������A�קK���ǽT
    removeHead = 1; % �Y��������
    removeEnd = 1;  % ����������
    hrv = hrv([removeHead+1:end-removeEnd],:);
    
    x = 5:5:length(hrv(:,1))*5;
    y = hrv(:,chartType);
    
    %x = [1,2];
    %y = [hrv(1,chartType), hrv(end,chartType)];
    
    plot(x,y,'DisplayName',['��' num2str(s) '��'])
    title(['HRV �ɰ���� ' Header{chartType} ' - �@' num2str(length(stage)) '��'])
    xlabel('����(min)')
    ylabel('�@��(ms)')
    
    hold on
end


legend()
hold off
