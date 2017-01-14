function [X, s] = toy_data_gen(num_subspace, dim_subspace, num_points_each_subspace, dim, corruption)

% num_subspace = 5
% dim_subspace = 4
% num_points_each_subspace = 20
% dim = 200
% corruption = 0.2

% initializing subspace
U1 = rand(dim, dim_subspace);
U1 = orth(U1);

% generating rotation matrix, note orthogonolize directly on cols of a
% random matrix result in a right-hand system, thus a permutation on the
% cols is performed
T = orth(rand(dim));
% det(T)
T = fliplr(T);

% generating all other subspaces
U = zeros(dim, dim_subspace, num_subspace);
U(:, :, 1) = U1;
for i = 2:num_subspace
    U(:, :, i) = T*U(:, :, i-1);
end


% sampling from subspaces
X = zeros(dim, num_points_each_subspace, num_subspace);
for i = 1:num_subspace
    X(:, :, i) = U(:, :, i)*rand(dim_subspace, num_points_each_subspace);
end
X  = reshape(X, [dim num_points_each_subspace*num_subspace]);


% generating truth
s = 1:num_subspace;
s = repmat(s, [num_points_each_subspace 1]);
s = s(:);

% generating corruption, 0 is clean data,
if corruption ~= 0
    a = randperm(size(X,2));
    b = a(1:size(X,2)*corruption);
    
    for i = 1:length(b)
        j = b(i);
        X(:,j) = X(:,j) + sqrt(0.1*norm(X(:,j)))*randn(dim, 1);
    end
   
end

% generating error, USE this part to generating contaminated data for
% ROBUTNESS performance.
% if error == true
%     a = randperm(size(X(:)));
%     b = a(1:40);
%     c = a(40:400);
%     
%     for  i = 1:length(b)
%         j = b(i);
%         X(:,j) = X(:,j) + 3.5*diag(X(:,j)*randsrc(2000,1,[-1,1])');
%     end
%     for  i = 1:length(c)
%         j = c(i);
%         X(:,j) = X(:,j) + 0.3*diag(X(:,j)*(randsrc(2000,1,[-1,1])'));
%     end
%     error_s = mean(X(:));
%     Y = sqrt(abs(3*error_s))*randn(size(X,1),100);
%     X = [X Y];
% end
save('toy_data', 'X', 's')