%% Simple DTFS Demo
close all;
% Generate a cosine with frequency 1
N = 50;
n = 0:N-1;
x = cos(n);
stem(x);

%% Use a matrix to calculate the DTFS coefficients
K = 50;
k = 0:K-1;% length N DTFS
[xx,yy] = meshgrid(n,k);
fmat = exp(-1j*2*pi/N.*xx.*yy)./N;

%% Matrix multiplication does the same as the series summation
% Shows us we have a cosinusoid with frequency 1
% Make sure to fftshift since this calculation gives us the frequency
% domain in [0, 2pi] and we wat to plot in [-pi,pi]!!
X = fmat * x';
figure();
w = -pi:2*pi/N:(pi-(2*pi/N));
stem(w,fftshift(abs(X)));
xlabel('Frequency \omega');
ylabel('Magnitude')

%% Add in some other frequencies with different magnitudes
x1 = x;
x2 = 3 * cos(3/2*n);
x3 = .5 * cos(.5 * n);
y = x1 + x2 + x3;

%% Use the same matrix as above
% We see the new frequencies show up on the plot with corresponding
% magnitudes
Y = fmat * y';
figure;
stem(w,fftshift(abs(Y)));
hold on;
plot(w,fftshift(abs(X)));
xlabel('Frequency \omega');
ylabel('Magnitude')
legend('Y: three frequencies', 'X: one frequency');

%% More complicated: sinc function
z = sinc((n-N/2)/pi);
figure;
stem(z);

%% Calculate the DTFS again
% A sinc and rect are pairs in the frequency/time domains
Z = fmat * z';
figure();
stem(w,fftshift(abs(Z)));
xlabel('Frequency \omega');
ylabel('Magnitude')

%% As we increase N, the DTFS converges to the DTFT
% i.e., continuous in the frequency domain
% Notice that the rect function we get as the output looks much more like
% a real rect function!!

N = 1024;
n = 0:N-1;
K = 1024;
k = 0:K-1; 
z = sinc((n-N/2)/pi);

[xx,yy] = meshgrid(n,k);
fmat = exp(-1j*2*pi/N.*xx.*yy)./N;

w = -pi:2*pi/N:(pi-(2*pi/N));
Z = fmat * z';
figure();
plot(w,fftshift(abs(Z)));
xlabel('Frequency \omega');
ylabel('Magnitude')

%% Filtering in the time domain
% Our frequency analysis of the sinc function shows that it's actually a
% lowpass filter
% Recall that multiplication in the frequency domain is equivalent to
% convolution in time, so we can apply LPF by convolution with sinc.
% Let's try it on the sum of sinusoids to recover x3
x1 = cos(n);
x2 = 3 * cos(3/2*n);
x3 = .5 * cos(.5 * n);
y = x1 + x2 + x3;
figure;
plot(y(1:128)); % Not a clean sinusoid
% Y = fmat * y';
% plot(w,fftshift(abs(Y)));


%% Generate a LPF with a stopband at f = 3/4
% This will keep only x3 and filter out x1, x2
z = sinc((n-N/2)/pi * 3/4)/4;


x3_recovered = conv(y,z,'same');
% X3_recovered = fmat * x3_recovered';
figure;
% plot(w,fftshift(abs(X3_recovered)));
plot(x3_recovered(1:128));
hold on;
plot(x3(1:128));
legend('x3 recovered', 'x3 original');