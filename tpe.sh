DRIVE_STANDINGS_FILE=drivers_standings.xml
DRIVE_LIST_FILE=drivers_list.xml

error=0
invalid_arguments_number=0
null_api_key=0
year_error=0
information_not_found=0
long=$(expr length "$API_KEY")

competitionType=$1
year=$2


ValidYear(){
    if [[ ! $1 =~ ^[0-9]*{4}$ ]]
    then
        echo "$1 not a number"
        year_error=1
        return 2
    fi

    if [ $1 -lt 2013 ] || [ $1 -gt 2023 ]
    then
        echo "The year choosen has to be between 2013 and 2023"
        year_error=1
        return 2
    fi
    return 0
}

# AskYearAgain(){

#     while [ true ]
#     do
#         echo "input a valid year"
#         read x
#         ValidYear $x
#         if [ $? -eq 0 ]
#         then
#             year="$x"
#             return 0
#         fi
#     done
# }
ValidCompetition(){
    if [[ ! $1 =~ (sc|xf|cw|go|mc)$ ]]
    then
        echo "Wrong categorie input error"
        echo "valid categories sc, xf, cw, go or mc"
        information_not_found=1
        return 2
    fi
    return 0
}

# AskCompetitionAgain(){
    
#     while [ true ]
#     do
#         echo "input a valid categorie"
#         read y
#         ValidCompetition $y
#         if [ $? -eq 0 ]
#         then
#             competitionType="$y"
#             return 0
#         fi
#     done
# }


if [ $# -ne 2 ]
then
    echo "Invalid number of arguments error"
    echo "Try ./tpe.sh [Competition] [Year]"
    invalid_arguments_number=1
fi

#$API_KEY must be 40 chars long
if [ 40 -ne $long ]
then
    echo "Invalid Api Key or not found"
    null_api_key=1
fi

ValidYear $2

ValidCompetition $1


# Call to information and lineups endpoint
./scripts_bash/drivers_standings.sh $DRIVE_STANDINGS_FILE $competitionType $year
if [ $? -ne 0 ]
then
    error=1
fi
./scripts_bash/drivers_list.sh $DRIVE_LIST_FILE $competitionType $year
if [ $? -ne 0 ]
then
    error=1
fi

echo "Geting data..."
java net.sf.saxon.Query "invalid_arguments_number=$invalid_arguments_number" "null_api_key=$null_api_key" "information_not_found=$information_not_found" "year_error=$year_error" "year=$year" "competitionType=$competitionType" ./xqueries/extract_nascar_data.xq -o:./data/nascar_data.xml > /dev/null 2>&1

echo "Generating '.fo' archive"
java net.sf.saxon.Transform -s:data/nascar_data.xml -xsl:tools/generate_fo.xsl -o:tools/nascar_page.fo > /dev/null 2>&1

echo "Making the .pdf archive"
./fop-2.9/fop/fop ./tools/nascar_page.fo  nascar_report.pdf > /dev/null 2>&1
echo "The pdf name as \"nascar_report.pdf\" can be found at the actual directory"