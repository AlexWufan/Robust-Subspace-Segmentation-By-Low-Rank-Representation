function [X, gnd] = face_pick_10

load YaleBCrop025.mat
ind = randperm(38);
ind = ind(1:10);
X = Y(:, :, ind);
X = reshape(X, [size(Y, 1), 640]);
gnd = 1:10;
gnd =repmat(gnd, [64 1]);
gnd = gnd(:);