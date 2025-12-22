/* 
This Script will restart Backbone. Only useful if you have changed the
preferences values.
*/

/* First Check if the Backbone Arexx Port is available */
IF ~SHOW('P', 'BACKBONE') THEN DO
	SAY 'Backbone is not running.'
	EXIT 10
END

/* Set up Arexx to send commands to Backbone and Request a return String */
ADDRESS "BACKBONE"
OPTIONS RESULTS

/* Tell Backbone to quit and restart itself */
"RESTART"
