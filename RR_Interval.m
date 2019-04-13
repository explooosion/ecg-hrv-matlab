function rr_interval = RR_Interval(r,data)
    % r = R�i���ޭ�
    % data = ��l��� (�a����ƻP�ɶ�)
    % ���o RR �Ӽ�, len = RR �Ӽ�    
    [a, rrLen]=size(r);
    % �ɶ��t ms, �Яd�N�ɶ��榡
    for i=2:rrLen
        % N �ɶ��I
        tPrev = datetime(data.('Time')(r(i-1)), 'InputFormat', 'yyyy-MM-dd''T''HH:mm:ss.SSS', 'Format', 'yyyy-MM-dd HH:mm:ss.SSS');
        % N+1 �ɶ��I
        tNext = datetime(data.('Time')(r(i)), 'InputFormat', 'yyyy-MM-dd''T''HH:mm:ss.SSS', 'Format', 'yyyy-MM-dd HH:mm:ss.SSS');
        % N �P N+1 �ɶ��t(ms)
        rr_interval(i-1) = milliseconds(diff(datetime([ tPrev ; tNext ])));
    end
end

