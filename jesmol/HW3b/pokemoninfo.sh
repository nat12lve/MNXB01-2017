#!/bin/bash

########################################################################
#
# MNXB01-2017-HW3b
# File: pokemoninfo.sh file
# Author: Jessamy Mol jessamy.mol@gmail.com
#		  FFlorido Paganelli florido.paganelli@hep.lu.se
#         Lund University
#
########################################################################

# The script must take in input as an argument the directory where the 
# database is stored.
# for example:
#   ./pokemoninfo.sh dataset/
# note that the name 'dataset' should not be hardcoded. It can be any directory
# name. Make sure to read slides 33,34,39 
# Store the folder name in a variable called DBDIR.
DBDIR=$1

# use this function to show an error message with usage information.
errormsg() {
   echo "Usage:"
   echo "$0 <directory>"
   echo "directory must be a path containing a csv dataset."	
}

### Exercise 1: 1 point
# Write an error and exit if no command line argument exists or if the argument
# is empty (it could be a variable!)
# hint: use the if construct and the proper conditions to verify the arguments

if [[ $# == 0 ]]; then
	echo "No directory given";
	errormsg;
	exit 1;
elif [[ -z "$DBDIR" ]]; then
	echo "Directory variable is empty";
	errormsg;
	exit 1;
fi

### Exercise 2: 1 point
# Write an error and exit if the DBDIR directory does not exist or it's not a directory.
# Hint: read http://tldp.org/LDP/Bash-Beginners-Guide/html/sect_07_01.html

if [[ ! -d "$DBDIR" ]]; then
	echo "'$DBDIR' is not an existing directory";
	errormsg;
	exit 1;
fi

### Exercise 3: 1 point
# Use the grep command to find which file contains "Pokémon Red Version"
# and output the results on screen.
# grep examples: http://tldp.org/LDP/Bash-Beginners-Guide/html/sect_04_02.html

echo -e "\nSearching for Pokémon Red..."
grep -r 'Pokémon Red Version' "$DBDIR"

### Exercise 4: 1 point
# delete existing allplatform.csv file in preparation of the next exercise

echo -e "\nRemoving old allplatforms.csv"
if [[ -f "${DBDIR}allplatforms.csv" ]]; then
	rm "${DBDIR}allplatforms.csv"
fi

#delete allplatforms.ordered.csv as well 
if [[ -f "${DBDIR}allplatforms.ordered.csv" ]]; then
	rm "${DBDIR}allplatforms.ordered.csv"
fi

### Exercise 5: 3 points
# Write a for loop that takes every file in the database and puts it 
# into a single file
# called allplatforms.csv.
# Inspect the csv files to understand their structure,
# and make sure to remove the header lines.
# Hint: use the slides about for ... do ... done
#       use the tail command to remove the header lines (check 'man tail'),
#       use the file concatenator '>>' to write out the allplatforms.csv file

# create allplatforms file with a for loop
echo -e "\nCreating new allplatforms.csv"
for filename in "$DBDIR"*.csv; do
	tail -n +2 "$filename" >> "$DBDIR"allplatforms.csv
done

### Exercise 6: 1 point
# Sort the contents of the allplatforms.csv file by using the sort 
# command and write the result in allplatforms.ordered.csv
# Hint: use \" as a delimiter for sort. Check 'man sort'

echo -e "\nSorting allplatforms.csv..."
sort -k 2 "$DBDIR"allplatforms.csv > "$DBDIR"allplatforms.ordered.csv

# Exercise 7: 4 points
# Write a for loop that, for each file, counts all the games
# in each file. Inspect the csv file to understand the structure of the 
# csv file to get the right numbers.
# Hint: use the slides about for ... do ... done
#       use the '$()' syntax to put the output of a command inside a variable
#       use the program tail to get rid of useless lines
#       use the program wc to count things
#       make use of the | symbol to compose         
#       use the 'basename' command to get rid of the directory part of the filename
# output the result in this form:
# <filename> has <number of games> games <newline>
# example output:
# poke.Android.csv has 2 game(s)
# poke.iOS.csv has 1 game(s)

echo -e "\nCalculating number of games for each file..."
for filename_dir in "$DBDIR"*.csv; do
	if [[ "${filename_dir}" != */allplatforms*.csv ]]; then
		filename="$(basename "${filename_dir}")"
		n_games="$(tail -n +2 "$filename_dir" | wc -l)"
		echo "${filename} has ${n_games} game(s)"
	fi
done
echo 

exit 0;
