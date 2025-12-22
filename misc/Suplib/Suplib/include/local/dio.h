
/*
 * DIO.H
 *
 *  (C)Copyright 1987 Matthew Dillon, All Rights Reserved
 *  Freely distributable.  Donations welcome, I guess.
 *
 *	Matthew Dillon
 *	891 Regal Rd.
 *	Berkeley, Ca.	94708
 *
 */

#ifndef LOCAL_DIO_H
#define LOCAL_DIO_H
#include <exec/types.h>
#include <exec/io.h>
#include <exec/memory.h>
#include <exec/ports.h>
#include <devices/timer.h>
#ifndef LOCAL_TYPEDEFS_H
#include <local/typedefs.h>
#endif

typedef struct IORequest IOR;
typedef struct IOStdReq  STD;

/*
 *	'to' is in microsections.  The IO request structure
 *  pointer is optional to dio_open().  If NULL, dio_open()
 *  initializes it's own IO request (to mostly zero).  You have
 *  to provide an IO request structure, for instance, if openning
 *  a console device since the window pointer must be passed to
 *  OpenDevice().
 *
 *	each DFD descriptor has it's own signal.
 *
 *	dio_isdone() returns 1 if the channel is clear, 0 otherwise.
 */

#ifdef NOTDEF
extern long dio_open();         /* dfd    = dio_open(devname,unit,flags,req)*/
extern long dio_dup();          /* newdfd = dio_dup(dfd)    */
extern STD *dio_ctl();          /* req  = dio_ctl(dfd,com,buf,len)          */
extern STD *dio_ctl_to();       /* req  = dio_ctl_to(dfd,com,buf,len,to)    */
extern STD *dio_wait();         /* req  = dio_wait(dfd)     */
extern STD *dio_abort();        /* req  = dio_abort(dfd)    */
extern STD *dio_isdone();       /* req  = dio_isdone(dfd)   */
extern int dio_signal();        /* signm= dio_signal(dfd)   */
extern void dio_close();        /*  dio_close(dfd)          */
extern void dio_cloesgroup();   /*  dio_closegroup(dfd)     */
extern void dio_cact();         /*  dio_cact(dfd,bool)      */

#endif

/*
 * dio_simple() and related macros return the !io_Error field. That
 * is, 0=ERROR, 1=OK
 *
 * dio_actual() returns the io_Actual field.
 *
 * NOTE: the io_Actual field may not be set by the device if an
 * error condition exists.  To make the io_ctl() and io_ctl_to()
 * call automatically clear the io_Actual field before doing the
 * io operation, use the DIO_CACT() call.  The reason this isn't
 * done automatically by default is that some devices require
 * parameters to be passed in the io_Actual field (like the
 * timer.device).
 *
 *  Remember, Asyncronous IO is done by sending -com instead of com.
 *
 *	CALL			    Syncronous IO   Asyncronous IO
 *
 *  dio_simple(dfd,com)             0=ERROR, 1=OK   undefined
 *  dio_actual(dfd,com)             io_Actual       undefined
 *  dio_reset(dfd)                  0=ERROR, 1=OK   n/a
 *  dio_update(dfd)                 0=ERROR, 1=OK   n/a
 *  dio_clear(dfd)                  0=ERROR, 1=OK   n/a
 *  dio_stop(dfd)                   0=ERROR, 1=OK   n/a
 *  dio_start(dfd)                  0=ERROR, 1=OK   n/a
 *  dio_flush(dfd)                  0=ERROR, 1=OK   n/a
 *  dio_getreq(dfd)                 returns a ptr to the IO
 *				    request structure
 *  NOTE: If you use the following, you probably want to have the
 *  device library automatically clear the io_Actual field before
 *  sending the request so you get 0 if an error occurs.  That
 *  is: dio_cact(dfd,1);
 *
 *
 *  dio_read(dfd,buf,len)           returns actual bytes read
 *  dio_write(dfd,buf,len)          returns actual bytes written
 *
 *	The timeout argument for dio_readto() and dio_writeto()
 *	is in MICROSECONDS, up to 2^31uS.
 *
 *  dio_readto(dfd,buf,len,to)      returns actual bytes read
 *  dio_writeto(dfd,buf,len,to)     returns actual bytes written
 *
 *	The asyncronous dio_reada() and dio_writea() do not
 *	return anything.
 *
 *  dio_reada(dfd,buf,len)          begin asyncronous read
 *  dio_writea(dfd,buf,len)         begin asyncronous write
 */

#define dio_mask(dfd)           (1 << dio_signal(dfd))

#define dio_simple(dfd,com)     (!dio_ctl(dfd,com,0,0)->io_Error)
#define dio_actual(dfd,com)     ( dio_ctl(dfd,com,0,0)->io_Actual)
#define dio_reset(dfd)          dio_simple(dfd,CMD_RESET)
#define dio_update(dfd)         dio_simple(dfd,CMD_UPDATE)
#define dio_clear(dfd)          dio_simple(dfd,CMD_CLEAR)
#define dio_stop(dfd)           dio_simple(dfd,CMD_STOP)
#define dio_start(dfd)          dio_simple(dfd,CMD_START)
#define dio_flush(dfd)          dio_simple(dfd,CMD_FLUSH)
#define dio_getreq(dfd)         dio_ctl(dfd,0,0,0)

#define dio_read(dfd,buf,len)       (dio_ctl(dfd,CMD_READ,buf,len)->io_Actual)
#define dio_write(dfd,buf,len)      (dio_ctl(dfd,CMD_WRITE,buf,len)->io_Actual)
#define dio_readto(dfd,buf,len,to)  (dio_ctl_to(dfd,CMD_READ,buf,len,to)->io_Actual)
#define dio_writeto(dfd,buf,len,to) (dio_ctl_to(dfd,CMD_WRITE,buf,len,to)->io_Actual)
#define dio_reada(dfd,buf,len)      ((void)dio_ctl(dfd,-CMD_READ,buf,len))
#define dio_writea(dfd,buf,len)     ((void)dio_ctl(dfd,-CMD_WRITE,buf,len))

#endif


