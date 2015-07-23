%% kerkernel
function [k] = kerkernel(X, x, tipo, par1, par2, par3)

% [k] = kerkernel (X, x, type, par1, par2, par3)
% Computes generalized inner product (kernel)
% between rows of matrix X and vector x
% 
% See also KERNEL

    N = size(X,1);
    k = NaN(N,1);
    for n = 1:N
        k(n) = kernel(X(n,:),x, tipo, par1, par2, par3);
    end
end
