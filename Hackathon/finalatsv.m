clc;
clear all;
close all;

%% Parameters
fs = 8000; % Sampling frequency in Hz
f_low = 500; % Lower cutoff frequency in Hz for bandpass filter
f_high = 3000; % Upper cutoff frequency in Hz for bandpass filter
speed_of_sound = 343; % Speed of sound in air (m/s)
num_mics = 6; % Number of microphones
mic_positions = [1, 0; 1, 1; -1, 1; 0, 1; -1, -1; 1, -1]; % Microphone positions in meters

%% Simulate Gunshot Signal
gunshot_sound = randn(1, fs); % Simulated gunshot impulse noise for 1 second

%% Simulate Delays Based on Sound Source
% Assume the source is at position (x_s, y_s) = (2, 2)
source_position = [3, -3];
distances = sqrt(sum((mic_positions - source_position).^2, 2)); % Distance from source to each mic
delays = distances / speed_of_sound; % Delays in seconds

% Add delays to signals for each microphone
mic_signals = zeros(num_mics, length(gunshot_sound));
for i = 1:num_mics
    delay_samples = round(delays(i) * fs); % Delay in samples
    if delay_samples < length(gunshot_sound)
        mic_signals(i, :) = [zeros(1, delay_samples), gunshot_sound(1:end - delay_samples)];
    end
end

%% Bandpass Filter Design
[b, a] = butter(4, [f_low f_high] / (fs/2), 'bandpass'); % 4th order Butterworth filter

% Apply the filter to each microphone signal
filtered_signals = zeros(size(mic_signals));
for i = 1:num_mics
    filtered_signals(i, :) = filter(b, a, mic_signals(i, :));
end

%% Plot Filtered Signals
figure;
for i = 1:num_mics
    subplot(num_mics, 1, i);
    plot((0:length(filtered_signals)-1) / fs, filtered_signals(i, :));
    title(['Filtered Signal at Microphone ', num2str(i)]);
    xlabel('Time (s)');
    ylabel('Amplitude');
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
