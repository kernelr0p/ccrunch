#!/bin/sh
#Guillermo Muñoz Mozos
#@gmunnozmozos
trap '{ echo "Hey, you pressed Ctrl-C.  Time to quit." ; exit 1; }' INT
usage() { echo "Usage: $0 [-r input_file] [-w output_file] [-f from_year] [-t to_year]" 1>&2; exit 1; }

while getopts ":r:w:f:t:" o; do
    case "${o}" in
        r)
            r=${OPTARG}
            ;;
        w)
            w=${OPTARG}
            ;;
	    f)
	        f=${OPTARG}
	        ;;
        t)
	        t=${OPTARG}
	        ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

if [ -z "${r}" ] || [ -z "${w}" ] || [ -z "${f}" ] || [ -z "${t}" ]; then
    usage
fi
charset="0123456789"
if [ "${#f}" = "${#t}" ]; then
    length_year=${#f}
else
    echo "Length of the numbers should be the same."
    exit
fi
year_variable=$(printf "%${length_year}s");num_var=`echo ${year_variable// /@}`
while IFS='' read -r line || [[ -n "$line" ]]; do
     echo "Processing line "$line"."
     length_line=${#line}
     total_length=$((length_line+length_year))
crunch $total_length $total_length ${charset} -t "${line}""${num_var}" -s "${line}""${f}" -e "${line}""${t}" -o "${line}".lst &> /dev/null l
done < "$r"
echo "Process completed."
cat *.lst >> $w
