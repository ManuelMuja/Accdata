%% Importazione

fc = 10e3;
tc = 1/fc;
c2g= .0375/5;

cd ../00importare/
printf('\nInizio a importare\n');

printf('\nDestra e sinistra...'); fflush(stdout);
dx_sx_7_8_2015
dxsx = CH(:,2:4)*c2g;
clear CH;

printf('\nAvanti e indietro...'); fflush(stdout);
avan_ind_7_8_2015
avin = CH(:,2:4)*c2g;
clear CH;

printf('\nSu e giu`...'); fflush(stdout);
su_giu_7_8_2015
sugiu = CH(:,2:4)*c2g;
clear CH;

printf('\nlancio 1, '); fflush(stdout);
lancio_tappo1_7_8_2015
lanciotappo(:,1:3,1) = CH(:,2:4)*c2g;
clear CH;

printf('2, '); fflush(stdout);
lancio_tappo2_7_8_2015
lanciotappo(:,1:3,2) = CH(:,2:4)*c2g;
clear CH;

printf('3, '); fflush(stdout);
lancio_tappo3_7_8_2015
lanciotappo(:,1:3,3) = CH(:,2:4)*c2g;
clear CH;

printf('4, '); fflush(stdout);
lancio_tappo4_7_8_2015
lanciotappo(:,1:3,4) = CH(:,2:4)*c2g;
clear CH;

printf('5'); fflush(stdout);
lancio_tappo5_7_8_2015
lanciotappo(:,1:3,5) = CH(:,2:4)*c2g;
clear CH;

printf('\n\nFINE!\n\n'); fflush(stdout);

[NC ND NN] = size(lanciotappo);

t = [1:NC]*tc;

save "dati.mat"
cd ../01eseguire
