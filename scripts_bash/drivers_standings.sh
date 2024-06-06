mkdir -p ../data
curl --request GET \
     --url "https://api.sportradar.com/nascar-ot3/$2/$3/standings/drivers.xml?api_key=${API_KEY}" \
     --header 'accept: application/json' -o ./data/$1
java net.sf.saxon.Transform -s:data/$1 -xsl:tools/namespaces.xsl -o:data/$1