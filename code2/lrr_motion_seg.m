% function [] = lrr_motion_seg()
datadir = './data/Hopkins155/';
seqs = dir(datadir);
seq3 = seqs(4:end);
%% load the data
data = struct('X',{},'name',{},'ids',{});
for i=1:length(seq3)
    fname = seq3(i).name;
    fdir = [datadir '/' fname];
    if isdir(fdir)
        datai = load([fdir '/' fname '_truth.mat']);
        id = length(data)+1;
        data(id).ids = datai.s;
        data(id).name = lower(fname);
        X = reshape(permute(datai.x(1:2,:,:),[1 3 2]),2*datai.frames,datai.points);
        data(id).X = [X;ones(1,size(X,2))];
    end
end
clear seq3;
%% segmentation 
tic;
errs = zeros(length(data),1);
lambda = 4;
for i=1:length(data)
    
    X = data(i).X;
    gnd = data(i).ids; K = max(gnd);
    if abs(K-2)>0.1 && abs(K-3)>0.1
        id = i; % the discarded sequqnce
    end
    %run lrr
    Z = solve_lrr(X,lambda);
    %post processing
    [U,S,V] = svd(Z,'econ'); 
    S = diag(S);
    r = sum(S>1e-4*S(1));
    U = U(:,1:r);S = S(1:r);
    U = U*diag(sqrt(S));
    U = normr(U);
    L = (U*U').^4;
    % spectral clustering
    D = diag(1./sqrt(sum(L,2)));
    L = D*L*D;
    [U,S,V] = svd(L);
    V = U(:,1:K);
    V = D*V;
    idx = kmeans(V,K,'emptyaction','singleton','replicates',20,'display','off');
    err0 =  missclassGroups(idx,gnd,K)/length(idx);
    % err0 = 1 - compacc(idx,gnd);
    disp(['seq ' num2str(i) ',err=' num2str(err0)]);
    errs(i) = err0;
    
%     normZ = Z - min(Z(:));
%     normZ = normZ ./ max(normZ(:)); % *
%     figure, imshow(normZ)
end

toc;

disp('results of all 156 sequences:');
disp(['max = ' num2str(max(errs)) ',min=' num2str(min(errs)) ...
    ',median=' num2str(median(errs)) ',mean=' num2str(mean(errs)) ',std=' num2str(std(errs))] );

errs = errs([1:id-1,id+1:end]);
disp('results of all 155 sequences:');
disp(['max = ' num2str(max(errs)) ',min=' num2str(min(errs)) ...
    ',median=' num2str(median(errs)) ',mean=' num2str(mean(errs)) ',std=' num2str(std(errs))] );


