% AccData

%% Impostazioni
set(0,'DefaultFigureWindowStyle','docked');

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

t = zeros(1,NN);
for n = 2:NN
  t(n) = t(n-1)+A(n,4);
end



%% Media mobile
M = 13;
P = 3;
flo = floor(M/2);
p=1;
AMM = NaN(NN/3,4);
for n = (flo+1):P:(NN-flo)
  AMM(p,1:3) = sum(A(n-flo:n+flo, 1:3))/M;
  AMM(p,4)   = t(n);
  p=p+1;
end



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
StatCorr = CorreggiStatistiche(stat);

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
hold on;
plot(MulDimScalX(1:8,1),MulDimScalX(1:8,2),'ro',...
                       'MarkerEdgeColor','b',...
                       'MarkerFaceColor','c',...
                       'MarkerSize',6);
plot(MulDimScalX(9:16,1),MulDimScalX(9:16,2),'ro',...
                       'MarkerEdgeColor','b',...
                       'MarkerFaceColor','w',...
                       'MarkerSize',6);
plot(MulDimScalX(17:end,1),MulDimScalX(17:end,2),'kx',...
                       'MarkerEdgeColor','k',...
                       'MarkerFaceColor','k',...
                       'MarkerSize',6);
hold off;
                   
% plot(MulDimScalX(1:8,1), MulDimScalX(1:8,2),'.b',...
%     MulDimScalX(9:16,1), MulDimScalX(9:16,2),'.r',...
% 	MulDimScalX(17:end,1), MulDimScalX(17:end,2), 'xk');




  %% RETE NEURALE
clear X;
X = stat;
% X = StatCorr;   %  caratteristiche normalizzate
% X = [stat(:,5), stat(:,6)];


Ingressi = X;
Risposte = [ones(1,8), -1*ones(1,8)]'; Y = Risposte;

[NumeroDiEsempi, NumeroDiIngressi] = size(Ingressi);
NumeroDiPesi = NumeroDiIngressi;
NumeroDiNeuroni = 1;
NumeroDiStrati = 1;
NumeroDiEpoche = 50;
FattoreDiApprendimento = 0.2;

%% la rete contiene comunque soltanto UN percettrone
AddestraRete(stat, Risposte, NumeroDiNeuroni, NumeroDiStrati, NumeroDiEpoche, FattoreDiApprendimento);




%% Disegna
% pause();
ind=[4 6];  % scrivere qua gli indici delle caratteristiche che si vogliono rappresentare
            % NB: chiaramente soltanto DUE!!
DisegnaRete(ind, Pesi);

% figure(3); clf;
%   plot(stat(1:8,ind(1)), stat(1:8,ind(2)), 'ob',...
%       stat(9:16,ind(1)), stat(9:16,ind(2)), 'xr');
%   xlabel('stdX');
%   ylabel('stdZ');
% % axis([-0.5 2, 2.5 4.5], 'equal');
% hold on;

% La retta V,
% intersezione tra il piano di separazione
% e il piano delle coordinate scelte,
% si trova ruotando di un quarto di giro
% la proiezione su di W sul piano scelto

