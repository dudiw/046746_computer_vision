function [R,Q] = rq(M)
    % First, we decompose Mᵀ = QᵀRᵀ
    [Q,R] = qr(flipud(M)');
    
    % Transform a lower triangular matrix Rᵀ to upper triangular matrix.
    % Flipping upside down is multiplying a permutation matrix on the left side. 
    R = flipud(R');
    R = fliplr(R);

    Q = Q';   
    Q = flipud(Q);
    
    % make the upper-triangular matrix R have possitive diagonal
    T = diag(sign(diag(R)));
    R = R * T; 
    
    % make diagonal of R positive, compensate for x and y axis pointing in
    % the opposite directions.
    Q = T * Q; 

end