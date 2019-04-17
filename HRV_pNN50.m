function [NN50,pNN50] = pNN50(RRI)

[a, rrLen]=size(RRI);

% 指標 - NN50(個數)
NN50 = 0;

% 指標 - pNN50(所佔比例%)
pNN50 = 0;

for i=2:rrLen
   % 每對相鄰的 RRI 超過 50ms的個數
   if( abs( RRI(i) - RRI(i-1) ) > 50 )
       NN50 = NN50 + 1;
   end
end

% 指標 - pNN50, NN50 佔 RRI 的總比例(%)
pNN50 = NN50 / rrLen * 100;

end

