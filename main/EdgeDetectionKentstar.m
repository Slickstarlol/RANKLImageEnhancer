function EdgeDetectionKentstar(blue, green, red, blueEx, greenEx, redEx)
% This function performs edge detection on three color channels (blue, green, red)
% for both observed and expected input images. The outputs include filtered,
% recolored, and edge-detected visualizations of the images.

figure;

% Step 1: Input - Read the TIFF images for observed and expected channels.
% These images represent the red, green, and blue channels of observed (actual)
% and expected (reference) datasets.
input_image_blue = imread(blue);         % Observed blue channel
input_image_green = imread(green);       % Observed green channel
input_image_red = imread(red);           % Observed red channel

input_image_blue_ex = imread(blueEx);    % Expected blue channel
input_image_green_ex = imread(greenEx);  % Expected green channel
input_image_red_ex = imread(redEx);      % Expected red channel

% Display the original observed images for each channel
subplot(3, 6, 1); imshow(input_image_blue); title('Original Blue Channel');
subplot(3, 6, 7); imshow(input_image_green); title('Original Green Channel');
subplot(3, 6, 13); imshow(input_image_red); title('Original Red Channel');

% Step 2: Average filtering to adjust saturation levels.
% Compute the scaling ratios for the observed images relative to the expected ones.
[blue_ratio, green_ratio, red_ratio] = averageratioRANKL(blueEx, greenEx, redEx, blue, green, red);

% Scale the observed images by the computed ratios to match saturation levels.
adjusted_image_blue = double(input_image_blue) / blue_ratio;
adjusted_image_green = double(input_image_green) / green_ratio;
adjusted_image_red = double(input_image_red) / red_ratio;

% Convert the adjusted images to grayscale (if not already).
input_image_blue_gray = rgb2gray(uint8(adjusted_image_blue));
input_image_green_gray = rgb2gray(uint8(adjusted_image_green));
input_image_red_gray = rgb2gray(uint8(adjusted_image_red));

% Step 3: Convert grayscale images to double for further processing.
input_image_blue_gray = double(input_image_blue_gray);
input_image_green_gray = double(input_image_green_gray);
input_image_red_gray = double(input_image_red_gray);

% Step 4: Pre-allocate memory for the filtered images.
% This initializes matrices for storing the results of edge detection.
filtered_image_blue = zeros(size(input_image_blue_gray));
filtered_image_green = zeros(size(input_image_green_gray));
filtered_image_red = zeros(size(input_image_red_gray));

% Step 5: Define Sobel operator masks for edge detection.
% These masks detect horizontal and vertical edges.
Mx = [-1 0 1; -2 0 2; -1 0 1]; % Horizontal edges
My = [-1 -2 -1; 0 0 0; 1 2 1]; % Vertical edges

% Step 6: Apply edge detection using the Sobel operator for each channel.
filtered_image_blue = apply_edge_detection(input_image_blue_gray, Mx, My);
filtered_image_green = apply_edge_detection(input_image_green_gray, Mx, My);
filtered_image_red = apply_edge_detection(input_image_red_gray, Mx, My);

% Step 7: Thresholding the filtered images to emphasize edges.
% Pixels below the threshold are set to 0, while others retain their intensity.
thresholdValue = 40; % Threshold value can be adjusted as needed.
output_image_blue = threshold_image(filtered_image_blue, thresholdValue);
output_image_green = threshold_image(filtered_image_green, thresholdValue);
output_image_red = threshold_image(filtered_image_red, thresholdValue);

% Create custom-colored visualizations for the edge-detected images.
% Adjust intensity scaling for enhanced visualization.
[rows, cols] = size(output_image_blue);
teal_image = zeros(rows, cols, 3, 'uint8'); % Teal-colored visualization
teal_image(:, :, 2) = uint8(min(output_image_blue * 1.5, 255)); % Green channel
teal_image(:, :, 3) = uint8(min(output_image_blue * 1.5, 255)); % Blue channel

green_image = zeros(rows, cols, 3, 'uint8'); % Green-colored visualization
green_image(:, :, 2) = uint8(min(output_image_green * 1.5, 255));

red_image = zeros(rows, cols, 3, 'uint8'); % Red-colored visualization
red_image(:, :, 1) = uint8(min(output_image_red * 1.5, 255));

% Step 8: Recolor edge-detected images using observed and expected images.
% Combine grayscale edges with RGB channels to create colored edge images.
recolored_blue = recolor_edges(output_image_blue, input_image_blue);
recolored_green = recolor_edges(output_image_green, input_image_green);
recolored_red = recolor_edges(output_image_red, input_image_red);

