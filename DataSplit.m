function [t5MINS, Len] = DataSplit(Data,M)

%% �ɶ��M��
% https://ww2.mathworks.cn/matlabcentral/fileexchange/28093-datestr2num
% 1030: 'yyyymmddTHHMMSS.FFF' 20000301T154517.123 
% 
% Data = ��� {'Data', 'Time'}
% M = ���γ�� (����)
%%

% �Ĥ@��O���, �ĤG��O�ɶ�
[Rows, Columns] = size(Data);

% ���γ��(����)
Unit = M;
UnitTime = Unit * 60;

% �_�l�ɶ����ޭ�
dIndex = 500;

% �_�l�ɶ����ޭ�(�|��s)
sIndex = 500;

% �_��ɶ�, 1030 �榡
sTime = DateStr2Num(Data(dIndex,2), 1030);

% ��e�������@���X��
counter = 0;

% �s�x Unit �������@�q�� cell
t5MINS = {};

%tic;

%%
for i=dIndex:Rows
    % ����ɶ�
    eTime = DateStr2Num(Data(i,2), 1030);
    
    % ����ɶ��P�_�O�_�j�󵥩󤭤���
    if(UnitTime <= diff([sTime; eTime])*24*3600)
        % �x�s�o�q���������϶����
        counter = counter + 1;
        t5MINS{counter} = Data(sIndex:i, :);
        % ���в����U�@�Ӥ������Ϭq
        sIndex = i + 1;
        sTime = DateStr2Num(Data(sIndex,2), 1030);
    end
end
%%

Len = length(t5MINS);

disp(['�`�@����', num2str(counter) , '�q,' ,' �ѤU', num2str(Rows - sIndex), '��, ����', num2str(Unit) ,'����']);
%toc

end

