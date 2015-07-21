function [y] = CorreggiStatistiche(x)
	N = size(x,3);
	media = mean(stat);
	y = (x-ones(N,1)*media);
	varia = std(stat);
	y = y./(ones(N,1)*varia);
end
