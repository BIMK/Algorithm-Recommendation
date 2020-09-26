function [ACC,RANK] = CalACC(Label,Out)
% Calculate the rank and accuracy on test set

    ACC  = zeros(1,length(Out));
	RANK = zeros(size(ACC));
    for i = 1 : length(Out)
        ACC(i) = Out{i}(Label(i))-min(Out{i}) < 1e-8;
        rank   = zeros(1,length(Out{i}));
        remain = 1 : length(Out{i});
        while ~isempty(remain)
        	current = Out{i}(remain)-min(Out{i}(remain)) < 1e-8;
            rank(remain(current)) = length(Out{i}) - length(remain) + 1;
            remain(current) = [];
        end
        RANK(i) = rank(Label(i));
    end
    ACC  = mean(ACC);
    RANK = mean(RANK);
end