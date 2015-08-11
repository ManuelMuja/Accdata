evento	= 'max';	% oppure 'min' oppure un altro trigger
dmeno_t	= .3;		% tempo da registrare *prima* dell'evento (secondi)
dpiu_t	= .4;		% tempo da registrare *dopo* l'evento (s)
dmeno_c	= dmeno_t*fc;	% tradotto in campioni
dpiu_c	= dpiu_t*fc;	% tradotto in campioni

for n = 1:NN		% quale esempio
	[mm ii]	= max(lanciotappo(:,:,n));	% trovo il massimo (uno per dimensione)
	[m i]	= max(mm);	% trovo il massimo dei massimi
	i	= ii(i);	% correggo l'indice

	primo(n)  = i-dmeno_c;	% campione iniziale
	ultimo(n) = i+dpiu_c;	% campione finale
end

