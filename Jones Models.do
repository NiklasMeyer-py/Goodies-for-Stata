
*** Für die Berechnung von Jones-Models - Wooohooo!
*** Überall da, wo GROSSBUCHSTABEN sind, müsst ihr eure jeweiligen Variablen eintragen.
*** Diese Logik ist auch für andere two-stage Modelle anwendbar (s. Dechow and Dichev, 2002; Roychowdhury, 2006).

gen scaler = L.TOTALASSETS

* Jones Models (Jones, 1991; Dechow et al., 1995; McNichols, 2002; Hribar and Collins, 2002; Kothari et al., 2005)
gen ass = 1/scaler
gen rev = (REVENUE-L.REVENUE)/scaler
gen revrec = ((REVENUE-L.REVENUE)-(ACCOUNTSRECEIVABLE-L.ACCOUNTSRECEIVABLE))/scaler
gen ppe = PROPERTYPLANTANDEQUIPMENT/scaler
gen roa = NETINCOME/scaler
gen cfo = CASHFLOWFROMOPERATIONS/scaler

gen tacc1 = ((CURRENTASSETS-L.CURRENTASSETS)-(CURRENTLIABILITIES-L.CURRENTLIABILITIES)-(CASH-L.CASH)+(SHORTTERMDEBT-L.SHORTTERMDEBT)-DEPRECIATIONANDAMORTIZATION)/scaler
gen tacc2 = (NETINCOME-(CASH-L.CASH))/scaler
gen tacc3 = (OPERATINGINCOME-CASHFLOWFROMOPERATIONS)/scaler

local model1 = "ass rev ppe"
local model2 = "ass revrec ppe"
local model3 = "ass revrec ppe roa"
local model4 = "ass revrec ppe cfo"
local model5 = "ass revrec ppe roa cfo"

/*
* Für ein Dechow and Dichev (2002) Model
gen dndwcap = (WORKINGCAPITAL-L.WORKINGCAPITAL)/scaler
gen dndlcfo = L.CASHFLOWFROMOPERATIONS/scaler
gen dndccfo = CASHFLOWFROMOPERATIONS/scaler
gen dndfcfo = F.CASHFLOWFROMOPERATIONS/scaler

local completemodeldnd = "dndwcap dndlcfo dndccfo dndfcfo"


* Für ein Roychowdhury (2006) Model
gen roycfo = CASHFLOWFROMOPERATIONS/scaler
gen roycgs = COGS/scaler
gen royinv = (INVENTORY-L.INVENTORY)/scaler
gen roypro = (COGS+(INVENTORY-L.INVENTORY))/scaler
gen royexp = DISCRETIONARYEXPENSES/scaler

gen royass = 1/scaler
gen roycrv = REVENUE/scaler
gen roydrv = (REVENUE-L.REVENUE)/scaler
gen roylrv = L.REVENUE/scaler
gen roytrv = (L.REVENUE-L2.REVENUE)/scaler

local completemodelroycfo = "roycfo royass roycrv roydrv"
local completemodelroycgs = "roycgs royass roycrv"
local completemodelroyinv = "royinv royass roydrv roytrv"
local completemodelroypro = "roypro royass roycrv roydrv roytrv"
local completemodelroyexp = "roypro royass roylrv"
*/

* Gruppe, innerhalb derer die first-stage Regression 
egen group_id = group(INDUSTRIE JAHR)

/*
*** Für Modelle mit Size-Matching (Ecker et al., 2013) oder Performance-Matching (Kothari et al., 2005):
egen match_decile = xtile(MATCHINGVARIABLE), n(10)

egen group_id = group(INDUSTRIE JAHR match_decile)
*/


forvalues t = 1/3 {
	forvalues m=1/5 {
		gen RESIDUALS=.
		levelsof group_id, local(groups)
		foreach g in `groups' {
			cap reg tacc`t' `model`m'' if group_id==`g'
			cap predict RESIDUALSTEMP if group_id==`g', re
			cap replace RESIDUALS = RESIDUALSTEMP if group_id==`g'
			cap drop RESIDUALSTEMP
		}
		rename RESIDUALS RESIDUALS_t`t'_m`m'
		winsor2 RESIDUALS_t`t'_m`m', replace cuts(1 99)
		gen abs_RESIDUALS_t`t'_m`m' = abs(RESIDUALS_t`t'_m`m')
	}
}


*** Denkt daran, die first-stage Variablen in eure second-stage Regression mit aufzunehmen, wenn Discretionary Accruals eure abhängige Variable in der second-stage Regression sind (Chen et al., 2017)!!!
