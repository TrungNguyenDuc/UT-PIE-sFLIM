function output_matrix = matrix_peak_reshape(input_matrix,left,right)
model.left= left;             % # of data points on the left of the peak. 5 is also fine- Important
model.right= right;          % # of data points on the right of the peak

total_decay = sum(input_matrix,1);
total_decay = sum(total_decay,2);
total_decay_size = size(total_decay);
total_decay = reshape(total_decay,total_decay_size(1),total_decay_size(3));
[~,default_max_index]=max(total_decay);
input_matrix_size = size(input_matrix);
output_matrix = zeros(input_matrix_size(1),input_matrix_size(2),(model.right-model.left+1));
error = 0;
for i = 1:input_matrix_size(1)
    for j = 1:input_matrix_size(2)
        [~,max_index]=max(input_matrix(i,j,:));
          try 
          output_matrix(i,j,:) = input_matrix(i,j,(default_max_index+model.left):(default_max_index+model.right));  
          %output_matrix(i,j,:) = input_matrix(i,j,(max_index+model.left):(max_index+model.right));
          catch
          output_matrix(i,j,:) = input_matrix(i,j,(default_max_index+model.left):(default_max_index+model.right));    
          error = error+1
          end
     end
end
output_total_intensity = sum(output_matrix,3);
output_total_intensity = reshape(output_total_intensity, [input_matrix_size(1) input_matrix_size(2)]);
output_total_intensity_fig = figure();
imagesc(output_total_intensity)
axis square;
colorbar;
end