recolored_blue_ex = recolor_edges_uniform(output_image_blue, input_image_blue_ex);
recolored_green_ex = recolor_edges_uniform(output_image_green, input_image_green_ex);
recolored_red_ex = recolor_edges_uniform(output_image_red, input_image_red_ex);

% Step 9: Display results for each color channel in multiple columns.
% Columns include filtered, custom-colored, recolored, and expected images.
subplot(3, 6, 2); imshow(filtered_image_blue, []); title('Filtered Blue Channel');
subplot(3, 6, 3); imshow(teal_image, []); title('Edge-Detected Blue (Our Color)');
subplot(3, 6, 4); imshow(recolored_blue); title('Edge-Detected Blue (Recolored)');
subplot(3, 6, 5); imshow(recolored_blue_ex); title('Edge-Detected Blue (Expected Color)');
subplot(3, 6, 6); imshow(input_image_blue_ex); title('Standard Image');

subplot(3, 6, 8); imshow(filtered_image_green, []); title('Filtered Green Channel');
subplot(3, 6, 9); imshow(green_image, []); title('Edge-Detected Green (Our Color)');
subplot(3, 6, 10); imshow(recolored_green); title('Edge-Detected Green (Recolored)');
subplot(3, 6, 11); imshow(recolored_green_ex); title('Edge-Detected Green (Expected Color)');
subplot(3, 6, 12); imshow(input_image_green_ex); title('Standard Image');

subplot(3, 6, 14); imshow(filtered_image_red, []); title('Filtered Red Channel');
subplot(3, 6, 15); imshow(red_image, []); title('Edge-Detected Red (Our Color)');
subplot(3, 6, 16); imshow(recolored_red); title('Edge-Detected Red (Recolored)');
subplot(3, 6, 17); imshow(recolored_red_ex); title('Edge-Detected Red (Expected Color)');
subplot(3, 6, 18); imshow(input_image_red_ex); title('Standard Image');

% Step 10: Combine results for a summary visualization.
merged_3 = cat(3, red_image(:, :, 1), green_image(:, :, 2), teal_image(:, :, 3)); % Custom-colored edges
merged_4 = cat(3, recolored_red(:, :, 1), recolored_green(:, :, 2), recolored_blue(:, :, 3)); % Recolored edges
merged_5 = cat(3, recolored_red_ex(:, :, 1), recolored_green_ex(:, :, 2), recolored_blue_ex(:, :, 3)); % Expected edges
merged_6 = cat(3, input_image_red_ex(:, :, 1), input_image_green_ex(:, :, 2), input_image_blue_ex(:, :, 3)); % Standard image

% Display the summary results.
figure;
subplot(1, 4, 1); imshow(merged_3); title('Our Color');
subplot(1, 4, 2); imshow(merged_4); title('Recolored');
subplot(1, 4, 3); imshow(merged_5); title('Expected Color');
subplot(1, 4, 4); imshow(merged_6); title('Standard Image');
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

function [blue, green, red] = averageratioRANKL(blueexpect, greenexpect, redexpect, blueob, greenob, redob)
    % Calculates the intensity ratio between observed and expected images for
    % the blue, green, and red channels.
    
    % Process the blue channel:
    blueexpectdata = importdata(blueexpect); % Load expected blue channel
    blueexpectdata(blueexpectdata == 0) = []; % Remove zero values
    blueexpectverage = mean(blueexpectdata); % Compute mean of expected data
    
    blueobdata = importdata(blueob); % Load observed blue channel
    blueobdata(blueobdata == 0) = []; % Remove zero values
    blueobaverage = mean(blueobdata); % Compute mean of observed data
    
    blue = blueobaverage / blueexpectverage; % Compute ratio for blue channel
    
    % Process the green channel:
    greenexpectdata = importdata(greenexpect); % Load expected green channel
    greenexpectdata(greenexpectdata == 0) = []; % Remove zero values
    greenexpectverage = mean(greenexpectdata); % Compute mean of expected data
    
    greenobdata = importdata(greenob); % Load observed green channel
    greenobdata(greenobdata == 0) = []; % Remove zero values
    greenobaverage = mean(greenobdata); % Compute mean of observed data
    
    green = greenobaverage / greenexpectverage; % Compute ratio for green channel
    
    % Process the red channel:
    redexpectdata = importdata(redexpect); % Load expected red channel
    redexpectdata(redexpectdata == 0) = []; % Remove zero values
    redexpectverage = mean(redexpectdata); % Compute mean of expected data
    
    redobdata = importdata(redob); % Load observed red channel
    redobdata(redobdata == 0) = []; % Remove zero values
    redobaverage = mean(redobdata); % Compute mean of observed data
    
    red = redobaverage / redexpectverage; % Compute ratio for red channel
end
