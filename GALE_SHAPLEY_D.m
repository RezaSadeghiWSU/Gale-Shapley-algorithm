% In the name of GOD
% Our names are Mahdieh Zabihimayvan and Reza Sadeghi
% Our emails are Zabihimayvan.2@wright.edu & Sadeghi.2@wright.edu

% Stable Marriage Problem (GALE-SHAPLEY)
% Man porposing
% The answer of Question 1-d: Run the algorithm on problem instances with
% n=10, 15, 20, 50, 100, and plot the average running time as a function of
% the problem input size (n)

clc
clear
close all


%% Inputs
Prompt={'How many times do you wish this algorithm will be generated on different inputs?'};
Name = 'Number of Iterations';
Defaultans = {'5'};
Answer = inputdlg(Prompt,Name,[1 50],Defaultans);
Iteration=str2double(Answer(1));

Time=zeros(1,Iteration); %% Time memorization

% getting the path of Input.txt
PathName=uigetdir(matlabroot,'Please select a place to store your input and output files');

nArray=zeros(1,Iteration);
for I=1:Iteration
    %% >>>>>>>>>> creating Input text files
    Prompt={'Please, Enter the number of requested pairs'};
    Name = 'Number of Pairs';
    Defaultans = {'10'};
    Answer = inputdlg(Prompt,Name,[1 50],Defaultans);
    n=str2double(Answer(1));
    nArray(I)=n;
    Name1=['Input' int2str(I) '.txt'];
    Name=[PathName '/' Name1];

    % providing random MenPreference and WomenPreferences
    % creation of random preference lists
    MenPreference=zeros(n);
    WomenPreference=zeros(n);
    for i=1:n
    % menPreference-> row: man numeber; column: man priorities
    MenPreference(i,:)=randperm(n);
    WomenPreference(i,:)=randperm(n);
    end

    file=fopen(Name,'w');
    fprintf(file, int2str(n));
    fprintf(file, '\n');
    % writing men prefernce list
    for i=1:n
        fprintf(file, ['m' int2str(i) ': ' ]);
        for j=1:n-1
            fprintf(file, ['w' int2str(MenPreference(i,j)) ', ']);
        end
        fprintf(file, ['w' int2str(MenPreference(i,n)) '\n']);
    end

    % writing wemen prefernce list
    for i=1:n
        fprintf(file, ['w' int2str(i) ': ' ]);
        for j=1:n-1
            fprintf(file, ['m' int2str(WomenPreference(i,j)) ', ']);
        end
        fprintf(file, ['m' int2str(WomenPreference(i,n)) '\n']);
    end

    fclose(file);
    
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
plot(nArray,Time)
title('The answer of questoin 1- d')
xlabel('Input size (n)')
ylabel('Running time (second)')