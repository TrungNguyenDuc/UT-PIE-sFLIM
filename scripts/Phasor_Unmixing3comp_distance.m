
function [f1,f2,f3]=Phasor_Unmixing3comp_distance(Y,A1,A2,A3)

M = [real(A1) real(A2) real(A3); imag(A1) imag(A2) imag(A3); 1 1 1];
N = cat(1, real(Y), imag(Y), ones(1,size(Y,2)));

f = M\N;
f1 = f(1,:);
f2 = f(2,:);
f3 = f(3,:);
end