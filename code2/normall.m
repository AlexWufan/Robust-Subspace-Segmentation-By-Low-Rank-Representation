function X1 = normall(X)

X1 = (X - min(X(:)))/(max(X(:))-min(X(:)));