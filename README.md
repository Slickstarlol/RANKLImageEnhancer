
# EdgeDetectionKentstar: Edge Detection on Multichannel Images

This MATLAB script, `EdgeDetectionKentstar`, is designed to perform edge detection on observed and expected datasets represented as multichannel images (red, green, and blue channels). It outputs filtered, recolored, and edge-detected visualizations for both observed and expected images.

---

## Features
- **Edge Detection**: Applies the Sobel operator to identify edges in grayscale images for each color channel.
- **Saturation Adjustment**: Adjusts observed images to match the saturation levels of expected datasets using computed ratios.
- **Custom Visualizations**: Generates recolored edge-detected images in user-defined color schemes.
- **Comparison Framework**: Provides side-by-side visual comparisons of observed and expected edge-detected results.

---

## Input and Output

### Inputs
- **Observed Channels**: File paths for blue, green, and red channels of the observed image.
- **Expected Channels**: File paths for blue, green, and red channels of the expected image.

### Outputs
- **Visualizations**: 
  - Original observed and expected images.
  - Filtered edge-detected images for each channel.
  - Recolored edge-detected images using observed and expected datasets.
  - Summary comparison images combining all results.

---

## Usage

### Organize Your Test Folder
1. Create a folder named `Test Folder`.
2. Save the observed TIFF files (color-coded) with the following exact names:
   - `BLUECHANNEL.tif` (Observed Blue Channel)
   - `GREENCHANNEL.tif` (Observed Green Channel)
   - `REDCHANNEL.tif` (Observed Red Channel)
3. Save the expected TIFF files (color-coded) with the following exact names:
   - `EXBLUECHANNEL.tif` (Expected Blue Channel)
   - `EXGREENCHANNEL.tif` (Expected Green Channel)
   - `EXREDCHANNEL.tif` (Expected Red Channel)

4. Place all these files into the `Test Folder`.

### Run the Script in MATLAB
1. Open MATLAB.
2. Navigate to the `Test Folder` using the file browser or the `cd` command.  
   Example: 
   ```matlab
   cd('path_to_Test_Folder')
   ```

3. Run the following command in the MATLAB command window:
   ```matlab
   EdgeDetectionKentstar("BLUECHANNEL.tif", "GREENCHANNEL.tif", "REDCHANNEL.tif", "EXBLUECHANNEL.tif", "EXGREENCHANNEL.tif", "EXREDCHANNEL.tif");
   ```

---

## How It Works

### Steps
1. **Input Loading**: Reads TIFF images for observed and expected color channels.
2. **Saturation Adjustment**: Scales the observed images using ratios calculated via `averageratioRANKL`.
3. **Grayscale Conversion**: Converts the adjusted images to grayscale for edge detection.
4. **Edge Detection**: Uses the Sobel operator to detect edges in the grayscale images.
5. **Thresholding**: Highlights strong edges by applying a threshold.
6. **Recoloring**: Creates custom-colored visualizations for the edge-detected results.
7. **Comparison**: Combines observed, recolored, and expected edge-detected images for comparison.

### Key Visualizations
- **Filtered Images**: Edge-detected images for each channel.
- **Custom-Colored Visualizations**: Highlights edges in teal, green, and red.
- **Recolored Edges**: Maps grayscale edges back to their original RGB channels.
- **Expected Color Comparison**: Matches edge-detected images to the expected dataset’s colors.

---

## Customization
- **Threshold Value**: Adjust the `thresholdValue` parameter in the script for different edge sensitivities.
- **Color Schemes**: Modify the color-mapping logic in `recolor_edges` and `recolor_edges_uniform` to customize visualizations.

---

## Dependencies
- MATLAB Image Processing Toolbox (for `imread`, `imshow`, etc.).

---

## Notes
- Ensure the input TIFF images are grayscale for single channels or RGB for combined channels.
- Output images and figures are scaled for visual clarity and not normalized for intensity consistency. 

Feel free to adapt the script to suit your specific edge-detection requirements or datasets.
