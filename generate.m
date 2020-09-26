function generate()
% Generate a dataset
clc; format compact; addpath('Optimizer');

    try
        load Dataset Input Output
    catch
        Input  = {};
        Output = {};
    end
    Algorithm = {@ABC,@ACO,@CMAES,@CSO,@DE,@FEP,@GA,@PSO,@SA,@Rand};

    for i = 1 : 100000
        clc; fprintf('#Generated functions: %d\n#Valid samples: %d\n',i,length(Input));
        % Randomly generate a function
        tree  = generate_tree(8,12);
        exp   = generate_tree2exp(tree);
        fun   = generate_exp2fun(exp);
        Data  = zeros(10,length(Algorithm));
        valid = true;
        for r = 1 : size(Data,1)
            for a = 1 : size(Data,2)
                % Obtain the minimum value found by each algorithm, where
                % the number of variable is 10, the population size is 100,
                % the number of generations is 100.
                Data(r,a) = Algorithm{a}(fun,10,100,100);
            end
            if any(isnan(Data(r,:))) || any(abs(Data(r,:))>1e10)
                % If the function has nan value or extremely large value,
                % ignore the function
                valid = false;
                break;
            end
        end
        % If the best algorithm is statistically similar to another
        % algorithm, ignore the function
        if valid
            [~,best] = min(mean(Data,1));
            for a = [1:best-1,best+1:size(Data,2)]
                [~,diff] = ranksum(Data(:,a),Data(:,best));
                if ~diff
                    valid = false;
                    break;
                end
            end
        end
        % Save this sample
        if valid
            Input  = [Input,exp];
            Output = [Output,mean(Data,1)];
            save Dataset Input Output
        end
    end
end