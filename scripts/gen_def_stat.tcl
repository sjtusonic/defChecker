
set CFG_GEN_DEF_SUM 1

puts "argv=$argv"
set fname $argv
if {$fname ne ""} {
	set ll $fname
}

set flagInComponents 0;
foreach fname $ll {
	set fh [open $fname r]
		if {$CFG_GEN_DEF_SUM} {
			set fhDefSum [open $fname.sum w]
		}
	while {![eof $fh]} {
		gets $fh line;
		if {[regexp {ROW .*} $line]} {
			set lw [split $line " "]
				set toStr [concat "ROW" [lrange $lw 1 4]];
			puts $fhDefSum [join $toStr ","]
		}
		if {[regexp {^END COMPONENTS} $line]} {
			set flagInComponents 0;
		}
		if {$flagInComponents} {
			if {$CFG_GEN_DEF_SUM} {
				if {$line eq ""} {continue}
				set tmpLine $line;
				regsub -all {\-} $tmpLine {} tmpLine;
				regsub -all {\+} $tmpLine {} tmpLine;
				regsub -all {\(} $tmpLine {} tmpLine;
				regsub -all {\)} $tmpLine {} tmpLine;
				regsub -all {;} $tmpLine {} tmpLine;
				regsub -all { +} $tmpLine { } tmpLine;
				regsub -all {^ } $tmpLine {} tmpLine;
				regsub -all { $} $tmpLine {} tmpLine;
				set lw [split $tmpLine " "]
					set toStr [concat "COMP" [lrange $lw 0 end]]
					puts $fhDefSum [join $toStr ","]

			}
		}
		if {[regexp {^COMPONENTS} $line]} {
			set flagInComponents 1;
		}
		if {[regexp {^DIEAREA} $line]} {
			set tmpLine $line;
			regsub -all { +} $tmpLine { } tmpLine;
			set ll [split $tmpLine " "]
			set w [lindex $ll 6]
			set h [lindex $ll 7]
			# set dieArea [format "%d" [expr int(1.0*$w * $h / 1e6)]]
			puts $fhDefSum "DIEAREA,$w,$h"
			# regsub -all {\-} $tmpLine {} tmpLine;
			# regsub -all {\+} $tmpLine {} tmpLine;
		}
	}
}
