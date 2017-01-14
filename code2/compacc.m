function [acc] = compacc(idx,gnd)
%inputs:
%      idx -- the clustering results
%      gnd -- the groudtruth clustering results
%outputs:
%      acc -- segmentation accuracy (or classification accuracy)
if size(idx,2)>1
    idx = idx';
end
if size(gnd,2)>1
    gnd = gnd';
end

uids = unique(idx);
nbc = length(uids);
n = length(idx);
%% generate the cost matrix
C = zeros(nbc);
for i=1:nbc
    uid = uids(i);
    inds = abs(idx-uid)<0.1;
    for j=1:nbc
        ypred = zeros(n,1);
        ypred(inds) = j;
        C(i,j) = 1 - sum(abs(gnd-ypred)<0.1)/n;
    end
end
%% run the Hugarian algorithm
M = Hungarian(C);
ypred = zeros(n,1);
for i=1:nbc
    inds = abs(idx-i)<0.1;
    ypred(inds) = find(M(i,:));
end
acc = sum(abs(ypred-gnd)<0.1)/n;