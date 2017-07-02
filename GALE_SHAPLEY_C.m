% In the name of GOD
% Our names are Mahdieh Zabihimayvan and Reza Sadeghi
% Our emails are Zabihimayvan.2@wright.edu & Sadeghi.2@wright.edu

% Stable Marriage Problem (GALE-SHAPLEY)
% Man porposing
% The answer of Question 1-c: Run the algorithm on several instances of the
% problem for n=10 with same input files and plot the variation in the
% running time.

clc
clear
close all


%% Inputs
InputGenerator
Prompt={'How many times do you wish this algorithm will be generated on this input?'};
Name = 'Number of Iterations';
Defaultans = {'10'};
Answer = inputdlg(Prompt,Name,[1 50],Defaultans);
Iteration=str2double(Answer(1));

Time=zeros(1,Iteration); %% Time memorization


for I=1:Iteration
    %% Initialize variables
    % WomenInversPreference-> row: woman numeber; column: man number
    [~,WomenInversPreference]=sort(WomenPreference,2);
    % Wife[m]=w-> the wife of man m is w
    Wife=zeros(1,n);
     % Husband is like Wife and can demonstrates S which demonstrates the set of matches
    Husband=zeros(1,n);
    % NextPropose is a pointer to woman in list for next proposal= next
    % prefered woman for each man
    NextPorpose=ones(1,n);
    % FreeMen is a stack of unmarried men
    FreeMen=java.util.Stack();
    for i=n:-1:1
        FreeMen.push(i);
    end

% Starting time just for Main algorithm
tic
    %% Main Algorithm
    % While runs untile some man m is unmatched (men who have zeros in wife array) and hasn's proposed to every
    % woman (that men whose next propose is bigger than the number of women)
    while (sum(NextPorpose(find(~Wife))< n+1)>0)
        SelectedMan=FreeMen.pop();
        SelectedWoman=MenPreference(SelectedMan,NextPorpose(SelectedMan));
        if(Husband(SelectedWoman)==0)
            Husband(SelectedWoman)=SelectedMan;
            Wife(SelectedMan)=SelectedWoman;
            NextPorpose(SelectedMan)=NextPorpose(SelectedMan)+1;
        elseif(WomenInversPreference(SelectedWoman, Husband(SelectedWoman))>WomenInversPreference(SelectedWoman, SelectedMan))
            FreeMen.push(Husband(SelectedWoman));
            Wife(Husband(SelectedWoman))=0;

            Husband(SelectedWoman)=SelectedMan;
            Wife(SelectedMan)=SelectedWoman;
            NextPorpose(SelectedMan)=NextPorpose(SelectedMan)+1;
        else
            FreeMen.push(SelectedMan);
            NextPorpose(SelectedMan)=NextPorpose(SelectedMan)+1;
        end
    end
% finshing time
Time(I)=toc;

%% Writing our outputs-> the stable mariages "m1-w3, m2-w1, ..."
Name1=['Output' int2str(I) '.txt'];
Name=[PathName '/' Name1];

file=fopen(Name,'w');
for i=1:n-1
    fprintf(file, ['m' int2str(i) '-w' int2str(Wife(i)) ', ']);
end
fprintf(file, ['m' int2str(n) '-w' int2str(Wife(n))]);

fclose(file);

end

%% plotting the times
plot(1:Iteration,Time)
title('The answer of questoin 1- c')
xlabel('Number of Iterations')
ylabel('Running time (second)')