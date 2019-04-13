close all;
clear;

% 讀取檔案 (data, time), 每個檔案為五分鐘
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

% 全部心電圖 N*5 分鐘, N = 6
% 合併成一張表格, 利用 pan_tompkin 演算法找到 QRS
Datas = [Data0 ; Data1 ; Data2 ; Data3 ; Data4 ; Data5];
[map, r, delay] = pan_tompkin(Datas.('Data'), 200, 0);

% 總平均心跳 6*5分鐘
[a, len] = size(r);
RR = len/(5*6);

% 時間差 ms
rrInterval = RR_Interval(r, Datas);

% 指標 - Mean NN(ms) Normal-to-Normal (NN) intervals
Mean_NN = mean(rrInterval);

% 指標 - SDNN(ms) standard deviation of all normal to normal intervals
SDNN = std(rrInterval);

% =================================================================== %
% 第一段五分鐘
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

% 指標 - SDANN_Index(ms) 先平均值再標準差
SDANN = std( [ MeanNN0 MeanNN1 MeanNN2 MeanNN3 MeanNN4 MeanNN5 ]);

SDNN_Index = mean( [ SDNN0 SDNN1 SDNN2 SDNN3 SDNN4 SDNN5 ]);


% ============================
% x= r(1:451);
% y=interp1(x,t,r(1):1:r(20),'spline');  %利用插值法求出以原ecg信?的采?率fs的?合函?
% plot(y);hold on,
% scatter(r(2:19)-r(2),t(1:18));
% 
% N=length(y);
% N1=20;    %确定?率?的范? 每一?元?fs/N=0.06Hz
% AF=fft(y);
% AF=abs(AF);   %求出傅里???后的幅?特性
% f=(0:N1-1)*200/N; 
% figure,plot(f,AF(1:N1));  %?一步是?fft的?率??行一定的?化，但是不?影?到fft的具体信息，只是?了方
%                                        %便?示而已，具体的fft使用??看上篇?于fft的介?。
