TYPES_FILE=types.xml
TYPE_INFO_FILE=type_info.xml
TYPE_LINEUPS_FILE=type_lineups.xml
TYPE_DATA_FILE=type_data.xml
MARKDOWN_FILE=type_page.md

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
    java net.sf.saxon.Query "type_id=$type_id" "invalid_arguments_number=$invalid_arguments_number" "null_api_key=$null_api_key" "information_not_found=$information_not_found" "year_error=$year_error" ./queries/extract_type_data.xq -o:./data/type_data.xml
    echo Data generated at data/$TYPE_DATA_FILE
    java net.sf.saxon.Transform -s:data/$TYPE_DATA_FILE -xsl:helpers/add_validation_schema.xsl -o:data/$TYPE_DATA_FILE
    java net.sf.saxon.Transform -s:data/$TYPE_DATA_FILE -xsl:helpers/generate_markdown.xsl -o:data/$MARKDOWN_FILE
    echo Page generated at data/$MARKDOWN_FILE
    exit 1
fi

name_prefix=$1
year=$2

# Call to types endpoint
./scripts/types.sh $TYPES_FILE

# Get type id for name_prefix and year received
type_id=$(java net.sf.saxon.Query "types_file=$TYPES_FILE" "type_prefix=$name_prefix" "type_year=$year" ./queries/extract_type_id.xq)

if [ -z "$type_id" ]
then
    type_id="nullid"
    information_not_found=1
    error=1
fi

# Call to information and lineups endpoint
./scripts/type_info.sh $TYPE_INFO_FILE $type_id
./scripts/type_lineups.sh $TYPE_LINEUPS_FILE $type_id

java net.sf.saxon.Query "type_id=$type_id" "invalid_arguments_number=$invalid_arguments_number" "null_api_key=$null_api_key" "information_not_found=$information_not_found" "year_error=$year_error" ./queries/extract_type_data.xq -o:./data/type_data.xml

java net.sf.saxon.Transform -s:data/$TYPE_DATA_FILE -xsl:helpers/add_validation_schema.xsl -o:data/$TYPE_DATA_FILE
echo Data generated at data/$TYPE_DATA_FILE
java net.sf.saxon.Transform -s:data/$TYPE_DATA_FILE -xsl:helpers/generate_markdown.xsl -o:data/$MARKDOWN_FILE
echo Page generated at data/$MARKDOWN_FILE