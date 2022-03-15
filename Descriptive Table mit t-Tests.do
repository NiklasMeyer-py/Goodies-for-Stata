

* Überall da, wo GROSSBUCHSTABEN sind, müsst ihr eure Variablen/Gruppen/Treatment eintragen.
* Wenn ihr die Tabellen ohne Standard Deviation haben wollt, müsst ihr alle Sachen mit "s1" und "s2" wegnehmen.


* FULL SAMPLE
cap matrix drop desc
* Hinter das "varlist" kommen die gewünschten Variablen.
foreach var of varlist VAR1 VAR2 VAR3 VAR4 {
    * In die Klammer kommt eure Treatment-Variable.
	ttest `var', by(TREATMENT)
	local m1 = `r(mu_1)'
	local m2 = `r(mu_2)'
	local s1 = `r(sd_1)'
	local s2 = `r(sd_2)'
	local n1 = `r(N_1)'
	local n2 = `r(N_2)'
	local d = `r(mu_1)' - `r(mu_2)'
	local p = `r(p)'
	
	cap confirm matrix desc
	if !_rc {
		matrix define desc = (desc \ `n1', `m1', `s1', `n2', `m2', `s2', `d', `p')
	} 
	else {
		matrix define desc = (`n1', `m1', `s1', `n2', `m2', `s2', `d', `p')
	}
}
* Hier die gewünschten Spalten- und Zeilennamen eingeben.
* Aber aufpassen, dass die Spaltennamen immer gleich 8 sind (oder 6 ohne SD) und die Zeilennamen gleich der Anzahl an verwendeten Variablen! 
matrix colnames desc = "N - Control Group" "Mean - Control Group" "SD - Control Group" "N - Treatment Group" "Mean - Treatment Group" "SD - Treatment Group" "Difference" "p-value"
matrix rownames desc = "Var1" "Var2" "Var3" "Var4"
* Hiermit wird euch die Matrix dann angezeigt und ihr könnt sie rauskopieren.
matrix list desc


* GROUPED SAMPLE WITH GROUP IDS
cap matrix drop bygr
* Hier die gewünschte Gruppe als ID eintragen.
* Zwar muss man die nachher ggfs. händisch ändern, aber man kann sie besser erkennen.
levelsof GROUP, local(groups)
foreach group in `groups' {
    cap matrix drop desc
	* Hinter das "varlist" kommen die gewünschten Variablen.
	foreach var of varlist VAR1 VAR2 VAR3 VAR4 {
		* In die Klammer kommt eure Treatment-Variable.
		* Die Gruppe müsst ihr hier ebenfalls anpassen
		ttest `var' if GROUP==`group', by(TREATMENT)
		local m1 = `r(mu_1)'
		local m2 = `r(mu_2)'
		local s1 = `r(sd_1)'
		local s2 = `r(sd_2)'
		local n1 = `r(N_1)'
		local n2 = `r(N_2)'
		local d = `r(mu_1)' - `r(mu_2)'
		local p = `r(p)'
		
		cap confirm matrix desc
		if !_rc {
			matrix define desc = (desc \ `group', `n1', `m1', `s1', `n2', `m2', `s2', `d', `p')
		} 
		else {
			matrix define desc = (`group', `n1', `m1', `s1', `n2', `m2', `s2', `d', `p')
		}
	}
	* Hier die gewünschten Spalten- und Zeilennamen eingeben.
	* Aber aufpassen, dass die Spaltennamen immer gleich 9 sind (oder 7 ohne SD; hier eine mehr für die Gruppen-ID) und die Zeilennamen gleich der Anzahl an verwendeten Variablen! 
	matrix colnames desc = "Group ID" "N - Control Group" "Mean - Control Group" "SD - Control Group" "N - Treatment Group" "Mean - Treatment Group" "SD - Treatment Group" "Difference" "p-value"
	matrix rownames desc = "Var1" "Var2" "Var3" "Var4"
	
	cap confirm matrix bygr
	if !_rc {
		matrix define bygr = (bygr \ desc)
	} 
	else {
		matrix define bygr = (desc)
	}
}
* Hiermit wird euch die Matrix dann angezeigt und ihr könnt sie rauskopieren.
matrix list bygr


* GROUPED SAMPLE WITH GROUP STRINGS
cap matrix drop bygr
* Hier die gewünschte Gruppe als Text (Strings) eintragen.
* Zwar werden die in den Zeilennamen direkt eingefügt, jedoch kann man das je nach Länge der Gruppen- und Variablennamen ggfs. nur schlecht erkennen.
levelsof GROUP, local(groups)
foreach group in `groups' {
    cap matrix drop desc
	* Hinter das "varlist" kommen die gewünschten Variablen.
	foreach var of varlist VAR1 VAR2 VAR3 VAR4 {
		* In die Klammer kommt eure Treatment-Variable.
		* Die Gruppe müsst ihr hier ebenfalls anpassen
		ttest `var' if GROUP=="`group'", by(TREATMENT)
		local m1 = `r(mu_1)'
		local m2 = `r(mu_2)'
		local s1 = `r(sd_1)'
		local s2 = `r(sd_2)'
		local n1 = `r(N_1)'
		local n2 = `r(N_2)'
		local d = `r(mu_1)' - `r(mu_2)'
		local p = `r(p)'
		
		cap confirm matrix desc
		if !_rc {
			matrix define desc = (desc \ `n1', `m1', `s1', `n2', `m2', `s2', `d', `p')
		} 
		else {
			matrix define desc = (`n1', `m1', `s1', `n2', `m2', `s2', `d', `p')
		}
	}
	* Hier die gewünschten Spalten- und Zeilennamen eingeben. 
	* Aber aufpassen, dass die Spaltennamen immer gleich 8 sind (oder 6 ohne SD) und die Zeilennamen gleich der Anzahl an verwendeten Variablen! Außerdem aufpassen, dass ihr `group' nicht verändert und nur den Spaltennamen einfach dahinter schreibt.
	matrix colnames desc = "N - Control Group" "Mean - Control Group" "SD - Control Group" "N - Treatment Group" "Mean - Treatment Group" "SD - Treatment Group" "Difference" "p-value"
	matrix rownames desc = "`group'  Var1" "`group'  Var2" "`group'  Var3" "`group'  Var4"
	
	cap confirm matrix bygr
	if !_rc {
		matrix define bygr = (bygr \ desc)
	} 
	else {
		matrix define bygr = (desc)
	}
}
* Hiermit wird euch die Matrix dann angezeigt und ihr könnt sie rauskopieren.
matrix list bygr