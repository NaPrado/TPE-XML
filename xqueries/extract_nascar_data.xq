declare variable $invalid_arguments_number as xs:boolean external;
declare variable $null_api_key as xs:boolean external;
declare variable $information_not_found as xs:boolean external;
declare variable $year_error as xs:integer external;
declare variable $year as xs:string external;
declare variable $competitionType as xs:string external;
declare variable $too_many_requests as xs:boolean external;


declare function local:query-errors($errorMessage as xs:string) as element(nascar_data) {
  element nascar_data{
    element error{$errorMessage}
  }
};


declare function local:main-errors($invalid_arguments as xs:boolean, $null_api as xs:boolean, $info_not_found as xs:boolean, $year_error as xs:integer, $too_many_requests as xs:boolean) as element()* {
  element nascar_data{

    if ($invalid_arguments) then
      element error{"Invalid number of arguments Error"}
    else (),
    
    if ($null_api) then
      element error{"Null API Key Error"}
    else (),

    if($year_error eq 1)then
      element error{"Year must be a number"}
    else if($year_error eq 2) then
      element error{"Year must be greater or equal to 2013 and lower equal 2024"}
    else (),
    
    if ($info_not_found) then
      element error{ "Season not found" }
    else (),

    if ($too_many_requests) then
      element error{ "Too many requests Error" }
    else ()

  }
};



declare function local:generate-xml($year as xs:string, $competitionType as xs:string) as element(nascar_data) {
  
  let $driversList := doc("../data/drivers_list.xml")
  let $driversRanking := doc("../data/drivers_standings.xml")/series/season

  return
  if (empty($driversList/series)) then
    local:query-errors("Series not found")
  else if (empty($driversList/series/season)) then
    local:query-errors("Season not found")
  else if (empty($driversList/series/season/driver)) then
    local:query-errors("Drivers not found")
  else if (empty($driversRanking)) then
    local:query-errors("Rankings not found")
  else
  element nascar_data {
    element year { fn:string($year)},
    element serie_type {fn:string($competitionType)},
    element drivers {
      for $driver in $driversRanking/driver
      let $dList := $driversList/series/season/driver[@id=$driver/@id]
      return
      element driver {
        element full_name { fn:string($dList/@full_name)},
        element country { fn:string($dList/@country)},
        element birth_date { fn:string($dList/@birthday)},
        element birth_place { fn:string($dList/@birth_place)},
        element rank { fn:string($driver/@rank)},
        element car { 
            if (empty($dList/car/manufacturer/@name)) then
                fn:string('-')
            else
              fn:string(($dList/car/manufacturer/@name)[1])
        },
        element statistics {
          element season_points { fn:string($driver/@points)},
          element wins { fn:string($driver/@wins)},
          element poles { fn:string($driver/@poles)},
          element races_not_finished { fn:string($driver/@dnf)},
          element laps_completed { fn:string($driver/@laps_completed)}
        }
      }
    }
  }
};



if ($invalid_arguments_number or $null_api_key or $information_not_found or $too_many_requests or $year_error ne 0) then
  local:main-errors($invalid_arguments_number, $null_api_key, $information_not_found, $year_error, $too_many_requests)
else
  local:generate-xml(xs:string($year), xs:string($competitionType))
