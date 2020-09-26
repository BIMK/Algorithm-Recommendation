function tree = generate_tree(minlen,maxlen)
% Randomly generate a tree

    % The initial tree
	tree = NODE(33,NODE(2));
    % Probabilities of selecting each operand
	pOperand = [30 5 1 1 1 1 0];
    pOperand = cumsum(pOperand);
    pOperand = pOperand./max(pOperand);
    % Indexes of each operand
    mOperand = 1 : 7;
    % Probabilities of selecting each operator
    pOperator = [15 15 10 10,...
                 2 2 2 5 5 2 2 3 3 3 3 3 3 1 1 1];
    pOperator = cumsum(pOperator);
    pOperator = pOperator./max(pOperator);
    % Indexes of each operator
    mOperator = [11:14,21:36];
    % Randomly generate a tree
    for i = 1 : randi([minlen maxlen])
        % Randomly reach a leaf 
        p = tree;
        while p.type > 0
            if p.type==1 || rand<0.5
                p = p.left;
            else
                p = p.right;
            end
        end
        % Select an operator
        operator = mOperator(find(rand<=pOperator,1));
        if operator <= 20	% Binary operator
            % Select an operand
            operand = mOperand(find(rand<=pOperand,1));
            if rand < 0.5
                p.left  = NODE(p.value);
                p.right = NODE(operand);
            else
                p.left  = NODE(operand);
                p.right = NODE(p.value);
            end
            p.value = operator;
        else                % Unary operator
            p.left  = NODE(p.value);
            p.value = operator;
        end
    end
    tree = injection(tree);
    cleaning1(tree);
    cleaning2(tree);
    cleaning1(tree);
    cleaning2(tree);
end

function tree = injection(tree)
% Difficulty injection

    r = rand();
    if r < 0.05
        % Noisy landscape
        tree = NODE(13,tree,NODE(7));
    elseif r < 0.1
        % Flat landscape
        tree = NODE(27,tree);
    elseif r < 0.2
        % Multimodal landscape
        tree = NODE(11,tree,NODE(28,tree));
    elseif r < 0.25
        % Highly multimodal landscape
    	tree = NODE(11,tree,NODE(23,NODE(28,tree)));
    elseif r < 0.3
        % Linkages between all the variables and the first variable
        tree = injection2(tree,1);
    elseif r < 0.35
        % Linkages between each two contiguous variables
        tree = injection2(tree,2);
    elseif r < 0.4
        % Complex linkages between all the variables
        tree = injection2(tree,3);
    elseif r < 0.45
        % Different optimal values to all the variables
        tree = injection2(tree,4);
    end
end

function tree = injection2(tree,type)
% Difficulty injection 2

    if isa(tree,'NODE')
        if tree.value == 2
            switch type
                case 1
                    tree = NODE(12,NODE(2),NODE(3));
                case 2
                    tree = NODE(12,NODE(2),NODE(4));
                case 3
                    tree = NODE(5);
                case 4
                    tree = NODE(13,NODE(6),NODE(2));
            end
        else
            tree.left  = injection2(tree.left,type);
            tree.right = injection2(tree.right,type);
        end
    end
end

function scalar = cleaning1(tree)
% Clean the unary operators

    switch tree.type
        case 0
            scalar = isscalar(tree);
        case 1
            scalar = cleaning1(tree.left);
            if scalar && isvector(tree)
                % If the node is a vector-oriented operator and the child
                % is a scalar, replace the node with its child
                tree.value = tree.left.value;
                tree.right = tree.left.right;
                tree.left  = tree.left.left;
            else
                if tree.value==26 && any(tree.left.value==[25,26,30])
                    % If the node is abs and the child is abs, log,
                    % or sqrt, replace the node with its child
                    tree.value = tree.left.value;
                    tree.left  = tree.left.left;
                elseif any(tree.value==[25,26,30]) && tree.left.value==26
                    % If the node is abs, log, or sqrt and the child is
                    % abs, replace the child with its child
                    tree.left = tree.left.left;
                elseif tree.value==21 && tree.left.value==21 || tree.value==22 && tree.left.value==22
                    % If both the node and child are negative or
                    % reciprocal, replace the node with its child's child
                    tree.value = tree.left.left.value;
                    tree.right = tree.left.left.right;
                    tree.left  = tree.left.left.left;
                elseif tree.value==24 && tree.left.value==25 || tree.value==25 && tree.left.value==24 || tree.value==30 && tree.left.value==31 || tree.value==31 && tree.left.value==30
                    % If both the node and child are square and sqrt or log
                    % and exp, replace the node with its child's child
                    tree.value = tree.left.left.value;
                    tree.right = tree.left.left.right;
                    tree.left  = tree.left.left.left;
                elseif tree.value==21 && tree.left.value==12
                    % If the node is negative and the child is subtraction,
                    % replace the node with its child then exchange its
                    % children
                    tree.value = 12;
                    tree.right = tree.left.left;
                    tree.left  = tree.left.right;
                elseif tree.value==22 && tree.left.value==14
                    % If the node is reciprocal and the child is division,
                    % replace the node with its child then exchange its
                    % children
                    tree.value = 14;
                    tree.right = tree.left.left;
                    tree.left  = tree.left.right;
                end
            end
            scalar = scalar || isvector(tree) && tree.value~=34;
        case 2
            scalar1 = cleaning1(tree.left);
            scalar2 = cleaning1(tree.right);
            scalar  = scalar1 && scalar2;
    end
