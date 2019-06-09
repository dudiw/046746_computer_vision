function [R,Q] = rq(M)
% http://ksimek.github.io/2012/08/14/decompose/?fbclid=IwAR1tFVLCA3MFwTXEEJUM_1nb_S3yErcJSCK2Ce-BGSBJ_QZDEYtJTSuVjWw
% https://www.uio.no/studier/emner/matnat/its/nedlagte-emner/UNIK4690/v17/forelesninger/lecture_5_2_pose_from_known_3d_points.pdf
% http://manao.inria.fr/perso/~ihrke/wordpress/wp-content/uploads/2015/09/perspective_and_3D_basics.pdf

    % RQ is Gram-Schmidt orthoganilization of rows of M, starting from the last column.
    %    RQ results in upper-triangular times rotation.

    % QR is Gram-Schmidt orthoganilization of columns of M, starting from the first column.
    %    RQ results in rotation times upper-triangular.
    
    % Here we use QR factorization, since standard RQ requires m<=n
    % • R is the right triangular 
    % • Q is the unitary rotation matrix
    
    % First, we decompose Mᵀ = QᵀRᵀ
    [Q,R] = qr(flipud(M)');
    
    % Transform a lower triangular matrix Rᵀ to upper triangular matrix.
    % Flipping upside down is multiplying a permutation matrix on the left side. 
    %     [ 0  0  1 ]
    % P = [ 0  1  0 ]  exchanges rows and columns
    %     [ 1  0  0 ]
    % Flipping rows is multiplying a permutation matrix on the right side. 
    R = flipud(R');
    R = fliplr(R);

    Q = Q';   
    Q = flipud(Q);
    
    % make diagonal of R positive, compensate for x and y axis pointing in
    % the opposite directions.
    T = diag(sign(diag(R)));
    R = R * T; 
    
    Q = T * Q; 

end