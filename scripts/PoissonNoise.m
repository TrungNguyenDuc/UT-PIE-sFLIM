function b=PoissonNoise(a)


sizeA = size(a); 
% Matrix in MxN 
a = a(:);
b=zeros(size(a));
idx1=find(a<50);
% Matrix Positions whose pixels intensities are less than 50
t=ones(size(idx1));
% Matrix having all ones, the size is equal to idx size
em=-ones(size(idx1));
%Matrix having all -ones, the size is equal to idx size
idx2= (1:length(idx1))';
% Put values in idx2 equal to length of idx1
if (~isempty(idx1)) 
    % if such pixels exists then
    g=exp(-a(idx1)); 
    % take Exponential of the values at those pixelpositions
    while ~isempty(idx2)
        em(idx2)=em(idx2)+1;
        t(idx2)=t(idx2).*rand(size(idx2));
        idx2 = idx2(t(idx2) > g(idx2));
    end
    b(idx1)=em;
end
idx1=find(a>=50);
% Cases where pixel intensities are more than 49 units
if (~isempty(idx1))
    b(idx1)=round(a(idx1)+sqrt(a(idx1)).*randn(size(idx1)));
end
b = reshape(b,sizeA);


end