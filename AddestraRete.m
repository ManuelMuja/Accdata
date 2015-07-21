function [Pesi, Soglia] = AddestraRete(Ingressi, Risposte, NumeroDiNeuroni, NumeroDiStrati, NumeroDiEpoche, FattoreDiApprendimento)

[NumeroDiEsempi, NumeroDiIngressi] = size(Ingressi);
NumeroDiPesi = NumeroDiIngressi;
Pesi = .2*rand(NW, 1)-.1;
Pesi = Pesi/sum(Pesi);
Soglia = .2*rand(1)-.1; Soglia0=Soglia;

passo = 0;
NeNe = NumeroDiEsempi*NumeroDiEpoche;
MemoriaPesi = NaN ( NumeroDiIngressi, NeNe );
MemoriaSoglia = NaN ( 1, NeNe );
FunzioneNeurale = NaN (NumeroDiEsempi, NumeroDiEpoche);
Errore = NaN (NumeroDiEsempi, NumeroDiEpoche);
ErroreDiscreto = NaN (NumeroDiEsempi, NumeroDiEpoche);
for epoca = 1 : NumeroDiEpoche
    p = randperm(NumeroDiEsempi);
    for esempio = 1: NumeroDiEsempi
        FunzioneNeurale(p(esempio), epoca) = sign( Ingressi(p(esempio),:) * Pesi - Soglia );
        Errore(p(esempio), epoca) = Risposte(p(esempio)) - FunzioneNeurale(p(esempio),epoca);
        ErroreDiscreto(p(esempio), epoca) = Risposte(p(esempio)) - sign(FunzioneNeurale(p(esempio),epoca));
        AggiustaPesi = (FattoreDiApprendimento * Errore(p(esempio), epoca) * Ingressi(p(esempio),:))';
        Pesi = Pesi + AggiustaPesi;
%         Pesi = Pesi/norm(Pesi);
        W = Pesi;
        AggiustaSoglia = FattoreDiApprendimento * Errore(p(esempio),epoca);
        Soglia = Soglia + AggiustaSoglia;
        passo = passo + 1;
        MemoriaPesi(:,passo) = Pesi;
        MemoriaSoglia(:,passo) = Soglia;
    end
end

disp('Risposte della rete nurale (per la cronologia, scrivere ''FunzioneNeurale'':');
disp(FunzioneNeurale(:,end)');
disp('Vettore dei pesi (normale al piano di separazione):');
disp(Pesi');

end	% AddestraRete

