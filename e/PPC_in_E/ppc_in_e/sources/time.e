OPT MODULE
OPT EXPORT

CONST     TAG_UTENTE = 			$80000000
CONST	PPCTIMERTAG_DUMMY		=TAG_UTENTE + $24000

/* PPCCreateTimerObject Tags */

/* ptr to an optional error reason field
 */
CONST	PPCTIMERTAG_ERROR		=PPCTIMERTAG_DUMMY + $0

/* use the CPU timer to do simple synchron
 * timer based operations
 */
CONST	PPCTIMERTAG_CPU			=PPCTIMERTAG_DUMMY + $1

/* create a job in a 50Hz timer queue
 * which will send your task a signal after
 * the ticks you specified run to zero.
 * You specify the number of 50Hz ticks
 * with the Tag.
 */
CONST	PPCTIMERTAG_50HZ		=PPCTIMERTAG_DUMMY + $2

/* The signalmask necessary for the 50Hz
 * timer to signal your task
 */
CONST	PPCTIMERTAG_SIGNALMASK		=PPCTIMERTAG_DUMMY + $3

/* After the ticks ran down and the task
 * is signaled the timer request is removed from the queue.
 */
CONST	PPCTIMERTAG_AUTOREMOVE		=PPCTIMERTAG_DUMMY + $4


/* PPCSetTimerObject= Tags */


/* Start Timer,Start Job=add to the joblist or
 * Start ticks for PPCGetTimerObject=
 */
CONST	PPCTIMERTAG_START		=PPCTIMERTAG_DUMMY + $11

/* Stop Timer,Stop Job=remove from the joblist or
 * Stop ticks for PPCGetTimerObject=
 */
CONST	PPCTIMERTAG_STOP		=PPCTIMERTAG_DUMMY + $12

/* PPCGetTimerObject= Tags */

/* Get ticks per second */
CONST	PPCTIMERTAG_TICKSPERSEC		=PPCTIMERTAG_DUMMY + $13

/* Get current ticks */
CONST	PPCTIMERTAG_CURRENTTICKS	=PPCTIMERTAG_DUMMY + $14

/* Get diff ticks after a start and stop */
CONST	PPCTIMERTAG_DIFFTICKS		=PPCTIMERTAG_DUMMY + $15

/* Get diff microseconds after a start and stop */
CONST	PPCTIMERTAG_DIFFMICRO		=PPCTIMERTAG_DUMMY + $16

/* Get diff seconds after a start and stop */
CONST	PPCTIMERTAG_DIFFSECS		=PPCTIMERTAG_DUMMY + $17

/* Get diff minutes after a start and stop */
CONST	PPCTIMERTAG_DIFFMINS		=PPCTIMERTAG_DUMMY + $18

/* Get diff hours after a start and stop */
CONST	PPCTIMERTAG_DIFFHOURS		=PPCTIMERTAG_DUMMY + $19

/* Get diff days after a start and stop */
CONST	PPCTIMERTAG_DIFFDAYS		=PPCTIMERTAG_DUMMY + $1a



CONST	PPCTIMERERROR_OK=	0
CONST	PPCTIMERERROR_MEMORY=	1




