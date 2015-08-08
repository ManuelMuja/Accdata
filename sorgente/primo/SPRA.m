function [y] = SPRA (X)
% Simple Pattern Recognition Algorithm
% [y] = SPRA (X)
% 
% Computes mean point of class1, mean point of class2,
% the difference vector 'w=c1-c2' is applied in 'c=(c1+c2)/2',
% than classification of a vector 'x=X(i,:)' is computed as
% sign( dot(x-c, w) )
%
% See also DOT, KERNEL



cp = 1/8*sum(X(1:8,:));
cm = 1/8*sum(X(9:16,:));
c  = (cp+cm)/2;
w  = (cp-cm)';
cc = ones(16,1)*c;

y = sign((X-cc)*w);

end

