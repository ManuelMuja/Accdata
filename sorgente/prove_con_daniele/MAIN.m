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
subplot(221); plot(acc(:,1,n), acc(:,3,n)); ylabel('acc_z');
subplot(222); plot(acc(:,1,n), acc(:,2,n)); xlabel('acc_y');
subplot(223); plot(acc(:,2,n), acc(:,3,n)); xlabel('acc_x'); ylabel('acc_y');
subplot(224); plot3(acc(:,1,n), acc(:,2,n), acc(:,3,n));
xlabel('acc_x'); ylabel('acc_y'); zlabel('acc_z');
drawnow;
print -depsc ../02guardare/acc3d
clf;


subplot(221); plot(vel(:,1,n), vel(:,3,n)); ylabel('vel_z');
subplot(222); plot(vel(:,1,n), vel(:,2,n)); xlabel('vel_y');
subplot(223); plot(vel(:,2,n), vel(:,3,n)); xlabel('vel_x'); ylabel('vel_y');
subplot(224); plot3(vel(:,1,n), vel(:,2,n), vel(:,3,n));
xlabel('vel_x'); ylabel('vel_y'); zlabel('vel_z');
drawnow;
print -depsc ../02guardare/vel3d
clf;


subplot(221); plot(pos(:,1,n), pos(:,3,n)); ylabel('pos_z');
subplot(222); plot(pos(:,1,n), pos(:,2,n)); xlabel('pos_y');
subplot(223); plot(pos(:,2,n), pos(:,3,n)); xlabel('pos_x'); ylabel('pos_y');
subplot(224); plot3(pos(:,1,n), pos(:,2,n), pos(:,3,n));
xlabel('pos_x'); ylabel('pos_y'); zlabel('pos_z');
drawnow;
print -depsc ../02guardare/pos3d
clf;



% cd 01eseguire
disegnetti;

