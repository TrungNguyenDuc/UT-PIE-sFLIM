function [cluster_prob,cluster_intensity]= GMM_unmixing_spectra(G_t,S_t,total_intensity,cluster_number,medfilt_size,ntimes,ITrel,path,color)


%% path
addpath('./flimtools');
phsiz=256;
fov=[0 1;0 .6];
% eb is size of medfilt2 matrix (3 in simFCS, 5 for Xtreme)
% ti is number of times it is to be applied
% ga is a flag in order to do median(0), mean(1) or gaussian(2) filtering.
%    defaulted to 0
%medfilt_size=5;
%ntimes=3;
remove=floor(medfilt_size/2)*(ntimes);

%phsiz2 phasor size
phsiz2=round([fov(2,2)-fov(2,1) fov(1,2)-fov(1,1)]*phsiz);


ITabs = 0;


%Inthre,0,[.1 .4 .5 .4 .3 .4]

%% phasor plots

ensenya('Phasor Plots.'); % print the title of each phasor

aux2=total_intensity; % this is the intensity image
Ithresh=max([ceil(quantile(aux2(:),.99)*ITrel),ITabs]); % calculate the intensity threshold
%Ithresh=ceil(quantile(aux2(:),ITrel));

aux=S_t; %S
aux1=G_t;%G
[aux,aux1] = phasorFilterIntensity(aux,aux1,aux2,Ithresh); % find the
% mask location with intensity threshold => similar to my method
% set the loaction with the intensity < threshold = NaN
% remove edges and NaNs - median filter need it
aux=aux(remove+1:end-remove,remove+1:end-remove,:);
% change the size of the image before apply the median filter
aux1=aux1(remove+1:end-remove,remove+1:end-remove,:);
draw_spectra_phasor_points(aux1,aux);
% PP will output an image with the phasor counts
%        function [I,tk1,tk2,remapping,extra] = phasorPlot2(S,G,sz,ex,fov,nor,txt,sty,cma)
%
% [I,tk1,tk2] = phasorPlot(G,S,sz,ex,fov,nor,txt)
% Plots phasor given S and G arrays.
%   phasorPlot(G,S); will plot the phasor plot.
%   I=phasorPlot(G,S); will output an image with the phasor counts.
%       sz is a 1x2 vector specifying output image size (and therefore binning in phasor space).
%       ex determines wether output should include axis and circle lines:
%          0 for nothing, 1 for flim phasor lines, 2 for spectral phasor lines,
%          11 for flim phasor lines and edges, 22 for spectral phasor lines and edges.
%          20 for only edges
%       fov is a 2x2 matrix of field of view: [minG maxG;minS maxS].
%       nor is used if the phasor plot is composition of several images:
%           set to 1 if there are NaNs in the data it will give more weight to images that
%           have less points so that the contribution of each pair of S and G is equal
%           set to 2 to normalise to the peak in the phasor plot instead of the counts (defaulted to 0).
%       txt flag indicates if text should be shown in axis (defaulted to 1).
%       sty flag for phasor style (0 for histogram, >0 for contour with the value determining the smoothing)
%       cma is the colormap for when sty==1 and there is no output

%% gmm clustering



poi=cell(1,1);
idx=poi;pro=poi;gmf=poi;
ensenya('Clustering');

aux2=total_intensity; % this is the intensity image

aux=S_t; %S
aux1=G_t;%G

Ithresh=ceil(quantile(aux2(:),ITrel));

[aux,aux1] = phasorFilterIntensity(aux,aux1,aux2,Ithresh);
% remove edges and NaNs what is this
S=aux(remove+1:end-remove,remove+1:end-remove,:);
G=aux1(remove+1:end-remove,remove+1:end-remove,:);
% important
indsout=find((S==0)&(G==0));
S(indsout)=NaN;G(indsout)=NaN;
%linear indexing of 2D array (S)
indsIm=find(~isnan(S));
%GMM
alldat=[G(indsIm) S(indsIm)];
options = statset('MaxIter',1000);
gmfit = fitgmdist(alldat,cluster_number,'CovarianceType','full','SharedCovariance',false,'Options',options);
% get alll data again without threshold
aux=S_t; %S
aux1=G_t;%G
S=aux(remove+1:end-remove,remove+1:end-remove,:);
G=aux1(remove+1:end-remove,remove+1:end-remove,:);
indsout=find((S==0)&(G==0));
S(indsout)=NaN;G(indsout)=NaN;
indsIm=find(~isnan(S));
alldat=[G(indsIm) S(indsIm)];
%classify using gmm
IDX = cluster(gmfit,alldat);
probs = posterior(gmfit,alldat);

