clc;
clear all;
close all;
% Parameters
N = 6;                      % Number of microphones
radius = 1;                  % Radius of the circular array (in meters)
c = 343;                     % Speed of sound (m/s)
fs = 48000;                  % Sampling rate (Hz)

% Microphone positions (circular array, equally spaced)
theta = linspace(0, 2*pi, N+1);   % Angles for microphone positions (0 to 360 degrees)
theta(end) = [];                  % Remove the last element to make it exactly N microphones
mic_positions = [radius * cos(theta); radius * sin(theta)]; % Microphone coordinates (x, y)
figure
plot(radius * cos(theta), radius * sin(theta))

% Simulated gunshot position
source_angle = pi/8;  % Gunshot located at 45 degrees (pi/4 radians)
source_distance = 10;  % Distance of the gunshot from the array center (in meters)
source_position = [source_distance * cos(source_angle); source_distance * sin(source_angle)];

% Calculate the time delays for each microphone
distances = sqrt(sum((mic_positions - source_position).^2, 1));  % Distance from source to each mic
time_delays = distances / c;   % Time delays for each mic (in seconds)
plot(time_delays)
disp(time_delays)
% Simulate gunshot signal (e.g., a sharp pulse)
t = 0:1/fs:0.05;  % Time vector (50 ms duration)
gunshot_signal = [1, zeros(1, length(t)-1)];  % Simple impulse (sharp pulse)
received_signals = zeros(N, length(gunshot_signal));

% Apply time delays to the gunshot signal for each microphone
for i = 1:N
    delay_samples = round(time_delays(i) * fs);  % Convert time delay to number of samples
    received_signals(i, delay_samples+1:end) = gunshot_signal(1:end-delay_samples);  % Delayed signal
end

% Plot the received signals
figure;
for i = 1:N
    subplot(N, 1, i);
    plot(t, received_signals(i, :));
    title(['Microphone ', num2str(i)]);
end
% Calculate TDOA between microphone pairs using cross-correlation
tdoa = zeros(N, N);  % Store TDOA values between each pair of microphones
for i = 1:N-1
    for j = i+1:N
        [corr_result, lags] = xcorr(received_signals(i, :), received_signals(j, :), 'coeff');
        [~, max_idx] = max(corr_result);         % Find the maximum correlation point
        tdoa(i, j) = lags(max_idx) / fs;         % Convert lag to time difference (seconds)
    end
end.