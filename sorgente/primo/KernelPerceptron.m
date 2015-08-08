function [y, a, e] = KernelPerceptron (X, Y, FdA, NumeroDiEpoche, tipo)

a = zeros(NE, 1);
y = NaN(NE,1);
e = NaN(NE,1);
b = [];
for j = 1:NumeroDiEpoche
    p = randperm(NE);
    for i = 1:NE
        kk = kerkernel(X, X(p(i),:), 'gauss', 0, 1, 0);
        y(p(i)) = sign(sum(a .* Y .* kk));
        a(y~=Y) = a(y~=Y)+1;
    end
    e(j) = sum(y ~= Y);
end

end