%important
%         % sort IDX so that indexes go with increasing lifetime
% phas=zeros(clusts(ii),1);%
% for ll=1:clusts(ii)%using pseudophase
%     phas(ll)=atan2(mean(alldat(IDX==ll,1)),mean(alldat(IDX==ll,2))-.5);
% end
% [~,ord]=sort(phas);
% IDX2=IDX;probs2=probs;
% for ll=1:clusts(ii)
%     IDX(find(IDX2==ord(ll)))=ll;
%     probs(:,ll)=probs2(:,ord(ll));
% end
% clear IDX2;clear probs2;
% 
% poi{ii}=alldat; % phasor plot without threshold
% idx{ii}=IDX; % index of cluster for each pixel
% pro{ii}=probs; %probability
% ind{ii}=indsIm; % index of point after threshold
% gmf{ii}=gmfit; %gm fit distribution results
G_a = reshape(G(indsIm),1,[]);
S_a = reshape(S(indsIm),1,[]);
%draw_phasor_points(aux1,aux,gate,n_time_bin);
draw_spectra_phasor_points(G_a,S_a);
%draw_phasor_points(aux1,aux,gate,n_time_bin);
hold on
gmPDF = @(x,y) arrayfun(@(x0,y0) pdf(gmfit,[x0,y0]),x,y);
fc = fcontour(gmPDF,[-1 1],'-r',LineWidth=0.1,LevelList=[0:3:100])
plot(gmfit.mu(:,1),gmfit.mu(:,2),'kx','MarkerSize',5,'LineWidth', 2,'DisplayName','Mean')
title('Spectral Phasor Plot and Fitted GMM Contour')
hold off


%% sort 
          
%         % sort IDX so that indexes go with increasing lifetime
phas=zeros(cluster_number,1);%
for lxl=1:cluster_number%using pseudophase
    phas(lxl)=atan2(mean(alldat(IDX==lxl,2)),mean(alldat(IDX==lxl,1))-.5);
end
[~,ord]=sort(phas);
IDX2=IDX;probs2=probs;
for lxl=1:cluster_number
    IDX(find(IDX2==ord(lxl)))=lxl;
    probs(:,lxl)=probs2(:,ord(lxl));
end
clear IDX2;clear probs2;

%% Visualize the group

G_a = reshape(G(indsIm) ,1,[]);
S_a = reshape(S(indsIm),1,[]);
draw_spectra_phasor_points(G_a,S_a);
hold on
gscatter(G_a,S_a,IDX)
plot(gmfit.mu(:,1),gmfit.mu(:,2),'kx','MarkerSize',5,'LineWidth', 2,'DisplayName','Mean')
title('Spectral Phasor Plot color-coded with cluster index')
%legend('Cluster 1','Cluster 2','Location','best')
 %%
mkdir(fullfile(path,color));
file_temp = fullfile(path,color,color);
file_temp = strcat(file_temp,'_');

new_size = size(S);
ind_reshape = reshape(IDX, [new_size(1) new_size(2)]);
figure();
imagesc(ind_reshape);
title("Intensity image color-coded with cluster index")
colorbar
axis square

intensity_for_cluster_unmixing =total_intensity(remove+1:end-remove,remove+1:end-remove,:);
cluster_prob=cell(cluster_number,1);
cluster_intensity=cell(cluster_number,1);
for i = 1:cluster_number
cluster_prob{i} = reshape(probs(:,i),[new_size(1) new_size(2)]);

% figure()
% imagesc(cluster_prob{i});
% axis square

figure()
cluster_intensity{i} = cluster_prob{i}.*intensity_for_cluster_unmixing;
imagesc(cluster_intensity{i})
title_str = strcat ('Unmixed intensity image for cluster-', int2str(i));
title(title_str);
colorbar
axis square

intensity_cluster_masked_tifffile = strcat(file_temp,'cluster_',int2str(i),'.tif');
imwrite(uint16(cluster_intensity{i}),intensity_cluster_masked_tifffile);



end
end
% figure()
% fsurf(gmPDF,[0 1],LevelList=[0:10:200])




