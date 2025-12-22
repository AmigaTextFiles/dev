/* 
This script will close all main Backbone windows.
*/

/* First Check if the Backbone Arexx Port is available */
IF ~SHOW('P', 'BACKBONE') THEN DO
	SAY 'Backbone is not running.'
	EXIT 10
END

/* Set up Arexx to send commands to Backbone and Request a return String */
ADDRESS "BACKBONE"
OPTIONS RESULTS

"GAMEDETAILS CLOSE"
"SCREENSETUP CLOSE"
"PLAYER CLOSE"
"PLAYERMORE CLOSE"
"OBJECTS CLOSE"
"BLOCKS CLOSE"
"LEVELS CLOSE"
"SCENES CLOSE"
"PANEL CLOSE"
"CONTROLS CLOSE"
"IMAGE EDITOR CLOSE"
"SOUND EDITOR CLOSE"
"BLOCK MAKER CLOSE"
