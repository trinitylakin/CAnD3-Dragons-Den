*log using "\\smb-isl01.fsu.edu\citrix\tal15b\Documents\CAnD3\Dragon's Den\LAdatacleaning.log", replace
*** Tim & Trinity's Dragon's Den Project ***
*** Racial disparities in marijuana-related arrests in the city of Los Angeles USA 2010-2019 ***
import delimited "\\smb-isl01.fsu.edu\citrix\tal15b\Documents\CAnD3\Dragon's Den\Marijuana_Data_LA.csv"

*removing minors
drop if age<18

*simplifying descent code to black, white, hisp, asian/pacific islander, other
encode descentcode, gen(race)
recode race (3 4 5 8 9 11 14 =1)(7=10)(13=.)
recode race (6=3)(12=4)(10=5)
label define racesimp 1 "Asian or Pacific Islander" 2 "Black" 3 "Hispanic/Latino" 5 "Other" 4 "White"
label values race racesimp

*creating more clear value labels for arrest type, removing "dependent" and "other"
encode arresttypecode, gen (type)
drop if type==1 | type==5
label define type1 2 "Felony" 3 "Infraction" 4 "Misdemeanor"
label values type type1

*simplifying charge group description
encode chargedescription, gen (chargedesc)
recode chargedesc (1=26)(3 4 19 20 21 24 25 27 =2)(14 18=7)(5 6 9 10 11 12 13 15 16 17=8)(23=22)
recode chargedesc (2=1)(7=2)(8=3)(22=4)(26=5)
label define chargedesc1 3 "Possession" 2 "Possession w/ intent to sell" 1 "Distribution/Selling/Transporting" 5 "Cultivating" 4 "Public consumption"
label values chargedesc chargedesc1

*fixing arrest date var from string to numeric
gen date = date(arrestdate, "MDY")
format date %td
gen year=year(date)

*converting sexcode from str to numeric
encode sexcode, gen (sex)
label define sex1 1 "Female" 2 "Male"
label values sex sex1

*dropping missings
egen missings= rmiss(reportid year age sex race type chargedesc)
drop if missings >0

keep reportid year age sex race type chargedesc
rename chargedesc charge
sum 


