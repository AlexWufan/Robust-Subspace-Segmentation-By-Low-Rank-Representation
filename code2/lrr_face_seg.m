% function [] = lrr_face_seg()
% data = loadmatfile('yaleb10.mat');
% 
% X = data.X;
% gnd = data.cids;
% K = max(gnd);

accuracy = [];
runTime = 0;
loops = 10;
% for count =1:loops
tic;


[X, gnd] = face_pick_10;
X = X/256;
gnd = gnd';
K = max(gnd');

%run lrr
Z = solve_lrr(X,0.15);

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

n = size(V,1);
M = zeros(K,K,20);
rand('state',123456789);
for i=1:size(M,3)
    inds = false(n,1);
    while sum(inds)<K
        j = ceil(rand()*n);
        inds(j) = true;
    end
    M(:,:,i) = V(inds,:);
end

runTime = runTime + toc;

idx = kmeans(V,K,'emptyaction','singleton','start',M,'display','off');
acc =  1 - missclassGroups(idx,gnd,K)/length(idx);

runTime = runTime + toc;

accuracy= [accuracy acc];
% end
runTime = runTime/loops
aveage_acc = mean(accuracy);
disp(['seg acc=' num2str(aveage_acc)]);
% disp(['accuracy std=' num2str(std(accuracy))]);
% normZ = Z - min(Z(:));
% normZ = normZ ./ max(normZ(:)); % *
% 
% imshow(normZ)