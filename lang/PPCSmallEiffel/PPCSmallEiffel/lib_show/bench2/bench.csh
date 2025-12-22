#!/bin/csh -f
#
# Run this file to have a comparison 
#
foreach b (*_bench.e)
	set cmd="compile $b make -no_split -boost -O3"
	set cmd="${SmallEiffel}/bin/$cmd"
	$cmd >& /dev/null
	echo "$b : "
	/bin/time a.out >&! tmp
	grep "user" tmp
end
/bin/rm -f tmp
