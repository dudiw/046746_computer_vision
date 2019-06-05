function [projI] = imageWarping(I,H)
%
% function function [projI] = imageWarping(I,H)
%
% Function   : imageWarping
%
% Purpose    : return projected image of I according to the affine
%              transformation matrix H
%              
% Parameters : I          - input Image.
%              H          - the transform matrix.
%
% Return     : projI   - the projected image.
%

% add black frame to the image to avoid interpulation problems
R = padarray(I(:,:,1), [1 1]); 
G = padarray(I(:,:,2), [1 1]);
B = padarray(I(:,:,3), [1 1]);

x = -1:1:(size(R,2)-2);
y = -1:1:(size(R,1)-2); 
[X, Y] = meshgrid(x, y);

numpoints = length(X(:));
P = [X(:)' ; Y(:)'; ones(1,numpoints)];
Pp = H * P; % the points projected

Xp = reshape(Pp(1,:),size(X));
Yp = reshape(Pp(2,:),size(Y));
xp = round(min(Xp(:)):1:max(Xp(:)));
yp = round(min(Yp(:)):1:max(Yp(:)));

[Xp,Yp]= meshgrid(xp,yp);

% make interpolation function to each color
Fr = scatteredInterpolant(Pp(1,:)',Pp(2,:)',R(:)); 
Fg = scatteredInterpolant(Pp(1,:)',Pp(2,:)',G(:));
Fb = scatteredInterpolant(Pp(1,:)',Pp(2,:)',B(:));

% calculate for int projected points
Fpr = Fr(Xp,Yp);
Fpg = Fg(Xp,Yp);
Fpb = Fb(Xp,Yp);

% make the projected image
projI = zeros(max(yp),max(xp));
projI(yp,xp,1) = Fpr;
projI(yp,xp,2) = Fpg;
projI(yp,xp,3) = Fpb;

end

