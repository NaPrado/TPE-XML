tooManyRequests=0
echo "Runining API for drivers_standings.xml of the competition $2 from the year $3"
curl --request GET \
     --url "https://api.sportradar.com/nascar-ot3/$2/$3/standings/drivers.xml?api_key=$API_KEY" \
     --header 'accept: application/json' -o ./data/$1\
     -s
java net.sf.saxon.Transform -s:data/$1 -xsl:tools/namespaces.xsl -o:data/$1 > /dev/null 2>&1
if cat "./data/drivers_standings.xml" | grep -q "Authentication Error" ;
then
    echo "Authentication Error, Invalid Api key"
    echo "Make sure you have configured it in .bashrc"
    exit 2
fi