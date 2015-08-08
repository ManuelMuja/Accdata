%% INIZIO
% function [ ret ] = main( X, Y)
%MAIN Summary of this function goes here
%   Detailed explanation goes here

clear all; clc; clf;

global X Y K;
global map obiettivo;
global a0;
map = @poly2fimap;
obiettivo = @lagrangiana;

iris_script;

X = iris.training.x;
Y = iris.training.y;

[NE, NX] = size(X);

NY = size(Y,2);

% Esempi = [X,Y];

K = matriceK(X);

a0 = zeros(NE,1);

% break
%% Addestramento
NumZummate = 2;         % Si cerca innanzitutto il C migliore
NumCicli = 5;   % >= 5  % con una grid-search prima grossolana
pmin = -5;              % C = 10^(-5), 10^(-5/2), 1, 10^(5/2), 10^5
pmax = 5;               % poi sempre più fine
base = 10;              % 
% base = 2;
% base = e;
for nz = 1:NumZummate
    P = linspace(pmin, pmax, NumCicli);
    disp(['Zummata ' num2str(nz) '/' num2str(NumZummate)]); drawnow
    [C, percentuale] = my_svmtrain (iris, NumCicli, P, base);

figure(3);
semilogx(C, percentuale, '-bs', 'LineWidth', 1, 'MarkerSize', 5, 'MarkerFaceColor', 'w');
hold on; drawnow;

    [bestP i] = max(percentuale);

    bestC = C(i);
    scritta = ['Con C = ' num2str(bestC) ' si ha accuratezza del ' num2str(bestP) '% in fase di validazione'];
    disp(scritta); drawnow
    
    ppasso = (pmax-pmin)/(NumCicli-1);
    pmin=P(i)-ppasso;
    pmax=P(i)+ppasso; 
end

%% Ricalcolo con C = bestC
% A = ones(1,NE);
% B = zeros(NE,1);
Aeq = Y';
Beq = 0;
% e ....
lb = [];
vincnonlin = [];
options = optimset('Display','off','Algorithm','active-set');
lu = bestC*ones(NE,1);

