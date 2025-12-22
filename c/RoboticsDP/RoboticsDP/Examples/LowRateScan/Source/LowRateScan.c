/*****************************************************************************/
/* INCLUDES INCLUDES INCLUDES INCLUDES INCLUDES INCLUDES INCLUDES INCLUDES I */
/*****************************************************************************/
#include <clib/exec_protos.h> /* OpenLibrary & CloseLibrary */
#include <stdio.h>            /* For printing error messages */
#include <minissc.h>          /* minissc library definitions */

/*****************************************************************************/
/* VARIABLES VARIABLES VARIABLES VARIABLES VARIABLES VARIABLES VARIABLES VAR */
/*****************************************************************************/
struct MiniSSCLibrary *MiniSSCBase=NULL; /* Library base */

/*****************************************************************************/
/* MAIN MAIN MAIN MAIN MAIN MAIN MAIN MAIN MAIN MAIN MAIN MAIN MAIN MAIN MAI */
/*****************************************************************************/
void main(void)
{
	/* Variables */
	int controller=0;  /* Use controller number 0*/
	int servo=0;       /* Use servo number 0 */
	int position;      /* Servo position looper */
	int step=1;        /* Speed of movement */
	int servorange=90; /* Servo's motion range in degrees */

	/* Open minissc library */
	if(MiniSSCBase=(struct MiniSSCLibrary *)OpenLibrary(SSC_NAME,SSC_VERSION))
	{
		/* Occupy controller */
		if(!ssc_OccupyController(controller,SSC_COMMMODE_LOW,SSC_CTRLMODE_NARROW))
		{
			/* Occupy servo */
			if(!ssc_OccupyServo(servo,servorange))
			{
				/* Rotate servo in clockwise */
				for(position=0;position<=SSC_MAX_AVALUE;position=position+step)
				{
					ssc_SetAPosition(servo,position);
				}
				/* Rotate servo in anticlockwise */
				for(position=SSC_MAX_AVALUE-1;position>=0;position=position-step)
				{
					ssc_SetAPosition(servo,position);
				}

				/* Free servo */
				ssc_FreeServo(servo);

				/* Free controller */
				ssc_FreeController(controller);

				/* Close library */
				CloseLibrary((struct Library *)MiniSSCBase);
			}
			/* Servo is not available */
			else
			{
				/* Free controller */
				ssc_FreeController(controller);

				/* Close library */
				CloseLibrary((struct Library *)MiniSSCBase);

				/* Print error message */
				printf("can't occupy servo #%d\n",servo);
			}
		}
		/* Controller is not available */
		else
		{
			/* Close library */
			CloseLibrary((struct Library *)MiniSSCBase);

			/* Print error message */
			printf("can't occupy controller #%d\n",controller);
		}
	}
	/* minissc.library not available */
	else
	{
		printf("can't open %s\n",SSC_NAME);
	}
}