% In the name of GOD
% Our names are Mahdieh Zabihimayvan and Reza Sadeghi
% Our emails are Zabihimayvan.2@wright.edu & Sadeghi.2@wright.edu

% Stable Marriage Problem (GALE-SHAPLEY)
% Man porposing

% Stability checking

clc
clear
close all

%% Input
%>>>>>>>>>>>>>>>> Reading data from Input text file
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
Wife=zeros(1,n);
for j=1:n-1 % we have also n pairs
    Wife(str2double(line(MPlusOne(j):HiphenPlacesNegativeOne(j))))=str2double(line(WPlusOne(j):CommaNegativeOne(j)));
end
Wife(str2double(line(MPlusOne(n):HiphenPlacesNegativeOne(n))))=str2double(line(WPlusOne(n):end));

%% Main Algorithm

UnstableFlage=0;
if(numel(find(Wife==0))>0)% Is a perfect match?
    UnstableFlage=1;
    m=find(Wife==0,1);
    WifeProblem=0;
else% Is this perfect match also contains stable matches?
    for m=1:n % check stability of all pairs
        PreviousChances=MenPreference(m,1:(1-find(MenPreference(m,:)==Wife(m))));
        for i=1:numel(PreviousChances)
            Test=WomenInversPreference(PreviousChances(i), Husband(PreviousChances(i)))>WomenInversPreference(PreviousChances(i), m);
            if(Test==1)
                UnstableFlage=1;
                WifeProblem=PreviousChances(i);
                break;
            end
        end
        if(UnstableFlage==1),break;end
    end
end
%% Result
if(UnstableFlage==1)
%     disp('Unstable Matching')
%     disp('M' + int2str(m)+ '-' + 'W' +int2str(PreviousChances(i)))
    warndlg(['M' int2str(m) '-W' int2str(WifeProblem) '!! Unstable Matching !!'])
else
%     disp('Stable Matching')
    warndlg('!! Stable Matching !!')
end