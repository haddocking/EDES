# EDES
#
# The files refer to the work published at:
#

- Script to define the CIPs variables: "divide_into_lists.tcl".
 Requires the knowledge of the residues lining the binding site.
 Open your protein on VMD, then launch the script from the Tk VMD console by typing "source divide_into_lists.tcl"

- Script to perform the multi-step cluster analysis: "R_clustering_cut.sh"
  Requires two input files: "index_RoGBS.dat" and "CVS_clustering.dat" (two example files are in the folder "example" - remove the first lines from the CVS_clustering.dat file before using   that file for the clustering!).

Steps:
-Check the formatting of the files needed (use the example files to check it);
-Copy the files in the current working directory (they need to be in the same directory of the R_clustering_cut.sh file);
-Check if you have the required packages for R (they are listed in the files "hclust_4cvs_template.R" and "k-means-head.R");
-Run "./R_clustering_cut.sh" without arguments to check the suggested width for the RoG-windows;
-Run the script to perform the cluster analysis (e.g. ./R_clustering_cut.sh 50 0.291).
