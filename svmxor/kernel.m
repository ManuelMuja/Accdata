function [ k ] = kernel( x1, x2 )
%KERNEL Summary of this function goes here
%   Detailed explanation goes here

gamma = 1;
k = (1+dot(x1,x2))^2;
% k = gamma*norm(x2-x1)^2;
end

