#prepare necessary files to check if scientific names from input file are in CSpace
#Usage: sh prepare_file.sh filename n
#where n is the position of the column in filename which contains the scientific names to be checked

#check that there are the correct number of arguments provided
if [[ $# != 2 ]]
	then
		echo "must supply two arguments"
		echo "the file name containing names to be checked"
		echo "and the numerical position (starting from 1) of the column containing scientific names"
		echo "e.g.:"
		echo "sh prepare_file.sh my_specimen_records.txt 6"
		exit 1
fi

#check that $1 exists and is not empty
if [ ! -e "$1" ]
	then
		echo "input file $1 not found, aborting script"
		exit 1
fi
if [ ! -s "$1" ]
	then
		echo "input file $1 is an empty file, aborting script"
		exit 1
fi

#check that $2 is a positive integer
if [ $2 -le 0 ]
	then
		echo "column position (argument 2, i.e.: \"$2\") is not a positive number"
		echo "aborting script"
		exit 1
fi

#check that $2 refers to a column containing data (i.e. $2 is not larger than total number of columns
TOTAL_COLUMNS=`head -n 1 "$1" | awk '{print NF}'`
if [ $2 -gt $TOTAL_COLUMNS ]
	then
		echo "column position ($2) larger than the total number of columns in $1 ($TOTAL_COLUMNS)"
		echo "aborting script"
		exit 1 
fi

#prepare the input file into a list of names
cut -f "$2" "$1" | sort | uniq | sort > input_names.txt

#check that there is exactly one taxon file and unverified taxon file
#using wc, $1 is line count, $2 is word count, $3 is letter count, and $4 is file name
#so ls for taxon_auth and unverified_auth files, and check that line count ($1) is exactly 1 for each
for PREFIX in "taxon_auth_" "unverified_auth_" 
do
	COUNT=`ls $PREFIX*.txt | wc | awk {'print $1'}`
	if [ $COUNT != 1 ]
		then
			PREFIX+="YYMMDD.txt"
			echo "check for taxon authority file $PREFIX)"
			echo "there are $COUNT when there should be exactly 1"
			echo "aborting script"
			exit 1
	fi
done

#concatenate CSpace authority files
tail -n +2 taxon_auth_*.txt > auth_file.txt
tail -n +2 unverified_auth_*.txt >> auth_file.txt 
