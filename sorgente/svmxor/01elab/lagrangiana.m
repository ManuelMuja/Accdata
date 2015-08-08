function [ Q ] = lagrangiana( a )
%LAGRANGIANA Summary of this function goes here
%   Detailed explanation goes here

global Y K;

NN = 1:size(Y,1);

Q=0;
for i=NN
    for j=NN
        Q = Q + a(i)*a(j)*Y(i)*Y(j)*K(i,j);
    end
end

Q = .5*Q - sum(a);

end