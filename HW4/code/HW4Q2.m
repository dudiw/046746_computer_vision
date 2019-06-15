function [] = HW4Q2()

% load train set (1.a)
cd(fullfile('eigenFaces'));
readYaleFaces;
cd(fullfile('..'));

C = 15;

fisherface(A, train_face_id, C);

end