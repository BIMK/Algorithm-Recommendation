function BEST = ACO(fitFun,D,N,G)
% Ant colony optimization

    Lower = zeros(N,D)-10;
    Upper = zeros(N,D)+10;
    Pdec  = unifrnd(Lower,Upper);
    Pobj  = fitFun(Pdec);
    [Pobj,rank] = sort(Pobj);
    Pdec = Pdec(rank,:);
    w = 1/(sqrt(2*pi)*0.5*N)*exp(-0.5*(((1:N)-1)/(0.5*N)).^2);
    p = cumsum(w);
    p = p/max(p);
    for gen = 1 : G
%         clc; fprintf('ACO %d\n',gen);
        Mean = Pdec;
        Std  = zeros(N,D);
        for i = 1 : N
            Std(i,:) = sum(abs(repmat(Pdec(i,:),N,1)-Pdec),1)/(N-1);
        end
        Qdec = zeros(N,D);
        for i = 1 : N
            for j = 1 : D
                s = find(rand<=p,1);
                Qdec(i,j) = Mean(s,j) + Std(s,j)*randn;
            end
        end
        Qdec = min(max(Qdec,Lower),Upper);
        Pdec = [Pdec;Qdec];
        Pobj = [Pobj;fitFun(Qdec)];
        [~,rank] = sort(Pobj);
        Pdec = Pdec(rank(1:N),:);
        Pobj = Pobj(rank(1:N),:);
        BEST = min(Pobj);
    end
end