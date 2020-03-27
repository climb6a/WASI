# WASI
Simulation and data analysis of measurements in deep and shallow waters.
![Example screenshot](./doc/GraphicalAbstract.tif)

## General info
The Water Colour Simulator **WASI** is a tool for the simulation of optical properties and light field parameters of deep and shallow waters, and for data analysis of instruments disposed above the water surface and submerged in the water. Supported measurements are downwelling irradiance, upwelling radiance, irradiance reflectance, remote sensing reflectance, attenuation, and absorption. Data analysis is done by inverse modeling. The provided database covers the spectral range from 350 to 1000 nm in 1 nm intervals. It can be exchanged easily to represent the studied area. The module WASI-2D extends the functionality towards image processing of atmospherically corrected data from airborne sensors and satellite instruments. 

## Download
The executable can be downloaded [here] (https://c.1und1.de/@519891561215951357/6PlmFxS0RAyf4FLNjVot4A)

## Setup
Run **INSTALL_WASI5_1.EXE** to unpack WASI version 5.1 to your computer. 
WASI5.1 is installed by default in the directory D:\WASI5.1
If you prefer installation in another directory, you need to edit the file WASI5_1.INI: 
Replace in WASI5_1.INI all occurences of "D:\WASI5.1\" with your directory.

## Major files and subdirectories
* WASI5_1.EXE      the executable file
* WASI5_1.INI      initialisation file
* ./DATA     directory with input spectra and demo data
* ./DOC      directory documentation

## Contact
Created by peter.gege@dlr.de - feel free to contact me!