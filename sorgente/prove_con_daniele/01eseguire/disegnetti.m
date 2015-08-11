I	= 1:NC;
tmin	= 3.5;
tmax	= 5;

imin	= I(t==tmin);
imax	= I(t==tmax);
II	= imin:imax;
TT	= t(imin:imax);

figure(1);
subplot(321);
	plot(TT, lanciotappo(imin:imax,1,1));
	box off;
	title('lancio 1');
subplot(322);
	plot(TT, lanciotappo(imin:imax,1,2));
	box off;
	title('lancio 2');
subplot(323);
	plot(TT, lanciotappo(imin:imax,1,3));
	box off;
	title('lancio 3');
subplot(324);
	plot(TT, lanciotappo(imin:imax,1,4));
	box off;
	title('lancio 4');
subplot(325);
	plot(TT, lanciotappo(imin:imax,1,5));
	box off;
	title('lancio 5');


figure(2);
subplot(221);
	plot(t, dxsx(:,3));
	title('Destra-sinistra, z');
subplot(222);
	plot(t, avin(:,1));
	title('Avanti-Indietro, x');
subplot(223);
	plot(t, sugiu(:,2));
	title('Su-giu`, y');



cd ..
figure(1);
print -dpdf 02guardare/diseX.pdf

figure(2);
print -dpdf 02guardare/prove.pdf


disp(['Current folder: ' pwd])
