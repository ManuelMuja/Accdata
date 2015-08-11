% I	= 1:NC;
% tmin	= 3.5;
% tmax	= 5;
% 
% imin	= I(t==tmin);
% imax	= I(t==tmax);
% II	= imin:imax;
% TT	= t(imin:imax);

d = 1
figure(1);
subplot(321);
	plot(t, lanciotappo(:,d,1));
	axis([t(primo(1)) t(ultimo(1)), -8 8]);
	box off;
	title('lancio 1');
subplot(322);
	plot(t, lanciotappo(:,d,2));
	axis([t(primo(2)) t(ultimo(2)), -8 8]);
	box off;
	title('lancio 2');
subplot(323);
	plot(t, lanciotappo(:,d,3));
	axis([t(primo(3)) t(ultimo(3)), -8 8]);
	box off;
	title('lancio 3');
subplot(324);
	plot(t, lanciotappo(:,d,4));
	axis([t(primo(4)) t(ultimo(4)), -8 8]);
	box off;
	title('lancio 4');
subplot(325);
	plot(t, lanciotappo(:,d,5));
	axis([t(primo(5)) t(ultimo(5)), -8 8]);
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
switch d
  case {1}
    nomefile = '02guardare/diseX.pdf';
  case {2}
    nomefile = '02guardare/diseY.pdf';
  case {3}
    nomefile = '02guardare/diseZ.pdf';
end
print ('-dpdf', nomefile);

figure(2);
print -dpdf 02guardare/prove.pdf


disp(['Current folder: ' pwd])
