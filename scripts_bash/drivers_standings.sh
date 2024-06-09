echo "Runining API for drivers_standings.xml of the competition $2 from the year $3"
curl --request GET \
     --url "https://api.sportradar.com/nascar-ot3/$2/$3/standings/drivers.xml?api_key=0gxXlJUhbM9aWudST1e683BMnfg0AR2p59lLA7Fw" \
     --header 'accept: application/json' -o ./data/$1\
     -s
if head -n 1 "./data/drivers_standings.xml" | grep -q "{\"message\":\"Too Many Requests\"}" ;
then
    echo "Api error: \"Too Many Requests\" "
    echo "Try again"
    exit 2
fi
java net.sf.saxon.Transform -s:data/$1 -xsl:tools/namespaces.xsl -o:data/$1