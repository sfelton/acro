#!/bin/bash 

#TODO
#Add different output flags/options
#  -Only exact matches  (-e)
#  -All matches         (default atm)
#  -Exact matches first
#  -Only acronym matches
#  -Only word matches

FILENAME="acronyms.txt"

#Get the directory of the acro.sh file regardless of symlinks
SOURCE="${BASH_SOURCE[0]}"
while [ -h $SOURCE ]; do 
    DIR="$( cd -P "$( dirname "SOURCE" )" && pwd )"
    SOURCE="$(readlink "$SOURCE")"
    [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

ACRO_FILE="$DIR/$FILENAME"
MAX_LINES=$(tput lines)

#Functions
function usage()
{
    echo "Usage: acro [ option ] search-string"
    echo "Flags: -A          print all acronyms"
    echo "       -a          prompt to add a new acronym to list"
    echo "       -c          create acronym file if it doesn't exsist"
    echo "       -e <search> only show exact matches"
    echo "       -h          show this help"
    echo "       -l <letter> list all acronyms starting with that letter"
}

function letter_list()
{
    grep -i "^$1\w*" $ACRO_FILE
}

function add_acronym()
{
    read -p "What is the ACRONYM? " ACRO
    read -p "What is the MEANING? " MEANING
    printf "%-8s| " $ACRO >> $ACRO_FILE
    echo $MEANING >> $ACRO_FILE
    sort $ACRO_FILE --output=$ACRO_FILE
}

function find_acronym_top_first()
{

    count=$(fgrep --ignore-case --count $1 $ACRO_FILE)
    exact_count=$(fgrep --ignore-case --count -w $1 $ACRO_FILE)
    
    if [ $exact_count -gt 0 -a $count -ne $exact_count ];then
        fgrep -i -w $1 $ACRO_FILE
        echo -------------------------------------------------------------
    fi
    fgrep --ignore-case $1 $ACRO_FILE
}

function find_acronym()
{
    count=$(fgrep --ignore-case --count $1 $ACRO_FILE)
    
    #-i == --ignore-case
    if [ $count -gt $MAX_LINES ]; then
        fgrep -i $1 $ACRO_FILE | less
    else
        fgrep -i $1 $ACRO_FILE
    fi
}

function create_acronym_file()
{
    echo Creating $FILENAME at $DIR
    echo "          Acronyms & Abbreviations" > $ACRO_FILE
    echo "-----------------------------------------" >> $ACRO_FILE
    echo "-----------------------------------------" >> $ACRO_FILE
}

function exit_if_file_doesnt_exsist()
{
    if [ ! -f "$ACRO_FILE" ]; then
        echo $ACRO_FILE does not exsist
        echo you can create it using 'acro -c'
        exit
    fi
}

while getopts ":Aae:hcl:" opt;do
    case $opt in
        A)
            exit_if_file_doesnt_exsist
            less $ACRO_FILE
            ;;
        a)
            exit_if_file_doesnt_exsist
            add_acronym
            ;;
        c)
            if [ -f "$ACRO_FILE" ]; then
                echo "$ACRO_FILE" already exsists
                exit
            fi
            create_acronym_file
            ;;
        e)
            fgrep -i -w $OPTARG $ACRO_FILE
            ;;
        h)
            usage
            ;;
        l)
            exit_if_file_doesnt_exsist
            letter_list $(echo $OPTARG | head -c 1)
            ;;
        \?)
            echo invalid option!!
            ;;
    esac
done

if [ $OPTIND -eq 1 -a $# -eq 1 ];then
    find_acronym_top_first $1
fi

