function BEST = DE(fitFun,D,N,G)
% Differential evolution

    Lower = zeros(N,D)-10;
    Upper = zeros(N,D)+10;
    Pdec  = unifrnd(Lower,Upper);
    Pobj  = fitFun(Pdec);
    for gen = 1 : G
%         clc; fprintf('DE %d\n',gen);
        % Mating selection
        [~,rank] = sort(Pobj);
        [~,rank] = sort(rank);
        Parents  = randi(N,2,2*N);
        [~,best] = min(rank(Parents),[],1);
        Mdec     = Pdec(Parents(best+(0:2*N-1)*2),:);
        % Generate offsprings
        Qdec = Pdec + 0.5*(Mdec(1:end/2,:)-Mdec(end/2+1:end,:));
        Qdec = min(max(Qdec,Lower),Upper);
        Qobj = fitFun(Qdec);
        % Environmental selection
        replace = Pobj > Qobj;
        Pdec(replace,:) = Qdec(replace,:);
        Pobj(replace)   = Qobj(replace);
        BEST = min(Pobj);
    end
end