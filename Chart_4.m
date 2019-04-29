clc;
close all;
clear;

%% �C�ըC�饭���ܤƪ�
% Summary of example objective

PATH = './export/';

Groups = [{'�����@';'�P�a��';'���Y��';'�����';'�B����'},{'�����v';'�L�a�w';'�i����';'���f�N';'���T�q'}];

Group1Data = [];
Group2Data = [];
for g=1:length(Groups(1,:))

    % �@�p���
    Group = cell2mat(Groups(:,g));

    for n=1:length(Group)

        % �п�J�m�W
        NAME = Group(n,:);

        HRV =  cell2mat(table2cell(readtable([ PATH '/' NAME '/HRV.csv' ])));

        stage = unique(HRV(:,1));

        Header = {'Stage','NNAvg','NN','MeanRR','SDNN','NN50','pNN50','RMSSD','SDRM','TP','HF','LF','VLF','ULF','nLF','nHF','LFHF_Ratio'};

        % ��J�n�ݪ�����
        chartType = 17;

        % �`�ѼơA�Ĥ@�ե|�ѡA�ĤG�դK��
        if g==1
            stageLen = 4;
        end
        if g==2
            stageLen = 7;
        end
        HRV_mean = zeros(stageLen,1);

        % �ӤH������
        for s=1:stageLen
            % filter by Stage 1~n
            hrv = HRV((HRV(:,1) == s),:);

            % �Y���h�� n �Ӥ������A�קK���ǽT
            removeHead = 1; % �Y��������
            removeEnd = 1;  % ����������
            hrv = hrv([removeHead+1:end-removeEnd],:);

            % �C�ѥ�����
            HRV_mean(s) = mean(hrv(:,chartType));
        end

        % �C�H�C�饭����ơA�@�p stage ��
        % ����4orN�ѡA��ƨC�H
        if g==1
            Group1Data = [ Group1Data , HRV_mean];
        end
        if g==2
            Group2Data = [ Group2Data , HRV_mean];
        end
    end
end

% ø�s��ըC�饭����

% group1
x1 = [1,2,3,4];
y1 = zeros(1,length(x1));
% �p��C�ըC�Ѳխ�����
for g=1:length(x1)
  y1(g) = mean(Group1Data(g,:));
end

% group2
x2 = [1,2,3,4,5,6,7];
y2 = zeros(1,length(x2));
% �p��C�ըC�Ѳխ�����
for g=1:length(x2)
  y2(g) = mean(Group2Data(g,:));
end

figure,
plot(x1,y1,'DisplayName','�Ĥ@��')
title(['�U�ըC�饭���ܤƪ� ' Header{chartType} ' - �@' num2str(length(stage)) '��'])
xlabel('��(day)')
ylabel('�@��(ms)')
hold on

plot(x2,y2,'DisplayName','�ĤG��')
title(['�U�ըC�饭���ܤƪ� ' Header{chartType} ' - �@' num2str(length(stage)) '��'])
xlabel('��(day)')
ylabel('�@��(ms)')
legend()

hold off
