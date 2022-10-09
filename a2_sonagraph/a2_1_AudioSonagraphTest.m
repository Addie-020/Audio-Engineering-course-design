% Description:  Homework for 2nd week
%               Plot the sonagraph of a given piece of voice
%               Use MATLAB Signal Processing Toolbox
% Projet:       Audio Engineering
% Date:         Sept 23, 2022
% Author:       Zhiyu Shen

clear
close all
clc

%%% Define parameters
Fs = 10000;                  % Sampling frequency


%%% Pre-processing

% Read audio from file
[audioIn, originalFs] = audioread('.\project_intro_terahertz_p1.m4a');

% Enhance voice level
audioIn = audioIn * 1;

% Detect the number of sound tracks
numTracks = size(audioIn, 2);

% Extract one sound track for analysis
soundTrack = audioIn(:, 1);

% Downsampling
soundResampled = resample(soundTrack, Fs, originalFs);

%%% De-meaning

% Enframe the wave
lenWave = length(soundResampled);           % Length of resampled wave
lenFrame = 50;                              % Length of a frame
numFrame = floor(lenWave/lenFrame);         % Number of frames
numTotFrame = lenFrame*numFrame;            % Number of samples in complete frame
waveFramed = soundResampled(1 : numTotFrame);
waveFramedRest = soundResampled(numTotFrame+1 : end);
waveFramedResize = reshape(waveFramed, lenFrame, numFrame);

% De-meaning by frame
muWaveFramed = sum(waveFramedResize)/lenFrame;
waveDemeanFramed = waveFramedResize - muWaveFramed;
muWaveFramedRest = sum(waveFramedRest)/length(waveFramedRest);
waveDemeanFramedRest = waveFramedRest - muWaveFramedRest;
waveZeroMean = reshape(waveDemeanFramed, numTotFrame, 1);

% Cut out signal
tmin = 36.45;
tmax = 36.475;
M1 = uint32(tmin*Fs+1);
M2 = uint32(tmax*Fs);
waveTest = waveZeroMean(M1 : M2);

% Set sonagraph properties
lenWin = 20;                % Window length
numOverlap = 0.5 * lenWin;  % Number of overlaped points
freqMax = 5;                % Maximum frequency displays
pltCom1 = ['De-mean every ', num2str(lenFrame), ' samples'];
pltCom2 = ['Fs = ', num2str(Fs), ' Hz,  ', ...
          'Window length = ', num2str(lenWin), ',  ', ...
          'Number of overlaped points = ', num2str(numOverlap)];

% Plot
distriPlt = figure(1);
distriPlt.WindowState = 'maximized';
% Plot wave
lenTest = length(waveTest);
tIdx = (0 : (lenTest-1)) / Fs;
subplot(2, 1, 1);
plot(tIdx, waveTest, 'Color', '#0072BD');
title('Sound Wave', pltCom1);
xlabel('Time (s)');
ylabel('Amplitude (V)');
set(gca, 'Fontsize', 20, 'Linewidth', 2, 'Fontname', 'Times New Roman');
% Plot sonagraph
subplot(2, 1, 2);
spectrogram(waveTest, lenWin, numOverlap, [], Fs, 'psd', 'yaxis');
title('Sonagraph (PSD)', pltCom2);
ylim([0 freqMax]);
set(gca, 'Fontsize', 20, 'Linewidth', 2, 'Fontname', 'Times New Roman');
