/* 
This script will open all main Backbone windows.
*/

/* First Check if the Backbone Arexx Port is available */
IF ~SHOW('P', 'BACKBONE') THEN DO
	SAY 'Backbone is not running.'
	EXIT 10
END

/* Set up Arexx to send commands to Backbone and Request a return String */
ADDRESS "BACKBONE"
OPTIONS RESULTS

"GAMEDETAILS OPEN"
"SCREENSETUP OPEN"
"PLAYER OPEN"
"OBJECTS OPEN"
"BLOCKS OPEN"
"LEVELS OPEN"
"SCENES OPEN"
"PANEL OPEN"
"CONTROLS OPEN"
