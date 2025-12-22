( example code for loading and saving data files within AFORTH)
( Copyright © Stratagem4, 1994)

CREATE data 40 ALLOT	( create a 40 element array)

: savedata				( save contents of 'data' to file)
						( syntax is savedata <name>")
	40 S->D	0 BUFFER	( get a buffer of 40 bytes in public memory)
	DUPD D0= IF			( if we have no buffer then)
		CR ." Could not allocate buffer...sorry!" CR
		ABORT			( drop everything)
	ELSE				( otherwise save the data)
		DUPD			( duplicate buffer address)
		data			( fetch pfa of 'data')
		4 ROLL 4 ROLL	( swap top two addresses)
		20 MOVE			( copy contents of 'data' to buffer)
		ASCII " WORD	( read next word as filename)
		SAVE-BUFFERS	( save data)
		DROP			( here we drop the success flag, but you should)
						( test it)
		EMPTY-BUFFERS	( clean up)
	THEN ;

: loaddata				( load file and palce in 'data')
						( syntax is loaddata <name>")
	ASCII " WORD BLOCK	( load filename)
	DUPD D0= IF			( if failed)
		ABORT			( drop everything)
	ELSE				( else)
		DUPD data 20 MOVE	( move data from buffer to 'data')
		EMPTY-BUFFERS	( free memory)
	THEN ;

: testdata				( fill the array with some known values)
	data				( fetch address of 'data')
	20 0 DO				( loop through 'data')
		DUPD I ROT ROT !	( store a value in each hole)
		2D+				( increment address)
	LOOP
	DROPD ;				( drop address)

: cleardata				( flush the array)
	data 40 0 FILL ;	( fill array with zero's)

: printdata				( show contents of array)
	data				( fetch address of data)
	20 0 DO				( loop through array)
		DUPD @ .		( fetch and print number)
		2D+				( increment address)
	LOOP
	DROPD ;				( drop address)

( and now the actual test begins)
( *** NOTE *** this is an auto booting file!!!!)
CR testdata CR
." test data: " CR printdata CR
savedata ram:datafile"
cleardata
." contents after saving and clearing: " CR printdata CR
loaddata ram:datafile"
." contents after loading: " CR printdata CR CR
