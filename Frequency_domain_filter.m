% Read the input image
image = imread("D:\pictures\gray2.jpg");

% Convert the image to grayscale if it's not already
if size(image, 3) == 3
    image = rgb2gray(image);
end

% Convert the image to double precision for processing
image = double(image);

% Get the size of the image
[rows, cols] = size(image);

% Step 1: Create the center multiplier
% Define frequency coordinates
u = (0:rows-1) - floor(rows/2);
v = (0:cols-1) - floor(cols/2);
[U, V] = meshgrid(u, v);

% Create the center multiplier (-1)^(x+y)
centerMultiplier = (-1).^(U + V);

% Step 2: Center the image in the frequency domain
% Apply the center multiplier to the image
image_centered = image .* centerMultiplier;

% Compute the DFT of the centered image
F_centered = fft2(image_centered);

% Step 3: Create and apply the high-pass filter in the frequency domain
% Define the high-pass filter (for simplicity, using an ideal high-pass filter)
filterRadius = 30; % Radius of the high-pass filter
D = sqrt(U.^2 + V.^2); % Distance from the center
H = double(D > filterRadius); % Ideal high-pass filter

% Ensure filter H matches the size of F_centered
assert(all(size(H) == size(F_centered)), 'Filter and image DFT dimensions do not match.');

% Multiply the centered DFT by the high-pass filter
G_centered = F_centered .* H;

% Step 4: Compute the inverse DFT
G = ifftshift(G_centered); % Shift back to original frequency domain
filteredImage_centered = ifft2(G); % Inverse DFT to get the image

% Step 5: Obtain the real part of the inverse DFT
filteredImage_centered = real(filteredImage_centered);

% Step 6: Apply the center multiplier again to the filtered image
filteredImage = filteredImage_centered .* centerMultiplier;

% Convert the filtered image back to uint8
filteredImage = uint8(abs(filteredImage));

% Display the original and filtered images
figure;
subplot(1, 2, 1);
imshow(uint8(image));
title('Original Image');

subplot(1, 2, 2);
imshow(filteredImage);
title('Filtered Image');
