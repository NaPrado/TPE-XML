declare option saxon:output "method=text";

declare variable $seasons_file as xs:string external;
declare variable $season_prefix as xs:string external;
declare variable $season_year as xs:integer external;

let $result := doc(concat("../data/", $seasons_file))//seasons/season[fn:contains(@name,$season_prefix) and @year = $season_year][1]/@id
return string($result)