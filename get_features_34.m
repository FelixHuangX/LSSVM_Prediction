%This function is using to extract features

function [h] = get_features_34(x,fs,Nstd,NR,MaxIter)
%time domain
a = zeros(1,16);
N = length(x);
a(1) = mean(x);
a(2) = rms(x);
a(3) = mean(abs(x));
a(4) = max(x)-min(x);
a(5) = max(abs(x));
a(6) = min(x);
a(7) = var(x);
a(8) = a(2)/abs(a(1));
a(9) = max(x)/a(2);
a(10) = max(x)/abs(a(1));
a(11) = kurtosis(x);
a(12) = skewness(x);
a(13) = std(x);
a14 = 0;
a15 = 0;
a16 = 0;
for i = 1:1:N
    a14 = a14 + sqrt(abs(x(i)));
    a15 = a15 + x(i)^3;
    a16 = a16 + x(i)^4;
end
a(14) = (a14/N)^2;
a(15) = a15/N;
a(16) = a16/N;

%frequency domain
b = zeros(1,12);
n=0:N-1;
t=n/fs;   %time series
y=fft(x,N);    %FFT on signal
mag=abs(y);     %getting the amplitude after FFT
f=n*fs/N;    %frequency series
mag=mag*2/N;
b(1) = mean(mag);
b(2) = var(mag);
b(3) = skewness(mag);
b(4) = kurtosis(mag);

%FC
fc1 = 0;
fc2 = 0;
fc3 = 0;
for i = 1:1:length(mag)
    fc1 = fc1 + f(i)*mag(i);
    fc2 = fc2 + mag(i);
end
fc = fc1/fc2;
b(5) = fc;
%STDF
for i = 1:1:length(mag)
    fc3 = fc3 + ((f(i)-fc)^2)*mag(i);
end
stdf = sqrt(fc3/length(mag));
b(6) = stdf;

fc4 = 0;
fc5 = 0;
fc6 = 0;
fc7 = 0;
for i = 1:1:length(mag)
    fc4 = fc4 + (f(i)^2)*mag(i);
    fc5 = fc5 + (f(i)^4)*mag(i);
    fc6 = fc6 + ((f(i)-fc)^3)*mag(i);
    fc7 = fc7 + sqrt(f(i)-fc)*mag(i);
end
b(7) = sqrt(fc4/fc2);
b(8) = sqrt(fc5/fc4);
b(9) = fc4/sqrt(fc2*fc5);
b(10) = stdf/fc;
b(11) = fc6/(length(mag)*(stdf^3));
b(12) = real(fc7/(length(mag)*stdf));

%eemd energy
[imf] = eemd(x,Nstd,NR,MaxIter);
c = zeros(1,6);
for j = 1:1:6
    c(j) = sum((imf(j,:)).^2);
end
h = [a,b,c];
%h = [a,b];
h = 1./(1+exp(-h));
end