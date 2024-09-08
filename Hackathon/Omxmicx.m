clc;
clear all;
close all;
%% Parameters for Circular Microphone Array
N = 6;                      % Number of microphones
radius = 1;                 % Radius of the circular array (in meters)
c = 343;                    % Speed of sound (m/s)
source_angle = pi/3;        % Source located at 60 degrees (pi/3 radians)
source_distance = 3;        % Distance of the source from array center (in meters)

% Microphone positions (circular array)
theta = linspace(0, 2*pi, N+1); % Angles for microphone positions (0 to 360 degrees)
theta(end) = [];                % Remove the last element to make it exactly N mics
mic_positions = [radius * cos(theta); radius * sin(theta)]; % Microphone coordinates (x, y)

% Display microphone positions
figure;
plot(mic_positions(1,:), mic_positions(2,:), 'o');
xlabel('X Position (m)');
ylabel('Y Position (m)');
title('Microphone Positions');
grid on;

%% Read MP3 Audio File
[audio_data, fs] = audioread('gshx.mp3'); % Replace 'gshx.mp3' with your MP3 file name

% Debug: Check if audio is loaded correctly
if isempty(audio_data)
    error('Audio data could not be loaded. Please check the file path and format.');
end
if isempty(fs)
    error('Sampling rate could not be determined. Please check the audio file.');
end

% Time vector for plotting
t = (0:length(audio_data)-1) / fs; % Time vector in seconds

%% Design Bandpass Filter
f_low = 500; % Lower cutoff frequency in Hz
f_high = 3000; % Upper cutoff frequency in Hz
filter_order = 4; % Filter order

% Design a Butterworth bandpass filter
[b, a] = butter(filter_order, [f_low f_high] / (fs / 2), 'bandpass'); 

% Apply Bandpass Filter to Audio Signal
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

% Plot Filtered Audio Signal in Frequency Domain
subplot(3, 1, 3); % Subplot for frequency-domain signal
plot(f, amplitude_spectrum);
xlabel('Frequency (Hz)');
ylabel('Amplitude');
title('Frequency Spectrum of Filtered Audio Signal');
xlim([0 fs/2]); % Limit x-axis to half the sampling rate (Nyquist limit)
grid on;

%% Simulate Source Position
source_position = [source_distance * cos(source_angle); source_distance * sin(source_angle)];

% Calculate the time delays for each microphone
distances = sqrt(sum((mic_positions - source_position).^2, 1));  % Distance from source to each mic
time_delays = distances / c;   % Time delays for each mic (in seconds)

% Simulate the signal received at each microphone (apply time delays)
received_signals = zeros(N, length(filtered_audio));
for i = 1:N
    delay_samples = round(time_delays(i) * fs);  % Convert time delay to number of samples
    received_signals(i, delay_samples+1:end) = filtered_audio(1:end-delay_samples);  % Delayed signal
end

%% Plot the received signals at each microphone
figure;
for i = 1:N
    subplot(N, 1, i);
    plot(t, received_signals(i, :));
    xlabel('Time (seconds)');
    ylabel('Amplitude');
    title(['Received Signal at Microphone ', num2str(i)]);
end

%% Calculate TDOA between microphone pairs using cross-correlation
tdoa = zeros(N, N);
for i = 1:N-1
    for j = i+1:N
        [corr_result, lags] = xcorr(received_signals(i, :), received_signals(j, :), 'coeff');
        [~, max_idx] = max(corr_result);         % Find maximum correlation point
        tdoa(i, j) = lags(max_idx) / fs;         % Time difference in seconds
    end
end

%% Display TDOA results
disp('TDOA (in seconds) between microphone pairs:');
disp(tdoa);

% Plot TDOA results
figure;
imagesc(tdoa);
colorbar;
title('TDOA Between Microphone Pairs');
xlabel('Microphone Index');
ylabel('Microphone Index');
