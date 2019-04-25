function [t5MINS, Len] = DataSplit(Data,M)

%% 時間套件
% https://ww2.mathworks.cn/matlabcentral/fileexchange/28093-datestr2num
% 1030: 'yyyymmddTHHMMSS.FFF' 20000301T154517.123 
% 
% Data = 資料 {'Data', 'Time'}
% M = 切割單位 (分鐘)
%%

% 第一欄是資料, 第二欄是時間
[Rows, Columns] = size(Data);

% 切割單位(分鐘)
Unit = M;
UnitTime = Unit * 60;

% 起始時間索引值
dIndex = 500;

% 起始時間索引值(會更新)
sIndex = 500;

% 起算時間, 1030 格式
sTime = DateStr2Num(Data(dIndex,2), 1030);

% 當前五分鐘共有幾筆
counter = 0;

% 存儲 Unit 分鐘為一段的 cell
t5MINS = {};

%tic;

%%
for i=dIndex:Rows
    % 結算時間
    eTime = DateStr2Num(Data(i,2), 1030);
    
    % 結算時間判斷是否大於等於五分鐘
    if(UnitTime <= diff([sTime; eTime])*24*3600)
        % 儲存這段五分鐘的區間資料
        counter = counter + 1;
        t5MINS{counter} = Data(sIndex:i, :);
        % 指標移往下一個五分鐘區段
        sIndex = i + 1;
        sTime = DateStr2Num(Data(sIndex,2), 1030);
    end
end
%%

Len = length(t5MINS);

disp(['總共切成', num2str(counter) , '段,' ,' 剩下', num2str(Rows - sIndex), '筆, 未滿', num2str(Unit) ,'分鐘']);
%toc

end

