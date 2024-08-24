
Fs = 1000;
t = 0:1/Fs:1-1/Fs;
fc = 100;
fm = 10;
A = 1;
Ac =5;
m = A*sin(2*pi*fm*t);
am_wave = ammod(m, fc, Fs, 0, Ac);
figure;
plot(t, am_wave);
title('AM Wave using ammod function');
xlabel('Time (s)');
ylabel('Amplitude');