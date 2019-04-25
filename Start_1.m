clc;
close all;
clear;

%% �N���w���H���έp��X�Ҧ����� 
% Ū���ɮ� (data, time), �C���ɮ׬�������
disp('Ū���ɮ�...');

PATH = './export/';

% �п�J�m�W
NAME = '�B����';

% �д��Ѧ@���X�Ӷ��q
STAGES = {'a' , 'b' , 'c' , 'd' };

for s=1:length(STAGES)
    
    STAGE = STAGES{s};

    getFiles = dir(['./data/' NAME '/' STAGE '/ecg/']);

    HRVAll5Mins = [];
    HRVAll = [];

    for f=3:length(getFiles)

        FILE = strrep(getFiles(f).name,'.dat','');

        disp([ '�ഫ��� ' num2str(f-2) '/' num2str(length(getFiles)-2) ' : ' FILE ]);

        ECGFILE = table2cell(readtable(['./data/' NAME '/' STAGE '/ecg/' FILE '.dat'], 'Format', '%f%s' ));

        disp('���θ��...');
        % ���Φ��������᪺���
        % t5ECG = �C�q���������ɶ��P���, t5Lens = �@�X�q������
        [t5ECG, t5Lens] = DataSplit(ECGFILE, 5);

        %% �p�⤭�����@�q�� QRS, RRI
        % ���|�B���s���
        DataCells = {t5Lens}; % ���������q���ơA�Ω�p��C�q��������
        TimeCells = {t5Lens}; % ���������ɶ���ơA�Ω�p��C�q�������� RRI
        for i=1:t5Lens
            ECG = t5ECG{:,i};
            DataCells{i} = cell2mat(ECG(:,1));
            TimeCells{i} = ECG(:,2);
        end

        HRV5Mins = zeros(t5Lens, 17);
        for i=1:t5Lens %t5Lens
            % �ļ�
            FS = 200;

            % ���X�q��t���
            dc = DataCells{:,i};
            dc = dc(:,1);

            % �Q�� pan_tompkin �t��k��� QRS
            [map, r, delay] = pan_tompkin(dc, FS, 0);

            % ���� - �`�����߸�����
            % �`�߸��� / �`������ (beat/min)
            HRV(i) = length(r)/5;

            % ���X�ɶ��b���
            tc = TimeCells{:,i}; tc = tc(:,1);

            % �p�� HRV ����
            [HRV5Mins(i,:), Header] = getHRV(s, RR_Interval(r, tc), 0, 0, 0);
            
        end

        % For debug
        % HRV5MinsTable = array2table(HRV5Mins, 'VariableNames', Header);

        % �N�������@�q����Ʋ֭p�_��
        HRVAll5Mins = [ HRVAll5Mins ; HRV5Mins ];

        %% Export 5mins Data
        if ~exist([ PATH NAME ], 'dir')
            mkdir([ PATH NAME ]);
        end
        % writetable(HRV5MinsTable, [PATH NAME STAGE FILE '.csv']);
    end


    %% Export All 5mins Data

    HRVAll5MinsTable = array2table(HRVAll5Mins, 'VariableNames', Header);

    % Export All Day Data
    writetable(HRVAll5MinsTable, [PATH NAME '/' STAGE '-HRVAll5Mins.csv']);

    % �@�� Time Domain �ܤƹϪ�
    showTDchart = 0;
    if showTDchart
        for k=1:length(HRVAll5Mins(1,:))
            time = 0:5:length(HRVAll5Mins(:,1))*5;
            % �Ĥ@����0
            data = vertcat(0, HRVAll5Mins(:,k));
            figure, plot(time, data)
            title(['HRV �ɰ���� - ' Header{k}])
            xlabel('����(min)')
            ylabel('�@��(ms)');
        end
    end


    %% �@�Ѥ@�ӫ��Ъ���� 
    % ���� - SDANN index(ms) �������ȦA�зǮt
    % SDANN index (standard deviation of average normal to normal intervals index)
    %disp('�p�� SDANN index');
    SDANN_index = std(HRVAll5Mins(:,1));

    % ���� - SDNN index(ms) ���зǮt�A������
    % SDNN index (standard deviation of all normal to normal intervals index)
    %disp('�p�� SDNN index');
    SDNN_index = mean(HRVAll5Mins(:,2));


    HRVAll = [ SDANN_index SDNN_index ];
    HRVAllTable = array2table(HRVAll, 'VariableNames', {'SDANN_index', 'SDNN_index'});

    writetable(HRVAllTable, [PATH NAME '/' STAGE '-HRVAll.csv']);


end


