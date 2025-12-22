#ifndef MINISSC_H
#define MINISSC_H

/*
**      $VER: minissc.h (15.01.2000)
**
**      minissc library definitions and structures
**
**      Copyright © 2000 Janne Peräaho.
**            All Rights Reserved.
*/

#ifndef EXEC_LIBRARIES_H
#include <exec/libraries.h>
#endif /* EXEC_LIBRARIES_H */

/*---- Library related ------------------------------------------------------*/
#define SSC_NAME    "minissc.library" /* Library name                        */
#define SSC_VERSION 1                 /* Library version                     */

/*---- Maximum values -------------------------------------------------------*/
#define SSC_MAX_SERVOS        8 /* Max number of servos per controller       */
#define SSC_MAX_CONTROLLERS  32 /* Max number of Mini SSC II Controllers     */
#define SSC_MAX_AVALUE      254 /* Max absolute servo value                  */
#define SSC_MAX_VALUE       179 /* Max servo value (degrees)                 */

/*---- Controller states ----------------------------------------------------*/
#define SSC_CTRLR_NA          0 /* Controller state: not available           */
#define SSC_CTRLR_BUSY        1 /* Controller state: busy                    */
#define SSC_CTRLR_READY       2 /* Controller state: ready                   */
#define SSC_CTRLR_LOCKED      3 /* Controller state: locked                  */

/*---- Servo states ---------------------------------------------------------*/
#define SSC_SERVO_NA          0 /* Servo state: Not available                */
#define SSC_SERVO_BUSY        1 /* Servo state: Busy                         */
#define SSC_SERVO_READY       2 /* Servo state: ready                        */
#define SSC_SERVO_LOCKED      3 /* Servo state: locked                       */

/*---- Communication modes --------------------------------------------------*/
#define SSC_COMMMODE_LOW      0 /* Comm speed: 2400 baud                     */
#define SSC_COMMMODE_HIGH     1 /* Comm speed: 9600 baud                     */

/*---- Controller modes -----------------------------------------------------*/
#define SSC_CTRLMODE_NARROW   0 /* Range of motion (Mini SSC): 90°           */
#define SSC_CTRLMODE_WIDE     1 /* Range of motion (Mini SSC): 180°          */

/*---- Library --------------------------------------------------------------*/
struct MiniSSCLibrary
{
	/* Compulsory library stuff */
	struct Library lib_node;
	APTR seg_list;
	struct ExecBase *SysBase;

	/* minissc.library data */
	BOOL initialized;          /* Library status: FALSE=not initialized, TRUE=initialized */
	struct MsgPort *SerialMP;  /* Message port for serial communication */
	struct IOExtSer *SerialIO; /* IO request structure for serial communication */
};

#endif /* MINISSC_H */
