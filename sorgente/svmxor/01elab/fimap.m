function [ map ] = fimap( x )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    map = [
        1
        x(1)^2
        sqrt(2)*x(1)*x(2)
        x(2)^2
        sqrt(2)*x(1)
        sqrt(2)*x(2)
    ]';

end

