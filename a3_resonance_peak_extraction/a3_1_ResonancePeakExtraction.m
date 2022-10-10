% Description:  Homework for 3rd week
%               Extract the renonance peak of a short piece of audio
%               Use MATLAB Signal Processing Toolbox
% Projet:       Audio Engineering
% Date:         Oct 8, 2022
% Author:       Zhiyu Shen

clear
close all
clc

%%% Define Parameters
Fs = 10000;                                 % Sampling frequency


%%% Pre-Processing

% Read audio from file
[audioIn, originalFs] = audioread('.\project_intro_terahertz_p1.m4a');

% Enhance voice level
audioIn = audioIn * 1;

% Detect the number of sound tracks
numTracks = size(audioIn, 2);

% Extract one sound track for analysis
trackA = audioIn(:, 1);

% Downsampling
signalResampled = resample(trackA, Fs, originalFs);

% Cut out signal (25ms)
tmin = 36.450;
tmax = 36.475;
M1 = uint32(tmin*Fs+1);
M2 = uint32(tmax*Fs);
audioSig = signalResampled(M1 : M2).';
lenSig = length(audioSig);

% Signal pre-emphasis
audioSig = 50 * audioSig;


%%% Calculate Cepstrum of the Signal

% Add window to signal
lenWin = 2^nextpow2(lenSig);
idxWin = 0 : 1 : lenWin-1;
winSig = 0.54 - 0.46*cos(2*pi*idxWin/lenWin);
sigWindowed = [audioSig, zeros(1, lenWin-lenSig)].*winSig;

% FFT for input signal (Step 1)
nfft = lenWin;
sigFFT = fft(sigWindowed, nfft);
% Logrithmatic operation for spectrum (Step 2)
logFFT = log(abs(sigFFT));
% IFFT operation to get cepstrum (Step 3)
sigCeps = ifft(logFFT, nfft);

% Calculate index
idxTime = (0 : nfft-1) / Fs * 1000;         % Time index (ms)
idxFreq = (0 : nfft/2-1) * Fs / nfft;       % Frequency index (Hz)


%%% Calculate power spectrum and log power spectrum of the signal

% Calculate power spectrum
pwrSpec2 = abs(sigFFT/nfft);
pwrSpec = pwrSpec2(1 : nfft/2);
pwrSpec(2:end-1) = 2 * pwrSpec(2:end-1);

% Calculate logrithmatic power spectrum
logPwrSpec = logFFT(1 : nfft/2);
logPwrSpec(2:end-1) = 2 * logPwrSpec(2:end-1);


%%% Derive the cepstrum of the channel impulse response

% Calculate the log FFT of channel impulse response
maxChan = 24;                               % Maximum index of valid channel impulse response
chanImpCeps = sigCeps(1:maxChan+1);
chanImpCeps = [chanImpCeps zeros(1, nfft-2*maxChan-1) chanImpCeps(end:-1:2)];
chanImpRespFFT = fft(chanImpCeps);

% Calculate the log power spectrum of channel impluse response
chanLogPwrSpec = real(chanImpRespFFT(1 : nfft/2));
chanLogPwrSpec(2:end-1) = 2 * chanLogPwrSpec(2:end-1);


%%% Plot
cepsPlot = figure(1);
cepsPlot.WindowState = 'maximized';

% Plot power spectrum
subplot(2, 2, 1);
plot(idxTime(1:lenSig), audioSig, 'Color', '#0072BD', 'LineWidth', 2);
title('\bf Time Domain Audio Signal', 'Interpreter', 'latex', 'FontSize', 20)
xlabel('\bf Time (ms)', 'Interpreter', 'latex', 'FontSize', 18);
ylabel('\bf Amplitude', 'Interpreter', 'latex', 'FontSize', 18);
set(gca, 'FontSize', 18);
subplot(2, 2, 2);
plot(idxFreq, pwrSpec, 'Color', '#0072BD', 'LineWidth', 2);
title('\bf Power Spectrum', 'Interpreter', 'latex', 'FontSize', 20)
xlabel('\bf Frequency (Hz)', 'Interpreter', 'latex', 'FontSize', 18);
ylabel('\bf Spectrum', 'Interpreter', 'latex', 'FontSize', 18);
set(gca, 'FontSize', 18);
subplot(2, 2, 3);
hold on
title('\bf Logrithmatic Power Spectrum', 'Interpreter', 'latex', 'FontSize', 20)
plot(idxFreq, logPwrSpec, 'Color', '#0072BD', 'LineWidth', 2);
plot(idxFreq, chanLogPwrSpec, 'Color', '#D95319', 'LineWidth', 2);
hold off
xlabel('\bf Frequency (Hz)', 'Interpreter', 'latex', 'FontSize', 18);
ylabel('\bf Logrithmatic Spectrum', 'Interpreter', 'latex', 'FontSize', 18);
legend('Audio signal', 'Channel impulse')
set(gca, 'FontSize', 18);
subplot(2, 2, 4);
plot(idxTime, sigCeps, 'Color', '#0072BD', 'LineWidth', 2);
title('\bf Cepstrum', 'Interpreter', 'latex', 'FontSize', 18)
xlabel('\bf Time (ms)', 'Interpreter', 'latex', 'FontSize', 18);
ylabel('\bf Cepstrum', 'Interpreter', 'latex', 'FontSize', 18);
set(gca, 'FontSize', 18);

