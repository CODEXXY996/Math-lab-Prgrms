clc;
clear all;
close all;
%% Read MP3 Audio File
[audio_data, fs] = audioread('gun-shot.mp3'); % Replace 'your_audio_file.mp3' with your MP3 file name

%% Debug: Check if audio is loaded correctly
if isempty(audio_data)
    error('Audio data could not be loaded. Please check the file path and format.');
end

if isempty(fs)
    error('Sampling rate could not be determined. Please check the audio file.');
end

%% Time Vector for Plotting
t = (0:length(audio_data)-1) / fs; % Time vector in seconds

%% Plot Audio Signal in Time Domain
figure;
subplot(2, 1, 1); % Create a subplot for time-domain signal
plot(t, audio_data);
xlabel('Time (seconds)');
ylabel('Amplitude');
title('MP3 Audio Signal in Time Domain');
grid on;

%% Fourier Transform of the Audio Signal
N = length(audio_data); % Number of samples
audio_fft = fft(audio_data); % Perform FFT
f = (0:N-1)*(fs/N); % Frequency vector up to Nyquist frequency
amplitude_spectrum = abs(audio_fft) / N; % Magnitude of FFT normalized by number of samples

%% Plot Audio Signal in Frequency Domain
subplot(2, 1, 2); % Create a subplot for frequency-domain signal
plot(f, amplitude_spectrum);
xlabel('Frequency (Hz)');
ylabel('Amplitude');
title('Frequency Spectrum of Audio Signal');
xlim([0 fs/2]); % Limit x-axis to half the sampling rate (Nyquist limit)
grid on;

%% Display Information
fprintf('Sampling Rate: %d Hz\n', fs);
fprintf('Duration: %.2f seconds\n', length(audio_data)/fs);
