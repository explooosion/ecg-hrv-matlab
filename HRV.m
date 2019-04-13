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
%[map, r, delay] = pan_tompkin(Datas.('Data'), 200, 0);

% 時間差 ms
%rrInterval = RR_Interval(r, Datas);

% 指標 - NN(ms)
%NN = mean(rrInterval);

% 指標 - SDNN(ms)
%SDNN = std(rrInterval);

NN50 = max(rrInterval);

% =================================================================== %
% 第一段五分鐘
[map, r, delay] = pan_tompkin(Data0.('Data'), 200, 0);
rrInvertal0 = RR_Interval(r, Data0);

[map, r, delay] = pan_tompkin(Data1.('Data'), 200, 0);
rrInvertal1 = RR_Interval(r, Data1);

[map, r, delay] = pan_tompkin(Data2.('Data'), 200, 0);
rrInvertal2 = RR_Interval(r, Data2);

[map, r, delay] = pan_tompkin(Data3.('Data'), 200, 0);
rrInvertal3 = RR_Interval(r, Data3);

[map, r, delay] = pan_tompkin(Data4.('Data'), 200, 0);
rrInvertal4 = RR_Interval(r, Data4);

[map, r, delay] = pan_tompkin(Data5.('Data'), 200, 0);
rrInvertal5 = RR_Interval(r, Data5);

% 指標 - SDANN_Index(ms) 先平均值再標準差
SDANN = std( [ mean(rrInvertal0) mean(rrInvertal1) mean(rrInvertal2) mean(rrInvertal3) mean(rrInvertal4) mean(rrInvertal5) ]);

% 指標 - SDNN_Index(ms) 先標準差再平均值
%SDANN_Index = mean( [ std(rrInvertal0) std(rrInvertal1) std(rrInvertal2) std(rrInvertal3) std(rrInvertal4) std(rrInvertal5) ]);

% [map,r,delay]=pan_tompkin(Data1,200,0);    % 利用pan_tomkin算法找到R?
% [a,l]=size(r);
% for i=2:l;
%     t(i-1)=r(i)-r(i-1);   %求出R-R?的??值，即使HRV
% end
% sdann1 = std(t);
% 
% [map,r,delay]=pan_tompkin(Data2,200,0);    % 利用pan_tomkin算法找到R?
% [a,l]=size(r);
% for i=2:l;
%     t(i-1)=r(i)-r(i-1);   %求出R-R?的??值，即使HRV
% end
% sdann2 = std(t);
% 
% [map,r,delay]=pan_tompkin(Data3,200,0);    % 利用pan_tomkin算法找到R?
% [a,l]=size(r);
% for i=2:l;
%     t(i-1)=r(i)-r(i-1);   %求出R-R?的??值，即使HRV
% end
% sdann3 = std(t);
% 
% [map,r,delay]=pan_tompkin(Data4,200,0);    % 利用pan_tomkin算法找到R?
% [a,l]=size(r);
% for i=2:l;
%     t(i-1)=r(i)-r(i-1);   %求出R-R?的??值，即使HRV
% end
% sdann4 = std(t);
% 
% [map,r,delay]=pan_tompkin(Data5,200,0);    % 利用pan_tomkin算法找到R?
% [a,l]=size(r);
% for i=2:l;
%     t(i-1)=r(i)-r(i-1);   %求出R-R?的??值，即使HRV
% end
% sdann5 = std(t);
% 
% SDANN = mean([sdann0 sdann1 sdann2 sdann3 sdann4 sdann5]);

% 
% % r = 索引值
% [a,l]=size(r);
% for i=2:l;
%     t(i-1)=r(i)-r(i-1);   %求出R-R?的??值，即使HRV
% end
% 
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
