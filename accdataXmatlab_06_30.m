%% Accelerometer Values

% filename:  accdata.txt
% Saving start time: Thu Apr 16 12:55:37 GMT+02:00 2015

% sensor resolution: 0.038307227m/s^2
%Sensorvendor: , name: 3-axis Accelerometer, type: 1,version : 1, range 39.2

% X value, Y value, Z value, time diff in ms

clear all;
load ws IDX C SUMD D;
clc; clf;

load accdataWS DatiGrezzi;
A = DatiGrezzi;
% end
%Thu Apr 16 12:56:47 GMT+02:00 2015

NN = length(A);
x = A(:,1);
y = A(:,2);
z = A(:,3);
t = zeros(1,NN);
for n = 2:NN
  t(n) = t(n-1)+A(n,4);
end



%% Media mobile
M = 13;
P = 3;
flo = floor(M/2);
p=1;
for n = (flo+1):P:(NN-flo)
  AMM(p,1:3) = sum(A(n-flo:n+flo, 1:3))/M;
  AMM(p,4)   = t(n);
  p=p+1;
end

NN = length(AMM);

xmm = AMM(:,1);
ymm = AMM(:,2);
zmm = AMM(:,3);
tmm = AMM(:,4);

% figure(2);
% plot(xmm, 'k;x;',
%      ymm, 'b;y;',
%      zmm, 'r;z;'
%     );
% title("Media mobile");
% xlabel("Campioni");
% ylabel("Accelerazioni");
% grid minor on;
% box off;

% drawnow;
% pause(2);

%% divisione in esempi
load accdataWS DatiBuoni;

B = DatiBuoni;

%% Calcoliamo alcune caratteristiche statistiche
% dei nostri esempi:
% per adesso `media' e `varianza'
stat(1,:,:) = nanmean(B);
stat(2,:,:) = std(B);
[NS ND NE] = size(stat);

temp = permute(stat, [3 2 1]);
stat = NaN(16,3);
j=0;
for i = 1:NS
    stat(:,j+1:j+ND) = temp(:,:,i);
    j=j+ND;
end

%% ora ``stat'' ha la forma di una tabella
% con tante righe quanti sono gli esempi (NE)
% e ND*NS colonne 
% mediaX mediaY mediaZ stdX stsY stdZ ...

media = mean(stat);
StatCorr = (stat-ones(NE,1)*media);
varia = std(stat);
StatCorr = StatCorr./(ones(NE,1)*varia);

% figure(2);
% plot(1:NS*ND, StatCorr(1:8,:)', 'ob',...
%     1:NS*ND, StatCorr(9:16,:), 'or');

figure(2);
plot(1:NS*ND, stat(1:8,:)', 'ob',...
    1:NS*ND, stat(9:16,:), 'or');

%% distanze e scalaggio dimensionale
[MulDimScal] = mdscale(pdist(stat, 'euclidean'), 2, 'Criterion', 'sstress');
size(MulDimScal);

% figure(3);
% for secondi = 3:-1:1
% plot(MulDimScal(1:8,1), MulDimScal(1:8,2), 'ob',...
%     MulDimScal(9:16,1), MulDimScal(9:16,2), 'or');
% title(secondi);
% pause(.1);
% end
%% Kmeans
X = stat;
K = 5;
% [IDX, C, SUMD, D] = kmeans(X, K);
save ws;

