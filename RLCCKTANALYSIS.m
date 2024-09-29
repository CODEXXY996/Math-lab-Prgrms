clc;
clear all;
close all;
syms I(t);
ode4 = diff(I(t), t, 2) + 1000 * diff(I, t) + I * 10^9 == 0;
cond4 = I(0) == 5;
cond5 = I(0) == 0;
conds = [cond4, cond5];
xSol4(t) = dsolve(ode4, conds);
disp('Current transient of RLC for V=5 volts')
disp(xSol4(t));

% Now let's plot the current transient
t1 = 0:.001:.01;
F3 = vpa(subs(xSol4, t, t1));
subplot(223)
plot(t1, F3)

