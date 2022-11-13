% adaptive, noise cancellation

close all
clear
clc

% Generate an "unknown" system
% System response: H(z)=1/(1-0.5 z^(-1))
A = [1 -0.5];
B = 1;

% Generate a sequence to be recovered
% s = [12 11 10 9 8 7 6 5 4 -12 -11 -10 -9 -8 -7 -6 -5 -4];
% for i = 1 : 12
%     s = [s s];
% end
s0 = [12 11 10 9 8 7 6 5 4 -12 -11 -10 -9 -8 -7 -6 -5 -4];
s = repmat(s0, 1, 2^12);

% Construct two measured sequence
% Reference channel: u1, Primary channel: u2,
% u1: received noise, u2: interfered signal
% Interfered signal is correlated with received noise
LL = length(s);
u1 = (rand(1, LL)-0.5)*30;          % Range: [-15, 15]
u2 = s + filter(B, A, u1);

% Set the initial state of the FIR filter (100 orders, 0)
order = 100;
h = zeros(1, order);
err = zeros(1, 240);
h1 = figure();
h2 = figure();
w = 0 : 0.001 : pi;

for i = 240 : LL
    % Adaptive filter
    [e0, h] = adaptive(u1(i:-1:i-order+1), u2(i), h);
    err = [err e0];

    % Visualize filter process
    if mod (i, 60) == 0
        figure(h1);
        subplot(311); plot(s(i-239:i)); ylim([-30, 30]);
        subplot(312); plot(u2(i-239:i));
        subplot(313); plot(err(i-239:i)); ylim([-30, 30]);
        drawnow;
    end

    % Plot filter's frequency response
    if mod (i, 240) == 0
        figure(h2);
        wn = exp(-1i*(0:order-1)'*w);
        H2 = h * wn;
        plot(abs(H2));
        drawnow
    end
    pause(0.001);
end

% freqeuncy response 1/(1-0.5z^(-1))
% H1 = 1./(1-0.5*e.^(-1i*w));

function [e0, hOut] = adaptive(xRef, xPrim, hIn)

%
% Adaptive function of active noise cancelling
%
% Input arguments:
%   @xRef : Reference channel signal
%   @xPrim: Primary channel signal
%   @h    : Current filter response
%
% Output arguments:
%   @e0: Error of next point
%   @h : Iterated filter response
%
% Author: Zhiyu Shen @Nanjing University
% Date  : Nov 3, 2022
%

% Define parameters
mu = 1e-6;

% Calculate y(n)
y = hIn * xRef.';

% Calculate error
e0 = xPrim - y;

% Update filter coefficients
hOut = hIn + mu*e0*xRef;


end