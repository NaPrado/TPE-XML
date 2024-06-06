declare variable $invalid_arguments_number as xs:boolean external;
declare variable $null_api_key as xs:boolean external;
declare variable $information_not_found as xs:boolean external;
declare variable $year_error as xs:integer external;
declare variable $year as xs:string external;
declare variable $competitionType as xs:string external;

declare function local:query-errors($errorMessage as xs:string) as element(nascar_data) {
  element nascar_data{
    element error{$errorMessage}
  }
};


declare function local:main-errors($invalid_arguments as xs:boolean, $null_api as xs:boolean, $info_not_found as xs:boolean, $year_error as xs:integer) as element()* {
  element nascar_data{

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
      element error{ "Season not found" }
    else ()

  }
};



declare function local:generate-xml($year as xs:string, $competitionType as xs:string) as element(nascar_data) {
  
  let $driversList := doc("../data/drivers_list.xml")
  let $driversRanking := doc("../data/drivers_standings.xml")/series/season

  return
  element nascar_data {
    element year { fn:string($year)},
    element serie_type {fn:string($competitionType)},
    element drivers {
      for $driver in $driversList/series/season/driver
      let $ranking := $driversRanking/driver[@id=$driver/@id]
      return
      element driver {
        element full_name { fn:string($driver/@full_name)},
        element country { fn:string($driver/@country)},
        element birth_date { fn:string($driver/@birth_place)},
        element rank { fn:string($ranking/@rank)},
        (:~ element car { fn:string($driversList/series/season/driver/car/manufacturer/@name[../../../team/@id = $driver/team/@id and ../../../@id = $driver/@id])}, ~:)
        element statistics {
          element season_points { fn:string($ranking/@points)},
          element wins { fn:string($ranking/@wins)},
          element poles { fn:string($ranking/@poles)},
          element races_not_finished { fn:string($ranking/@dnf)},
          element laps_completed { fn:string($ranking/@laps_completed)}
        }
      }
    }
  }
};



if ($invalid_arguments_number or $null_api_key or $information_not_found or $year_error ne 0) then
  local:main-errors($invalid_arguments_number, $null_api_key, $information_not_found, $year_error)
else
  local:generate-xml(xs:string($year), xs:string($competitionType))