end

function cons = cleaning2(tree)
% Clean the binary operators

    switch tree.type
        case 0
            cons = iscons(tree);
        case 1
            cons = cleaning2(tree.left);
        case 2
            cons1 = cleaning2(tree.left);
            cons2 = cleaning2(tree.right);
            cons  = cons1 && cons2;
            if cons
                % If both the children are constants, change the node to a
                % constant
                tree.value = 1;
                tree.left  = [];
                tree.right = [];
            elseif tree.right.value == 21
                % If the node is addition and the right child is negative,
                % change the node to subtraction and replace the right
                % child with its child
                if tree.value == 11
                    tree.value = 12;
                    tree.right = tree.right.left;
                % If the node is subtraction and the right child is
                % negative, change the node to addition and replace the
                % right child with its child
                elseif tree.value == 12
                    tree.value = 11;
                    tree.right = tree.right.left;
                end
            elseif tree.right.value == 22
                % If the node is multiplication and the right child is
                % reciprocal, change the node to division and replace the
                % right child with its child
                if tree.value == 13
                    tree.value = 14;
                    tree.right = tree.right.left;
                % If the node is division and the right child is
                % reciprocal, change the node to multiplication and replace
                % the right child with its child
                elseif tree.value == 14
                    tree.value = 13;
                    tree.right = tree.right.left;
                end
            elseif tree.left.value==21 && tree.value==11
                % If the node is addition and the left child is negative,
                % change the node to subtraction, replace the left child
                % with its child, then exchange the node's children
                tree.value = 12;
                temp       = tree.right;
                tree.right = tree.left.left;
                tree.left  = temp;
            elseif tree.left.value==22 && tree.value==13
                % If the node is multiplication and the left child is
                % reciprocal, change the node to division, replace the left
                % child with its child, then exchange the node's children
                tree.value = 14;
                temp       = tree.right;
                tree.right = tree.left.left;
                tree.left  = temp;
            elseif isbinary(tree.left) && cons2
                if all(ismember([tree.value,tree.left.value],[11,12])) || all(ismember([tree.value,tree.left.value],[13,14]))
                    if iscons(tree.left.left) || iscons(tree.left.right)
                        % If the left child is a binary operator, at least
                        % one of the left child's children is a constant,
                        % and the right child is a constant, replace the
                        % node with its left child
                        tree.value = tree.left.value;
                        tree.right = tree.left.right;
                        tree.left  = tree.left.left;
                    end
                end
            elseif cons1 && isbinary(tree.right)
                if all(ismember([tree.value,tree.right.value],[11,12])) || all(ismember([tree.value,tree.right.value],[13,14]))
                    if iscons(tree.right.right)
                        % If the right child is a binary operator, the
                        % right child's right child is a constant, and the
                        % left child is a constant, replace the right child
                        % with its left child
                        tree.right = tree.right.left;
                    elseif iscons(tree.right.left)
                        % If the right child is a binary operator, the
                        % right child's left child is a constant, and the
                        % left child is a constant, replace the right child
                        % with its right child then change the node's
                        % operator
                        if tree.value == tree.right.value
                            if tree.value <= 12
                                tree.value = 11;
                            else
                                tree.value = 13;
                            end
                        else
                            if tree.value <= 12
                                tree.value = 12;
                            else
                                tree.value = 14;
                            end
                        end
                        tree.right = tree.right.right;
                    end
                end
            elseif isbinary(tree.left) && isbinary(tree.right)
                if all(ismember([tree.left.value,tree.value,tree.right.value],[11,12])) || all(ismember([tree.left.value,tree.value,tree.right.value],[13,14]))
                    if (iscons(tree.left.left)||iscons(tree.left.right)) && iscons(tree.right.right)
                        % If both the left and right children are binary
                        % operators, at least one of the left child's
                        % children is a constant, and the right child's
                        % right child is a constant, replace the right
                        % child with its left child
                        tree.right = tree.right.left;
                    elseif (iscons(tree.left.left)||iscons(tree.left.right)) && iscons(tree.right.left)
                        % If both the left and right children are binary
                        % operators, at least one of the left child's
                        % children is a constant, and the right child's
                        % left child is a constant, replace the right child
                        % with its right child then change the node's
                        % operator
                        if tree.value == tree.right.value
                            if tree.value <= 12
                                tree.value = 11;
                            else
                                tree.value = 13;
                            end
                        else
                            if tree.value <= 12
                                tree.value = 12;
                            else
                                tree.value = 14;
                            end
                        end
                        tree.right = tree.right.right;
                    end
                end
            end
    end
end