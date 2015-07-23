%% kernel
function [k] = kernel(x1, x2, tipo, par1, par2, par3)
% KERNEL  Compute generalized inner product between two vectors
%   k = kernel (x1, x2, type, par1, par2, par3)
%   
%   NB: arguments labeled with 'any' can be any number or anything
%       because are not involved in computation
%   k = kernel (x1, x2, 'poly', p, gamma, r) = ( r + gamma*dot(x1, x2) )^p
%     polinomial kernel
%   k = kernel (x1, x2, 'dot', any, any, any) = dot(x1, x2)
%     dot (inner, scalar) product or linear kernel
%     same as kernel(x1, x2, 1, 1, 0)
%   k = kernel (x1, x2, 'rbf', any, gamma, any) = exp(-gamma*norm(x1-x2)^2)
%     radial basis function kernel
%   k = kernel (x1, x2, 'gauss', any, sigma, any) = exp(-norm(x1-x2)^2/(2*sigma^2)
%     gaussian kernel
%     same as kernel (x1, x2, 'rbf', any, 1/(2*sigma^2), any)
%   k = kernel (x1, x2, 'sigmoid', any, gamma, r) =  tanh( gamma*dot(x1, x ) + r)
%     
% See also DOT, KERKERNEL

    switch (tipo)
        case 'dot'
            k = dot(x1, x2);
        case 'poly'
            p = par1;
            gamma = par2;
            r = par3;
            k = ( r + gamma*dot(x1, x2) )^p;
        case 'gauss'
            sigma = par2;
            k = exp(-norm(x1-x2)^2/(2*sigma^2));
        case 'rbf'
            gamma = par2;
            k = exp(-gamma*norm(x1-x2)^2);
        case 'sigmoid'
            gamma = par2;
            r = par3;
            k = tanh(gamma*dot(x1, x2)+r);
    end
end

% kernel = @(x,y) 1+dot(x,y)
% alpha*kernel
