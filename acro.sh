#!/usr/bin/env bash 

#TODO
# -Add functionality for different acronym lists

VERSION=0.5
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
    echo "       -s          show current status of acro"
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

function show_status()
{
    echo "acro v$VERSION"
    echo "=============="
    echo "Current acro list: $FILENAME"
    echo "=============="
    echo "Available acro lists:"
    basename $(ls -c1 -1 $DIR/*.txt)
}

#Check if there are no arguments
if (($# == 0));then
    show_status
    echo
    usage
fi

while getopts ":Aae:hcl:s" opt;do
    case $opt in
        #All
        A)
            exit_if_file_doesnt_exsist
            less $ACRO_FILE
            ;;
        #Add an acronym
        a)
            exit_if_file_doesnt_exsist
            add_acronym
            ;;
        #Create acronym list
        c)
            if [ -f "$ACRO_FILE" ]; then
                echo "$ACRO_FILE" already exsists
                exit
            fi
            create_acronym_file
            ;;
        #Show only exact matches
        e)
            fgrep -i -w $OPTARG $ACRO_FILE
            ;;
        #show Help message
        h)
            usage
            ;;
        #Show all acronyms starting with a letter
        l)
            exit_if_file_doesnt_exsist
            letter_list $(echo $OPTARG | head -c 1)
            ;;
        #Show status
        s)
            show_status
            ;;
        \?)
            echo invalid option!!
            ;;
    esac
done

if [ $OPTIND -eq 1 -a $# -eq 1 ];then
    find_acronym_top_first $1
fi

