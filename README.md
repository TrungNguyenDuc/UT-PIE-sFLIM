# Multiplexed Imaging and Hybrid Unmixing in Live Cells Using PIE-sFLIM

This repository contains the Python code used for the analysis and unmixing of fluorescence signals in live-cell imaging based on fluorescence lifetime and spectral phasor analysis, as described in the paper *"Multiplexed Imaging in Live Cells Using Pulsed Interleaved Excitation Spectral FLIM"* published in *Optics Express* [1]. https://opg.optica.org/oe/fulltext.cfm?uri=oe-32-3-3290&id=545659. 

## Overview

The code provides tools for:
- Calibrating phasor transformations using well-characterized dyes (e.g., fluorescein, Atto633).
- Performing lifetime and spectral phasor analysis to resolve fluorescence signals.
- Implementing a hybrid unmixing algorithm using the Gaussian Mixture Model (GMM) to separate fluorescence signals from multiple fluorophores based on both lifetime and spectral characteristics.

### Key Concepts:
- **PIE-sFLIM**: Pulsed Interleaved Excitation Spectral Fluorescence Lifetime Imaging Microscopy.
- **Phasor Transform**: A mathematical transformation that maps lifetime and spectral data into a phasor space.
- **Hybrid Unmixing**: A method combining lifetime and spectral phasors for improved unmixing of overlapping fluorescence signals using GMM.

## Installation

To run the analysis code, you need to install the following Python packages:

```bash
pip install numpy scipy matplotlib scikit-learn
```

Ensure that you have the necessary dependencies for image and signal processing installed (e.g., `PIL` for image handling, `h5py` for storing large datasets, etc.).

## Files and Structure

- **`phasor_analysis.py`**: Contains functions for performing phasor transformations on both lifetime and spectral data.
- **`gmm_unmixing.py`**: Implements the Gaussian Mixture Model (GMM) clustering and unmixing approach.
- **`image_processing.py`**: Handles image preprocessing, noise reduction, and median filtering of phasor data.
- **`example_data/`**: Contains example datasets (e.g., fluorescence lifetime and spectral data) used for testing and validation.

## Usage

### 1. **Phasor Calibration**

To perform phasor calibration, use the script `phasor_analysis.py` with well-characterized fluorophores. Example:

```python
from phasor_analysis import calibrate_phasors

# Example fluorophores
fluorophore_data = {'fluorescein': {'lifetime': 4, 'emission': [500, 550]},
                    'Atto633': {'lifetime': 3.3, 'emission': [600, 650]}}

calibrated_phasors = calibrate_phasors(fluorophore_data)
```

This will calibrate the phase 𝜑 and modulation 𝑚 values, which can be used for further analysis.

### 2. **Phasor Transformation**

To transform lifetime or spectral data into phasor space, use the following:

```python
from phasor_analysis import lifetime_to_phasor, spectral_to_phasor

# Lifetime data (example)
lifetime_data = {'lifetime': [3.8, 5]}  # Example for LysoTracker Green and NucSpot488

phasors = lifetime_to_phasor(lifetime_data)
```

You can similarly apply `spectral_to_phasor()` for spectral data.

### 3. **Hybrid Unmixing with GMM**

To apply the hybrid unmixing algorithm with Gaussian Mixture Models (GMM), use the script `gmm_unmixing.py`:

```python
from gmm_unmixing import unmix_fluorescence

# Example phasor data
phasor_data = {'lifetime_phasors': lifetime_phasors, 'spectral_phasors': spectral_phasors}

unmixed_images = unmix_fluorescence(phasor_data, num_components=3)
```

This will use the GMM algorithm to separate fluorescence signals into distinct fluorophores.

### 4. **Visualizing Results**

To visualize the unmixing results and phasor plots, you can use `matplotlib` for plotting:

```python
import matplotlib.pyplot as plt
from image_processing import plot_phasor_cloud

# Plot phasor cloud
plot_phasor_cloud(lifetime_phasors)
```

This will generate a visualization of the phasor cloud, helping you to analyze the results.

## Example Data

The `example_data/` folder contains simulated datasets for testing. These datasets demonstrate the application of the phasor transformation and GMM unmixing algorithm. You can load the data and run the analysis on these datasets to see the results in action.

```bash
cd example_data/
python process_example_data.py
```

This will execute the analysis and show the resulting unmixed fluorescence images.

## References

