function exp = generate_tree2exp(tree)
% Convert the tree to the reverse Polish expression

    switch tree.type
        case 0
            exp = tree.value;
        case 1
            exp = [generate_tree2exp(tree.left),tree.value];
        case 2
            exp = [generate_tree2exp(tree.left),generate_tree2exp(tree.right),tree.value];
    end
end