% Description:  Homework for 4th week
%               Design a digital filter
% Projet:       Audio Engineering
% Date:         Oct 15, 2022
% Author:       Zhiyu Shen

clear
close all
clc

%% Define parameters
nInf = 16385;                           % Number representing infinite
centerIdx = (nInf+1) / 2;               % Center index of infinite assumption
nDisp = 1024;

wP1 = 0.2*pi;                           % Upper passband angular frequency (rad)
wP2 = 0.4*pi;                           % Lower passband angular frequency (rad)


%% Construct ideal frequency response

hwBp0 = zeros(1, nInf);                 % Allocate points for ideal frequency response
wDelta = 2*pi / (nInf-1);               % Increment of angular
w0 = 0 : wDelta : 2*pi;                 % Digital angular frequency index
f0 = w0 / (2*pi);                       % Digital frequency index
idxFp1 = round(wP1/wDelta) + 1;         % Corresponding frequency response index of fp1
idxFp2 = round(wP2/wDelta) + 1;         % Corresponding frequency response index of fp2
hwBp0(idxFp1:idxFp2) = 1;               % Construct frequency response function
idxN = -nInf/2 : nInf/2;                % Filter impulse response index
% Filter impulse response
hnBp0 = (sin(wP2.*idxN)-sin(wP1.*idxN)) ./ (pi.*idxN);
idxNShift = 0 : nInf;                   % Filter impulse response index (Shifted after 0)

% Plot original frequency response (ideal)
idealPlot = figure(1);
idealPlot.WindowState = 'maximized';
% Plot ideal frequency response of BPF
subplot(2, 1, 1);
plot(w0/pi, hwBp0, 'Color', '#0072BD', 'LineWidth', 2);
title('\bf Ideal Frequency Response of BPF', 'Interpreter', ...
    'latex', 'FontSize', 18)
xlabel('\bf $\omega\ (\pi\ rad)$', 'Interpreter', ...
    'latex', 'FontSize', 18);
ylabel('\bf $H_0(\omega)$', 'Interpreter', 'latex', 'FontSize', 18);
xlim([0 2]);
set(gca, 'FontSize', 18);
% Plot ideal impulse response of BPF
subplot(2, 1, 2);
plot(idxN, hnBp0, 'Color', '#0072BD', 'LineWidth', 2);
title('\bf Ideal Impulse Response of BPF', 'Interpreter', ...
    'latex', 'FontSize', 18)
xlabel('\bf $n$', 'Interpreter', 'latex', 'FontSize', 18);
ylabel('\bf $h_{d0}(n)$', 'Interpreter', 'latex', 'FontSize', 18);
xlim([-nDisp/2 nDisp/2]);
set(gca, 'FontSize', 18);


%% Construct window function

nWin = 512;                                    % Window length
idxWin = 0 : nWin;                              % Digital index of Window function
winSig = 0.54 - 0.46*cos(2*pi*idxWin/nWin);     % Construct window function
idxWinShift = -nWin/2 : nWin/2;                 % Digital index of Window function (Zero centered)
% Windowed filter impulse response
hnBpWin = hnBp0((centerIdx-nWin/2):(centerIdx+nWin/2)) .* winSig;

% Plot window function
windowPlot = figure(2);
windowPlot.WindowState = 'maximized';
% Plot window function
subplot(2, 1, 1);
plot(idxWinShift, winSig, 'Color', '#0072BD', 'LineWidth', 2);
title('\bf Window Function (Hamming Window)', 'Interpreter', 'latex', ...
    'FontSize', 18)
xlabel('\bf $n$', 'Interpreter', 'latex', 'FontSize', 18);
ylabel('\bf $w(n)$', 'Interpreter', 'latex', 'FontSize', 18);
xlim([-nWin/2 nWin/2]);
set(gca, 'FontSize', 18);
subplot(2, 1, 2);
plot(idxWinShift, hnBpWin, 'Color', '#0072BD', 'LineWidth', 2);
title('\bf Windowed Impulse Response of BPF (Shifted)', ...
    'Interpreter', 'latex', 'FontSize', 18)
xlabel('\bf $n$', 'Interpreter', 'latex', 'FontSize', 18);
ylabel('\bf $h_0(n)$', 'Interpreter', 'latex', 'FontSize', 18);
xlim([-nWin/2 nWin/2]);
set(gca, 'FontSize', 18);


%% DFT to Recover Frequency Response

nFFT = 16384;
hwBpWin = fft(hnBpWin, nFFT);
hwBpAmp = abs(hwBpWin(1 : (nFFT/2+1)));
hwBpAng = angle(hwBpWin(1 : (nFFT/2+1)));
wIncWin = pi / (nFFT/2);
wIdxWin = 0 : wIncWin : pi;

% Plot bandpass filter functions
bpfPlot = figure(3);
bpfPlot.WindowState = 'maximized';
titleInfo = ['Hamming Window, ', '$N=', num2str(nWin), '$'];
% Plot actual impulse response of BPF
subplot(3, 1, 1);
plot(idxWinShift, hnBpWin, 'Color', '#0072BD', 'LineWidth', 2);
title('\bf Impulse Response of BPF', titleInfo, 'Interpreter', 'latex', 'FontSize', 18)
xlabel('\bf $n$', 'Interpreter', 'latex', 'FontSize', 18);
ylabel('\bf $h_{BP}(n)$', 'Interpreter', 'latex', 'FontSize', 18);
xlim([-nWin/2 nWin/2]);
set(gca, 'FontSize', 18);
% Plot actual amplitude-frequency response of BPF
subplot(3, 1, 2);
plot(wIdxWin/pi, 20*log10(hwBpAmp), 'Color', '#0072BD', 'LineWidth', 2);
title('\bf Amplitude-Frequency Response of BPF', 'Interpreter', 'latex', ...
    'FontSize', 18)
xlabel('\bf $\omega\ (\pi\ rad)$', 'Interpreter', 'latex', 'FontSize', 18);
ylabel('\bf $\vert H_{BP}(\omega)\vert$', 'Interpreter', 'latex', 'FontSize', 18);
xlim([0 1]);
ylim([-120 20]);
set(gca, 'FontSize', 18);
% Plot actual phase-frequency response of BPF
subplot(3, 1, 3);
plot(wIdxWin/pi, hwBpAng, 'Color', '#0072BD', 'LineWidth', 2);
title('\bf Phase-Frequency Response of BPF', 'Interpreter', 'latex', ...
    'FontSize', 18)
xlabel('\bf $\omega\ (\pi\ rad)$', 'Interpreter', 'latex', 'FontSize', 18);
ylabel('\bf $\vert \phi_{BP}(\omega)\vert\ (rad)$', 'Interpreter', 'latex', 'FontSize', 18);
xlim([0 1]);
ylim([-1.2*pi 1.2*pi]);
set(gca, 'FontSize', 18);
