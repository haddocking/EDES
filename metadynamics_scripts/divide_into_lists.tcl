# Script to divide the residues defining the binding site into lists in order to define the CIPs collective variables
#
#Usage: open on VMD your target protein, define its binding site here and run the script from the tk console: source divide_into_lists.tcl

#location of orient and la1.0 libraries

lappend auto_path ~/scripts/tcl/orient
lappend auto_path ~/scripts/tcl/la1.0

package require Orient
namespace import Orient::orient

set sel [atomselect top "protein and backbone and --> INSERT HERE RESIDUES OF THE BINDING SITE <--"]
set cm_tmp [measure center $sel]
set cm_bs [vecscale -1 $cm_tmp]
set all [atomselect top all]

$all moveby $cm_bs

set I [draw principalaxes $sel]
set A [orient $sel [lindex $I 2] {0 0 1}]
$all move $A
set I [draw principalaxes $sel]
set A [orient $sel [lindex $I 1] {0 1 0}]
$all move $A
set I [draw principalaxes $sel]

set L [lsort -uniq -integer [$sel get resid]]
#plane xy
set Z_1  {}
set Z_2  {}
#piane xz
set Y_1  {}
set Y_2  {}
#piane yz
set X_1  {}
set X_2  {}

set Z_1_serials  {}
set Z_2_serials {}
set Y_1_serials  {}
set Y_2_serials {}
set X_1_serials  {}
set X_2_serials {}

foreach i $L {
set resid [atomselect top "resid $i and backbone"]
set cm [measure center $resid]

if {[lindex $cm 0] >= 0} {
    lappend X_1 $i
} else {lappend X_2 $i}

if {[lindex $cm 1] >= 0} {
    lappend Y_1 $i
} else {lappend Y_2 $i}

if {[lindex $cm 2] >= 0} {
    lappend Z_1 $i
} else {lappend Z_2 $i}
}
puts ""
puts "plane xy resIDs"
puts "Z_1: $Z_1"
puts "Z_2: $Z_2"
puts ""
foreach i $Z_1 {
    set resid_for_serial [atomselect top "resid $i and backbone"]
    lappend Z_1_serials [$resid_for_serial get serial]}
foreach i $Z_2 {
    set resid_for_serial [atomselect top "resid $i and backbone"]
    lappend Z_2_serials [$resid_for_serial get serial]}

puts "List  Z_1 serials:  $Z_1_serials"
puts "List Z_2 serials:  $Z_2_serials"

puts ""
puts "plane xz resIDs"
puts "Y_1: $Y_1"
puts "Y_2: $Y_2"

foreach i $Y_1 {
    set resid_for_serial [atomselect top "resid $i and backbone"]
    lappend Y_1_serials [$resid_for_serial get serial]}
foreach i $Y_2 {
    set resid_for_serial [atomselect top "resid $i and backbone"]
    lappend Y_2_serials [$resid_for_serial get serial]}
puts ""

puts "List Y_1 serials:  $Y_1_serials"
puts "List Y_2 serials:  $Y_2_serials"


puts ""
puts "plane yz resIDs"
puts "X_1: $X_1"
puts "X_2: $X_2"

foreach i $X_1 {
    set resid_for_serial [atomselect top "resid $i and backbone"]
    lappend X_1_serials [$resid_for_serial get serial]}
foreach i $X_2 {
    set resid_for_serial [atomselect top "resid $i and backbone"]
    lappend X_2_serials [$resid_for_serial get serial]}
puts ""

puts "List X_1 serials:  $X_1_serials"
puts "List X_2 serials:  $X_2_serials"
