TYPES_FILE=types.xml
TYPE_INFO_FILE=type_info.xml
TYPE_LINEUPS_FILE=type_lineups.xml
TYPE_DATA_FILE=type_data.xml

DRIVE_STANDINGS_FILE=drivers_standings.xml
DRIVE_LIST_FILE=drivers_list.xml

MARKDOWN_FILE=type_page.md

error=0
invalid_arguments_number=0
null_api_key=0
year_error=0
information_not_found=0


if [ $# -ne 2 ]
then
    invalid_arguments_number=1
    error=1
fi

if [ -z "$API_KEY" ]
then
    null_api_key=1
    error=1
fi

if [ $2 -eq $2 2>/dev/null ]
then
    if [ $2 -lt 2013 ] || [ $2 -gt 2023 ]
    then
        year_error=2
        error=1
    fi
else
    year_error=1
    error=1
fi

if [ $error -eq 1 ]
then
    java net.sf.saxon.Query "type_id=$type_id" "invalid_arguments_number=$invalid_arguments_number" "null_api_key=$null_api_key" "information_not_found=$information_not_found" "year_error=$year_error" ./xqueries/extract_nascar_data.xq -o:./data/type_data.xml
    echo Data generated at data/$TYPE_DATA_FILE
    java net.sf.saxon.Transform -s:data/$TYPE_DATA_FILE -xsl:tools/add_validation_schema.xsl -o:data/$TYPE_DATA_FILE
    java net.sf.saxon.Transform -s:data/$TYPE_DATA_FILE -xsl:tools/generate_markdown.xsl -o:data/$MARKDOWN_FILE
    echo Page generated at data/$MARKDOWN_FILE
    exit 1
fi

competitionType=$1
year=$2


# Call to information and lineups endpoint
./scripts_bash/drivers_standings.sh $DRIVE_STANDINGS_FILE $competitionType $year
./scripts_bash/drivers_list.sh $DRIVE_LIST_FILE $competitionType $year

java net.sf.saxon.Query "invalid_arguments_number=$invalid_arguments_number" "null_api_key=$null_api_key" "information_not_found=$information_not_found" "year_error=$year_error" "year=$year" "competitionType=$competitionType" ./xqueries/extract_nascar_data.xq -o:./data/nascar_data.xml

# xsltproc -o ./tools/nascar_page.fo ./tools/generate_fo.xsl ./data/nascar_data.xml
java net.sf.saxon.Transform -s:data/nascar_data.xml -xsl:tools/generate_fo.xsl -o:tools/nascar_page.fo
./fop-2.9/fop/fop ./tools/nascar_page.fo  nascar_report.pdf

# java net.sf.saxon.Transform -s:data/$TYPE_DATA_FILE -xsl:tools/add_validation_schema.xsl -o:data/$TYPE_DATA_FILE
# echo Data generated at data/$TYPE_DATA_FILE
# java net.sf.saxon.Transform -s:data/$TYPE_DATA_FILE -xsl:tools/generate_markdown.xsl -o:data/$MARKDOWN_FILE
# echo Page generated at data/$MARKDOWN_FILE