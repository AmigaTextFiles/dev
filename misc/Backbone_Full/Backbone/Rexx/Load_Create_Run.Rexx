/* 
This Script will bring up a requestor, then ask for a project file.
It will then automatically load it, create it and run it without any
further requestors (providing there are no errors).
*/

/* First Check if the Backbone Arexx Port is available */
IF ~SHOW('P', 'BACKBONE') THEN DO
	SAY 'Backbone is not running.'
	EXIT 10
END

/* Set up Arexx to send commands to Backbone and Request a return String */
ADDRESS "BACKBONE"
OPTIONS RESULTS

/* Open a requestor */
"REQUEST This Demo Arexx Script Will Automatically&Load, Create and Run a Backbone&Project In One Command!Continue|Cancel"
If RC=0 THEN   /* If user hits Cancel */
	EXIT 10
ELSE DO  /* If user hits Continue */
	"PICKPROJECT_LOAD"   /* Bring up Project File Selector */
	If RC=0 THEN DO     /* If Cancel Wasn't Hit */
		"OPEN" RESULT    /* Open up Project */
		"CREATE_NOREQ"   /* Create Project with No Requestors */
		"RUN"           /* Run the Game */
	END
END
