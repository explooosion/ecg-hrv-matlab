function rr_interval = RR_Interval(r,data)
    % r = R波索引值
    % data = 原始資料 (帶有資料與時間)
    % 取得 RR 個數, len = RR 個數    
    [a, rrLen]=size(r);
    % 時間差 ms, 請留意時間格式
    
    for i=2:rrLen
        % N 時間點
        tPrev = DateStr2Num(data(r(i-1)), 1030);
        % N+1 時間點
        tNext = DateStr2Num(data(r(i)), 1030);
        % N 與 N+1 時間差(ms)
        rr_interval(i-1) = diff([ tPrev ; tNext ])*24*3600*1000;
    end
end

