declare variable $season_id as xs:string external;
declare variable $invalid_arguments_number as xs:boolean external;
declare variable $null_api_key as xs:boolean external;
declare variable $information_not_found as xs:boolean external;
declare variable $year_error as xs:integer external;

declare function local:query-errors($errorMessage as xs:string) as element(season_data) {
  element season_data{
    element error{$errorMessage}
  }
};

declare function local:main-errors($invalid_arguments as xs:boolean, $null_api as xs:boolean, $info_not_found as xs:boolean, $year_error as xs:integer) as element()* {
  element season_data{

    if ($invalid_arguments) then
      element error{"Invalid number of arguments"}
    else (),
    
    if ($null_api) then
      element error{"Null API Key"}
    else (),

    if($year_error eq 1)then
      element error{"Year must be a number"}
    else if($year_error eq 2) then
      element error{"Year must be greater or equal to 2007"}
    else (),
    
    if ($info_not_found) then
      element error{
        if (doc("../data/season_info.xml")//h1) then
          "Invalid API Key"
        else if(doc("../data/season_info.xml")//page_not_found) then
          "Season not found"
        else ()
      }
    else ()

  }
};


declare function local:generate-xml($seasonId as xs:string) as element(season_data) {

  let $seasonInfo := doc("../data/season_info.xml")/season_info
  let $seasonLineup := doc("../data/season_lineups.xml")/season_lineups

  return
  if (empty($seasonInfo/season[@id = $seasonId])) then
    local:query-errors("Season not found")
  else if (empty($seasonInfo/stages/stage)) then
    local:query-errors("Stages not found")
  else if (empty($seasonInfo/stages/stage/groups/group)) then
    local:query-errors("Groups not found")
  else if (empty($seasonInfo/stages/stage/groups/group/competitors/competitor)) then
    local:query-errors("Competitors not found")
  else
  element season_data {
    element season {
      element name { fn:string($seasonInfo/season/@name) },
      element competition {
        element name { fn:string($seasonInfo/season/competition/@name)},
        element gender { fn:string($seasonInfo/season/competition/@gender)}
      },
      element date{
        element start {fn:string($seasonInfo/season/@start_date)},
        element end {fn:string($seasonInfo/season/@end_date)},
        element year {fn:string($seasonInfo/season/@year)}
      }
    },
    element stages {
      for $stage in $seasonInfo/stages/stage
      return
      element stage{
        attribute phase {$stage/@phase},
        attribute start_date {$stage/@start_date},
        attribute end_date {$stage/@end_date},
        element groups {
          for $group in $stage/groups/group
          return
          element group{
            for $competitor in $group/competitors/competitor
            return
            element competitor{
              attribute id {$competitor/@id},
              element name {fn:string($competitor/@name)},
              element abbreviation {fn:string($competitor/@abbreviation)}
            }
          }
        }
      }
    },
    
    element competitors {
      for $competitor in distinct-values($seasonInfo/stages/stage/groups/group/competitors/competitor/@name)
      return
      element competitor{
        element name {fn:string($competitor)},
        element players {
          for $player in distinct-values($seasonLineup/lineup/lineups/competitors/competitor[@name = $competitor]/players/player/@id)
          let $actual := ($seasonLineup/lineup/lineups/competitors/competitor/players/player[@id = $player])[1]
          return
          element player {
            attribute id {$player},
            element name {fn:string($actual/@name)}, 
            element type {fn:string($actual/@type)},
            element date_of_birth {fn:string($actual/@date_of_birth)},
            element nationality {fn:string($actual/@nationality)},
            element events_played {count($seasonLineup/lineup/lineups/competitors/competitor[@name = $competitor]/players/player[@id = $player and @played = 'true'])}
          }
        }
      }
    }  
  }
}; 


if($invalid_arguments_number or $null_api_key or $information_not_found or $year_error ne 0) then
  local:main-errors($invalid_arguments_number, $null_api_key, $information_not_found, $year_error)
else
  local:generate-xml($season_id)