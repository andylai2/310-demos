close all;
clear all;
%% Z-Transform
% symbolic math notation

syms n; 
f = (1/3)^n;
fprintf('Function f[n]\n');
pretty(f)
F = ztrans(f);
fprintf('\nZ-Transform F[z]\n');
pretty(F);
%% Z-transform
% discrete math

sys = tf([1 0], [1, -1/3]);
fprintf('\nNumerical representation of F[z] from poles and zeros\n');
display(sys);
%% Plot poles and zeros in complex plane
% 'x' shows poles, 'o' shows zeros

hplot = pzplot(sys);
% plot unit circle
ylim([-1 1]);
xlim([-1 1]);
hold on
th = 0:pi/50:2*pi;
xunit = cos(th);
yunit = sin(th);
plot(xunit, yunit);
hold off
%% Linearity

g = (1/3)^n - (2/3)^n;
fprintf('Function g[n]\n');
pretty(g)
G = ztrans(g);
fprintf('\nZ-Transform G[z]\n');
pretty(G);

sysG = tf([-3 0], [9 -9 2]);
fprintf('\nNumerical representation of G[z] from poles and zeros\n');
display(sysG);
%% Both poles show up

figure;
hplot = pzplot(sysG);
% plot unit circle
ylim([-1 1]);
xlim([-1 1]);
hold on
plot(xunit, yunit);
hold off
%% Unstable example

k = (5/4)^n;
pretty(k);
figure;
fplot(k, [0 100]);
title('Unbounded function');
ylabel('k[n]')
xlabel('n')
K = ztrans(k);
fprintf('\nZ-Transform K[z]\n');
pretty(K);
%% pole outside unit circle

figure;
pzplot(tf([1 0],[1 -5/4]));
% plot unit circle
ylim([-1.5 1.5]);
xlim([-1.5 1.5]);
hold on
plot(xunit, yunit);
hold off
%% Using the Inverse Z-Transform

syms z;
F = 5*z/(z - 5/6*z + 1/6);
pretty(F)
sys = tf([5 0],[1 -5/6 1/6]);
% Plot poles and zeros
figure;
pzplot(sys);
% plot unit circle
ylim([-1 1]);
xlim([-1 1]);
hold on
th = 0:pi/50:2*pi;
xunit = cos(th);
yunit = sin(th);
plot(xunit, yunit);
hold off
%% Apply Inverse Z-Transform

pretty(iztrans(F));