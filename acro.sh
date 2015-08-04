#!/bin/bash 

#TODO
# Add -h flag to display usage
# Probably fix usage up a little to be usefule

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
    echo Provide acronym to look up
    echo    ex. acro TLA
    echo 
    echo Add acronym with \'acro add\'
    echo List all acronyms with \'acro all\'
}

function letter_list()
{
    grep -i "^$1\w*" $ACRO_FILE
}

function add_acronym()
{
    read -p "What is the ACRONYM? " ACRO
    read -p "What is the MEANING? " MEANING
    cp -f $ACRO_FILE $ACRO_FILEi.backup
    printf "%-8s| " $ACRO >> $ACRO_FILE
    echo $MEANING >> $ACRO_FILE
    sort $ACRO_FILE --output=$ACRO_FILE
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

while getopts ":Aae:cl:" opt;do
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
    find_acronym $1
fi
#case $1 in
#    all | All)
#        less $ACRO_FILE
#        ;;
#    add | Add)
#        add_acronym
#        ;;
#    *)
#        find_acronym $1
#        ;;
#esac

