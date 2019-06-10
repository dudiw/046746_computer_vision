function [] = HW3Q1()

% HW3.Q1: Optical flow

%% Task A

url = fullfile('seq.gif');

[images, ~] = imread(url, 'Frames', 'all');
[Width, Height, ~, count] = size(images);

N = [16   8];
T = [ 1 0.1];

for n = N
    for t = T
        previous = zeros(Width, Height);

        h = figure();
        axis tight manual
        filename = ['optical_flow_N_' num2str(n) '_t_' num2str(t) '.gif'];
        for k=1:count
            current = images(:,:,:, k);
            if k == 1
                previous = current;
                continue;
            end
            [ X,Y,U,V ] = estimateFlowLK(previous, current, n, t);

            previous = current;

            imshow(current);
            hold on;
            quiver(Y,X,U,V,'r');
            title(['Optical Flow:','Locus Kanade']);
            xlabel(['Frame ', num2str(k),' N = ', num2str(n), ', t = ', num2str(t)]);

            % Capture the plot as an image and write to GIF file
            drawnow 
              frame = getframe(h); 
              im = frame2im(frame); 
              [imind,cm] = rgb2ind(im,256); 
              if k == 2 
                  imwrite(imind,cm,filename,'gif', 'Loopcount',inf); 
              else 
                  imwrite(imind,cm,filename,'gif','WriteMode','append'); 
              end 
        end
    end
end        