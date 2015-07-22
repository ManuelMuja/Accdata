function [ k ] = kerkernel( X, x )
%KERKERNEL Summary of this function goes here
%   Detailed explanation goes here

    for i = 1:size(X,1)
        k(i,:) = kernel(X(i,:),x);
    end
end

