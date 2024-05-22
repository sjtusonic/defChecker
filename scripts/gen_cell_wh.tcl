puts "argv=$argv"
set fname $argv
if {$fname ne ""} {
	set ll $fname
}

set flagLibrary 0;
set endIdx "end"
set fhOut [open "data/widthHeight.csv" a]
foreach fname [lrange $ll 0 $endIdx] {
	set fh [open $fname r]
		if {[regexp {place_opt} $fname]} {continue}
	set cntLine 0

		while {![eof $fh]} {
			gets $fh line;
# puts "line=$line"
			if {[regexp {^MACRO} $line]} {
				set flagLibrary 1;
			}
			if {!$flagLibrary} {
				continue;
			}

			if {[regexp {^MACRO } $line]} {
				set lw [split $line " "];
				if {[llength $lw]!=2} {continue;}
				set tmpLine $line;
				regsub -all {.*MACRO } $tmpLine {} tmpLine;
				regsub -all { +} $tmpLine  {} tmpLine;

# puts "tmpLine=$tmpLine";
				puts -nonewline $fhOut "$tmpLine,";


			}
			if {[regexp {SIZE} $line]} {
				set tmpLine $line;
				regsub -all {;} $tmpLine {} tmpLine;
				regsub -all {.*SIZE } $tmpLine {} tmpLine;
				regsub -all {BY} $tmpLine {} tmpLine;
				regsub -all { +} $tmpLine { } tmpLine;
				regsub -all {^ } $tmpLine {} tmpLine;
				regsub -all { $} $tmpLine {} tmpLine;
				regsub -all { } $tmpLine {,} tmpLine;
				# puts "tmpLine=$tmpLine"
					puts $fhOut "$tmpLine"
			}

			if {![expr $cntLine % 1000000]} {
				puts "$fname line:$cntLine [exec date]"
			}
			incr cntLine;
		}
}
flush $fhOut
close $fhOut
