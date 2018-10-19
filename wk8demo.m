%% DFT is implemented with the FFT command (fast fourier transform)
% Results in an N-point sample of the spectral domain

N = 16;
n = 0:N-1;
x_0 = sin(pi/2*n);
X_0 = fft(x_0);

% Generate a meaningful \omega vector based on n
w = linspace(-1, (N-1)/N, N) * pi;
stem( w, abs( fftshift( X_0 ) ) );
xlim([-pi, pi]);

%% We can increase the resolution of the DFT by lengthening the time signal

% First try, N is small
N = 32;
n = 0:N-1;
x_1 = 0.3 * sin(pi/2*n) + 0.7 * sin(3*pi/4*n) + .125 * sin(pi/3*n) + .42 * sin(4*pi/7*n);
X_1 = fft(x_1);
w = linspace(-1, (N-1)/N, N) * pi;
stem( w, abs( fftshift( X_1 ) ) );
xlim([-pi, pi]);

% Try lengthening N
N = 128;
n = 0:N-1;
x_2 = 0.3 * sin(pi/2*n) + 0.7 * sin(3*pi/4*n) + .125 * sin(pi/3*n) + .42 * sin(4*pi/7*n);
X_2 = fft(x_2);
w = linspace(-1, (N-1)/N, N) * pi;
stem( w, abs( fftshift( X_2 ) ) );
xlim([-pi, pi]);
% Much better spectral resolution!

%% Another method: zero padding
% Can improve spectral resolution without the need for more data
N_1 = 32; N_2 = 64;
% x_1 is a length 32 sequence
x_3 = zeros(1,64);
x_3(1:32) = x_1;
X_3 = fft(x_3);
w_1 = linspace(-1, (N_1-1)/N_1, N_1) * pi;
w_2 = linspace(-1, (N_2-1)/N_2, N_2) * pi;
stem( w_2, abs( fftshift( X_3) ) );
hold on;
stem( w_1, abs( fftshift( X_1) ) );
xlim([-pi, pi]);
% Easy MATLAB implementation:
m = 32; % amount to zero pad by
X_3zp = fft(x_1, N_1 + m); % This is equivalent to X_3 

%% DFT application: Yanny vs. Laurel
close all;
[y,Fs] = audioread( 'yanny-laurel.wav'); % Fs is the sampling rate
y = y(:,1); % Look at just one channel

%% Do you hear Yanny or Laurel?
sound(y,Fs)

%% Perform spectral analysis using the DFT
N = size(y,1);
Y = fft(y);
% our frequency vector will be in terms of Hz, not radians
% Note that it is based on the sampling rate
f = linspace(-1, (N-1)/N, N) * Fs/2; 
plot(f, fftshift(abs(Y)));
xlim([f(1), f(end)]);
grid on;
% We learn that the signal is bandlimited to +/- 8000 Hz, but not much else
% Let's downsample by a factor of two to make it easier
y_ds = decimate(y,2);

%% How can we get a more complete picture? SPECTROGRAM
% A spectrogram windows in time, so we can understand how the spectral
% domain changes as a function of time

N_ds = size(y_ds,1);
M = 256; % Window size
P = M/4; % Overlap size
n_win = ceil( N_ds / (M-P) );
spect = zeros(n_win, M);
for i = 1:n_win-1
    y_windowed = y_ds( ((M-P)*(i-1)+1):((M-P)*(i-1)+M) );
    spect(i,:) = fftshift( abs( fft( y_windowed ) ) );
end
y_windowed = y_ds( ((M-P)*(n_win-1):end ) );
spect(n_win,:) = fftshift( abs( fft( y_windowed, M ) ) );

f = linspace(0,((M/2)-1)/(M/2),M/2) * (Fs/2)/2;
t = 0:(n_win-1) * (M-P) / (Fs/2);

% View the spectral domain, positive frequencies only
imagesc(t,f,spect(:,M/2+1:end).'); 
ax = gca;
ax.CLim = [0,3];
xlabel('Time (s)');
ylabel('Frequency (Hz)');
axis xy;

% Two spectral components: <1500 Hz, >1500 Hz

%% Use two filters to separate the spectral components
[b_lo, a_lo] = ellip(6, 5, 100, 1500/(Fs/2), 'low');
[b_hi, a_hi] = ellip(6, 5, 100, 1500/(Fs/2), 'high');
y_lo = filter(b_lo, a_lo, y);
y_hi = filter(b_hi, a_hi, y);

%% Yanny or Laurel? (Low Frequencies)
sound(y_lo*2, Fs);

%% Yanny or Laurel? (High Frequencies)
sound(y_hi*2, Fs);