function [ K ] = matriceK( X )
%MATRICEK Summary of this function goes here
%   Detailed explanation goes here

    N = size(X,1);
    NN=1:N;
    for i=NN
        for j=NN
            K(i,j) = kernel(X(i,:), X(j,:));
        end
    end

end

