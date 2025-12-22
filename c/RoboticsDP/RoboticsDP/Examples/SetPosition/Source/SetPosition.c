/*****************************************************************************/
/* INCLUDES INCLUDES INCLUDES INCLUDES INCLUDES INCLUDES INCLUDES INCLUDES I */
/*****************************************************************************/
#include <clib/exec_protos.h> /* OpenLibrary & CloseLibrary */
#include <stdio.h>            /* For printing error messages */
#include <minissc.h>          /* minissc library definitions */
#include <dos/rdargs.h>       /* For reading CLI arguments */
#include <clib/dos_protos.h>  /* For reading CLI arguments */

/*****************************************************************************/
/* DEFINES DEFINES DEFINES DEFINES DEFINES DEFINES DEFINES DEFINES DEFINES D */
/*****************************************************************************/
#define MSG_CANTOPEN    0   /* CLI message ids */
#define MSG_ARGMISSING  1
#define MSG_INVSERVOID  2
#define MSG_INVSERVOPOS 3
#define MSG_COUNT       4   /* Number of CLI messages */
#define MSG_MAX_LEN     256 /* Maximum message length */
/* Command line template:                                          */
/* SERVO    - target servo: 0-255                                  */
/* POSITION - new servo position: 0-254                            */
/* HIGH     - use 9600 baud rate (default is 2400)                 */
/* WIDE     - use wide motion range: 180° (default is narrow: 90°) */
#define TEMPLATE        "SERVO/A/N,POSITION=POS/A/N,HIGH/S,WIDE/S"
#define ARG_SERVO       0   /* Argument ids */
#define ARG_POSITION    1
#define ARG_HIGH        2
#define ARG_WIDE        3
#define ARG_COUNT       4   /* Number of arguments */

/*****************************************************************************/
/* CONSTS CONSTS CONSTS CONSTS CONSTS CONSTS CONSTS CONSTS CONSTS CONSTS CON */
/*****************************************************************************/
const char *vertag="$VER: SetPosition 1.0 (27.1.2000)"; /* Version string */

/*****************************************************************************/
/* VARIABLES VARIABLES VARIABLES VARIABLES VARIABLES VARIABLES VARIABLES VAR */
/*****************************************************************************/
struct MiniSSCLibrary *MiniSSCBase=NULL; /* Library base */
char *message[MSG_COUNT]=
{
	"%s: can't open %s",
	"%s: required argument missing",
	"%s: invalid servo id",
	"%s: invalid servo position"
};                                       /* CLI messages */

/*****************************************************************************/
/* MAIN MAIN MAIN MAIN MAIN MAIN MAIN MAIN MAIN MAIN MAIN MAIN MAIN MAIN MAI */
/*****************************************************************************/
int main(int argc, char **argv)
{
	/* Variables */
	struct RDArgs *arguments;      /* Command line args */
	LONG value[ARG_COUNT];         /* Given argument values */
	int errcode=0;                 /* Error code to CLI */
	int controller=0;              /* Target controller id */
	int servo=0;                   /* Target servo id */
	int position;                  /* New servo position */
	int rate=SSC_COMMMODE_LOW;     /* Controller's communication mode */
	int range=SSC_CTRLMODE_NARROW; /* Controller's motion range */
	int servorange=90;             /* Servo's motion range in degrees */
	int counter;                   /* For loop counter */
	char msgstring[MSG_MAX_LEN];   /* String for printing messages */

	/* Init values */
	for(counter=0;counter<ARG_COUNT;counter++)
	{
		value[counter]=NULL;
	}

	/* Open minissc library */
	if(MiniSSCBase=(struct MiniSSCLibrary *)OpenLibrary(SSC_NAME,SSC_VERSION))
	{
		/* Read arguments */
		if(arguments=ReadArgs(TEMPLATE,value,NULL))
		{
			/* Get servo id */
			if(value[ARG_SERVO])
			{
				servo=(int)*(LONG *)value[ARG_SERVO];
			}
			/* No servo id */
			else
			{
				errcode=20;
			}
			/* Get servo position */
			if(value[ARG_POSITION])
			{
				position=(int)*(LONG *)value[ARG_POSITION];

				/* Position out of range */
				/*
				   This check is not really required.
				   I make the check because I don't want
				   to occupy a servo for nothing.
				   (Occupying causes servo to move to
				   position 127.)
				*/
				if((position>SSC_MAX_AVALUE)||(position<0))
				{
					sprintf(msgstring,message[MSG_INVSERVOPOS],argv[0]);
					printf("%s\n",msgstring);
					errcode=20;
				}
			}
			/* No position */
			else
			{
				errcode=20;
			}
			/* 9600 baud rate selected */
			if(value[ARG_HIGH])
			{
				rate=SSC_COMMMODE_HIGH;
			}
			/* 180° motion range selected */
			if(value[ARG_WIDE])
			{
				range=SSC_CTRLMODE_WIDE;
				servorange=180;
			}

			/* Move servo */
			if(errcode==0)
			{
				/* Occupy correct controller */
				controller=(int)servo/SSC_MAX_SERVOS;
				if(!ssc_OccupyController(controller,rate,range))
				{
					/* Occupy servo */
					if(!ssc_OccupyServo(servo,servorange))
					{
						/* Set new servo position */
						if(ssc_SetAPosition(servo,position))
						{
							sprintf(msgstring,message[MSG_INVSERVOPOS],argv[0]);
							printf("%s\n",msgstring);
							errcode=20;
						}

						/* Free servo */
						ssc_FreeServo(servo);
					}
					/* Not a valid servo */
					else
					{
						sprintf(msgstring,message[MSG_INVSERVOID],argv[0]);
						printf("%s\n",msgstring);
						errcode=20;
					}

					/* Free controller */
					ssc_FreeController(controller);
				}
				/* Not a valid controller */
				else
				{
					sprintf(msgstring,message[MSG_INVSERVOID],argv[0]);
					printf("%s\n",msgstring);
					errcode=20;
				}
			}
		}
		/* Missing argument */
		else
		{
			sprintf(msgstring,message[MSG_ARGMISSING],argv[0]);
			printf("%s\n",msgstring);
			errcode=20;
		}

		/* Close library */
		CloseLibrary((struct Library *)MiniSSCBase);
	}
	/* minissc.library not available */
	else
	{
		sprintf(msgstring,message[MSG_CANTOPEN],argv[0],SSC_NAME);
		printf("%s\n",msgstring);
		errcode=20;
	}

	return errcode;
}