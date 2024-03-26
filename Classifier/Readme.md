<H1>Exploratory Data Analysis for the Tumor Dataset</H1>
This project aims to perform exploratory data analysis for the Breast Cancer Wisconsin (Diagnostic) dataset and process and analyze it so  that  it can be used for building a tumor classifier, by identifying from the image whether the given tumor image id Malignant or Benign. In this project EDA has been performed, where uneeded columns have dropped, association between features have been identified along with the outliers and redundant feautures. All this has been done by employing python data analysis libraries including Numpy, Pandas, Matpotlib, Seaborn, etc. which have been used to manipulate the data and understand the given features in the dataset with the help of various charts and plots including Violin plots, Joint plots, Swarm Plots and Correlation Heat maps, to identify the association between the features. 
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
