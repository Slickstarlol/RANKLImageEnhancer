
function EdgeDetectionKentstar(blue, green, red)



figure;

% Step 1: Input – Read the TIFF images (e.g., REDCHANNEL.tif, GREENCHANNEL.tif, BLUECHANNEL.tif)
input_image_blue = importdata(blue);
input_image_green = importdata(green);
input_image_red = importdata(red);

% Subplot 1: Original Blue Channel
subplot(3, 3, 1);
imshow(input_image_blue, []);
title('Original Blue Channel');

% Subplot 4: Original Green Channel
subplot(3, 3, 4);
imshow(input_image_green, []);
title('Original Green Channel');

% Subplot 7: Original Red Channel
subplot(3, 3, 7);
imshow(input_image_red, []);
title('Original Red Channel');

% Step 2: Convert each image to grayscale (if necessary)
input_image_blue = rgb2gray(input_image_blue);
input_image_green = rgb2gray(input_image_green);
input_image_red = rgb2gray(input_image_red);

% Step 3: Convert each image to double
input_image_blue = double(input_image_blue);
input_image_green = double(input_image_green);
input_image_red = double(input_image_red);

% Step 4: Pre-allocate the filtered_image matrix for each channel
filtered_image_blue = zeros(size(input_image_blue));
filtered_image_green = zeros(size(input_image_green));
filtered_image_red = zeros(size(input_image_red));

% Step 5: Define Sobel Operator Masks for edge detection
Mx = [-1 0 1; -2 0 2; -1 0 1]; % Horizontal edges
My = [-1 -2 -1; 0 0 0; 1 2 1]; % Vertical edges

% Step 6: Edge Detection Process for each channel
% For blue channel
for i = 1:size(input_image_blue, 1) - 2
    for j = 1:size(input_image_blue, 2) - 2
        region = input_image_blue(i:i+2, j:j+2);
        Gx = sum(sum(Mx .* region));
        Gy = sum(sum(My .* region));
        filtered_image_blue(i+1, j+1) = sqrt(Gx^2 + Gy^2);
    end
end

% For green channel
for i = 1:size(input_image_green, 1) - 2
    for j = 1:size(input_image_green, 2) - 2
        region = input_image_green(i:i+2, j:j+2);
        Gx = sum(sum(Mx .* region));
        Gy = sum(sum(My .* region));
        filtered_image_green(i+1, j+1) = sqrt(Gx^2 + Gy^2);
    end
end

% For red channel
for i = 1:size(input_image_red, 1) - 2
    for j = 1:size(input_image_red, 2) - 2
        region = input_image_red(i:i+2, j:j+2);
        Gx = sum(sum(Mx .* region));
        Gy = sum(sum(My .* region));
        filtered_image_red(i+1, j+1) = sqrt(Gx^2 + Gy^2);
    end
end

% Step 7: Display the filtered images (Gradient Magnitude)
filtered_image_blue = uint8(filtered_image_blue);
filtered_image_green = uint8(filtered_image_green);
filtered_image_red = uint8(filtered_image_red);

% Step 8: Thresholding the filtered image for each channel
thresholdValue = 100; % Adjust threshold as needed
output_image_blue = max(filtered_image_blue, thresholdValue);
output_image_blue(output_image_blue == round(thresholdValue)) = 0;

output_image_green = max(filtered_image_green, thresholdValue);
output_image_green(output_image_green == round(thresholdValue)) = 0;

output_image_red = max(filtered_image_red, thresholdValue);
output_image_red(output_image_red == round(thresholdValue)) = 0;

% Step 9: Create RGB images for each channel (Teal, Green, Red)

% Normalize the output images to [0, 255] if necessary
output_image_blue = uint8(output_image_blue);
output_image_green = uint8(output_image_green);
output_image_red = uint8(output_image_red);

% Combine the channels into an RGB image using the original channels for color
[rows, cols] = size(output_image_blue);
reverted_rgb_image = zeros(rows, cols, 3); % Initialize the RGB image

% Assign each channel's intensity to its respective color
reverted_rgb_image(:, :, 1) = output_image_red;   % Red channel
reverted_rgb_image(:, :, 2) = output_image_green; % Green channel
reverted_rgb_image(:, :, 3) = output_image_blue;  % Blue channel

% Step 10: Create a figure with 9 subplots (3 rows x 3 columns)

% Subplot 2: Filtered Blue Channel
subplot(3, 3, 2);
imshow(filtered_image_blue, []);
title('Filtered Blue Channel');

% Subplot 3: Edge-Detected Blue Channel (Teal)
teal_image = zeros(rows, cols, 3, 'uint8'); % Create teal-colored RGB image
teal_image(:, :, 2) = uint8(min(output_image_blue * 1.5, 255)); % Green channel
teal_image(:, :, 3) = uint8(min(output_image_blue * 1.5, 255)); % Blue channel
subplot(3, 3, 3);
imshow(teal_image);
title('Edge-Detected Blue Channel');

% Subplot 5: Filtered Green Channel
subplot(3, 3, 5);
imshow(filtered_image_green, []);
title('Filtered Green Channel');

% Subplot 6: Edge-Detected Green Channel
green_image = zeros(rows, cols, 3, 'uint8'); % Create green-colored RGB image
green_image(:, :, 2) = uint8(min(output_image_green * 1.5, 255)); % Green channel
subplot(3, 3, 6);
imshow(green_image);
title('Edge-Detected Green Channel');

% Subplot 8: Filtered Red Channel
subplot(3, 3, 8);
imshow(filtered_image_red, []);
title('Filtered Red Channel');

% Subplot 9: Edge-Detected Red Channel
red_image = zeros(rows, cols, 3, 'uint8'); % Create red-colored RGB image
red_image(:, :, 1) = uint8(min(output_image_red * 1.5, 255)); % Red channel
subplot(3, 3, 9);
imshow(red_image);
title('Edge-Detected Red Channel');

figure;
% Display the reverted RGB image
imshow(uint8(reverted_rgb_image));
title('Reverted RGB Image');
end
