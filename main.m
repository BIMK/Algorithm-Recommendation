function main()
% Compare the accuracy of several methods
clc; format compact; addpath('Optimizer');

    type = 1;  % 1. Train a new model 2. Load an existing model

    %% Load dataset
    load Dataset Input Output;
    train    = 1 : round(length(Output)*0.8);
    test     = setdiff(1:length(Output),train);
    TrainIn  = Input(train);
    TrainOut = Output(train);
    TestIn   = Input(test);
    TestOut  = Output(test);
    
    %% Training and test
	[ACC,RANK] = AR_WB(type,TrainIn,TrainOut,TestIn,TestOut)
end