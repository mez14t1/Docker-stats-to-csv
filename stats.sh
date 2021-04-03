#!/bin/sh

delimiter=";"

usage() { echo "Usage: $0 must provide file name as argument and [-d <string> ] as an optional delimiter (default is ';') " 1>&2; exit 1; }


while getopts ":d:" o; do
    case "${o}" in
        d)
            delimiter=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

fileName="";

if [ $1 ] ; then fileName=$1 ; else usage ; fi

touch $fileName

echo "CONTAINER ID${delimiter}NAME${delimiter}CPU%${delimiter}MEM USAGE${delimiter}MEM LIMIT${delimiter}MEM %${delimiter}NET I${delimiter}NET O${delimiter}BLOCK I${delimiter}BLOCK O${delimiter}PIDS" > $fileName

while true; 
    do 
    docker stats --format "{{.ID}}${delimiter}{{.Name}}${delimiter}{{.CPUPerc}}${delimiter}{{.MemUsage}}${delimiter}{{.MemPerc}}${delimiter}{{.NetIO}}${delimiter}{{.BlockIO}}${delimiter}{{.PIDs}}" --no-stream|sed -e "s/ \/ /${delimiter}/g"  | tee --append $fileName;sleep 1 ; done


#    | sed -n '1!p'|sed -e "s/\s\{3,\}/;/g"  | tee --append stats.csv;sleep 1 ; done
