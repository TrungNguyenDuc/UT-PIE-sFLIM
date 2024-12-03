function [GS_good, xyz_good] = fun_calcPhasors(handles)
%FUN_CALCPHASORHIST Summary of this function goes here
%   This function is used to calculate phasors
%
%   Author: Yide Zhang
%   Email: yzhang34@nd.edu
%   Date: April 12, 2019
%   Copyright: University of Notre Dame, 2019

if isfield(handles, 'imageG') && isfield(handles, 'imageS') && isfield(handles, 'imageI')
    G_stack = handles.imageG;
    S_stack = handles.imageS;
    I_stack = handles.imageI;
    [n_x, n_y, n_z] = size(I_stack);
    if isequal(size(G_stack),size(S_stack)) && isequal(size(G_stack),size(I_stack))
        
Imin = min(I_stack(:));
Imax = max(I_stack(:));      
Smin = min(S_stack(:));
Smax = max(S_stack(:)); 
Gmin = min(G_stack(:));
Gmax = max(G_stack(:));        
        % use a matrix to store phasor information for the whole volume/frame
        n_good = numel(find(((I_stack < Imax) & (I_stack > Imin)) &...
                    ((G_stack < Gmax) & (G_stack > Gmin)) & ...
                    ((S_stack < Smax) & (S_stack > Smin))));
        G_good = zeros(n_good,1);
        S_good = zeros(n_good,1);
        x_good = zeros(n_good,1);
        y_good = zeros(n_good,1);
        z_good = zeros(n_good,1);
        
        i_good = 1;
        hwb_progress = waitbar(0, 'Calculating phasors ...');
        for i_z = 1:n_z            
            waitbar(i_z/n_z, hwb_progress);
            for i_x = 1:n_x
                for i_y = 1:n_y
                    iG = G_stack(i_x, i_y, i_z);
                    iS = S_stack(i_x, i_y, i_z);
                    iI = I_stack(i_x, i_y, i_z);
                    if iI <= Imax && iI >= Imin &&...
                            iG <= Gmax && iG >= Gmin &&...
                            iS <= Smax && iS >= Smin
                        
                        % reserve data for K-means clustering
                        G_good(i_good) = iG;
                        S_good(i_good) = iS;
                        x_good(i_good) = i_x;
                        y_good(i_good) = i_y;
                        z_good(i_good) = i_z;
                        i_good = i_good + 1;
                    end
                end
            end
            
        end
       
        GS_good = [G_good, S_good];
        xyz_good = [x_good, y_good, z_good];
        
        close(hwb_progress);

    end
end

