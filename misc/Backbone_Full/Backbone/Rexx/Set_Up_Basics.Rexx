/* 
This script will set up some basics for you by asking a few questions.
*/

/* First Check if the Backbone Arexx Port is available */
IF ~SHOW('P', 'BACKBONE') THEN DO
	SAY 'Backbone is not running.'
	EXIT 10
END

/* Set up Arexx to send commands to Backbone and Request a return String */
ADDRESS "BACKBONE"
OPTIONS RESULTS

"REQUEST This Arexx Script will Set Up&The Basics of a Game for You&By Asking a Series of Questions.&&First you must start a new&Project for this Game!Continue|Cancel"
If RC=0 THEN
	EXIT 1

/* Start New Project */
"PICKPROJECT_NEW"
If RC=1 THEN EXIT 1
"STARTNEW" RESULT
If RC=1 THEN DO
	"REQUEST Couldn't Start New Project.!OK"
	EXIT 5
END

"REQUEST Would you like your&Game to be Viewed from&Above or the Side?!Above|Side"
V=RC
If V=0 THEN
	"VIEW SIDE"
ELSE
	"VIEW ABOVE"

"REQUEST What Block Size&Are you Using?!16x16|32x32"
BS=RC
If BS=0 THEN
	"BLOCKSIZE 32"
ELSE
	"BLOCKSIZE 16"

"REQUEST How many Colours?!8|16|32|64"
COL=RC
If COL=0 THEN
	"COLOURS 64"
ELSE IF COL=1 THEN
	"COLOURS 8"
ELSE IF COL=2 THEN
	"COLOURS 16"
ELSE IF COL=3 THEN
	"COLOURS 32"

/* Assume Standard Lowres Screen and Set Scrolling Appropriately */
If V=0 THEN DO
	"RES 0"
	"HSCROLL 0"
	"VSCROLL 1"
	END
ELSE DO
	"RES 0"
	"HSCROLL 0"
	"VSCROLL 0"
	END

/* Set Screen Size to Default for Lowres */
"SCREENSIZEX 320"
"SCREENSIZEY 192"

/* Set Up Weapons */
"REQUEST Will Your Game have Weapons in it?!Yes|No"
WEP=RC
If WEP=0 THEN
	"GUN OFF"
ELSE IF WEP=1 THEN
	"GUN ON"

/* Update Screen Setup Window */
"SCREENSETUP CLOSE"
"SCREENSETUP OPEN"
"REQUEST As you can see, the screen&setup details are now updated!Amazing"

/* Finally Save the New Project */
"SAVE"

"REQUEST Script Completed.&Game Basics now Laid Out!Thanks"
