% Description:  Homework for 1st week
%               Measure the spectrum of a given voice piece
% Projet:       Audio Engineering
% Date:         Sept 16, 2022
% Author:       Zhiyu Shen

clear
close all
clc

% Define parameters
Fs = 8000;                  % Sampling frequency

% Read audio from file
[audioIn, originalFs] = audioread('.\audio_test.wav');

% Detect the number of sound tracks
numTracks = size(audioIn, 2);

% Extract one sound track for analysis
soundTrack = audioIn(:, 1);

% Downsampling
soundResampled = resample(soundTrack, Fs, originalFs);

% Plot sound wave
lenSample = length(soundResampled);
tmin = 0.45;
tmax = 0.48;
t1 = (0 : (lenSample-1)) / Fs;
figure(1)
subplot(1, 2, 1);
plot(t1, soundResampled);
xlim([tmin tmax]);
ylim([tmin tmax]);
axis([tmin, tmax, -0.2, 0.2]);
xlabel('t/s');
ylabel('Amplitute');
title('Sound wave');

% Cut out signal
M1 = uint32(tmin*Fs+1);
M2 = uint32(tmax*Fs);
soundCut = soundResampled(M1:M2);

% Plot spectrum
lenCut = length(soundCut);
xfft = fft(soundCut);
P2 = abs(soundCut);
P1 = P2(1 : lenCut/2+1);
P1(2 : end-1) = 2 * P1(2 : end-1);
f = Fs * (0 : (lenCut/2)) / lenCut;
fm = Fs/2;
subplot(1, 2, 2);
plot(f, P1) 
title('Single-Sided Amplitude Spectrum')
xlabel('f(Hz)')
ylabel('|P1(f)|')
