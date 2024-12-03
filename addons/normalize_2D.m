function norm_matrix = normalize_2D(matrix)
norm_matrix = (matrix - min(matrix(:)))/(max(matrix(:)) - min(matrix(:)));
end