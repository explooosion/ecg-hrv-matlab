close all;
clear;

%% Ū���ɮ� (data, time), �C���ɮ׬�������
ECGFILE = table2cell(readtable('./datas/20190411-210637.dat', 'Format', '%f%s' ));

% ���Φ��������᪺��� (�`���, �@�X�q������)
[t5MINS, Len] = DataSplit(ECGFILE, 5);


%% �p����� QRS, RRI
% �q cell �Ѻc�X�Өë��w���o�Ĥ@��Ҧ����
Datas     = []; % �Ω����p�� QRS
Times     = []; % �Ω����p�� RRI
DataCells = []; % �Ω�ӧO�p�� QRS
TimeCells = []; % �Ω�ӧO�p�� RRI
for i=1:Len
    Data = t5MINS{:,i};
    DataCells{i} = cell2mat(Data(:,1));
    Datas = [ Datas ; cell2mat(Data(:,1)) ];
    TimeCells{i} = Data(:,2);
    Times = [ Times ; Data(:,2)];
end

% �Q�� pan_tompkin �t��k��� QRS
% map = �o�i�᪺�q��t, r = R�p���ޭ�
[map, r, delay] = pan_tompkin(Datas, 200, 0);


% s = abs(fft(map));
% subplot(2,1,1), plot(s);    % ����W��
% subplot(2,1,2), plot(map);    % ��ܪi��

%%
% ���� - �`�����߸����� Len*5����, Len �����������Ӽ�
[a, len] = size(r);
HR = len/(Len*5);

% ���� - RRI
RRI = RR_Interval(r, Times);

% ���� - NN50
[NN50, pNN50]= HRV_pNN50(RRI);

% ���� - r-MSSD
[a, rrLen]=size(RRI);
for i=2:rrLen
  rMSSD_ARR(i-1) = abs(RRI(i) - RRI(i-1));
end
rMSSD = sqrt(sum(rMSSD_ARR.^2));

% ���� - Mean NN(ms) Normal-to-Normal (NN) intervals
MeanNN = mean(RRI);

% ���� - SDNN(ms) standard deviation of all normal to normal intervals
SDNN = std(RRI);

%% �ӧO�� SDNN, SDANN_Index
for i=1:Len
    dc = DataCells{:,i};
    dc = dc(:,1);
    [map, r, delay] = pan_tompkin(dc, 200, 0);
    
    tc = TimeCells{:,i};
    tc = tc(:,1);
    RRICell = RR_Interval(r, tc);
    MeanNNCells(i) = mean(RRICell);
    SDNNCells(i) = std(RRICell);
    
    [a, len] = size(r);
    HRCells(i) = len/5;
    
    RRICells{i} = RRICell;
    
    y=interp1(r(2:209),RRICell(2:209),r(2):1:r(209),'spline');  %�Q�δ��Ȫk�D�X�H��ecg�H?����?�vfs��?�X��?
    
    %plot(y);hold on,
    %scatter(r(2:19)-r(2),RRICell(2:19));

    N=length(y);
    N1=210; %�T�w�W�v�b���d�� �C�@�椸��fs/N=0.06Hz
    AF=fft(y);
    AF=abs(AF); %�D�X�ť߸��ܴ��᪺�T�W�S��
    
    f=(0:N1-1)*200/N; 
    figure,plot(f,AF(1:N1))
    title(['HRV �W�Ф��R - ' num2str(i)])
    xlabel('Frequency [Hz]')
    ylabel('Power [ms^{2}]');

end

% ���� - SDANN_Index(ms) �������ȦA�зǮt
SDANN = std(MeanNNCells);
%

% ���� - SDANN_Index(ms) ���зǮt�A������
SDANNIndex = mean(SDNNCells);
