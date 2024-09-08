clc;
clear all;
close all;

%% Read MP3 Audio File
[audio_data, fs] = audioread('.mp3'); % Replace 'your_audio_file.mp3' with your MP3 file name

%% Debug: Check if audio is loaded correctly
if isempty(audio_data)
    error('Audio data could not be loaded. Please check the file path and format.');
end

if isempty(fs)
    error('Sampling rate could not be determined. Please check the audio file.');
end

%% Time Vector for Plotting
t = (0:length(audio_data)-1) / fs; % Time vector in seconds

%% Design Bandpass Filter
f_low = 500; % Lower cutoff frequency in Hz
f_high = 3000; % Upper cutoff frequency in Hz
filter_order = 4; % Filter order

% Design a Butterworth bandpass filter
[b, a] = butter(filter_order, [f_low f_high] / (fs / 2), 'bandpass'); 

%% Apply Bandpass Filter to Audio Signal
filtered_audio = filter(b, a, audio_data);

%% Plot Original and Filtered Audio Signals in Time Domain
figure;
subplot(3, 1, 1); % Subplot for original time-domain signal
plot(t, audio_data);
xlabel('Time (seconds)');
ylabel('Amplitude');
title('Original MP3 Audio Signal in Time Domain');
grid on;

subplot(3, 1, 2); % Subplot for filtered time-domain signal
plot(t, filtered_audio);
xlabel('Time (seconds)');
ylabel('Amplitude');
title('Filtered MP3 Audio Signal in Time Domain');
grid on;

%% Fourier Transform of the Filtered Audio Signal
N = length(filtered_audio); % Number of samples
audio_fft = fft(filtered_audio); % Perform FFT on filtered audio
f = (0:N-1) * (fs / N); % Frequency vector up to Nyquist frequency
amplitude_spectrum = abs(audio_fft) / N; % Magnitude of FFT normalized by number of samples

%% Plot Filtered Audio Signal in Frequency Domain
subplot(3, 1, 3); % Subplot for frequency-domain signal
plot(f, amplitude_spectrum);
xlabel('Frequency (Hz)');
ylabel('Amplitude');
title('Frequency Spectrum of Filtered Audio Signal');
xlim([0 fs/2]); % Limit x-axis to half the sampling rate (Nyquist limit)
grid on;

%% Display Information
fprintf('Sampling Rate: %d Hz\n', fs);
fprintf('Duration: %.2f seconds\n', length(audio_data)/fs);
