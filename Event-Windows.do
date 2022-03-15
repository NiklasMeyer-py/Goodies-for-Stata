* Ein Skript, um Event-Windows zu erstellen!
* Es werden außerdem nur solche Eventperioden markiert, bei denen sich keine Eventperioden überschneiden, und dementsprechend wird eine neue Eventvariable erstellt.
* Beachtet, dass das nur funktioniert, wenn eure Eventperioden kürzer sind als die Länge der durchgängigen Zeitreihe im xtset (i.e., keine Gaps zwischendrin, z.B. bei Wochenenden) und eure Eventperiode symmetrisch ist!
* (Für durchgängige Eventperioden könnt ihr über egen DATEVAR = group(date) eine Hilfsvariable erstellen.)
* (Für asymmetrische Eventperioden könnt ihr egen WINDOWVAR = filter(EVENTVAR) außerhalb des Loops verwenden und die Eventperioden anpassen - dabei aber Vorsicht, das bisschen hakelig.)

foreach var of varlist EVENTVAR { /// EVENTVAR ist eure Variable, die einzelne Events markiert, vor und nach denen ihr die Eventperiode erstellen wollt.
	foreach w in "6" "30" { /// Hier könnt ihr eure Eventperioden eintragen, immer in Anführungszeichen.
	    local v = `w'/2
		gen tempvar = 1/(2*`w'+1)
		egen tempwindow = filter(`var'), l(-`w'/`w') n
		replace tempwindow = 1 if tempwindow==tempvar
		gen `var'`w' = 0
		replace `var'`w' = 1 if tempwindow==1 & `var'==1
		egen `var'_window`w' = filter(`var'`w'), l(-`v'/`v') c(-`v'(1)`v')
		replace `var'_window`w' =. if `var'_window`w'==0 & `var'`w'==0
		gen `var'_inwindow`w' = 0
		replace `var'_inwindow`w' = 1 if `var'_window`w'>0
		gen `var'_POST`w' = 0 if !missing(`var'_window`w')
		replace `var'_POST`w' = 1 if `var'_window`w'>=0 &!missing(`var'_window`w') /// Wenn POST das Eventjahr selber nicht einschließen soll, schreibt nur ">".
		drop tempvar tempwindow
	}
}

* Viel Spaß. :)
