function [C, percentuale, risposte, giuste] = my_svmtrain (iris, NumCicli, P, base)
%MY_SVMTRAIN Summary of this function goes here
%   Detailed explanation goes here

global X Y;
NE = size(X);
NF = length(poly2fimap(X(1,:)));    % dimensione dello spazio delle caratteristiche

global obiettivo;

% a0 = 0.01*rand(NE,1);
a0 = zeros(NE,1);
% A = ones(1,NE);
% B = zeros(NE,1);
Aeq = Y';
Beq = 0;
% e ....
lb = [];
vincnonlin = [];
options = optimset('Display','off','Algorithm','active-set');

C = NaN(1,NumCicli);                %
percentuale = NaN(1,NumCicli);      %
conta = 1;                          %
for p = P
    disp(['Ciclo ', num2str(conta) '/' num2str(NumCicli)]); drawnow
    C(conta) = base^p;
    lu = C(conta)*ones(size(a0));

    a = fmincon(obiettivo,...
        a0,...
        [], [],...              % ci sarebbero A, B,...
        Aeq, Beq,...
        lb, lu,...
        vincnonlin,...
        options);
    
    w = zeros(1,NF);
    for i=1:NE
        w = w + a(i)*Y(i)*poly2fimap(X(i,:),1);
    end
    w = w';
    b = 0;
    
    risposte = sign(iris.validation.map*w+b);
    giuste = risposte.*iris.validation.y;
    percentuale(conta) = sum(giuste(giuste==1))/length(risposte)*100;
    
    conta = conta+1;
%     disp('Vettore W e soglia B');
%     disp(w);
%     disp(b);
%     
%     x = -2:.5:2;
%     y = -2:.5:2;
%     f = NaN(length(x), length(y));
%     for i=1:length(x)
%         for j=1:length(y)
%             ics = [x(i) y(j)];
%             f(i,j) = sign( poly2fimap(ics,1)*w + b );
%         end
%     end
%     
%     figure(conta); clf;
%     hold on;
%     [c,h]=contour(x,y,f, min(min(f)):1:max(max(f)));
%     axis('equal');
%     text_handle = clabel(c,h);
%     % colormap autumn
%     colorbar
%     plot(X(Y==1,1), X(Y==1,2), 'or', 'MarkerFace', 'r');
%     plot(X(Y==-1,1), X(Y==-1,2), 'ob', 'MarkerFace', 'b');
%     hold off;
end

end

