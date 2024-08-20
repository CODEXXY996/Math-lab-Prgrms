t =- 10:10;
unit_impulse=(t == 0);
unit_step=(t >=0);
unit_ramp=t .* (t >= 0);

subplot(3,1,1);
stem(t, unit_impulse);
title("Unit Impulse Signal(Discrete)");
xlabel('time');
ylabel('Amplitude');

subplot(3,1,2);
stem(t, unit_step);
title('Unit Step Signal(Discrete)');
xlabel('time');
ylabel('Amplitude');

subplot(3,1,3);
stem(t, unit_ramp);
title('Unit Ramp Signal(Discrete)');
xlabel('Time');
ylabel('Amplitude');