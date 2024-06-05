SEASONS_FILE=seasons.xml
SEASON_INFO_FILE=season_info.xml
SEASON_LINEUPS_FILE=season_lineups.xml
SEASON_DATA_FILE=season_data.xml
MARKDOWN_FILE=season_page.md

error=0
invalid_arguments_number=0
null_api_key=0
year_error=0
information_not_found=0
year_min=2013
year_max=2023

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
    if [ $2 -lt year_min ] || [ $2 -gt year_max ]
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
    java net.sf.saxon.Query "season_id=$season_id" "invalid_arguments_number=$invalid_arguments_number" "null_api_key=$null_api_key" "information_not_found=$information_not_found" "year_error=$year_error" ./queries/extract_season_data.xq -o:./data/season_data.xml
    echo Data generated at data/$SEASON_DATA_FILE
    java net.sf.saxon.Transform -s:data/$SEASON_DATA_FILE -xsl:helpers/add_validation_schema.xsl -o:data/$SEASON_DATA_FILE
    java net.sf.saxon.Transform -s:data/$SEASON_DATA_FILE -xsl:helpers/generate_markdown.xsl -o:data/$MARKDOWN_FILE
    echo Page generated at data/$MARKDOWN_FILE
    exit 1
fi

name_prefix=$1
year=$2

# Call to seasons endpoint
./scripts/seasons.sh $SEASONS_FILE

# Get season id for name_prefix and year received
season_id=$(java net.sf.saxon.Query "seasons_file=$SEASONS_FILE" "season_prefix=$name_prefix" "season_year=$year" ./queries/extract_season_id.xq)

if [ -z "$season_id" ]
then
    season_id="nullid"
    information_not_found=1
    error=1
fi

# Call to information and lineups endpoint
./scripts/season_info.sh $SEASON_INFO_FILE $season_id
./scripts/season_lineups.sh $SEASON_LINEUPS_FILE $season_id

java net.sf.saxon.Query "season_id=$season_id" "invalid_arguments_number=$invalid_arguments_number" "null_api_key=$null_api_key" "information_not_found=$information_not_found" "year_error=$year_error" ./queries/extract_season_data.xq -o:./data/season_data.xml

java net.sf.saxon.Transform -s:data/$SEASON_DATA_FILE -xsl:helpers/add_validation_schema.xsl -o:data/$SEASON_DATA_FILE
echo Data generated at data/$SEASON_DATA_FILE
java net.sf.saxon.Transform -s:data/$SEASON_DATA_FILE -xsl:helpers/generate_markdown.xsl -o:data/$MARKDOWN_FILE
echo Page generated at data/$MARKDOWN_FILE