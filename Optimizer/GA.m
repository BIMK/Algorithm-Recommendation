function BEST = GA(fitFun,D,N,G)
% Genetic algorithm

    Lower = zeros(N,D)-10;
    Upper = zeros(N,D)+10;
    Pdec  = unifrnd(Lower,Upper);
    Pobj  = fitFun(Pdec);
    for gen = 1 : G
%         clc; fprintf('GA %d\n',gen);
        % Mating selection
        [~,rank] = sort(Pobj);
        [~,rank] = sort(rank);
        Parents  = randi(N,2,N);
        [~,best] = min(rank(Parents),[],1);
        Mdec     = Pdec(Parents(best+(0:N-1)*2),:);
        Parent1  = Mdec(1:end/2,:);
        Parent2  = Mdec(end/2+1:end,:);
        % Simulated binary crossover
        beta = zeros(size(Parent1));
        mu   = rand(size(Parent1));
        beta(mu<=0.5) = (2*mu(mu<=0.5)).^(1/21);
        beta(mu>0.5)  = (2-2*mu(mu>0.5)).^(-1/21);
        beta = beta.*(-1).^randi([0,1],N/2,D);
        beta(rand(N/2,D)<0.5) = 1;
        Qdec = [(Parent1+Parent2)/2+beta.*(Parent1-Parent2)/2
                (Parent1+Parent2)/2-beta.*(Parent1-Parent2)/2];
        % Polynomial mutation
        Site       = rand(N,D) < 1/D;
        mu         = rand(N,D);
        temp       = Site & mu<=0.5;
        Qdec       = min(max(Qdec,Lower),Upper);
        Qdec(temp) = Qdec(temp)+(Upper(temp)-Lower(temp)).*((2.*mu(temp)+(1-2.*mu(temp)).*(1-(Qdec(temp)-Lower(temp))./(Upper(temp)-Lower(temp))).^21).^(1/21)-1);
        temp       = Site & mu>0.5; 
        Qdec(temp) = Qdec(temp)+(Upper(temp)-Lower(temp)).*(1-(2.*(1-mu(temp))+2.*(mu(temp)-0.5).*(1-(Upper(temp)-Qdec(temp))./(Upper(temp)-Lower(temp))).^21).^(1/21));
        Qdec = min(max(Qdec,Lower),Upper);
        % Environmental selection
        Pdec = [Pdec;Qdec];
        Pobj = [Pobj;fitFun(Qdec)];
        [~,rank] = sort(Pobj);
        Pdec = Pdec(rank(1:N),:);
        Pobj = Pobj(rank(1:N),:);
        BEST = min(Pobj);
    end
end