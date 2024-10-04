clc;
clear all;
close all;
syms f1 f2 f3 f4 x
f1=sin(x);
f2=cos(x);
f3=sinh(x);
f4=cosh(x);
diff1 = diff(f1,x);
diff2 = diff(f2,x);
diff3 = diff(f3,x);
diff4 = diff(f4,x);
t = -10:0.01:10;
diffval1 = vpa(subs(diff1,x,t));
diffval2 = vpa(subs(diff2,x,t));
diffval3 = vpa(subs(diff3,x,t));
diffval4 = vpa(subs(diff4,x,t));
subplot(2,2,1);
plot(t,diffval1);
xlabel("time");
ylabel("f'(sin(t))")
subplot(2,2,2);
plot(t,diffval2);
xlabel("time");
ylabel("f'(cos(t))")
subplot(2,2,3);
plot(t,diffval3);
xlabel("time");
ylabel("f'(sinh(t))")
subplot(2,2,4);
plot(t,diffval4);
xlabel("time");
ylabel("f'(cosh(t))");

