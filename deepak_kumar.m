
% clear all the variables
% close all the open figures 
clc; clear all; close all;
clc
clear all
close all
% SAMPLING 

x=0:300; % Days from 0-300
a1 =     2.7e+18 % paramters for the equation below found using curve fitting
       b1 =        2438 
       c1 =       393.6  
       a2 =   2.175e+05  
       b2 =       208.7 
       c2 =       76.74  
       a3 =   1.452e+05  
       b3 =       127.7  
       c3 =       40.87  
 
signal_1= a1*exp(-((x-b1)/c1).^2) + a2*exp(-((x-b2)/c2).^2) + a3*exp(-((x-b3)/c3).^2);
               % input signal found using curve fitting tool
% QUANTIZATION 

bits=20; %number of bits required 
L=2^bits; %number of bytes per sample
xmax=600000; %the range of values
xmin=0;
del=0.09; %incrementing by 0.09 generated a cleaner demodulated signal rather than 1
%A quantization partition defines several contiguous, nonoverlapping ranges of values within the set of real numbers
partition=xmin:del:xmax; % defining partition according to the indexing
%a codebook tells the quantizer which common value to assign to inputs
%that fall into each range of the partition
%defining codebook: the lower range/upper range of the codebook must be
%one increment less/more
%than the partition or can be equally distributed in both sides as is done
%here
codebook=xmin-(del/2):del:xmax+(del/2);
[index,quants]=quantiz(signal_1,partition,codebook); %quantization using
%quantiz
% gives rounded off values of the samples
% NORMALIZATION 
l1=length(index); % to convert 1 to n as 0 to n-1 indicies

for i=1:l1
if (index(i)~=0)
index(i)=index(i)-1;
 end
end
%ENCODING 
code=de2bi(index,'left-msb'); % decimal to binary conversion with MSB to
%the left
code_row=reshape(code, [1,numel(code)]); %converting the array to a singlerow array.
%The number of elements (366) in code array determines the number of columns in code_row array
k=1;
for i=1:l1 % to convert column vector to row vector
 for j=1:bits
 coded(k)=code(i,j);
 j=j+1;
 k=k+1;
 end
 i=i+1;
end
%DEMODULATION 
index1=bi2de(code_row,'left-msb'); %converting from binary to decimal
resignal=del*index+xmin+(del/2); %to recover the modulated signal
% Plotting 
figure 
plot(signal_1,'b') % plotting the curve fitted  signal
title('Total no of cases')
xlabel('Days')
ylabel('No.of cases')
figure
scatter(x,signal_1,'g'); %   sampled signal plot
title('Sampled Signal')
xlabel('DAYS')
ylabel('No. of cases')
figure
stem(quants,'o') % quantized signal plot
title('Quantized Signal')
xlabel('Days')
ylabel('No. of cases')
figure
stairs(coded,'c'); 
axis([0 200 -2 2])
title('Digital signal')  % digital signalplot
xlabel('Time')
ylabel('Amplitude')
figure
plot(resignal,'r') %  demodulated signal plot 
title('Demodulated Signal')
xlabel('Days')
ylabel('No. of cases')

