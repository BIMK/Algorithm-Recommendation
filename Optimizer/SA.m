function BEST = SA(fitFun,D,N,G)
% Simulated annealing

    Lower = zeros(1,D)-10;
    Upper = zeros(1,D)+10;
    Pdec  = unifrnd(Lower,Upper);
    Pobj  = fitFun(Pdec);
    BEST  = Pobj;
    T     = 0.1;
    sigma = 0.1*(Upper-Lower);
    for gen = 1 : N*G
%         clc; fprintf('SA %d\n',gen);
        mut   = rand(1,D)<0.5;
        Qdec  = Pdec;
        Qdec(mut) = Pdec(mut) + sigma(mut).*randn(1,sum(mut));
        Qdec  = min(max(Qdec,Lower),Upper);
        Qobj  = fitFun(Qdec);
        delta = (Qobj-Pobj)/(abs(Pobj)+1e-6);
        if rand < exp(-delta/T)
            Pdec = Qdec;
            Pobj = Qobj;
        end
        T     = T*0.99;
        sigma = sigma*0.98;
        BEST  = min(BEST,Pobj);
    end
end