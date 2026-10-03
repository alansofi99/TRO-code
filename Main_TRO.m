clear all
clc

% Start timing
%fprintf('Starting optimization...\n');
tic;

% Define parameter
SearchAgents_no = 100; % Number of search agents
%Function_name="CEC10";
Function_name="F1";

Max_iteration = 300; % Maximum number of iterations
%lb=-100;             ub=100;              dim=10;
% Load details of the selected benchmark function
[lb, ub, dim, fobj] = Get_Functions_details(Function_name);
%[lb, ub, dim, fobj] = Func_eng(Function_name);
%fobj = @(x) cec22_test_func(x', Function_name);

% Call the TRO optimization function
[finalBest]=TRO(SearchAgents_no,Max_iteration,lb,ub,dim,fobj);

ave= mean(finalBest);
std_= std(finalBest);
disp('final best');
disp(finalBest);
disp(['Best: ' num2str(min(finalBest))]);
disp(['Worst: ' num2str(max(finalBest))]);
disp(['Average: ' num2str(ave)]);
disp(['Std: ' num2str(std_)]);

results = [ave, std_];
% End timing
toc;

disp('Optimization completed');
