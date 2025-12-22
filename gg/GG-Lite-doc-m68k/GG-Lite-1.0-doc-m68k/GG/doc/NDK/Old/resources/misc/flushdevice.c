/* Copyright (c) 1990 Commodore-Amiga, Inc.
 *
 * This example is provided in electronic form by Commodore-Amiga, Inc. for
 * use with the 1.3 revisions of the Addison-Wesley Amiga reference manuals. 
 * The 1.3 Addison-Wesley Amiga Reference Manual series contains additional
 * information on the correct usage of the techniques and operating system
 * functions presented in this example.  The source and executable code of
 * this example may only be distributed in free electronic form, via bulletin
 * board or as part of a fully non-commercial and freely redistributable
 * diskette.  Both the source and executable code (including comments) must
 * be included, without modification, in any copy.  This example may not be
 * published in printed form or distributed with any commercial product.
 * However, the programming techniques and support routines set forth in
 * this example may be used in the development of original executable
 * software products for Commodore Amiga computers.
 * All other rights reserved.
 * This example is provided "as-is" and is subject to change; no warranties
 * are made.  All use is at your own risk.  No liability or responsibility
 * is assumed.
 */

  /*
   * A safe way to expunge ONLY a certain device.  The serial.device holds
   * on to the misc serial resource until a general expunge occurs.
   * This code attempts to flush ONLY the named device out of memory and
   * nothing else.  If it fails, no status is returned since it would have
   * no valid use after the Permit().
   */
   #include <exec/types.h>
   #include <exec/execbase.h>
   #include <proto/all.h>

   #ifdef LATTICE
   int CXBRK(void)    { return(0); }  /* Disable Lattice CTRL/C handling */
   int chkabort(void) { return(0); }  /* really */
   #endif

   void FlushDevice(char *);

   extern struct ExecBase *SysBase;
 
   void FlushDevice(char *name)
   {
   struct Device *devpoint;

       Forbid();
       if( devpoint=(struct Device *)FindName(&SysBase->DeviceList,name) )
       RemDevice(devpoint);
       Permit();
   }
