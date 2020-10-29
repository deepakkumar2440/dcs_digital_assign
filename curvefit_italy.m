clc
clear all
M=xlsread('italycovid.xlsx');
x=M(:,1)
y=M(:,2)
cftool
plot(x,y) ;

xlabel('Days');
ylabel('No. of cases');
title ('Total no. of cases in Italy');
