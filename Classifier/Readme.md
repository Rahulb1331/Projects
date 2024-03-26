<H2>About the Dataset:</H2>
Features are computed from a digitized image of a fine needle aspirate (FNA) of a breast mass. They describe characteristics of the cell nuclei present in the image. 
Attribute Information:
ID number
Diagnosis (M = malignant, B = benign) 3-32)
Ten real-valued features are computed for each cell nucleus:

radius (mean of distances from center to points on the perimeter)<br>
texture (standard deviation of gray-scale values)<br>
perimeter<br>
area<br>
smoothness (local variation in radius lengths)<br>
compactness (perimeter^2 / area - 1.0)<br>
concavity (severity of concave portions of the contour)<br>
concave points (number of concave portions of the contour)<br>
symmetry<br>
fractal dimension ("coastline approximation" - 1)<br>
The mean, standard error and "worst" or largest (mean of the three largest values) of these features were computed for each image, resulting in 30 features. For instance, field 3 is Mean Radius, field 13 is Radius SE, field 23 is Worst Radius.

All feature values are recoded with four significant digits.

Missing attribute values: none
Class distribution: 357 benign, 212 malignant<br>
Citation: Wolberg,William, Mangasarian,Olvi, Street,Nick, and Street,W.. (1995). Breast Cancer Wisconsin (Diagnostic). UCI Machine Learning Repository. https://doi.org/10.24432/C5DW2B.
