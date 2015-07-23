function [y, w, o] = rnvc(x, Y, a, NumeroDiEpoche, importanza)

w = sign(importanza(car));
o = 0;

s=0;
e = NaN(NumeroDiEsempi,NumeroDiEpoche);
f = NaN(NumeroDiEsempi,NumeroDiEpoche);
NeNe = NumeroDiEsempi*NumeroDiEpoche;
mw= NaN(1, NeNe);
mo= NaN(1, NeNe);
for j = 1:NumeroDiEpoche
    p = randperm(NumeroDiEsempi);
    for i = 1:NumeroDiEsempi
        f(p(i), j) = tanh( x(p(i)) * w - o);
        e(p(i), j) = Y(p(i)) - f(p(i),j);
        dy = e(p(i), j) * f(p(i),j) * (1-f(p(i),j));
%         dw = (a * e(p(i), j) * x(p(i),:))';
%         w = w + dw;
        do = a * e(p(i),j);
        o = o - do;
        s = s + 1;
        mw(:,s) = w;
        mo(:,s) = o;
    end
end

end

