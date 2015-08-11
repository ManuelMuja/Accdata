%% Importazione

fc = 10e3;
tc = 1/fc;
c2g= .0375/5;

cd ../00importare/
sprintf('\nInizio a importare\n');

sprintf('\nDestra e sinistra...'); drawnow;
dx_sx_7_8_2015
dxsx = CH(:,2:4)*c2g;
clear CH;

sprintf('\nAvanti e indietro...'); drawnow;
avan_ind_7_8_2015
avin = CH(:,2:4)*c2g;
clear CH;

sprintf('\nSu e giu`...'); drawnow;
su_giu_7_8_2015
sugiu = CH(:,2:4)*c2g;
clear CH;

sprintf('\nlancio 1, '); drawnow;
lancio_tappo1_7_8_2015
lanciotappo(:,1:3,1) = CH(:,2:4)*c2g;
clear CH;

sprintf('2, '); drawnow;
lancio_tappo2_7_8_2015
lanciotappo(:,1:3,2) = CH(:,2:4)*c2g;
clear CH;

sprintf('3, '); drawnow;
lancio_tappo3_7_8_2015
lanciotappo(:,1:3,3) = CH(:,2:4)*c2g;
clear CH;

sprintf('4, '); drawnow;
lancio_tappo4_7_8_2015
lanciotappo(:,1:3,4) = CH(:,2:4)*c2g;
clear CH;

sprintf('5'); drawnow;
lancio_tappo5_7_8_2015
lanciotappo(:,1:3,5) = CH(:,2:4)*c2g;
clear CH;

sprintf('\n\nFINE!\n\n'); drawnow;

[NC ND NN] = size(lanciotappo);

t = [1:NC]*tc;

save dati_matlab
cd ../01eseguire
