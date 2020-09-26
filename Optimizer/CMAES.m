function BEST = CMAES(fitFun,D,N,G)
% Covariance matrix adaptation evolution strategy

    Lower = zeros(N,D)-10;
    Upper = zeros(N,D)+10;
    % Number of parents
    mu    = round(N/2);
    % Parent weights
    w     = log(mu+0.5) - log(1:mu);
    w     = w./sum(w);
    % Number of effective solutions
    mu_eff = 1/sum(w.^2);
    % Step size control parameters
    cs    = (mu_eff+2)/(D+mu_eff+5);
    ds    = 1 + cs + 2*max(sqrt((mu_eff-1)/(D+1))-1,0);
    ENN   = sqrt(D)*(1-1/(4*D)+1/(21*D^2));
    % Covariance update parameters
    cc    = (4+mu_eff/D)/(4+D+2*mu_eff/D);
    c1    = 2/((D+1.3)^2+mu_eff);
    alpha_mu = 2;
    cmu   = min(1-c1,alpha_mu*(mu_eff-2+1/mu_eff)/((D+2)^2+alpha_mu*mu_eff/2));
    hth   = (1.4+2/(D+1))*ENN;
	% Initialization
	Mstep = zeros(1,D);
    Mdec  = unifrnd(Lower(1,:),Upper(1,:));
    Mobj  = fitFun(Mdec);
    BEST  = Mobj;
    ps    = zeros(1,D);
    pc    = zeros(1,D);
    C     = eye(D);
    sigma = 0.3*(Upper(1,:)-Lower(1,:));
    for gen = 1 : G
%         clc; fprintf('CMA-ES %d\n',gen);
        % Generate samples
        for i = 1 : N
            Pstep(i,:) = mvnrnd(zeros(1,D),C);
        end
        Pdec = Mdec + sigma.*Pstep;
        Pdec = min(max(Pdec,Lower),Upper);
        Pobj = fitFun(Pdec);
        BEST = min(BEST,min(Pobj));
        % Sort population
        [~,rank] = sort(Pobj);
        Pstep = Pstep(rank,:);
        Pdec  = Pdec(rank,:);
        Pobj  = Pobj(rank,:);
        % Update mean
        Mstep = w*Pstep(1:mu,:);
        Mdec  = Mdec + sigma.*Mstep;
        % Update step size
        ps    = (1-cs)*ps + sqrt(cs*(2-cs)*mu_eff)*Mstep/chol(C)';
        sigma = sigma*exp(cs/ds*(norm(ps)/ENN-1))^0.3;
        % Update covariance matrix
        hs    = norm(ps)/sqrt(1-(1-cs)^(2*(gen+1))) < hth;
        delta = (1-hs)*cc*(2-cc);
        pc    = (1-cc)*pc + hs*sqrt(cc*(2-cc)*mu_eff)*Mstep;
        C     = (1-c1-cmu)*C + c1*(pc'*pc+delta*C);
        for i = 1 : mu
            C = C + cmu*w(i)*Pstep(i,:)'*Pstep(i,:);
        end
        [V,E] = eig(C);
        if any(diag(E)<0)
            C = V*max(E,0)/V;
        end
    end
end