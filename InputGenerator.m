% In the name of GOD
% Our names are Mahdieh Zabihimayvan and Reza Sadeghi
% Our emails are Zabihimayvan.2@wright.edu & Sadeghi.2@wright.edu

% Input generator for Stable Marriage Problem (GALE-SHAPLEY)

clc
clear
close all

%% getting the number of n
% n number of mans or womens
%n=100;
Prompt={'Please, Enter the number of requested pairs', 'The name of the text file'};
Name = 'Number of Pairs';
Defaultans = {'10', 'Input.txt'};
Answer = inputdlg(Prompt,Name,[1 50],Defaultans);
n=str2double(Answer(1));
Name1=cell2mat(Answer(2));

%% getting the path of Input.txt
PathName=uigetdir(matlabroot,'Please select a place to store your input file');
Name=[PathName '/' Name1];

%% providing random MenPreference and WomenPreferences
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
warndlg('Your input is created','!! Finished !!')