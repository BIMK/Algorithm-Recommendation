function BEST = ABC(fitFun,D,N,G)
% Artificial bee colony algorithm

    Lower = zeros(N,D)-10;
    Upper = zeros(N,D)+10;
    Pdec  = unifrnd(Lower,Upper);
    Pobj  = fitFun(Pdec);
    Limit = zeros(1,N);
    for gen = 1 : G/2
%         clc; fprintf('ABC %d\n',gen);
        % Employed bees
        Qdec = Pdec + (rand(size(Pdec))*2-1).*(Pdec-Pdec(randi(end,1,end),:));
        Qdec = min(max(Qdec,Lower),Upper);
        Qobj = fitFun(Qdec);
        replace         = Pobj > Qobj;
        Pdec(replace,:) = Qdec(replace,:);
        Pobj(replace)   = Qobj(replace);
        Limit(~replace) = Limit(~replace) + 1;
        % Onlooker bees
        if ~any(isinf(Pobj)|isnan(Pobj))
            P = cumsum(exp(-Pobj/mean(abs(Pobj)+1e-6)));
        else
            P = 1 : N;
        end
        P = P/max(P);
        Q = arrayfun(@(S)find(rand<=P,1),1:N);
        Qdec = Pdec(Q,:) + (rand(size(Pdec))*2-1).*(Pdec(Q,:)-Pdec(randi(end,1,end),:));
        Qdec = min(max(Qdec,Lower),Upper);
        Qobj = fitFun(Qdec);
        replace         = Pobj > Qobj;
        Pdec(replace,:) = Qdec(replace,:);
        Pobj(replace)   = Qobj(replace);
        Limit(~replace) = Limit(~replace) + 1;
        % Scout bees
        Q = Limit > 20;
        Pdec(Q,:) = unifrnd(Lower(1:sum(Q),:),Upper(1:sum(Q),:));
        Pobj(Q)   = fitFun(Pdec(Q,:));
        Limit(Q)  = 0;
        BEST      = min(Pobj);
    end
end