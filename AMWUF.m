am_wave_manual = (A* sin(2*pi*fm*t) + Ac) .* cos(2*pi*fc*t)
figure;
plot(t, am_wave_manual);
title('AM Wave without using function');
xlabel('Time (s)');
ylabel('Amplitude');