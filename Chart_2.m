clc;
close all;
clear;

%% �ӤH�C�骺�_�l�P�����ܤƪ�
% Summary of example objective

PATH = './export/';

% �п�J�m�W
NAME = '�����@';

HRV =  cell2mat(table2cell(readtable([ PATH '/' NAME '/HRV.csv' ])));

stage = unique(HRV(:,1));

Header = {'Stage','NNAvg','NN','MeanRR','SDNN','NN50','pNN50','RMSSD','SDRM','TP','HF','LF','VLF','ULF','nLF','nHF','LFHF_Ratio'};

% ��J�n�ݪ�����
chartType = 2;

HRV_start = zeros(length(stage),1);
HRV_end = zeros(length(stage),1);

for s=1:length(stage)
    % filter by Stage 1~n
    hrv = HRV((HRV(:,1) == s),:);
    
    % �Y���h�� n �Ӥ������A�קK���ǽT
    removeHead = 1; % �Y��������
    removeEnd = 1;  % ����������
    hrv = hrv([removeHead+1:end-removeEnd],:);
    
    % ��X�C��_�l��
    HRV_start(s) = hrv(1,chartType);
    % ��X�C�鵲����
    HRV_end(s) = hrv(end,chartType);
end

figure,

x = 1:1:length(stage);
y = HRV_start;
plot(x,y,'DisplayName', '�C��_�l��')
title(['HRV �_�l���ܤ� ' Header{chartType} ' - �@' num2str(length(stage)) '��'])
xlabel('��(day)')
ylabel('�@��(ms)')
hold on

x = 1:1:length(stage);
y = HRV_end;
plot(x,y,'DisplayName', '�C�鵲����')
title(['HRV �������ܤ� ' Header{chartType} ' - �@' num2str(length(stage)) '��'])
xlabel('��(day)')
ylabel('�@��(ms)')

legend()
hold off



