clear all; clf; clc;

%%
%
%
%

% cd 01eseguire
% importazione
% % cd ..

load '00importare/dati_matlab'

cd 01eseguire
segmenta;

% media mobile
M = 5;
a = 1;			% preparo i polinomi
b = ones(1,M); b = b/sum(b);	% per la media mobile

n = 4;
acc(:,:,n) = filter(b, a, lanciotappo(primo(n):ultimo(n),:,n));
vel(:,:,n) = cumsum(acc(:,:,n));
pos(:,:,n) = cumsum(vel(:,:,n));
figure(3);
  plotyy(t(primo(n):ultimo(n)), acc(:,:,n),...
  t(primo(n):ultimo(n)), vel(:,:,n));
print -depsc ../02guardare/vel4.eps



% cd 01eseguire
disegnetti;
