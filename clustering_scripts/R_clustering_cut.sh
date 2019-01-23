#!/bin/sh

######################################
# Cluster Analysis Script implementing the "windows approach"
#######################################

RoG_min=$(sort -gk2 index_RoGBS.dat | head -1 | awk '{print $2}')
RoG_max=$(sort -gk2 index_RoGBS.dat | tail -1 | awk '{print $2}')
RoG_difference=$(echo "$RoG_max - $RoG_min" | bc)

if [ $# -le 1 ]; then
    echo "";
    echo "[N] = N° of desired clusters (e.g. N=50)";
    echo "[Sigma] = Width of each (RoG) window";
    echo "Usage: $0 [N] [Sigma]";
    echo "The number of Windows has been set to 10 - according to their width, the number of structures contained into each window will be different!";
    echo "";
    echo "RoG_max - RoG_min = $RoG_difference";
    echo "So, the suggested Sigma is given by $RoG_difference/10= ";
    suggested_sigma=$(echo "$RoG_difference/10"| bc -l)
    printf "%.3f" $suggested_sigma
    echo "";
    echo "";
    exit 1;
fi

N=$1       
sigma=$2 

top[1]=$(echo "$RoG_min+$sigma"|bc -l)
btm[1]=$(echo "$RoG_min"|bc -l)

for i in `seq 2 10`; do
    iminus1=$(echo "$i -1"|bc)
    
    declare btm[$i]=${top[$((${i}-1))]}
    declare top[$i]=$(echo "${btm[${i}]}+${sigma}" | bc -l)
done


for i in `seq 1 10`; do
    awk -v top1=${top[${i}]} -v btm1=${btm[${i}]} '{if ($2 < top1 && $2 >= btm1) print $0}' index_RoGBS.dat > RoGBS-sigma_win${i}.dat
done
echo ""
echo ""
printf "%s\n" "N° of clusters in each window"
N_tot=$(wc -l index_RoGBS.dat)
N_tot_lines=$(echo $N_tot | cut -d ' ' -f1)
for i in `seq 1 10`; do
    a=$(wc -l RoGBS-sigma_win$i.dat)
    num_lines=$(echo $a | cut -d ' ' -f1)
    N_cluster=$(echo "$N*($num_lines/$N_tot_lines)"|bc -l)
    N_cl_rounded=$(echo "($N_cluster+0.9)/1" | bc)
    cluster_num[$i]=${N_cl_rounded}
    printf "%s" "Window" $i ": "
    printf "%.0f"  ${cluster_num[$i]}
    printf "%s" " | Structure in this window: " $num_lines
    printf "\n"
done

echo "Total number of clusters:" $(echo "${cluster_num[1]}+${cluster_num[2]}+${cluster_num[3]}+${cluster_num[4]}+${cluster_num[5]}+${cluster_num[6]}+${cluster_num[7]}+${cluster_num[8]}+${cluster_num[9]}+${cluster_num[10]}" | bc -l)

N_total_clusters=$(echo "${cluster_num[1]}+${cluster_num[2]}+${cluster_num[3]}+${cluster_num[4]}+${clu\
ster_num[5]}+${cluster_num[6]}+${cluster_num[7]}+${cluster_num[8]}+${cluster_num[9]}+${cluster_num[10]}" | bc -l)

echo " "
echo "...Saving the CVs in each Window for the clustering..."
echo " "
for i in `seq 1 10`; do
    echo "Working on Window: " $i "..."
    
    awk '{printf"\\b%s\\b\n",$1}' RoGBS-sigma_win$i.dat > sigma_${i}_ready.dat
    while IFS='' read -r line || [[ -n "$line" ]]
    do
	grep -m 1 "${line} " CVS_clustering.dat>> lines_sigma${i}.dat
    done < sigma_${i}_ready.dat
    awk '{print $2}' lines_sigma${i}.dat > dataclust_sigma${i}.dat
done


echo "Preparing R files..."
for i in `seq 1 10`; do 
    sed "s/FILENAME/dataclust_sigma${i}.dat/" hclust_4cvs_template.R > Rhclust_win${i}_tmp.R
    sed "s/NCLUSTER/${cluster_num[i]}/" Rhclust_win${i}_tmp.R > Rhclust_win${i}_tmp2.R
    sed "s/OUTPUTNAME/clusterselected_s${i}.dat/" Rhclust_win${i}_tmp2.R > Rhclust_win${i}.R
    rm Rhclust_win${i}_tmp.R Rhclust_win${i}_tmp2.R
    R < Rhclust_win${i}.R --no-save
done
awk '{print $2}' CVS_clustering.dat > CVS_clustering_for_kmeans.dat
for i in `seq 1 10`;
do grep -v "V1" clusterselected_s${i}.datmatrix > tmp;
   sed 's/"/ /g' tmp > tmp${i};
done
awk '{printf "%s,",$2}' tmp1 tmp2 tmp3 tmp4 tmp5 tmp6 tmp7 tmp8 tmp9 tmp10  > CV0_center
awk '{printf "%s,",$3}' tmp1 tmp2 tmp3 tmp4 tmp5 tmp6 tmp7 tmp8 tmp9 tmp10  > CV1_center
awk '{printf "%s,",$4}' tmp1 tmp2 tmp3 tmp4 tmp5 tmp6 tmp7 tmp8 tmp9 tmp10  > CV2_center
awk '{printf "%s,",$5}' tmp1 tmp2 tmp3 tmp4 tmp5 tmp6 tmp7 tmp8 tmp9 tmp10  > CV3_center
cat CV?_center | sed 's/\,$//' > CV_ALL_center
cat k-means-head.R CV_ALL_center k-means-tail.R > k-means_tmp.R
sed "s/CENTERS/$N_total_clusters/g" k-means_tmp.R > k-means_ready.R
R < k-means_ready.R --no-save

