clc;
close all;
clear;

%% �p��C�H�C�Ѫ��_�l�P�׭�, ���ন�
% �Х��]�� Start_2.m
% �N�C�H���Ҧ����q��ƾ�֦��@�����

PATH = './export/';

getNames = dir(PATH);
Groups = [{'�����@';'�P�a��';'���Y��';'�����';'�B����'},{'�����v';'�L�a�w';'�i����';'���f�N';'���T�q'}];

newHRVByName = [];

for g=1:length(Groups(1,:))
    
    % ======================================================
    People = Groups(:,g);
    for p=1:length(People)
        NAME = cell2mat(People(p));
        HRV = cell2mat(table2cell(readtable([PATH NAME '/' 'HRV.csv'])));
        
        % �C�H��骺�_�l�P�׭�(���e�P�U�@����������)
        % ����}�l��P�����e�Q����
        IndexS = 2; % mean(2 * 2+1)
        IndexE = 1;

        pointer = length(HRV(1,end));
        
        newHRVPointer = [];
        % �ھڤ��P�ժ��i��p�⥭��
        for s=1:length(unique(HRV(:,1)))
            hrv = HRV((HRV(:,1) == s),:);
            % ���ЭӼ�, �p��C�ӫ��Ъ��_�l�P����
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
    
    % �s�W���uName�v

%     for f=1:length(files)  
%         HRVAll = [ HRVAll ; readtable(['./export/' NAME '/' cell2mat(files(f)) ])];
%     end
    % writetable(HRVAll, [PATH NAME '/' 'HRV.csv']);
    % ======================================================

end