%% scalaggio dopo il kmeans
clear MulDimScal stress disparities
% [Y, I] = sortrows([X, IDX], NS*ND+1);
% temp=Y;
% [Y(:,end), (1:16)']
% clear Y;
% Y = [temp(:,1:end-1); C];

% [MulDimScalY] = mdscale(pdist([Y],'euclidean'), 2, 'Criterion', 'sstress');
[MulDimScalX] = mdscale(pdist([X;C],'euclidean'), 2, 'Criterion', 'sstress');


% k = convhull(x,y);
% plot(x(k),y(k),'r-',x,y,'b+')



figure(1);

plot(MulDimScalX(1:8,1),MulDimScalX(1:8,2),'ro',...
                       'MarkerEdgeColor','b',...
                       'MarkerFaceColor','c',...
                       'MarkerSize',6);
hold on;
plot(MulDimScalX(9:16,1),MulDimScalX(9:16,2),'ro',...
                       'MarkerEdgeColor','b',...
                       'MarkerFaceColor','w',...
                       'MarkerSize',6);
hold on;
plot(MulDimScalX(17:end,1),MulDimScalX(17:end,2),'kx',...
                       'MarkerEdgeColor','k',...
                       'MarkerFaceColor','k',...
                       'MarkerSize',6);
hold off;
                   
% plot(MulDimScalX(1:8,1), MulDimScalX(1:8,2),'.b',...
%     MulDimScalX(9:16,1), MulDimScalX(9:16,2),'.r',...
% 	MulDimScalX(17:end,1), MulDimScalX(17:end,2), 'xk');

%% Disegna le statistiche
% pause();
figure(4); clf;
plot(stat(1:8,5), stat(1:8,6), 'ob',...
    stat(9:16,5), stat(9:16,6), 'xr');

%% RETE NEURALE
Ingressi = X;
Risposte = [ones(1,8), -1*ones(1,8)]'; Y = Risposte;

NumeroDiEsempi = NE;
NumeroDiIngressi = NS*ND; NX = NumeroDiIngressi;
NumeroDiPesi = NumeroDiIngressi; NW = NumeroDiPesi;
NumeroDiNeuroni = 1; NN = NumeroDiNeuroni;
NumeroDiStrati = 1; NL = NumeroDiStrati;

Pesi = rand(NW, 1);
Pesi = Pesi/sum(Pesi);
W = Pesi;
Soglia = 0;
FattoreDiApprendimento = 0.2;

passo = 0;
NumeroDiEpoche = 17;
NeNe = NumeroDiEsempi*NumeroDiEpoche;
MemoriaPesi = NaN ( NumeroDiIngressi, NeNe );
FunzioneNeurale = NaN (NumeroDiEsempi, NumeroDiEpoche);
Errore = NaN (NumeroDiEsempi, NumeroDiEpoche);
for epoca = 1 : NumeroDiEpoche
%     WW = W * ones(1,NumeroDiEsempi);
%     SSoglia = Soglia * ones(NumeroDiEsempi,1);
    p = randperm(NumeroDiEsempi);
    for esempio = 1: NumeroDiEsempi
        FunzioneNeurale(p(esempio), epoca) = tanh( Ingressi(p(esempio),:) * Pesi - Soglia );
        Errore(p(esempio), epoca) = Risposte(p(esempio)) - FunzioneNeurale(p(esempio),epoca);
        AggiustaPesi = (FattoreDiApprendimento * Errore(p(esempio), epoca) * Ingressi(p(esempio),:))';
        Pesi = Pesi + AggiustaPesi; W = Pesi;
        AggiustaSoglia = FattoreDiApprendimento * Soglia * Errore(p(esempio),epoca);
        Soglia = Soglia + AggiustaSoglia;
        passo = passo + 1;
        MemoriaPesi(:,passo) = Pesi;
        MemoriaSoglia(:,passo) = Soglia;
    end
end

figure(3);
subplot(311); plot(1:NumeroDiEsempi:NeNe, sum(abs(Errore)));
subplot(312); plot(1:NeNe, MemoriaPesi);
subplot(313); plot(1:NeNe, MemoriaSoglia);



%% altro approccio alla valutazione delle caratteristiche
% Questa sezione calcola per ogni caratteristica
% (coordinata nello spazio delle caratteristiche)
% la sua 'importanza'
% ai fini della creazione di un albero di decisione,
% vale a dire la sua 'bisezionalità'
% o più semplicemente 'separabilità'.

% Le caratteristiche più importanti,
% quelle con indice di separabilità più grande (in val. ass.),
% saranno poi date in pasto alla
% (fin troppo) semplice rete neurale che segue.

for i = 1:NumeroDiIngressi
    x = stat(:,i);
    bau = sortrows([x,Y], 1);
    baubau = bau(:,2).*Y;
    importanza(i) = sum(baubau);
end
importanza = -importanza/NumeroDiEsempi;
disp('Importanza delle varie caratteristiche:');
disp('    mx        my        mz        vx        vy        vz');
% printf('mx\tmy\t');
disp(importanza)

%% Rete neurale per la valutazione delle caratteristiche
clear x y z;
% clear X W;
car = 3;
x = StatCorr(:,car);
% w = rand(1)-0.5;
w = sign(importanza(car));
o = 0;
a = 0.2;

s=0;
NumeroDiEpoche = 10;
e = NaN(NumeroDiEsempi,NumeroDiEpoche);
f = NaN(NumeroDiEsempi,NumeroDiEpoche);
NeNe = NumeroDiEsempi*NumeroDiEpoche;
mw= NaN(1, NeNe);
for j = 1:NumeroDiEpoche
    p = randperm(NumeroDiEsempi);
    for i = 1:NumeroDiEsempi
        f(p(i), j) = tanh( x(p(i)) * w - o);
        e(p(i), j) = Y(p(i)) - f(p(i),j);
        dy = e(p(i), j) * f(p(i),j) * (1-f(p(i),j));
%         dw = (a * e(p(i), j) * x(p(i),:))';
%         w = w + dw;
        do = a * e(p(i),j);
        o = o - do;
        s = s + 1;
        mw(:,s) = w;
        mo(:,s) = o;
    end
end

figure(3);
subplot(311); plot(1:NumeroDiEsempi:NeNe, sum(abs(e)));
subplot(312); plot(1:NeNe, mw);
subplot(313); plot(1:NeNe, mo);

sign(w*x-o)