close all;
clear;

% Ū���ɮ� (data, time), �C���ɮ׬�������
Data0 = readtable('./20190324-100822-0.dat', 'Format', '%f%s' );
Data0.Properties.VariableNames = {'Data' 'Time'};

Data1 = readtable('./20190324-100822-1.dat', 'Format', '%f%s' );
Data1.Properties.VariableNames = {'Data' 'Time'};

Data2 = readtable('./20190324-100822-2.dat', 'Format', '%f%s' );
Data2.Properties.VariableNames = {'Data' 'Time'};

Data3 = readtable('./20190324-100822-3.dat', 'Format', '%f%s' );
Data3.Properties.VariableNames = {'Data' 'Time'};

Data4 = readtable('./20190324-100822-4.dat', 'Format', '%f%s' );
Data4.Properties.VariableNames = {'Data' 'Time'};

Data5 = readtable('./20190324-100822-5.dat', 'Format', '%f%s' );
Data5.Properties.VariableNames = {'Data' 'Time'};

% �����߹q�� N*5 ����, N = 6
% �X�֦��@�i���, �Q�� pan_tompkin �t��k��� QRS
Datas = [Data0 ; Data1 ; Data2 ; Data3 ; Data4 ; Data5];
[map, r, delay] = pan_tompkin(Datas.('Data'), 200, 0);

% �`�����߸� 6*5����
[a, len] = size(r);
RR = len/(5*6);

% �ɶ��t ms
rrInterval = RR_Interval(r, Datas);

% ���� - Mean NN(ms) Normal-to-Normal (NN) intervals
Mean_NN = mean(rrInterval);

% ���� - SDNN(ms) standard deviation of all normal to normal intervals
SDNN = std(rrInterval);

% =================================================================== %
% �Ĥ@�q������
[map, r, delay] = pan_tompkin(Data0.('Data'), 200, 0);
rrInvertal0 = RR_Interval(r, Data0);
MeanNN0 = mean(rrInvertal0);
SDNN0 = std(rrInvertal0);
[a, len] = size(r);
RR0 = len/5;

[map, r, delay] = pan_tompkin(Data1.('Data'), 200, 0);
rrInvertal1 = RR_Interval(r, Data1);
MeanNN1 = mean(rrInvertal1);
SDNN1 = std(rrInvertal1);
[a, len] = size(r);
RR1 = len/5;

[map, r, delay] = pan_tompkin(Data2.('Data'), 200, 0);
rrInvertal2 = RR_Interval(r, Data2);
MeanNN2 = mean(rrInvertal2);
SDNN2 = std(rrInvertal2);
[a, len] = size(r);
RR2 = len/5;

[map, r, delay] = pan_tompkin(Data3.('Data'), 200, 0);
rrInvertal3 = RR_Interval(r, Data3);
MeanNN3 = mean(rrInvertal3);
SDNN3 = std(rrInvertal3);

[map, r, delay] = pan_tompkin(Data4.('Data'), 200, 0);
rrInvertal4 = RR_Interval(r, Data4);
MeanNN4 = mean(rrInvertal4);
SDNN4 = std(rrInvertal4);
[a, len] = size(r);
RR4 = len/5;

[map, r, delay] = pan_tompkin(Data5.('Data'), 200, 0);
rrInvertal5 = RR_Interval(r, Data5);
MeanNN5 = mean(rrInvertal5);
SDNN5 = std(rrInvertal5);
[a, len] = size(r);
RR5 = len/5;

% ���� - SDANN_Index(ms) �������ȦA�зǮt
SDANN = std( [ MeanNN0 MeanNN1 MeanNN2 MeanNN3 MeanNN4 MeanNN5 ]);

SDNN_Index = mean( [ SDNN0 SDNN1 SDNN2 SDNN3 SDNN4 SDNN5 ]);


% ============================
% x= r(1:451);
% y=interp1(x,t,r(1):1:r(20),'spline');  %�Q�δ��Ȫk�D�X�H��ecg�H?����?�vfs��?�X��?
% plot(y);hold on,
% scatter(r(2:19)-r(2),t(1:18));
% 
% N=length(y);
% N1=20;    %�̩w?�v?���S? �C�@?��?fs/N=0.06Hz
% AF=fft(y);
% AF=abs(AF);   %�D�X�Ũ�???�Z���T?�S��
% f=(0:N1-1)*200/N; 
% figure,plot(f,AF(1:N1));  %?�@�B�O?fft��?�v??��@�w��?�ơA���O��?�v?��fft�����^�H���A�u�O?�F��
%                                        %�K?�ܦӤw�A���^��fft�ϥ�??�ݤW�g?�_fft����?�C
