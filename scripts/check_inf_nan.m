function A=check_inf_nan(A)

A(isnan(A))=0;
A(isinf(A))=0;

end