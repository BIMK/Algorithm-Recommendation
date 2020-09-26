function BEST = FEP(fitFun,D,N,G)
% Fast evolutionary programming

    Lower = zeros(N,D)-10;
    Upper = zeros(N,D)+10;
    Pdec  = unifrnd(Lower,Upper);
    Pvel  = rand(size(Pdec));
    Pobj  = fitFun(Pdec);
    for gen = 1 : G
%         clc; fprintf('FEP %d\n',gen);
        tau  = 1/sqrt(2*sqrt(D));
        tau1 = 1/sqrt(2*D);
        GaussianRand  = repmat(randn(N,1),1,D);
        GaussianRandj = randn(N,D);
        CauchyRandj   = trnd(1,N,D);
        Odec = Pdec + Pvel.*CauchyRandj;
        Ovel = Pvel.*exp(tau1*GaussianRand+tau*GaussianRandj);
        Odec = min(max(Odec,Lower),Upper);
        Pdec = [Pdec;Odec];
        Pvel = [Pvel;Ovel];
        Pobj = [Pobj;fitFun(Odec)];
        Win  = zeros(1,size(Pdec,1));
        for i = 1 : size(Pdec,1)
            Win(i) = sum(Pobj(i)<=Pobj(randperm(size(Pdec,1),10)));
        end
        [~,rank] = sort(Win,'descend');
        Pdec = Pdec(rank(1:N),:);
        Pvel = Pvel(rank(1:N),:);
        Pobj = Pobj(rank(1:N));
        BEST = min(Pobj);
    end
end