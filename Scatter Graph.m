

x= 0:3*pi/199:3*pi;
y = cos(x) + rand(1, 200);
scatter(x, y);
title('Scatter Plot of y =cos(x) + rand(1,200)');
xlabel('x');
ylabel('y');