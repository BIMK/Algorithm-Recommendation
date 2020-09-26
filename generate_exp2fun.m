function fun = generate_exp2fun(exp)
% Convert the reverse Polish expression to the function

%           Meaning                     Syntax
% 1         Real number in 1-10         1.5
% 2         Decision vector             (x1,...,xd)
% 3         First decision variable     x1
% 4         Translated decision vector	(x2,...,xd,0)
% 5         Rotated decision vector     XR
% 6         Index vector                (1,...,d)
% 7         Random number in 1-1.1      rand() 
% 11        Addition                    x+y
% 12        Subtraction                 x-y
% 13        Multiplication              x.*y
% 14        Division                    x./y
% 21        Negative                    -x
% 22        Reciprocal                  1./x
% 23        Multiplying by 10           10.*x
% 24        Square                      x.^2
% 25        Square root                 sqrt(abs(x))
% 26        Absolute value              abs(x)
% 27        Rounded value               round(x)
% 28        Sine                        sin(2*pi*x)
% 29        Cosine                      cos(2*pi*x)
% 30        Logarithm                   log(abs(x))
% 31        Exponent                    exp(x)
% 32        sum of vector           	sum(x)
% 33        Mean of vector          	mean(x)
% 34        Cumulative sum of vector	cumsum(x)
% 35        Product of vector           prod(x)
% 36        Maximum of vector           max(x)

	str = {};
    for value = reshape(exp,1,[])
        if value < 0
            str = [str,num2str(abs(value))];
        else
            switch value
                case 1      % Real number in 1-10
                    str = [str,num2str(rand*9+1)];
                case 2      % Decision vector
                    str = [str,'x'];
                case 3      % First decision variable
                    str = [str,'x(:,1)'];
                case 4      % Translated decision vector
                    str = [str,'[x(:,2:end),zeros(size(x,1),1)]'];
                case 5      % Rotated decision vector
                    str = [str,sprintf('(x*%s)',mat2str(rand(10)))];
                case 6      % Index vector
                    str = [str,'(1:size(x,2))'];
                case 7      % Random number in 1-1.1
                    str = [str,'(1+rand(size(x,1),1)/10)'];
                case 11     % Addition
                    str = [str(1:end-2),sprintf('(%s+%s)',str{end-1},str{end})];
                case 12     % Subtraction
                    str = [str(1:end-2),sprintf('(%s-%s)',str{end-1},str{end})];
                case 13     % Multiplication
                    str = [str(1:end-2),sprintf('(%s.*%s)',str{end-1},str{end})];
                case 14     % Division
                    str = [str(1:end-2),sprintf('(%s./%s)',str{end-1},str{end})];
                case 21     % Negative
                    str = [str(1:end-1),sprintf('(-%s)',str{end})];
                case 22     % Reciprocal
                    str = [str(1:end-1),sprintf('(1./%s)',str{end})];
                case 23     % Multiplying by 10
                    str = [str(1:end-1),sprintf('(10*%s)',str{end})];
                case 24     % Square
                    str = [str(1:end-1),sprintf('(%s.^2)',str{end})];
                case 25     % Square root
                    str = [str(1:end-1),sprintf('sqrt(abs(%s))',str{end})];
                case 26     % Absolute value
                    str = [str(1:end-1),sprintf('abs(%s)',str{end})];
                case 27     % Rounded value
                    str = [str(1:end-1),sprintf('round(%s)',str{end})];
                case 28     % Sine
                    str = [str(1:end-1),sprintf('sin(2*pi*%s)',str{end})];
                case 29     % Cosine
                    str = [str(1:end-1),sprintf('cos(2*pi*%s)',str{end})];
                case 30     % Logarithm
                    str = [str(1:end-1),sprintf('log(abs(%s))',str{end})];
                case 31     % Exponent
                    str = [str(1:end-1),sprintf('exp(%s)',str{end})];
                case 32     % Sum of vector
                    str = [str(1:end-1),sprintf('sum(%s,2)',str{end})];
                case 33     % Mean of vector
                    str = [str(1:end-1),sprintf('mean(%s,2)',str{end})];
                case 34     % Cumulative sum of vector
                    str = [str(1:end-1),sprintf('cumsum(%s,2)',str{end})];
                case 35     % Product of vector
                    str = [str(1:end-1),sprintf('prod(%s,2)',str{end})];
                case 36     % Maximum of vector
                    str = [str(1:end-1),sprintf('max(%s,[],2)',str{end})];
            end
        end
    end
    fun = str2func(['@(x)',str{1}]);
end