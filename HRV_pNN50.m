function [NN50,pNN50] = pNN50(RRI)

[a, rrLen]=size(RRI);

% ���� - NN50(�Ӽ�)
NN50 = 0;

% ���� - pNN50(�Ҧ����%)
pNN50 = 0;

for i=2:rrLen
   % �C��۾F�� RRI �W�L 50ms���Ӽ�
   if( abs( RRI(i) - RRI(i-1) ) > 50 )
       NN50 = NN50 + 1;
   end
end

% ���� - pNN50, NN50 �� RRI ���`���(%)
pNN50 = NN50 / rrLen * 100;

end

