integral_m = cumsum(m)/Fs;
fm_wave_manual = Ac * cos(2*pi*fc*t +kf * integral_m);
figure;
plot(t, fm_wave_manual);
title('FM Wave without using function');
xlabel('Time (s)');
ylabel('Amplitude');