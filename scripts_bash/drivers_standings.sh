curl --request GET \
     --url "https://api.sportradar.com/nascar-ot3/$2/$3/standings/drivers.xml?api_key=0gxXlJUhbM9aWudST1e683BMnfg0AR2p59lLA7Fw" \
     --header 'accept: application/json' -o ./data/$1
java net.sf.saxon.Transform -s:data/$1 -xsl:tools/namespaces.xsl -o:data/$1