[a,fval,exitflag] = fmincon(obiettivo,...
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

risposte = sign(iris.test.map*w+b);
giuste = risposte.*iris.test.y;
percentuale.test = sum(giuste(giuste==1))/length(risposte)*100;
    
scritta = ['Con C = ' num2str(bestC) ' si ha accuratezza del ' num2str(percentuale.test) '% in fase di test'];
disp(scritta); drawnow


%% figure 1

iris.training.pos = iris.training.x(iris.training.y==1,:);

iris.training.neg = iris.training.x(iris.training.y==-1,:);

iris.test.pos.all = iris.test.x(iris.test.y==1,:);

ind = (iris.test.y==1) .* (risposte==1);
iris.test.pos.ok = iris.test.x(logical(ind),:);
clear ind;
ind = (iris.test.y==1) .* (risposte==-1);
iris.test.neg.falsi = iris.test.x(logical(ind),:);


iris.test.neg.all = iris.test.x(iris.test.y==-1,:);
clear ind;
ind = (iris.test.y==-1) .* (risposte==-1);
iris.test.neg.ok = iris.test.x(logical(ind),:);
clear ind;
ind = (iris.test.y==-1) .* (risposte==1);
iris.test.pos.falsi = iris.test.x(logical(ind),:);

asv = a(a>0);
iris.supportvectors.all = iris.training.x(a>0,:);
isv = iris.supportvectors.all;

iris.supportvectors.pos = iris.training.x(logical((a>0) .* (iris.training.y==1)), :);
iris.supportvectors.neg = iris.training.x(logical((a>0) .* (iris.training.y==-1)), :);

figure(1); clf;
hold on;
plot(iris.supportvectors.pos(:,3), iris.supportvectors.pos(:,4),...
    'bo',...
    'LineWidth',1,...
    'MarkerSize', 10,...
    'MarkerFaceColor', [0.8 0.8 1.0]);
plot(iris.supportvectors.neg(:,3), iris.supportvectors.neg(:,4),...
    'ro',...
    'LineWidth',1,...
    'MarkerSize', 10,...
    'MarkerFaceColor', [1.0 0.8 0.8]);
plot(iris.training.pos(:,3), iris.training.pos(:,4),...
    'bo',...
    'MarkerSize', 10);
plot(iris.training.neg(:,3), iris.training.neg(:,4),...
    'ro',...
    'MarkerSize', 10);
plot(iris.test.pos.ok(:,3), iris.test.pos.ok(:,4),...
    'b+',...
    'MarkerSize', 5);
plot(iris.test.neg.ok(:,3), iris.test.neg.ok(:,4),...
    'r+',...
    'MarkerSize', 5);
plot(iris.test.neg.falsi(:,3), iris.test.neg.falsi(:,4),...
    'bx',...
    'LineWidth',2,...
    'MarkerSize', 10);
plot(iris.test.pos.falsi(:,3), iris.test.pos.falsi(:,4),...
    'rx',...
    'LineWidth',2,...
    'MarkerSize', 10);
hold off;
xlabel('Petal length');
ylabel('Petal width');
legend('Vettori di Supporto +1', 'Vettori di Supporto -1',...
    'Altri vettori di addestramento +1', 'e -1',...
    'Test con successo +1', 'e -1',...
    'Falsi positivi', 'Falsi negativi',...
    'Location', 'SouthEast');
grid on;
box off;
% axis([0.5 5.5, 0 2]);

DataOra = clock;
nomefig = ['iris1-' num2str(DataOra(1)) '-' num2str(DataOra(2)) '-' num2str(DataOra(3)) '-' num2str(DataOra(4)) '-' num2str(DataOra(5))];
print ('-dpdf', nomefig);

%% figure 2

iris.setosa.set = iris.sample.set(1:50, :);
iris.versicolor.set = iris.sample.set(51:100, :);
iris.virginica.set = iris.sample.set(101:end, :);
figure(2); clf;
hold on;
irisH(:,1) = plot((1:4)-.2, iris.setosa.set', 'bo', 'MarkerSize', 8);% legend(irisH,'.setosa');
irisH(:,2) = plot(1:4, iris.versicolor.set', 'b^', 'MarkerSize', 8);% legend(irisH(2),'Versicolor');
irisH(:,3) = plot((1:4)+.2, iris.virginica.set', 'bs', 'MarkerSize', 8);% legend(irisH(3),'Virginica');

axis([0 5, 0 8], 'square');
xlabel('Sepal length, Sepal width, Petal length, Petal width');
title('iris');
% legend('.setosa', 'Versicolor', 'Virginica');
set(gca, 'XGrid', 'on', 'XTick', [1 2 3 4]);

DataOra = clock;
nomefig = ['iris2-' num2str(DataOra(1)) '-' num2str(DataOra(2)) '-' num2str(DataOra(3)) '-' num2str(DataOra(4)) '-' num2str(DataOra(5))];
print ('-dpdf', nomefig);

%% figure 3

figure(3);
plot(bestC, bestP, 'or', 'LineWidth', 2, 'MarkerSize', 30);
hold off;
xlabel('C');
ylabel('Percentuale di azzeccamento');
grid on;
box off;

DataOra = clock;
nomefig = ['iris3-' num2str(DataOra(1)) '-' num2str(DataOra(2)) '-' num2str(DataOra(3)) '-' num2str(DataOra(4)) '-' num2str(DataOra(5))];
print ('-dpdf', nomefig);


%% figure 4
iris.data.pos = iris.data.set(iris.data.set(:,end)==1, 1:end-1);
iris.data.neg = iris.data.set(iris.data.set(:,end)==-1, 1:end-1);

figure(4); clf;
subplot(331);
  plot(iris.data.pos(:,1), iris.data.pos(:,2),...
    'bo',...
    'LineWidth',.5,... 
    'MarkerSize', 2,...
    'MarkerFaceColor', [0.8 0.8 1.0]);
  hold on;
  plot(iris.data.neg(:,1), iris.data.neg(:,2),...
    'ro',...
    'LineWidth',.5,... 
    'MarkerSize', 2,...
    'MarkerFaceColor', [1.0 0.8 0.8]);
  hold off;
  ylabel('Sepal width');

subplot(334);
  plot(iris.data.pos(:,1), iris.data.pos(:,3),...
    'bo',...
    'LineWidth',.5,... 
    'MarkerSize', 2,...
    'MarkerFaceColor', [0.8 0.8 1.0]);
  hold on;
  plot(iris.data.neg(:,1), iris.data.neg(:,3),...
    'ro',...
    'LineWidth',.5,... 
    'MarkerSize', 2,...
    'MarkerFaceColor', [1.0 0.8 0.8]);
  hold off;
  ylabel('Petal length');
  axis([4 8, 0 8]);

subplot(337);
  plot(iris.data.pos(:,1), iris.data.pos(:,4),...
    'bo',...
    'LineWidth',.5,... 
    'MarkerSize', 2,...
    'MarkerFaceColor', [0.8 0.8 1.0]);
  hold on;
  plot(iris.data.neg(:,1), iris.data.neg(:,4),...
    'ro',...
    'LineWidth',.5,... 
    'MarkerSize', 2,...
    'MarkerFaceColor', [1.0 0.8 0.8]);
  hold off;
  xlabel('Sepal length');
  ylabel('Petal width');
  
subplot(335);
  plot(iris.data.pos(:,2), iris.data.pos(:,3),...
    'bo',...
    'LineWidth',.5,... 
    'MarkerSize', 2,...
    'MarkerFaceColor', [0.8 0.8 1.0]);
  hold on;
  plot(iris.data.neg(:,2), iris.data.neg(:,3),...
    'ro',...
    'LineWidth',.5,... 
    'MarkerSize', 2,...
    'MarkerFaceColor', [1.0 0.8 0.8]);
  hold off;
  axis([2 5, 0 8]);

subplot(338);
  plot(iris.data.pos(:,2), iris.data.pos(:,4),...
    'bo',...
    'LineWidth',.5,...
    'MarkerSize', 2,...
    'MarkerFaceColor', [0.8 0.8 1.0]);
  hold on;
  plot(iris.data.neg(:,2), iris.data.neg(:,4),...
    'ro',...
    'LineWidth',.5,... 
    'MarkerSize', 2,...
    'MarkerFaceColor', [1.0 0.8 0.8]);
  hold off;
  xlabel('Sepal width');
  
subplot(339);
  plot(iris.data.pos(:,3), iris.data.pos(:,4),...
    'bo',...
    'LineWidth',.5,... 
    'MarkerSize', 2,...
    'MarkerFaceColor', [0.8 0.8 1.0]);
  hold on;
  plot(iris.data.neg(:,3), iris.data.neg(:,4),...
    'ro',...
    'LineWidth',.5,... 
    'MarkerSize', 2,...
    'MarkerFaceColor', [1.0 0.8 0.8]);
  xlabel('Petal length');
  hold off;
  axis([0 8, 0 3]);

% DataOra = clock;
% nomefig = ['iris4-' num2str(DataOra(1)) '-' num2str(DataOra(2)) '-' num2str(DataOra(3)) '-' num2str(DataOra(4)) '-' num2str(DataOra(5))];
% print ('-dpdf', nomefig);
  
%% FINE
iris.quanti.pos.falsi = size(iris.test.pos.falsi,1);
iris.quanti.neg.falsi = size(iris.test.neg.falsi,1);
scritta = ['Ci sono ' num2str(iris.quanti.pos.falsi) ' falsi positivi e ' num2str(iris.quanti.neg.falsi) ' falsi negativi'];
disp(scritta); drawnow



