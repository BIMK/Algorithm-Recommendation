function BEST = Rand(fitFun,D,N,G)
% Random search

    Lower = zeros(N,D)-10;
    Upper = zeros(N,D)+10;
    Pdec  = unifrnd(repmat(Lower,G,1),repmat(Upper,G,1));
    Pobj  = fitFun(Pdec);
    BEST  = min(Pobj);
end