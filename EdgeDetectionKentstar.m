function EdgeDetectionKentstar(blue, green, red)

figure;

% Step 1: Input – Read the TIFF images (e.g., REDCHANNEL.tif, GREENCHANNEL.tif, BLUECHANNEL.tif)
input_image_blue = importdata(blue);
input_image_green = importdata(green);
input_image_red = importdata(red);

% Display the original images
subplot(3, 4, 1);
imshow(input_image_blue, []);
title('Original Blue Channel');

subplot(3, 4, 5);
imshow(input_image_green, []);
title('Original Green Channel');

subplot(3, 4, 9);
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

% Colored edge-detection images
[rows, cols] = size(output_image_blue);
teal_image = zeros(rows, cols, 3, 'uint8');
teal_image(:, :, 2) = uint8(min(output_image_blue * 1.5, 255)); % Green channel
teal_image(:, :, 3) = uint8(min(output_image_blue * 1.5, 255)); % Blue channel

green_image = zeros(rows, cols, 3, 'uint8');
green_image(:, :, 2) = uint8(min(output_image_green * 1.5, 255)); % Green channel

red_image = zeros(rows, cols, 3, 'uint8');
red_image(:, :, 1) = uint8(min(output_image_red * 1.5, 255)); % Red channel

% Display results for each channel in 4 columns
% Subplot 2: Filtered Blue Channel
subplot(3, 4, 2);
imshow(filtered_image_blue, []);
title('Filtered Blue Channel');

% Subplot 3: Edge-Detected Blue Channel (Grayscale)
subplot(3, 4, 3);
imshow(output_image_blue, []);
title('Edge-Detected Blue (Gray)');

% Subplot 4: Edge-Detected Blue Channel (Colored)
subplot(3, 4, 4);
imshow(teal_image);
title('Edge-Detected Blue (Teal)');

% Subplot 5: Filtered Green Channel
subplot(3, 4, 6);
imshow(filtered_image_green, []);
title('Filtered Green Channel');

% Subplot 7: Edge-Detected Green Channel (Grayscale)
subplot(3, 4, 7);
imshow(output_image_green, []);
title('Edge-Detected Green (Gray)');

% Subplot 8: Edge-Detected Green Channel (Colored)
subplot(3, 4, 8);
imshow(green_image);
title('Edge-Detected Green (Colored)');

% Subplot 9: Filtered Red Channel
subplot(3, 4, 10);
imshow(filtered_image_red, []);
title('Filtered Red Channel');

% Subplot 10: Edge-Detected Red Channel (Grayscale)
subplot(3, 4, 11);
imshow(output_image_red, []);
title('Edge-Detected Red (Gray)');

% Subplot 11: Edge-Detected Red Channel (Colored)
subplot(3, 4, 12);
imshow(red_image);
title('Edge-Detected Red (Colored)');

figure;
% Display the reverted RGB image
imshow(uint8(reverted_rgb_image));
title('Reverted RGB Image');

end
