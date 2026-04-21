# Distance_SVs_to_AZ_in_FIJI
Measures distances of SVs to AZ in TEM Images

## Overview

This FIJI/ImageJ macro performs a **semi-automated measurement of distances between synaptic vesicles (SVs) and the active zone (AZ)** in microscopy images.

Users:
- Draw the **active zone (AZ)** as a curve  
- Mark **synaptic vesicles (SVs) edges** as points  
- The macro computes the **shortest distance from each SV to the AZ**  

---

## ⚙️ Workflow

1. **Image input**
   - Uses the current image or prompts to open one  

2. **Spatial calibration**
   - Checks for global scale  
   - If missing, prompts user to define it from a scale bar  
   - Distances are reported in **nanometers**  

3. **Annotation**
   - Draw AZ using a freehand line (converted to spline)  
   - Mark SVs using multipoint tool  

4. **Distance calculation**
   - Generates a **Euclidean Distance Map** from the AZ  
   - Measures distance at each SV position  

5. **Output**
   - ROI set (`.zip`)  
   - Distance table (`.txt`, values in *MEAN* column)  

---

## 🔬 Applications

Useful for **synaptic and cellular biology**, for example:
- Vesicle positioning relative to release sites  
- Docking and priming analysis  
- Comparing spatial organization across conditions  

---

## 💡 Key advantages

- Semi-automated and reproducible  
- Accurate Euclidean distances  
- Scales efficiently to many vesicles  

---

## ⚠️ Notes

- Requires manual annotation of the AZ (Use at your own risk)
- Results depend on accurate user annotations  
- Requires proper calibration  
- Designed for 2D analysis  

