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
%[map, r, delay] = pan_tompkin(Datas.('Data'), 200, 0);

% �ɶ��t ms
%rrInterval = RR_Interval(r, Datas);

% ���� - NN(ms)
%NN = mean(rrInterval);

% ���� - SDNN(ms)
%SDNN = std(rrInterval);

NN50 = max(rrInterval);

% =================================================================== %
% �Ĥ@�q������
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

% ���� - SDANN_Index(ms) �������ȦA�зǮt
SDANN = std( [ mean(rrInvertal0) mean(rrInvertal1) mean(rrInvertal2) mean(rrInvertal3) mean(rrInvertal4) mean(rrInvertal5) ]);

% ���� - SDNN_Index(ms) ���зǮt�A������
%SDANN_Index = mean( [ std(rrInvertal0) std(rrInvertal1) std(rrInvertal2) std(rrInvertal3) std(rrInvertal4) std(rrInvertal5) ]);

% [map,r,delay]=pan_tompkin(Data1,200,0);    % �Q��pan_tomkin��k���R?
% [a,l]=size(r);
% for i=2:l;
%     t(i-1)=r(i)-r(i-1);   %�D�XR-R?��??�ȡA�Y��HRV
% end
% sdann1 = std(t);
% 
% [map,r,delay]=pan_tompkin(Data2,200,0);    % �Q��pan_tomkin��k���R?
% [a,l]=size(r);
% for i=2:l;
%     t(i-1)=r(i)-r(i-1);   %�D�XR-R?��??�ȡA�Y��HRV
% end
% sdann2 = std(t);
% 
% [map,r,delay]=pan_tompkin(Data3,200,0);    % �Q��pan_tomkin��k���R?
% [a,l]=size(r);
% for i=2:l;
%     t(i-1)=r(i)-r(i-1);   %�D�XR-R?��??�ȡA�Y��HRV
% end
% sdann3 = std(t);
% 
% [map,r,delay]=pan_tompkin(Data4,200,0);    % �Q��pan_tomkin��k���R?
% [a,l]=size(r);
% for i=2:l;
%     t(i-1)=r(i)-r(i-1);   %�D�XR-R?��??�ȡA�Y��HRV
% end
% sdann4 = std(t);
% 
% [map,r,delay]=pan_tompkin(Data5,200,0);    % �Q��pan_tomkin��k���R?
% [a,l]=size(r);
% for i=2:l;
%     t(i-1)=r(i)-r(i-1);   %�D�XR-R?��??�ȡA�Y��HRV
% end
% sdann5 = std(t);
% 
% SDANN = mean([sdann0 sdann1 sdann2 sdann3 sdann4 sdann5]);

% 
% % r = ���ޭ�
% [a,l]=size(r);
% for i=2:l;
%     t(i-1)=r(i)-r(i-1);   %�D�XR-R?��??�ȡA�Y��HRV
% end
% 
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
