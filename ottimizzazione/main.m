clear all;
clc; clf;

load esempi x y;

obiettivo = @funzione;
a0 = 0.01*rand(16,1);
A = ones(1,16);
b = zeros(16,1);
% Aeq = [];
% beq = [];
% da provare
Aeq = y';
beq = 0;
% e ....
lb = [];
lu = [];
% vincnonlin = @supporto;
% ... togliere i vincoli non lineari
vincnonlin = [];
options = optimset('Display','iter','Algorithm','active-set');

[a,fval,exitflag,output,lambda,grad,hessian] = fmincon( obiettivo,...
                                                        a0,...
                                                        A, b,...
                                                        Aeq, beq,...
                                                        lb, lu,...
                                                        vincnonlin,...
                                                        options);
a
fval
% [X,Y]=meshgrid(-1:.01:1);
% for h=1:size(X,1)
%     for k=1:size(X,2)
%         F(h,k) = funzione([X(h,k), Y(h,k)]);
%         C(h,k) = supporto([X(h,k), Y(h,k)]);
%     end
% end

% figure(1);
% hold on;
% [c,h]=contour(X,Y,F, min(min(F)):.2:max(max(F)));
% contour(X,Y,C, 1);
% axis('equal');
% text_handle = clabel(c,h);
% % colormap autumn
% colorbar
% hold off;