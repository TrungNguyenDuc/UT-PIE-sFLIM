
function [ellipse_mask] = ellipse_mask(G_t_matrix,S_t_matrix,center_x,center_y,a,b,theta,sz)
    %viscircles(center,radius)
    ellipse_mask = zeros(sz,sz);
    for i =1:sz
        for j =1:sz
            %temp = [G_t_matrix(i,j) S_t_matrix(i,j)]
            ellipse_mask(i,j) = inellipse(G_t_matrix(i,j), S_t_matrix(i,j), center_x, center_y, a, b, theta) ;
        end
    end
    figure()
    imagesc(ellipse_mask)
    axis square;
end