# EDES (Ensemble-Docking with Enhanced-sampling of pocket Shape)
#
#### - The files refer to the work available [here](https://www.biorxiv.org/content/early/2018/10/03/434092);
#### - Some other useful pieces of information about the method can be found in this [tutorial](http://www.bonvinlab.org/education/biomolecular-simulations-2018/Metadynamics_tutorial/) used for the [BioExcel Summer School 2018](https://bioexcel.eu/services/training/summerschool2018/).
#
Collection of key scripts to generate the CIPs variables and to run the multi-step cluster analysis.

##### Script to define the CIPs variables: "divide_into_lists.tcl".
This script is found within the metadynamics_scripts folder. It is based on the [orient and la1.0 VMD libraries](https://www.ks.uiuc.edu/Research/vmd/script_library/scripts/orient/) and it only requires the knowledge of the residues lining the binding site in order to generate the list of residues for each of the three CIP variable.
##### USAGE:
Open your protein with VMD, then run the script from the Tk VMD console by typing:
```sh
source divide_into_lists.tcl
```
Please be sure to edit, before running the script, the list of residues lining the binding site.
You should put your selection in place of"-->INSERT HERE RESIDUES OF THE BINDING SITE <---".


In our example (file 1JEJ.pdb within the "example" folder), the binding site is "resid 18 213 238 240 188 189 191 195 214 237 261 267 269 272". The output will look like the following one:

```sh
plane xy resIDs
Z_1: 18 213 214 237 238 240 272
Z_2: 188 189 191 195 261 267 269

List Z_1 serials:  {133 134 135 136} {1727 1728 1729 1730} {1738 1739 1740 1741} {1927 1928 1929 1930} {1936 1937 1938 1939} {1951 1952 1953 1954} {2207 2208 2209 2210}
List Z_2 serials:  {1524 1525 1526 1527} {1528 1529 1530 1531} {1545 1546 1547 1548} {1575 1576 1577 1578} {2105 2106 2107 2108} {2160 2161 2162 2163} {2175 2176 2177 2178}

plane xz resIDs
Y_1: 18 240 261 267 269 272
Y_2: 188 189 191 195 213 214 237 238

List Y_1 serials:  {133 134 135 136} {1951 1952 1953 1954} {2105 2106 2107 2108} {2160 2161 2162 2163} {2175 2176 2177 2178} {2207 2208 2209 2210}
List Y_2 serials:  {1524 1525 1526 1527} {1528 1529 1530 1531} {1545 1546 1547 1548} {1575 1576 1577 1578} {1727 1728 1729 1730} {1738 1739 1740 1741} {1927 1928 1929 1930} {1936 1937 1938 1939}

plane yz resIDs
X_1: 188 195 213 214 237 238 267 269 272
X_2: 18 189 191 240 261

List X_1 serials:  {1524 1525 1526 1527} {1575 1576 1577 1578} {1727 1728 1729 1730} {1738 1739 1740 1741} {1927 1928 1929 1930} {1936 1937 1938 1939} {2160 2161 2162 2163} {2175 2176 2177 2178} {2207 2208 2209 2210}
List X_2 serials:  {133 134 135 136} {1528 1529 1530 1531} {1545 1546 1547 1548} {1951 1952 1953 1954} {2105 2106 2107 2108}
```

Where you can see the resIDs and serials associated to each list for all the three CIP variables.

Once you have the serial numbers, you can use them to define the collective variables as in the example files plumed-common.dat and plumed.[0-3].dat you can find in the example folder.

##### Script to perform the multi-step cluster analysis: "R_clustering_cut.sh".
This script is found within the "clustering_scripts" folder.
  It requires two input files: "index_RoGBS.dat" and "CVS_clustering.dat" (two example files are in the folder "example"; please ensure to remove the first three lines from the CVS_clustering.dat file before using the scripts!).

##### USAGE:
-Check the formatting of the files needed (use the example files to check it);

-Copy the files in the current working directory (they need to be in the same directory of the R_clustering_cut.sh file);

-Check if you have the required packages for R (they are listed in the files "hclust_4cvs_template.R" and "k-means-head.R");

-Run "./R_clustering_cut.sh" without arguments to check the suggested width for the RoG-windows;
If you run the script in the same directory of the example files given here, you should be able to see an output like this:

```sh
[N] = N° of desired clusters (e.g. N=50)
[Sigma] = Width of each (RoG) window
Usage: ./R_clustering_cut.sh [N] [Sigma]
The number of Windows has been set to 10 - according to their width, the number of structures contained into each window will be different!

RoG_max - RoG_min = 1.481319
So, the suggested Sigma is given by 1.481319/10=
0.148
```

-Run the script to perform the cluster analysis (e.g. ./R_clustering_cut.sh 50 0.291).
After the calculation has finished, you will see a file named: "matrix_k-means-init-centers.dat" containing the index of the selected frames.


