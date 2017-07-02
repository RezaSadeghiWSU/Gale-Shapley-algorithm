% In the name of GOD
% Our names are Mahdieh Zabihimayvan and Reza Sadeghi
% Our emails are Zabihimayvan.2@wright.edu & Sadeghi.2@wright.edu

% Stable Marriage Problem (GALE-SHAPLEY)
% Man porposing

clc
clear
close all


%% Inputs
%>>>>>>>>>>>>>>>> reading data from text file
[filename, pathname]=uigetfile({'*.*'},'Please, select your input');
Path=[pathname filename];

fileID = fopen(Path,'r');
n=str2double(fgets(fileID));
MenPreference=zeros(n);
WomenPreference=zeros(n);

% Creating men priorities
i=0;
while (i<n)
%line format-> m1: w1, w2, ...
    i=i+1;
    line = fgets(fileID);
    SelectedMan=str2double(line(2:((find(line==':')-1))));
    WPlacesPlusOne=find(line=='w')+1;
    CommaPlacesNegetiveOne=find(line==',')-1;
    for j=1:n-1 % we have also n women
        MenPreference(SelectedMan,j)=str2double(line(WPlacesPlusOne(j):CommaPlacesNegetiveOne(j)));
    end
    MenPreference(SelectedMan,n)=str2double(line((CommaPlacesNegetiveOne(j)+4):end));
end

% Creating Women priorities
i=0;
while (i<n)
%line format-> m1: w1, w2, ...
    i=i+1;
    line = fgets(fileID);
    SelectedWoman=str2double(line(2:((find(line==':')-1))));
    WPlacesPlusOne=find(line=='m')+1;
    CommaPlacesNegetiveOne=find(line==',')-1;
    for j=1:n-1 % we have also n women
        WomenPreference(SelectedWoman,j)=str2double(line(WPlacesPlusOne(j):CommaPlacesNegetiveOne(j)));
    end
    WomenPreference(SelectedWoman,n)=str2double(line((CommaPlacesNegetiveOne(j)+4):end));
end

fclose(fileID);

Prompt={'Please, Enter the name of your output'};
Name = 'Output name';
Defaultans = {'Output.txt'};
Answer = inputdlg(Prompt,Name,[1 50],Defaultans);
Name=cell2mat(Answer(1));
Name=[pathname Name];

% %>>>>>>>>>>>>>>>> Generating data ourselves
% % n number of mans or womens
% n=10;
% 
% % creation of random preference lists
% MenPreference=zeros(n);
% WomenPreference=zeros(n);
% for i=1:n
% % menPreference-> row: man numeber; column: man priorities
% MenPreference(i,:)=randperm(n);
% WomenPreference(i,:)=randperm(n);
% end
% 

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
% for i=1:n
%     FreeMen.push(i);
% end
for i=n:-1:1
    FreeMen.push(i);
end

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

toc
%% Writing our output-> the stable mariages "m1-w3, m2-w1, ..."
%disp(Wife)

file=fopen(Name,'w');
for i=1:n-1
    fprintf(file, ['m' int2str(i) '-w' int2str(Wife(i)) ', ']);
end
fprintf(file, ['m' int2str(n) '-w' int2str(Wife(n))]);

fclose(file);
open(Name)
warndlg('Your output is created','!! Finished !!')

% %% Stability checking
% UnstableFlage=0;
% for m=1:n % check stability of all pairs
%     PreviousChances=MenPreference(m,1:(1-find(MenPreference(m,:)==Wife(m))));
%     for i=1:numel(PreviousChances)
%         Test=WomenInversPreference(PreviousChances(i), Husband(PreviousChances(i)))>WomenInversPreference(PreviousChances(i), m);
%         if(Test==1)
%             UnstableFlage=1;
%             break;
%         end
%     end
%     if(UnstableFlage==1),break;end
% end
% 
% if(UnstableFlage==1)
%     disp('Unstable Matching')
%     disp('M' + int2str(m)+ '-' + 'W' +int2str(PreviousChances(i)))
% else
%     disp('Stable Matching')
% end