#!/bin/bash 

# The point of this is to look up an acronym from an acronym file and display
# what it is

#Get the directory of the acro.sh file regardless of symlinks
SOURCE="${BASH_SOURCE[0]}"
while [ -h $SOURCE ]; do 
    DIR="$( cd -P "$( dirname "SOURCE" )" && pwd )"
    SOURCE="$(readlink "$SOURCE")"
    [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

ACRO_FILE="$DIR/acronyms.txt"
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

#Make sure that the acro file actually exsists
if [ ! -f "$ACRO_FILE" ]; then
    echo $ACRO_FILE does not exsist
    exit
fi

while getopts ":Aal:" opt;do
    case $opt in
        A)
            less $ACRO_FILE
            ;;
        a)
            add_acronym
            ;;
        l)
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

