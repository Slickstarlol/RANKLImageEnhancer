function EdgeDetectionKentstar(blue, green, red)

figure;

% Step 1: Input – Read the TIFF images (e.g., REDCHANNEL.tif, GREENCHANNEL.tif, BLUECHANNEL.tif)
input_image_blue = imread(blue);
input_image_green = imread(green);
input_image_red = imread(red);

% Display the original images
subplot(3, 4, 1);
imshow(input_image_blue);
title('Original Blue Channel');

subplot(3, 4, 5);
imshow(input_image_green);
title('Original Green Channel');

subplot(3, 4, 9);
imshow(input_image_red);
title('Original Red Channel');

% Step 2: Convert each image to grayscale (if necessary)
input_image_blue_gray = rgb2gray(input_image_blue);
input_image_green_gray = rgb2gray(input_image_green);
input_image_red_gray = rgb2gray(input_image_red);

% Step 3: Convert each image to double
input_image_blue_gray = double(input_image_blue_gray);
input_image_green_gray = double(input_image_green_gray);
input_image_red_gray = double(input_image_red_gray);

% Step 4: Pre-allocate the filtered_image matrix for each channel
filtered_image_blue = zeros(size(input_image_blue_gray));
filtered_image_green = zeros(size(input_image_green_gray));
filtered_image_red = zeros(size(input_image_red_gray));

% Step 5: Define Sobel Operator Masks for edge detection
Mx = [-1 0 1; -2 0 2; -1 0 1]; % Horizontal edges
My = [-1 -2 -1; 0 0 0; 1 2 1]; % Vertical edges

% Step 6: Edge Detection Process for each channel
filtered_image_blue = apply_edge_detection(input_image_blue_gray, Mx, My);
filtered_image_green = apply_edge_detection(input_image_green_gray, Mx, My);
filtered_image_red = apply_edge_detection(input_image_red_gray, Mx, My);

% Step 7: Thresholding the filtered images for each channel
thresholdValue = 100; % Adjust threshold as needed
output_image_blue = threshold_image(filtered_image_blue, thresholdValue);
output_image_green = threshold_image(filtered_image_green, thresholdValue);
output_image_red = threshold_image(filtered_image_red, thresholdValue);

% Custom-colored edge-detection images
[rows, cols] = size(output_image_blue);
teal_image = zeros(rows, cols, 3, 'uint8');
teal_image(:, :, 2) = uint8(min(output_image_blue * 1.5, 255)); % Green channel
teal_image(:, :, 3) = uint8(min(output_image_blue * 1.5, 255)); % Blue channel

green_image = zeros(rows, cols, 3, 'uint8');
green_image(:, :, 2) = uint8(min(output_image_green * 1.5, 255)); % Green channel

red_image = zeros(rows, cols, 3, 'uint8');
red_image(:, :, 1) = uint8(min(output_image_red * 1.5, 255)); % Red channel

% Step 8: Recolor edge-detected images using the original images
recolored_blue = recolor_edges(output_image_blue, input_image_blue);
recolored_green = recolor_edges(output_image_green, input_image_green);
recolored_red = recolor_edges(output_image_red, input_image_red);

% Step 9: Display results for each channel in 4 columns
% Blue Channel
subplot(3, 4, 2);
imshow(filtered_image_blue, []);
title('Filtered Blue Channel');

subplot(3, 4, 3);
imshow(teal_image, []);
title('Edge-Detected Blue (Grayscale)');

subplot(3, 4, 4);
imshow(recolored_blue);
title('Edge-Detected Blue (Recolored)');

% Green Channel
subplot(3, 4, 6);
imshow(filtered_image_green, []);
title('Filtered Green Channel');

subplot(3, 4, 7);
imshow(green_image, []);
title('Edge-Detected Green (Grayscale)');

subplot(3, 4, 8);
imshow(recolored_green);
title('Edge-Detected Green (Recolored)');

% Red Channel
subplot(3, 4, 10);
imshow(filtered_image_red, []);
title('Filtered Red Channel');

subplot(3, 4, 11);
imshow(red_image, []);
title('Edge-Detected Red (Grayscale)');

subplot(3, 4, 12);
imshow(recolored_red);
title('Edge-Detected Red (Recolored)');

end

% Helper Function: Apply Edge Detection
function filtered_image = apply_edge_detection(input_image, Mx, My)
    filtered_image = zeros(size(input_image));
    for i = 1:size(input_image, 1) - 2
        for j = 1:size(input_image, 2) - 2
            region = input_image(i:i+2, j:j+2);
            Gx = sum(sum(Mx .* region));
            Gy = sum(sum(My .* region));
            filtered_image(i+1, j+1) = sqrt(Gx^2 + Gy^2);
        end
    end
end

% Helper Function: Threshold Image
function output_image = threshold_image(input_image, thresholdValue)
    output_image = max(input_image, thresholdValue);
    output_image(output_image == thresholdValue) = 0;
    output_image = uint8(output_image);
end

% Helper Function: Recolor Edges
function recolored_image = recolor_edges(grayscale_image, original_image)
    % Normalize grayscale image to [0, 1]
    normalized_gray = double(grayscale_image) / 255;

    % Separate original RGB channels
    red_channel = double(original_image(:, :, 1)) / 255;
    green_channel = double(original_image(:, :, 2)) / 255;
    blue_channel = double(original_image(:, :, 3)) / 255;

    % Multiply normalized grayscale intensity by original RGB channels
    recolored_red = normalized_gray .* red_channel;
    recolored_green = normalized_gray .* green_channel;
    recolored_blue = normalized_gray .* blue_channel;

    % Combine back into an RGB image
    recolored_image = cat(3, recolored_red, recolored_green, recolored_blue);

    % Scale back to [0, 255] and convert to uint8
    recolored_image = uint8(recolored_image * 255);
end
