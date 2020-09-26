function [ACC,RANK] = AR_WB(type,TrainIn,TrainOut,TestIn,TestOut)
% White-box algorithm recommendation method

    %% LSTM based classification
    % Tokenize the reverse Polish expression
    TrainIn  = cellfun(@(s)num2str(s),TrainIn,'UniformOutput',false);
    TrainIn  = tokenizedDocument(TrainIn');
    TestIn   = cellfun(@(s)num2str(s),TestIn,'UniformOutput',false);
    TestIn   = tokenizedDocument(TestIn');
    enc      = wordEncoding(TrainIn);
    TrainIn  = doc2sequence(enc,TrainIn,'Length',27);
    TestIn   = doc2sequence(enc,TestIn,'Length',27);
    [~,TrainOut] = min(cell2mat(TrainOut'),[],2);
    TrainOut = categorical(TrainOut);
    % Train LSTM
    switch type
        case 1
            layers = [sequenceInputLayer(1)
                      wordEmbeddingLayer(50,enc.NumWords)
                      bilstmLayer(50,'OutputMode','last')
                      fullyConnectedLayer(max(double(TrainOut)))
                      softmaxLayer
                      classificationLayer];
            options = trainingOptions('adam','MaxEpochs',30,'GradientThreshold',1,'InitialLearnRate',0.01);
            net = trainNetwork(TrainIn,TrainOut,layers,options);
            save AR_WB net
        case 2
            load AR_WB net
    end
    
    %% Classification
    [ACC,RANK] = CalACC(double(classify(net,TestIn)),TestOut);
end