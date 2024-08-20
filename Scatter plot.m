%Part 5: Realize the given function using scatter plots.
%y = cos(x) + rand(1,200)
%Initialize x as a linearly spaced vector with 200 points between 0 and 3*pi

x= 0:3*pi/199:3*pi;
y = cos(x) + rand(1, 200);
scatter(x, y);
title('Scatter Plot of y =cos(x) + rand(1,200)');
xlabel('x');
ylabel('y');