function rr_interval = RR_Interval(r,data)
    % r = R�i���ޭ�
    % data = ��l��� (�a����ƻP�ɶ�)
    % ���o RR �Ӽ�, len = RR �Ӽ�    
    [a, rrLen]=size(r);
    % �ɶ��t ms, �Яd�N�ɶ��榡
    
    for i=2:rrLen
        % N �ɶ��I
        tPrev = DateStr2Num(data(r(i-1)), 1030);
        % N+1 �ɶ��I
        tNext = DateStr2Num(data(r(i)), 1030);
        % N �P N+1 �ɶ��t(ms)
        rr_interval(i-1) = diff([ tPrev ; tNext ])*24*3600*1000;
    end
end

