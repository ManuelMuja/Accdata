function f = funzione(a)
%FUNZIONE Summary of this function goes here
%   Detailed explanation goes here

load esempi x y;

Nb=1;
Na=size(x,2);

f = sum(a);

for i=Nb:Na
    for j=Nb:Na
        A = a(i)*a(j);
        Y = y(i)*y(j);
        X = dot(x(i,:),x(j,:));
        f = -( f - 1/2*A*Y*X );
    end
end

end

