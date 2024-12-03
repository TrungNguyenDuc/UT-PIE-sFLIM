function SF = SpectralFLIM_SimulateCarpet_2comp(Lambda_center,Lambda_std,Tau,Tau_Vect,Spectral_Vect,Weight)

if nargin<6
    Weight = 1;
end
if nargin<5
Spectral_Vect = linspace(405,670,32);
Tau_Vect      = linspace(0,12.5,32);
end

Lambda_Gauss = Gaussian(Spectral_Vect,Lambda_std,Lambda_center,1);
for i = 1:length(Spectral_Vect)
    
    if i==1
        SF = Lambda_Gauss(i)/2*exp(-Tau_Vect/Tau(1))';
        SF = SF + Weight*Lambda_Gauss(i)/2*exp(-Tau_Vect/Tau(2))';
    else
        SF(:,i) = Lambda_Gauss(i)/2*exp(-Tau_Vect/Tau(1))';
        SF(:,i) = SF(:,i)+Weight*Lambda_Gauss(i)/2*exp(-Tau_Vect/Tau(2))';
    end
    
end
end