R = [0 -1 ; 1 0];           % matrice di rotazione
V = zeros(length(W),1);     % considero solo le coordinate scelte
V(ind) = (W(ind)'*R)';      % le altre sono nulle
U = zeros(length(W),1);     % 
U(ind) = [1; -W(ind(1))/W(ind(2))]; % questo serve a disegnare in 2D
% e punto di applicazione
% W0 = Soglia*W/(norm(W));
% V0 = W0(ind)';
% % quindi
% V = V/norm(V);
% V = V+V0;^2

% base = [0 1];         % è uguale
% vett = -(base*W(ind(1))/W(ind(2)) - Soglia/W(ind(2)));

% molt = [1, 1];
% plot( [V0(1)-0*V(1), V0(1)+5*V(1)], [V0(2)-0*V(2), V0(2)+5*V(2)], '-rs');
% plot( [V0(1), V0(1)+W(ind(1))/norm(W(ind))], [V0(2), V0(2)+W(ind(2))/norm(W(ind))] , '-^');
% % plot( base, vett, '--r');
% legend('Giusti','Sbagliati','Separazione','w^','Location','NorthEastOutside')
% hold off;

figure(3)
blux = X(1:8,:)*W;
bluy = X(1:8,:)*U;
rosx = X(9:16,:)*W;
rosy = X(9:16,:)*U;
minx = min([blux; rosx]) - 0.1*(max([blux; rosx])-min([blux; rosx]));
maxx = max([blux; rosx]) + 0.1*(max([blux; rosx])-min([blux; rosx]));
miny = min([bluy; rosy]) - 0.1*(max([bluy; rosy])-min([bluy; rosy]));
maxy = max([bluy; rosy]) + 0.1*(max([bluy; rosy])-min([bluy; rosy]));
  plot( blux, bluy, 'ob',...
        rosx, rosy, 'or',...
      Soglia*ones(1,2), [-1000 1000],'-k');
  grid off; box off;
  xlabel('w');
  legend('Giusti', 'Sbagliati', 'Separazione', 'Location', 'NorthEastOutside');
  axis([minx maxx, miny maxy]);
  title('Proiezione dei punti sul vettore W e sul piano di separazione');
print -depsc NeuClass07031347c

figure(4);
  subplot(311);
    plot(1:NumeroDiEsempi:NeNe, sum(abs(ErroreDiscreto))/2, '-b.');
    ylabel('Errore totale');
    xlabel('Passi di apprendimento (di epoca in epoca)');
  subplot(312);
    plot(1:NeNe, MemoriaPesi);
    ylabel('Pesi');
  subplot(313); plot(1:NeNe, MemoriaSoglia);
    ylabel('Soglia');
    xlabel('Passi di apprendimento');
  title('Apprendimento della rete neurale');








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

clear X;
X = stat;
% X = StatCorr;   %  caratteristiche normalizzate
% X = [stat(:,4), stat(:,6)];

importanza = ImportanzaDelleCaratteristiche(stat);

disp('Importanza delle varie caratteristiche:');
disp('    mx        my        mz        vx        vy        vz');
% printf('mx\tmy\t');
disp(importanza);

%% Rete neurale per la valutazione delle caratteristiche
clear x y z;
% clear X W;
car = 4;
a = 0.2;
NumeroDiEpoche = 10;

[y, w, o] = rnvc (stat(:,car), Y, a, NumeroDiEpoche, importanza);

% figure(4);
% subplot(311); plot(1:NumeroDiEsempi:NeNe, sum(abs(e)));
% subplot(312); plot(1:NeNe, mw);
% subplot(313); plot(1:NeNe, mo);
% 
y = sign(w*x-o);
disp('Risposte del neuroncino:');
disp(y');
disp('Soglia del neuroncino:');
disp(w*o);






%% Kernel perceptron
% è una versione kernelizzata del perceptron.
% Parte dalla considerazione che sia
% w = somme_i( alfa(i) y(i) x(i)
% quindi y_cap = sign(w'*x) = ... = sign(somme_i (alfa(i) y(i) k(x(i), x)))
% dove k() è la funzione kernel che può essere un prodotto scalare o altro

% NB: questo algoritmo non considera la soglia

clear a e f i j x y;
NumeroDiEpoche = 10;
FdA = 0.1;
tipo = 'gauss';

[y, a, e] = KernelPerceptron(stat, Risposte, FdA, NumeroDiEpoche, tipo);

figure(5);
plot(e, '-b.');
title('Apprendimento del percettrone kernelizzato');
xlabel('Epoca');
ylabel('Errore');
axis([1 NumeroDiEpoche, 0 NumeroDiEsempi]);

% w = sum( ( (a.*Y) *ones(1,6) ).* X);  % X nel caso più semplice
% w = w' / norm(w);                     % In realtà bisogna scrivere FI(X)

disp('Risposte del KP:');
disp(y');
disp('Contatori del KP');
disp(a');

%% Simple Pattern Recognition Algorithm (SPRA)
% prende i centri come media dei punti di ogni classe,
% prende il punto medio e il vettore differenza tra i centri,
% l'iperpiano individuato da questi due
% tutto con prodottini scalari

y = SPRA(stat);

disp('Risposte dello SPRA:');
disp(y');

%% Macchina a vettori di supporto
% il super metodo super nuovissimo
% per massimizzare il margine tra le classisis
% tra i clusters!!
% anche non lineare
% anche fuzzy!!!!
% separa le classi non separabili con estrema facilitò!!
% con i kerkernellsess!!

% Chang e Lin suggeriscono di seguire la sequenza seguente
% - trasformare i dati nel formato di un pacchetto svm
% - eseguire uno scalaggio semplice dei dati
% - considerare i kernel a base radiale (gaussiano)
% - crossvalidare per trovare i C e gamma migliori
% - usare questi C e gamma per addestrare l'intero insieme di addestramento
% - testare

