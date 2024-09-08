clc;
clear all;
close all;
%% Parameters
f_low = 500; % Lower cutoff frequency in Hz for bandpass filter
f_high = 3000; % Upper cutoff frequency in Hz for bandpass filter
speed_of_sound = 343; % Speed of sound in air (m/s)
num_mics = 6; % Number of microphones
mic_positions = [0, 0; 1, 0; 0, 1; 1, 1; 0.5, 1.5; 1.5, 0.5]; % Microphone positions in meters

%% Read MP3 Audio File
file_name = 'gshx.mp3'; % Replace with your MP3 file name

% Check if the file exists
if exist(file_name, 'file')
    [audio_data, fs] = audioread(file_name); % Read audio data from the file
    disp('Audio file loaded successfully.');
else
    error('File not found. Please check the file path and name.');
end

%% Check for Mono or Stereo Audio
if size(audio_data, 2) > 1
    audio_data = mean(audio_data, 2); % Convert stereo to mono by averaging the channels
end

%% Time Vector for Plotting
t = (0:length(audio_data)-1) / fs; % Time vector in seconds

%% Simulate Delays Based on Sound Source
% Assume the source is at position (x_s, y_s) = (2, 2)
source_position = [2, 2];
distances = sqrt(sum((mic_positions - source_position).^2, 2)); % Distance from source to each mic
delays = distances / speed_of_sound; % Delays in seconds

% Add delays to signals for each microphone
mic_signals = zeros(num_mics, length(audio_data));
for i = 1:num_mics
    delay_samples = round(delays(i) * fs); % Delay in samples
    mic_signals(i, :) = [zeros(1, delay_samples), audio_data(1:end - delay_samples)'];
end

%% Bandpass Filter Design
[b, a] = butter(4, [f_low f_high] / (fs/2), 'bandpass'); % 4th order Butterworth filter

% Apply the filter to each microphone signal
filtered_signals = zeros(size(mic_signals));
for i = 1:num_mics
    filtered_signals(i, :) = filter(b, a, mic_signals(i, :));
end

%% Cross-Correlation for TDOA Estimation
tdoa_estimates = zeros(num_mics, num_mics); % Matrix to hold TDOA values
for i = 1:num_mics
    for j = i+1:num_mics
        [corr_ij, lags] = xcorr(filtered_signals(i, :), filtered_signals(j, :));
        [~, max_idx] = max(corr_ij); % Find the index of the maximum peak in the cross-correlation
        tdoa_estimates(i, j) = lags(max_idx) / fs; % Calculate TDOA in seconds
    end
end

%% Debugging: Display TDOA Estimates
disp('TDOA Estimates (in seconds):');
disp(tdoa_estimates);

%% Localization Using TDOA
% Example calculation for a 2D scenario
d12 = tdoa_estimates(1, 2) * speed_of_sound; % Distance difference between mic 1 and 2
d13 = tdoa_estimates(1, 3) * speed_of_sound; % Distance difference between mic 1 and 3

% Debugging: Display Distance Differences
disp('Distance Differences (in meters):');
disp(['d12: ', num2str(d12)]);
disp(['d13: ', num2str(d13)]);

% Check for valid input range for acosd
if abs(d12) > norm(mic_positions(2,:) - mic_positions(1,:)) || abs(d13) > norm(mic_positions(3,:) - mic_positions(1,:))
    error('Calculated distance differences are out of range for angle calculation.');
end

% Calculate angle of arrival (AoA)
theta12 = atan2d(mic_positions(2,2) - mic_positions(1,2), mic_positions(2,1) - mic_positions(1,1)) - acosd(d12 / norm(mic_positions(2,:) - mic_positions(1,:)));
theta13 = atan2d(mic_positions(3,2) - mic_positions(1,2), mic_positions(3,1) - mic_positions(1,1)) - acosd(d13 / norm(mic_positions(3,:) - mic_positions(1,:)));

% Average the AoA estimates for robustness
estimated_angle = mean([theta12, theta13]);

%% Display Results
fprintf('Estimated Direction of Gunshot: %.2f degrees\n', estimated_angle);

%% Fourier Transform of Filtered Audio Signal
N = length(filtered_signals(1, :)); % Number of samples in one microphone signal
audio_fft = fft(filtered_signals(1, :)); % Perform FFT on one filtered audio signal
f = (0:N-1) * (fs / N); % Frequency vector up to Nyquist frequency
amplitude_spectrum = abs(audio_fft) / N; % Magnitude of FFT normalized by number of samples

%% Plot Original and Filtered Audio Signals in Time and Frequency Domain
figure;
subplot(3, 1, 1); % Subplot for original time-domain signal
plot(t, audio_data);
xlabel('Time (seconds)');
ylabel('Amplitude');
title('Original MP3 Audio Signal in Time Domain');
grid on;

subplot(3, 1, 2); % Subplot for filtered time-domain signal
plot((0:length(filtered_signals(1, :))-1) / fs, filtered_signals(1, :));
xlabel('Time (seconds)');
ylabel('Amplitude');
title('Filtered Audio Signal in Time Domain');
grid on;

subplot(3, 1, 3); % Subplot for frequency-domain signal
plot(f, amplitude_spectrum);
xlabel('Frequency (Hz)');
ylabel('Amplitude');
title('Frequency Spectrum of Filtered Audio Signal');
xlim([0 fs/2]); % Limit x-axis to half the sampling rate (Nyquist limit)
grid on;

