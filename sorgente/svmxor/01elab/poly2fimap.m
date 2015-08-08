function [ fi ] = poly2fimap( x, c )
%POLY2FIMAP feature map of second-degree polynomial kernel
%   [ FI ] = POLY2FIMAP ( X, C )
%   X is the vector to be mapped with K = (C + <X'*X>)^2
%   C is the constant (default 1)

N = length(x);

if (nargin == 1)
    c = 1;
end

fi = x.^2;                          % FI_c (x) = x_1^2 ,..., x_N^2,
for i = N:-1:2                      
    for j = i-1:-1:1                %   rad2 x_N x_(N-1) ,..., rad2 x_N x_1,
        fi = [fi sqrt(2)*x(i)*x(j)];%   rad2 x_(N-1) x_(N-2) ,..., rad2 x_(N-1) x_1,
    end                             %   ... , rad2 x_2 x_1,
end                                 
for i = N:-1:1
    fi = [fi sqrt(2*c)*x(i)];       %   rad(2c) x_N ,..., rad(2c) x_1,
end

fi = [fi c];                        %   c

end

