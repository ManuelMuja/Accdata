function imp = ImportanzaDelleCaratteristiche(X)

[NumeroDiEsempi, NumeroDiIngressi] = size(X);
importanza=NaN(1,NumeroDiIngressi);

for i = 1:NumeroDiIngressi
    x = X(:,i);
    bau = sortrows([x,Y], 1);
%   importanza(i) = dot(bau(:,2), Y);
    baubau = bau(:,2).*Y;
    importanza(i) = sum(baubau);
end
importanza = -importanza/NumeroDiEsempi;

end

