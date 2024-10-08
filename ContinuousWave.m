t = linspace(0, 1, 1000);
freq = 2;
sine_wave = sin(2 * pi * t * freq);
square_wave = square(2 * pi * t * freq);
triangular_wave = sawtooth(2 * pi * t * freq* 0.5);
sawtooth_wave = sawtooth(2 * pi * t *freq);
figure;
subplot(4,1,1);
plot(t, sine_wave);
title("Continuous Sine Wave");
xlabel('Time');
ylabel('Amplitude');
subplot(4,1,2);
plot(t, square_wave);
title('Continuous Square Wave');
xlabel('Time');
ylabel('Amplitude');
subplot(4,1,3);
plot(t, triangular_wave);
title('Continuous Triangular Wave');
xlabel('Time');
ylabel('Amplitude');
subplot(4,1,4);
plot(t, sawtooth_wave);
title("Continuous Sawtooth Wave");
xlabel("Time");
ylabel('Amplitude');