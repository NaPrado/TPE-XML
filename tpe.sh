DRIVE_STANDINGS_FILE=drivers_standings.xml
DRIVE_LIST_FILE=drivers_list.xml

hasAnErrorOcurred=0
error=0
invalid_arguments_number=0
null_api_key=0
year_error=0
information_not_found=0
tooManyRequests=0

competitionType=$1
year=$2

ValidYear(){
    if ! [[ $1 =~ ^[0-9]{1,4}$ ]];
    then
        echo "$1 not a number"
        year_error=1
        hasAnErrorOcurred=1
        return 2
    fi

    if [ $1 -lt 2013 ] || [ $1 -ge 2024 ]
    then
        echo "The year choosen has to be between 2013 and 2024"
        year_error=2
        hasAnErrorOcurred=1
        return 2
    fi
    return 0
}

ValidCompetition(){
    if [[ ! $1 =~ (sc|xf|cw|go|mc)$ ]]
    then
        echo "Wrong categorie input error"
        echo "valid categories sc, xf, cw, go or mc"
        information_not_found=1
        hasAnErrorOcurred=1
        return 2
    fi
    return 0
}

if [ $# -ne 2 ]
then
    echo "Invalid number of arguments error"
    echo "Try ./tpe.sh [Competition] [Year]"
    invalid_arguments_number=1
    hasAnErrorOcurred=1
fi

#$SPORTRADAR_API must be 40 chars long
if [ -z $SPORTRADAR_API ]
then
    echo "Invalid Api Key or not found"
    null_api_key=1
    hasAnErrorOcurred=1
fi

ValidYear $2

ValidCompetition $1


# Call to information and lineups endpoint
./scripts_bash/drivers_standings.sh $DRIVE_STANDINGS_FILE $competitionType $year
errorkey=$?
if [ $errorkey -eq 2 ]
then
    null_api_key=1
    error=1
    hasAnErrorOcurred=1
fi
if head -n 1 "./data/drivers_standings.xml" | grep -q "{\"message\":\"Too Many Requests\"}" ;
then
    echo "Api error: \"Too Many Requests\" "
    echo "Try again"
    tooManyRequests=1
    hasAnErrorOcurred=1
fi
if head -n 1 "./data/drivers_standings.xml" | grep -q "{\"message\":\"Object not found\"}" ;
then
    echo "Wrong categorie input error"
    echo "valid categories sc, xf, cw, go or mc"
    information_not_found=1
    hasAnErrorOcurred=1
fi

./scripts_bash/drivers_list.sh $DRIVE_LIST_FILE $competitionType $year
if head -n 1 "./data/drivers_list.xml" | grep -q "{\"message\":\"Too Many Requests\"}" ;
then
    echo "Api error: \"Too Many Requests\" "
    echo "Try again"
    tooManyRequests=1
    hasAnErrorOcurred=1
fi

echo "Geting data..."
java net.sf.saxon.Query "invalid_arguments_number=$invalid_arguments_number" "null_api_key=$null_api_key" "information_not_found=$information_not_found" "year_error=$year_error" "year=$year" "competitionType=$competitionType" "too_many_requests=$tooManyRequests" ./xqueries/extract_nascar_data.xq -o:./data/nascar_data.xml > /dev/null 2>&1

echo "Generating '.fo' archive"
if [ $hasAnErrorOcurred -eq 0 ]
then
    java net.sf.saxon.Transform -s:data/nascar_data.xml -xsl:tools/generate_fo.xsl -o:tools/nascar_page.fo > /dev/null 2>&1
else
    java net.sf.saxon.Transform -s:data/nascar_data.xml -xsl:tools/generate_fo_error.xsl -o:tools/nascar_page.fo > /dev/null 2>&1
fi

echo "Making the .pdf archive"
./fop-2.9/fop/fop ./tools/nascar_page.fo  nascar_report.pdf > /dev/null 2>&1
echo "The pdf name as \"nascar_report.pdf\" can be found at the actual directory"