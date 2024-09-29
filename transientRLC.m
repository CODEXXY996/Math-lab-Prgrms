% Given differential equation
syms i(t);
DI = diff(i,t);
ode4 = diff(i(t),t,2) + 1000*diff(i,t) + i*10^9 == 0;

% Initial conditions
cond4 = i(0) == 5;
cond5 = DI(0) == 0;
conds = [cond4, cond5];

% Solve the ODE
xSo14(t) = dsolve(ode4, conds);

% Display the result
disp('Current transient of RLC for V=5 volts:');
disp(xSo14(t));

% Time range for plotting
t1 = 0:.001:.01;

% Evaluate the solution at these time points
F3 = vpa(subs(xSo14, t, t1));

% Plot the current transient
subplot(223);
plot(t1, F3);
title('Current Transient for V=5 volts');
xlabel('Time (s)');
ylabel('Current (A)');
grid on;
