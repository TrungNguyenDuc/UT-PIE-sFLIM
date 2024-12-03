
function [circle_mask] = circle_mask_intensity(center,radius,sz)
    %viscircles(center,radius)
    circle_mask = zeros(sz,sz);
    for i =1:sz
        for j =1:sz
            %temp = [G_t_matrix(i,j) S_t_matrix(i,j)]
        distance = norm([i j] - center);
        if distance<radius
            circle_mask(j,i) =1;
        end
        end
    end
    figure()
    imagesc(circle_mask)
    axis square;
end