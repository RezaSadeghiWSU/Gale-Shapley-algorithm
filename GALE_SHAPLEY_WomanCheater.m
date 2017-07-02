% In the name of GOD
% Our names are Mahdieh Zabihimayvan and Reza Sadeghi
% Our emails are Zabihimayvan.2@wright.edu & Sadeghi.2@wright.edu

% Stable Marriage Problem (GALE-SHAPLEY)
% Try to find winner cheating woman

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

%>>>>>>>>>>>>>>>>> Reading data from Output text file
[filename, pathname]=uigetfile({'*.*'},'Please, select your Output');
Path=[pathname filename];

fileID = fopen(Path,'r');

% Creating men priorities

%line format-> m1: w1, w2, ...
line = fgets(fileID);
HiphenPlacesNegativeOne=find(line=='-')-1;
MPlusOne=find(line=='m')+1;
WPlusOne=find(line=='w')+1;
CommaNegativeOne=find(line==',')-1;
LastWife=zeros(1,n);
for j=1:n-1 % we have also n pairs
    LastWife(str2double(line(MPlusOne(j):HiphenPlacesNegativeOne(j))))=str2double(line(WPlusOne(j):CommaNegativeOne(j)));
end
LastWife(str2double(line(MPlusOne(n):HiphenPlacesNegativeOne(n))))=str2double(line(WPlusOne(n):end));
MainWomenpreference=WomenPreference;

%% Try to find golden woman
Tries=0;
while (Tries<1000)
Tries=Tries+1;
WomenPreference=MainWomenpreference;

Flag=1;
Times=0;
while(Flag && Times<n)
    Times=Times+1;
    EspecialWoman=LastWife(randi(n));
    EspecialHusband=find(LastWife==EspecialWoman);
    if(WomenPreference(EspecialWoman,1)~=EspecialHusband),Flag=0;end
end
Places=randperm(n,2);
Temp=WomenPreference(EspecialWoman, Places);
WomenPreference(EspecialWoman, Places(1))=Temp(2);
WomenPreference(EspecialWoman, Places(2))=Temp(1);

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
NewHusband=find(Wife==EspecialWoman);
if(find(MainWomenpreference(EspecialWoman,:)==NewHusband)<find(MainWomenpreference(EspecialWoman,:)==EspecialHusband))
    disp('EspecialWoman:')
    disp(EspecialWoman)
    disp('lying about following men is the key point:')
    disp(Temp)
    disp('Previous Pairs (WifeOfMan1 WifeOfMan2 WifeOfMan3...):')
    disp(LastWife)
    disp('NewPairs (WifeOfMan1 WifeOfMan2 WifeOfMan3...):')
    disp(Wife)
    break;
    warndlg('!! Win !!')
end

end


