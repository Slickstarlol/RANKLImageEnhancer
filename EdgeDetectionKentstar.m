function EdgeDetectionKentstar(blue, green, red, blueEx, greenEx, redEx)

figure;

% Step 1: Input – Read the TIFF images (e.g., REDCHANNEL.tif, GREENCHANNEL.tif, BLUECHANNEL.tif)
input_image_blue = imread(blue);
input_image_green = imread(green);
input_image_red = imread(red);


input_image_blue_ex = imread(blueEx);
input_image_green_ex = imread(greenEx);
input_image_red_ex = imread(redEx);

% Display the original images
subplot(3, 6, 1);
imshow(input_image_blue);
title('Original Blue Channel');

subplot(3, 6, 7);
imshow(input_image_green);
title('Original Green Channel');

subplot(3, 6, 13);
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

recolored_blue_ex = recolor_edges_uniform(output_image_blue, input_image_blue_ex);
recolored_green_ex = recolor_edges_uniform(output_image_green, input_image_green_ex);
recolored_red_ex = recolor_edges_uniform(output_image_red, input_image_red_ex);



% Step 9: Display results for each channel in 4 columns
% Blue Channel
subplot(3, 6, 2);
imshow(filtered_image_blue, []);
title('Filtered Blue Channel');

subplot(3, 6, 3);
imshow(teal_image, []);
title('Edge-Detected Blue (Our Color)');

subplot(3, 6, 4);
imshow(recolored_blue);
title('Edge-Detected Blue (Recolored)');

subplot(3, 6, 5);
imshow(recolored_blue_ex);
title('Edge-Detected Blue (Expected Color)');

subplot(3, 6, 6);
imshow(input_image_blue_ex);
title('Standard Image');

% Green Channel
subplot(3, 6, 8);
imshow(filtered_image_green, []);
title('Filtered Green Channel');

subplot(3, 6, 9);
imshow(green_image, []);
title('Edge-Detected Green (Our Color)');

subplot(3, 6, 10);
imshow(recolored_green);
title('Edge-Detected Green (Recolored)');

subplot(3, 6, 11);
imshow(recolored_green_ex);
title('Edge-Detected Green (Expected Color)');


subplot(3, 6, 12);
imshow(input_image_green_ex);
title('Standard Image');

% Red Channel
subplot(3, 6, 14);
imshow(filtered_image_red, []);
title('Filtered Red Channel');

subplot(3, 6, 15);
imshow(red_image, []);
title('Edge-Detected Red (Our Color)');

subplot(3, 6, 16);
imshow(recolored_red);
title('Edge-Detected Red (Recolored)');


subplot(3, 6, 17);
imshow(recolored_red_ex);
title('Edge-Detected Red (Expected Color)');


subplot(3, 6, 18);
imshow(input_image_red_ex);
title('Standard Image');

% Combine Column 3: Edge-Detected (Our Color)
merged_3 = cat(3, red_image(:, :, 1), green_image(:, :, 2), teal_image(:, :, 3));
% Combine Column 4: Recolored
merged_4 = cat(3, recolored_red(:, :, 1), recolored_green(:, :, 2), recolored_blue(:, :, 3));
% Combine Column 5: Expected Recoloring
merged_5 = cat(3, recolored_red_ex(:, :, 1), recolored_green_ex(:, :, 2), recolored_blue_ex(:, :, 3));
% Combine Column 6: Standard
merged_6 = cat(3, input_image_red_ex(:, :, 1), input_image_green_ex(:, :, 2), input_image_blue_ex(:, :, 3));

% Create a new figure to display the combined columns
figure;
subplot(1, 4, 1);
imshow(merged_3);
title('Our Color');

subplot(1, 4, 2);
imshow(merged_4);
title('Recolored');

subplot(1, 4, 3);
imshow(merged_5);
title('Expected Color');

subplot(1, 4, 4);
imshow(merged_6);
title('Standard Image');

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

% Helper Function: Recolor Edges with Uniform Saturation
function recolored_image = recolor_edges_uniform(grayscale_image, ex_image)
    % Threshold grayscale image to create a binary mask
    binary_mask = grayscale_image > 0;

    % Separate the ex_image RGB channels
    red_channel = ex_image(:, :, 1);
    green_channel = ex_image(:, :, 2);
    blue_channel = ex_image(:, :, 3);

    % Apply the binary mask to recolor with a uniform color
    recolored_red = uint8(binary_mask) .* red_channel;
    recolored_green = uint8(binary_mask) .* green_channel;
    recolored_blue = uint8(binary_mask) .* blue_channel;

    % Combine back into an RGB image
    recolored_image = cat(3, recolored_red, recolored_green, recolored_blue);
end
