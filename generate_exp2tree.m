function tree = generate_exp2tree(exp)
% Convert the reverse Polish expression to the tree

    tree = [];
    for i = 1 : length(exp)
        if exp(i) <= 10
            tree = [tree,NODE(exp(i))];
        elseif exp(i) <= 20
            tree = [tree(1:end-2),NODE(exp(i),tree(end-1),tree(end))];
        else
            tree = [tree(1:end-1),NODE(exp(i),tree(end))];
        end
    end
end