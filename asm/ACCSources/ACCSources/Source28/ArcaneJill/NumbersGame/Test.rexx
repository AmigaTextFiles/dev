/* Proggy to test NumbersGame,
 * by returning all possible non-equivalent ways of making 100
 * and then all possible consecutive integers
 * out of the seeds 1, 2, 3, 4, 5 and 6.
 */

address NUMBERSGAME	/* Send ARexx commands to NUMBERSGAME */
options results		/* Allow NUMBERSGAME to send back results */

'GetScheme' 1 2 3 4 5 6
scheme = result

/* Find largest possible result */
'GetMethod' scheme 16383
method = result
say 'Largest possible result is:' method

/* Find all possible ways of making 100 */
say ''
say 'Different ways of making 100:'
do i = 1
	'GetMethod' scheme 100 i
	method = result
	if method = '' then leave
	say method
	end

/* Find all possible consecutive integers */
say ''
say 'All possible consecutive integers:'
do i = 1
	'GetMethod' scheme i 1
	method = result
	if method = '' then leave
	say method
	end

/* Free the memory occupied by the scheme - VERY IMPORTANT!!! */
'FreeScheme' scheme

