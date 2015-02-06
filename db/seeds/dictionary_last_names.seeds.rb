after :value_types do
  last_names = %w(smith johnson williams brown jones miller davis garcia rodriguez wilson martinez anderson taylor thomas hernandez moore martin jackson thompson white lopez lee gonzalez harris clark lewis robinson walker perez hall young allen sanchez wright king scott green baker adams nelson hill ramirez campbell mitchell roberts carter phillips evans turner torres parker collins edwards stewart flores morris nguyen murphy rivera cook rogers morgan peterson cooper reed bailey bell gomez kelly howard ward cox diaz richardson wood watson brooks bennett gray james reyes cruz hughes price myers long foster sanders ross morales powell sullivan russell ortiz jenkins gutierrez perry butler barnes fisher henderson coleman simmons patterson jordan reynolds hamilton graham kim gonzales alexander ramos wallace griffin west cole hayes chavez gibson bryant ellis stevens murray ford marshall owens mcdonald harrison ruiz kennedy wells alvarez woods mendoza castillo olson webb washington tucker freeman burns henry vasquez snyder simpson crawford jimenez porter mason shaw gordon wagner hunter romero hicks dixon hunt palmer robertson black holmes stone meyer boyd mills warren fox rose rice moreno schmidt patel ferguson nichols herrera medina ryan fernandez weaver daniels stephens gardner payne kelley dunn pierce arnold tran spencer peters hawkins grant hansen castro hoffman hart elliott cunningham knight bradley carroll hudson duncan armstrong berry andrews johnston ray lane riley carpenter perkins aguilar silva richards willis matthews chapman lawrence garza vargas watkins wheeler larson carlson harper george greene burke guzman morrison munoz jacobs obrien lawson franklin lynch bishop carr salazar austin mendez gilbert jensen williamson montgomery harvey oliver howell dean hanson weber garrett sims burton fuller soto mccoy welch chen schultz walters reid fields walsh little fowler bowman davidson may day schneider newman brewer lucas holland wong banks santos curtis pearson delgado valdez pena rios douglas sandoval barrett hopkins keller guerrero stanley bates alvarado beck ortega wade estrada contreras barnett caldwell santiago lambert powers chambers nunez craig leonard lowe rhodes byrd gregory shelton frazier becker maldonado fleming vega sutton cohen jennings parks mcdaniel watts barker norris vaughn vazquez holt schwartz steele benson neal dominguez horton terry wolfe hale lyons graves haynes miles park warner padilla bush thornton mccarthy mann zimmerman erickson fletcher mckinney page dawson joseph marquez reeves klein espinoza baldwin moran love robbins higgins ball cortez le griffith bowen sharp cummings ramsey hardy swanson barber acosta luna chandler blair daniel cross simon dennis oconnor quinn gross navarro moss fitzgerald doyle mclaughlin rojas rodgers stevenson singh yang figueroa harmon newton paul manning garner mcgee reese francis burgess adkins goodman curry brady christensen potter walton goodwin mullins molina webster fischer campos avila sherman todd chang blake malone wolf hodges juarez gill farmer hines gallagher duran hubbard cannon miranda wang saunders tate mack hammond carrillo townsend wise ingram barton mejia ayala schroeder hampton rowe parsons frank waters strickland osborne maxwell chan deleon norman harrington casey patton logan bowers mueller glover floyd hartman buchanan cobb french kramer mccormick clarke tyler gibbs moody conner sparks mcguire leon bauer norton pope flynn hogan robles salinas yates lindsey lloyd marsh mcbride owen solis pham lang pratt lara brock ballard trujillo shaffer drake roman aguirre morton stokes lamb pacheco patrick cochran shepherd cain burnett hess li cervantes olsen briggs ochoa cabrera velasquez montoya roth meyers cardenas fuentes weiss hoover wilkins nicholson underwood short carson morrow colon holloway summers bryan petersen mckenzie serrano wilcox carey clayton poole calderon gallegos greer rivas guerra decker collier wall whitaker bass flowers davenport conley houston huff copeland hood monroe massey roberson combs franco larsen pittman randall skinner wilkinson kirby cameron bridges anthony richard kirk bruce singleton mathis bradford boone abbott charles allison sweeney atkinson horn jefferson rosales york christian phelps farrell castaneda nash dickerson bond wyatt foley chase gates vincent mathews hodge garrison trevino villarreal heath dalton valencia callahan hensley atkins huffman roy boyer shields lin hancock grimes glenn cline delacruz camacho dillon parrish oneill melton booth kane berg harrell pitts savage wiggins brennan salas marks russo sawyer baxter golden hutchinson liu walter mcdowell wiley rich humphrey johns koch suarez hobbs beard gilmore ibarra keith macias khan andrade ware stephenson henson wilkerson dyer mcclure blackwell mercado tanner eaton clay barron beasley oneal preston small wu zamora macdonald vance snow mcclain stafford orozco barry english shannon kline jacobson woodard huang kemp mosley prince merritt hurst villanueva roach nolan lam yoder mccullough lester santana valenzuela winters barrera leach orr berger mckee strong conway stein whitehead bullock escobar knox meadows solomon velez odonnell kerr stout blankenship browning kent lozano bartlett pruitt buck barr gaines durham gentry mcintyre sloan melendez rocha herman sexton moon hendricks rangel stark lowery hardin hull sellers ellison calhoun gillespie mora knapp mccall morse dorsey weeks nielsen livingston leblanc mclean bradshaw glass middleton buckley schaefer frost howe house mcintosh ho pennington reilly hebert mcfarland hickman noble spears conrad arias galvan velazquez huynh frederick randolph cantu fitzpatrick mahoney peck villa michael donovan mcconnell walls boyle mayer zuniga giles pineda pace hurley mays mcmillan crosby ayers case bentley shepard everett pugh david mcmahon dunlap bender hahn harding acevedo raymond blackburn duffy landry dougherty bautista shah potts arroyo valentine meza gould vaughan fry rush avery herring dodson clements sampson tapia bean lynn crane farley cisneros benton ashley mckay finley best blevins friedman moses sosa blanchard huber frye krueger bernard rosario rubio mullen benjamin haley chung moyer choi horne yu woodward ali nixon hayden rivers estes mccarty richmond stuart maynard brandt oconnell hanna sanford sheppard church burch levy rasmussen coffey ponce faulkner donaldson schmitt novak costa montes booker cordova waller arellano maddox mata bonilla stanton compton kaufman dudley mcpherson beltran dickson mccann villegas proctor hester cantrell daugherty cherry bray davila rowland levine madden spence good irwin werner krause petty whitney baird hooper pollard zavala jarvis holden haas hendrix mcgrath bird lucero terrell riggs joyce mercer rollins galloway duke odom andersen downs hatfield benitez archer huerta travis mcneil hinton zhang hays mayo fritz branch mooney ewing ritter esparza frey braun gay riddle haney kaiser holder chaney mcknight gamble vang cooley carney cowan forbes ferrell davies barajas shea osborn bright cuevas bolton murillo lutz duarte kidd key cooke)

  last_names.each do |last_name|
    dictionary = Dictionary.new
    dictionary.value_type_id = ValueType.where(key: 'last_name').first.id
    dictionary.value = last_name
    dictionary.save
  end
end
