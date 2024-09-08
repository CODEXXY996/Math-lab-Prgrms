clc;
clear all;
close all;
%% Parameters
f_low = 500; % Lower cutoff frequency in Hz for bandpass filter
f_high = 3000; % Upper cutoff frequency in Hz for bandpass filter
threshold_peak_freq = 500; % Example threshold for peak frequency (Hz)
threshold_energy_band = 0.001; % Example threshold for total energy in specific bands

%% Read MP3 Audio File
file_name = 'gshx.mp3'; % Replace with your MP3 file name
[audio_data, fs] = audioread(file_name); % Read audio data from the file
audio_data = mean(audio_data, 2); % Convert stereo to mono if necessary

%% Bandpass Filter Design
[b, a] = butter(4, [f_low f_high] / (fs/2), 'bandpass'); % 4th order Butterworth filter
filtered_signal = filter(b, a, audio_data);

%% Compute FFT
N = length(filtered_signal);
fft_signal = fft(filtered_signal);
f = (0:N-1) * (fs / N); % Frequency vector
amplitude_spectrum = abs(fft_signal) / N; % Magnitude of FFT normalized by number of samples

%% Extract Features
[~, peak_freq_idx] = max(amplitude_spectrum(1:floor(N/2))); % Index of peak frequency
peak_freq = f(peak_freq_idx); % Peak frequency in Hz

% Calculate total energy in the band of interest
band_energy = sum(amplitude_spectrum(f >= 500 & f <= 3000).^2);

%% Classification
if peak_freq > threshold_peak_freq && band_energy > threshold_energy_band
    disp('Gunshot detected.');
else
    disp('No gunshot detected.');
end

%% Plot Frequency Spectrum
figure;
plot(f, amplitude_spectrum);
xlabel('Frequency (Hz)');
ylabel('Amplitude');
title('Frequency Spectrum of Filtered Audio Signal');
xlim([0 fs/2]);
grid on;


disp(peak_freq)
disp(band_energy)