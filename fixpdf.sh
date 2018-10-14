#!/bin/bash

# This script tries to remove a link embedded on each page of a pdf file
# version 0.2
# Author: M. Ahsan
# last updated 2018-10-14 8:00PM EEST

usage() {
    echo "Usage: $0 [inputfile] [url]"
}

# check if the number of arguments is correct
checkargs() {
    if [ $# -ne 2 ]
    then
        echo "The script needs a pdf input file and url to be removed from the file."
        usage
        exit 1
    fi

}

# check if qpdf and sed are installed
CMD1="qpdf"
CMD2="sed"
checkutils() {
    for j in "$CMD1" "$CMD2"; do
        echo "checking if $j utility is available on this computer..."
        command -v $j > /dev/null
        if [ $? -ne 0 ]
        then
            echo "Command $j is not found in the path."
            echo "Cannot continue!"
            exit 1
        else
            echo "Found the $j utility in the path."
            echo "Continuing..."
        fi
    done
}

FILE=$1
URL=$2
STAGE1="stage1"
STAGE2="stage2"

# decompress the pdf file
decompresspdf() {
    echo "Decompressing the pdf file $FILE."
    if [ ! -e "$FILE" ]
    then
        echo "The file $FILE does not exist."
        echo "Cannot continue!"
        exit 1
    else
       "$CMD1" --stream-data=uncompress "$FILE" $STAGE1.pdf
       if [ $? -eq 0 ]
       then
           echo "Successfully decompressed the pdf file."
       else
           echo "Failed to decompress the pdf file!"
           exit 1
       fi
   fi
}

# remove the link from the decompressed pdf file
cleanpdf() {
    echo "Removing the url $URL from the file $FILE"
    $CMD2 -e "s/$URL/ /g" <$STAGE1.pdf >$STAGE2.pdf
    if [ $? -eq 0 ]
    then
        echo "Successfully removed the url from pdf file."
    else
        echo "Failed to remove the url from pdf file!"
        exit 1
    fi
}

# recompress the cleaned pdf file
compresspdf() {
    echo "Recompressing the pdf file."
    "$CMD1" --stream-data=compress $STAGE2.pdf cleanedfile.pdf >& /dev/null
}

checkargs "$@"
checkutils
decompresspdf
cleanpdf
compresspdf
echo "Removing intermediate files."
rm -rf stage*.pdf
echo
echo "All done."
echo
