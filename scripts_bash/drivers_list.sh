echo "Runining API for drivers_list.xml of the competition $2 from the year $3"
curl --request GET \
     --url "https://api.sportradar.com/nascar-ot3/$2/$3/drivers/list.xml?api_key=$API_KEY" \
     --header 'accept: application/json' -o ./data/$1\
     -s
java net.sf.saxon.Transform -s:data/$1 -xsl:tools/namespaces.xsl -o:data/$1 > /dev/null 2>&1