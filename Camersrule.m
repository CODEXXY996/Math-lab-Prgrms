a1 = input("Enter the value for al: ");
b1 = input("Enter the value for bi: ");
a2 - input("Enter the value for a2: ");
b2 = input("Enter the value for b2: ");
c1 = input("Enter the value for ci: ");
c2 = input("Enter the value for c2: ");
eq_mat = [a1 b1; a2 b2];
A_mat = [c1 b1; c2 b2];
B_mat - [a1 c1; a2 c2];
detA = det(A_mat);
detB = det(B_mat);
eq_det = det(eq_mat);
X- detA / eq_det;
Y= detB / eq_det;
fprintf("The value of X is %.2f\n", X);
fprintf("The value of Y is %.2f\n", Y);