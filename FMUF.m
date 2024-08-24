
kf = 100;
fm_wave = fmmod(m, fc, Fs, kf);
figure;
plot(t, fm_wave);
title('FM Wave using fmmod function');
xlabel('Time (s)');
ylabel('Amplitude');