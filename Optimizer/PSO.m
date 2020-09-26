function BEST = PSO(fitFun,D,N,G)
% Particle swarm optimization

    Lower = zeros(N,D)-10;
    Upper = zeros(N,D)+10;
    Pdec  = unifrnd(Lower,Upper);
    Pvel  = zeros(size(Pdec));
    Pobj  = fitFun(Pdec);
    PBdec = Pdec;
    PBobj = Pobj;
    [~,index] = min(PBobj);
    GBdec = PBdec(index,:);
    for gen = 1 : G
%         clc; fprintf('PSO %d\n',gen);
        % Update particles
        r1   = repmat(rand(N,1),1,D);
        r2   = repmat(rand(N,1),1,D);
        Pvel = 0.4.*Pvel + r1.*(PBdec-Pdec) + r2.*(repmat(GBdec,N,1)-Pdec);
        Pdec = Pdec + Pvel;
        Pdec = min(max(Pdec,Lower),Upper);
        Pobj = fitFun(Pdec);
        % Update global best and personal best
        replace = Pobj < PBobj;
        PBdec(replace,:) = Pdec(replace,:);
        PBobj(replace,:) = Pobj(replace,:);
        [BEST,index]     = min(PBobj);
        GBdec = PBdec(index,:);
    end
end