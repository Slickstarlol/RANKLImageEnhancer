clc; clear all;
% Import TIFF files
B = importdata("BLUECHANNEL.tif");
R = importdata("REDCHANNEL.tif");
G = importdata("GREENCHANNEL.tif");
% Ensure all images have the same dimensions
[rowsB, colsB] = size(B);
[rowsG, colsG] = size(G);
[rowsR, colsR] = size(R);
if rowsB ~= rowsG || colsB ~= colsG || rowsB ~= rowsR || colsB ~= colsR
    error('All TIFF files must have the same dimensions.');
end
% Normalize the images for display (optional)
B_display = mat2gray(B);
G_display = mat2gray(G);
R_display = mat2gray(R);
% Create a new figure for the overlay
figure;
% Display the blue channel
ax1 = axes; % Create axes for the blue channel
image(ax1, B_display, 'CDataMapping', 'scaled'); % Display blue channel
colormap(ax1, [0 0 1]); % Custom blue colormap
axis image;
hold on;
% Overlay the green channel with transparency
ax2 = axes; % Create a second axes for the green channel
image(ax2, G_display, 'CDataMapping', 'scaled', 'AlphaData', 0.25); % Add transparency to green
colormap(ax2, [0 1 0]); % Custom green colormap
axis image;
set(ax2, 'Visible', 'off'); % Hide second axes outline
% Overlay the red channel with transparency
ax3 = axes; % Create a third axes for the red channel
image(ax3, R_display, 'CDataMapping', 'scaled', 'AlphaData', 0.25); % Add transparency to red
colormap(ax3, [1 0 0]); % Custom red colormap
axis image;
set(ax3, 'Visible', 'off'); % Hide third axes outline
% Finalize the plot
title('Overlay of Blue, Green, and Red Channels with Transparency');