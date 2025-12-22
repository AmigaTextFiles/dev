
/*
 *  IOCTL.H
 *
 *  Note on IOF_ASYNC:	Handles by default can do only one thing at a time...
 *			This might cause the device to block when you specify
 *			an asynchronous operation when the previous op has not
 *			completed yet.	Not all devices support IOC_NASYNCH
 *
 *  SEE IOCTL.DOC !!!!!
 */

#define IOF_ASYNC   0x80000000L     /*	Do asynchronously if possible.	    */
#define IOF_NOORD   0x40000000L     /*	Execute immediately if possible     */
#define IOF_BUF     0x20000000L     /*	Ioctl args are a buffer and a length*/
#define IOF_NB	    0x10000000L     /*	Non-Blocking.  Do not block	    */

#define IOCMASK     0x00FFFFFFL

#define IOC_RESET   1L
#define IOC_READ    (2L|IOF_BUF)        /*  IOF_ASYNC usually implemented   */
#define IOC_WRITE   (3L|IOF_BUF)        /*  IOF_ASYNC usually implemented   */
#define IOC_UPDATE  4L
#define IOC_CLEAR   5L
#define IOC_STOP    6L
#define IOC_START   7L
#define IOC_FLUSH   8L

#define IOC_SIGNAL  0x040L		/*  Get/Set signal # for asynch ops	*/
#define IOC_SLOTS   0x041L		/*  Get/Set # of parallel asynch reqs	*/
#define IOC_RAVAIL  0x042L		/*  Return # bytes ready to read	*/
#define IOC_WAVAIL  0x043L		/*  Return # bytes that can be written	*/
#define IOC_BLOCKSZ 0x044L		/*  R/W can be in multiples of this val */
#define IOC_RBUFSZ  0x045L		/*  Get/Set input buffer size, bytes	*/
#define IOC_WBUFSZ  0x046L		/*  Get/Set output buffer size, bytes	*/
#define IOC_ASYRDY  0x048L		/*  Asynchronous control, see docs	*/
#define IOC_ASYWAIT 0x049L
#define IOC_TXTCMD  0x04AL		/*  Ascii command to execute remote	*/

#define IOC_ABORT   0x050L		/*  Abort all asynch. requests		*/
#define IOC_DUP     0x051L		/*  Duplicate a handle			*/
#define IOC_CHOWN   0x052L		/*  Change ownership of a handle	*/

#define IOC_SETFUNC 0x054L		/*  Set IOCTL dispatch function 	*/
#define IOC_GETFUNC 0x055L		/*  Get IOCTL dispatch function 	*/
#define IOC_DEVCLAS 0x056L		/*  Return device type			*/

/*
 *  These _IOC commands are for internal use only and
 *  should never be used from application programs.
 */

#define _IOC_CREATE 0x60
#define _IOC_DELETE 0x61
#define _IOC_OPEN   0x62
#define _IOC_CLOSE  0x63
#define _IOC_DUP    0x64

/*
 *  DEVICE ABILITIES
 */

#define IOTC_CLASS0	0
#define IOTC_CLASS1	1
#define IOTC_CLASS2	2
#define IOTC_CLASS3	3
#define IOTC_CLASS4	4

