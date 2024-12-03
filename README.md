# Multiplexed Imaging and Hybrid Unmixing in Live Cells Using PIE-sFLIM

This repository contains the Python code used for the analysis and unmixing of fluorescence signals in live-cell imaging based on fluorescence lifetime and spectral phasor analysis, as described in the paper *"Multiplexed Imaging in Live Cells Using Pulsed Interleaved Excitation Spectral FLIM"* published in *Optics Express* [1]. https://opg.optica.org/oe/fulltext.cfm?uri=oe-32-3-3290&id=545659. 

![PIE-sFLIM-Fig 1](https://github.com/user-attachments/assets/f848e6c6-4925-49d0-8edd-6873edf203ef)

Fig. 1. Schematic of the PIE-sFLIM system with an example of 16-channel raw data analysis. (a) PIE-sFLIM setup, where the two avalanche photodiode (APD) channels and the two-photon (2P) laser are for the traditional confocal and two-photon imaging. (b) 16-channel intensity with time-resolved fluorescence response (TRES) analysis for signal visualization, demonstrated on a convallaria sample with 488 nm excitation. (c) Representative decays curves for each spectral channel and spectrum at each pixel. The dips in the emission spectrum are due to the dichroic mirror that blocks the two potential excitation wavelengths at 560 nm and 650 nm. Abbreviations: 16-PMT, 16 channels photomultiplier tube; 2P, two-photon; FPGA, field programmable gate array; DFD, digital frequency domain; CFD, constant fraction discriminator; TRES, time-resolved emission spectrum; APD, avalanche photodiode; RL, relay lens; VP, variable pinhole; EM, emission filter; FL, focusing lens; IRB, infrared blocking filter; M, mirror; D, dichroic mirror; GSM, galvo mirror; SL, scan lens; Ex, excitation laser, Em, emission band.

## Overview

The code provides tools for:
- Calibrating lifetime and lamda phasor transformations using well-characterized dyes (e.g., fluorescein, Atto633).
  
  ![PIE-sFLIM-Fig 2](https://github.com/user-attachments/assets/51b69419-7322-4c07-a4b2-ab32113d659e)
  Fig. 2. (a) Lifetime phasors can be generated using the measured phase delay φ(ω) and modulation m(ω) in a frequency-domain (FD) setup. For a single species, lifetime decreases clockwise along the universal semicircle. (b) Lifetime phasors can also be obtained from time-domain decay data, after conducting Fourier transform. The FLIM image shows T24 cells stained with LysoTracker Green (3.8 ns, green) and NucSpot488 (5 ns, blue). (c) Lifetime phasor calibration using fluorescein (4 ns, excited by 488 nm laser) for green (Em1) and orange (Em2) emission bands. (d) Lifetime phasor calibration using Atto633 (3.3 ns, excited by 650 nm laser) for red (Em3) emission band. (e) 𝜏 phasor plot of a convallaria sample. (f) False-colored FLIM image of the convallaria. Abbreviations: Nuc, NucSpot488; Lyso, LysoTracker Green. Scale bars are 5 µm.

  ![PIE-sFLIM-Fig 3](https://github.com/user-attachments/assets/1aa43797-122e-4ec4-a73f-8713f338f453)

  Fig. 3. Spectral phasor plots of simulated Gaussian emission spectra centered at the peak wavelengths of 579.9 nm (A, B, C), 527.1 nm (D, E) and 670 nm (F) with the FWHM of A: 30 nm, B: 60 nm, C: 90 nm, D: 50 nm, E: 20 nm, F: 50 nm.

- Performing lifetime and spectral phasor analysis to resolve fluorescence signals.
  
- Implementing a hybrid unmixing algorithm using the Gaussian Mixture Model (GMM) to separate fluorescence signals from multiple fluorophores based on both lifetime and spectral characteristics.

  ![PIE-sFLIM-Fig 4](https://github.com/user-attachments/assets/099ef703-ff89-47df-a532-5c881e324c5e)

  Fig. 4. (a) The TRES matrix I(t, λ) at each pixel is separately transformed into λ phasors and 𝜏 phasors. (b) λ phasor plots before and after spectral denoising. (c) 𝜏 phasor plots corresponding to the three emission bands. (d) Representative inputs and outputs of the Gaussian Mixture Models (GMM) based on unmixed spectra and lifetime phasors of the three emission bands. (e) Merged intensity image, merged multi-target image and unmixed images of T24 cells with nucleus stained with NucSpot488 (Nuc), lysosomes (Lyso) stained with LysoTracker Green, mitochondria (Mito) stained with MitoTracker Orange, plasma membrane (PM) stained with SPY555-BG (SNAP), Golgi stained with HT7-JF646 (HT7) and vimentin filament stained with HT9-JF646 (HT9). Scale bar is 20 µm.

### Key Concepts:
- **PIE-sFLIM**: Pulsed Interleaved Excitation Spectral Fluorescence Lifetime Imaging Microscopy.
- **Phasor Transform**: A mathematical transformation that maps lifetime and spectral data into a phasor space.
- **Hybrid Unmixing**: A method combining lifetime and spectral phasors for improved unmixing of overlapping fluorescence signals using GMM.

## Usage
**Phasor-sFLIM manual**


## Example Data



## References

