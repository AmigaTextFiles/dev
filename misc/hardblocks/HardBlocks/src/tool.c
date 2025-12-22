/* $Revision Header *** Header built automatically - do not edit! ***********
 *
 *	(C) Copyright 1992 by Torsten Jürgeleit
 *
 *	Name .....: tool.c
 *	Created ..: Wednesday 19-Feb-92 10:05:27
 *	Revision .: 2
 *
 *	Date        Author                 Comment
 *	=========   ====================   ====================
 *	27-Apr-92   Torsten Jürgeleit      add no library option
 *	11-Mar-92   Torsten Jürgeleit      argv[ARGUMENT_UNIT] is a (BYTE *)
 *	19-Feb-92   Torsten Jürgeleit      Created this file!
 *
 ****************************************************************************
 *
 *	Tool for manipulating hardblocks
 *
 * $Revision Header ********************************************************/

	/* Includes */

#include <exec/types.h>
#include <devices/hardblocks.h>
#include <libraries/arpbase.h>
#include <functions.h>
#include <stdlib.h>
#ifndef LINK_TEST
#include "hardblocks.h"
#else LINK_TEST
#include "hardblocks_link.h"
#endif LINK_TEST

	/* Defines */

#define DEFAULT_DEVICE		"scsi.device"
#define DEFAULT_UNIT		"0"

#define MAX_ARGUMENTS		11

#define ARGUMENT_DEVICE		0
#define ARGUMENT_UNIT		1
#define ARGUMENT_FILE		2
#define ARGUMENT_LOAD		3
#define ARGUMENT_RESTORE	4
#define ARGUMENT_DEFAULT	5
#define ARGUMENT_SHOW		6
#define ARGUMENT_OUTPUT		7
#define ARGUMENT_SAVE		8
#define ARGUMENT_BACKUP		9
#define ARGUMENT_REMOVE		10

	/* Externals */

IMPORT struct DOSBase   *DOSBase;

	/* Globals */

struct ArpBase	*ArpBase;
#ifndef LINK_TEST
struct Library	*HardBlocksBase;
#endif LINK_TEST

BYTE template[]  = "Device,Unit,FILE/k,LOAD/s,RESTORE/s,DEFAULT/s,SHOW/s,"
		   "OUTPUT/k,SAVE/s,BACKUP/s,REMOVE/s",
     xtra_help[] = "HBtool v1.1 - Copyright © 1992 Torsten Jürgeleit\n\n"
		   "Usage: HBtool [Device] [Unit] [FILE name] [LOAD]"
		   " [RESTORE] [DEFAULT] [SHOW] [OUTPUT file] [SAVE]"
		   " [BACKUP] [REMOVE]\n"
		   "\t[Device]      = device name (default: scsi.device)\n"
		   "\t[Unit]        = device unit num (default 0)\n"
		   "\t[FILE name]   = file to restore/save hardblocks\n"
		   "\t[LOAD]        = load hardblocks from device (default)\n"
		   "\t[RESTORE]     = restore hardblocks from file\n"
		   "\t[DEFAULT]     = create standard rigid disk block\n"
		   "\t[SHOW]        = show currently loaded hardblocks (default)\n"
		   "\t[OUTPUT file] = output file for show (default: NULL -> stdout)\n"
		   "\t[SAVE]        = save currently loaded hardblocks to device\n"
		   "\t[BACKUP]      = backup currently loaded hardblocks to file\n"
		   "\t[REMOVE]      = delete rigid disk block from device";

	/* Prototypes */

LONG _main(LONG alen, BYTE *aptr);
BOOL safety_check(BYTE *device, ULONG unit);

	/* Main routine - no startup code */

   LONG
_main(LONG alen, BYTE *aptr)
{
   LONG return_code = RETURN_FAIL;

   /* First open ARP library */
   if (!(ArpBase = OpenLibrary(ArpName, ArpVersion))) {
      Write(Output(), "Need ARP library V39+\n", 22L);
   } else {
#ifndef LINK_TEST
      if (!(HardBlocksBase = OpenLibrary(HardBlocksName,
						      HardBlocksVersion))) {
	 Puts("Need hardblocks library");
      } else {
#endif LINK_TEST
	 BYTE   *argv[MAX_ARGUMENTS];
	 USHORT i;

	 /* Clear argument array */
	 for (i = 0; i < MAX_ARGUMENTS; i++) {
	    argv[i] = NULL;
	 }

	 /* Parse command line arguments */
	 if (GADS(aptr, alen, &xtra_help[0], &argv[0], &template[0]) < 0) {
	    Puts(argv[0]);
	 } else {
	    struct RigidDiskBlock  rdb;
	    BPTR   fh;
	    BYTE   *device, *file = argv[ARGUMENT_FILE];
	    ULONG  unit;
	    USHORT error;

	    /* Install default arguments if not present */
	    if (!argv[ARGUMENT_DEVICE]) {
	       argv[ARGUMENT_DEVICE] = DEFAULT_DEVICE;
	    }
	    device = argv[ARGUMENT_DEVICE];
	    if (!argv[ARGUMENT_UNIT]) {
	       argv[ARGUMENT_UNIT] = DEFAULT_UNIT;
	    }
	    unit = Atol(argv[ARGUMENT_UNIT]);
	    if (!argv[ARGUMENT_LOAD] && !argv[ARGUMENT_RESTORE] &&
			!argv[ARGUMENT_DEFAULT] && !argv[ARGUMENT_REMOVE]) {
	       argv[ARGUMENT_LOAD] = (BYTE *)-1L;
	    }
	    if (!argv[ARGUMENT_SHOW] && !argv[ARGUMENT_SAVE] &&
			 !argv[ARGUMENT_BACKUP] && !argv[ARGUMENT_REMOVE]) {
	       argv[ARGUMENT_SHOW] = (BYTE *)-1L;
	    }

	    /* Get output file handle for show */
	    if (argv[ARGUMENT_SHOW]) {
	       BYTE *output = argv[ARGUMENT_OUTPUT];

	       if (!output) {
		  fh = Output();
	       } else {
		  if (!(fh = Open(output, (LONG)MODE_NEWFILE))) {
		     Printf("Can't open '%s'\n", output);
		     error = HBERR_FILE_OPEN_FAILED;
		  }
	       }
	    }

	    /* Load hardblocks from device */
	    if (!error && argv[ARGUMENT_LOAD]) {
	       Printf("Loading hardblocks from unit %ld of `%s'\n", unit,
								    device);
	       if (!(error = LoadHardBlocks(&rdb, device, unit))) {

		  /* Now play with hardblocks data */
		  if (argv[ARGUMENT_SHOW]) {
		     error = PrintHardBlocks(&rdb, fh);
		  }
		  if (!error && argv[ARGUMENT_BACKUP]) {
		     if (!file) {
			Printf("No backup file name\n");
			error = HBERR_FILE_OPEN_FAILED;
		     } else {
			Printf("Backup hardblocks to `%s'\n", file);
			error = BackupHardBlocks(&rdb, file);
		     }
		  }
		  FreeHardBlocks(&rdb);
	       }
	    }
	    
	    /* Restore hardblocks from file */
	    if (!error && argv[ARGUMENT_RESTORE]) {
	       if (!file) {
		  Printf("No restore file name\n");
		  error = HBERR_FILE_OPEN_FAILED;
	       } else {
		  Printf("Restoring hardblocks from `%s'\n", file);
		  if (!(error = RestoreHardBlocks(&rdb, file))) {

		     /* Now play with hardblocks data */
		     if (argv[ARGUMENT_SHOW]) {
			error = PrintHardBlocks(&rdb, fh);
		     }
		     if (!error && argv[ARGUMENT_SAVE]) {
			Printf("Saving hardblocks to unit %ld of"
						   " `%s'\n", unit, device);
			if (safety_check(device, unit) == TRUE) {
			   error = SaveHardBlocks(&rdb, device, unit);
			}
		     }
		     FreeHardBlocks(&rdb);
		  }
	       }
	    }

	    /* Create standard rigid disk block */
	    if (!error && argv[ARGUMENT_DEFAULT]) {
	       Printf("Creating standard rigid disk block for unit %ld"
						" of `%s'\n", unit, device);
	       if (!(error = InitRigidDiskBlock(&rdb, device, unit))) {

		  /* Now play with hardblocks data */
		  if (argv[ARGUMENT_SHOW]) {
		     error = PrintHardBlocks(&rdb, fh);
		  }
		  if (!error && argv[ARGUMENT_SAVE]) {
		     Printf("Saving hardblocks to unit %ld of `%s'\n", unit,
								    device);
		     if (safety_check(device, unit) == TRUE) {
			error = SaveHardBlocks(&rdb, device, unit);
		     }
		  }
		  if (!error && argv[ARGUMENT_BACKUP]) {
		     if (!file) {
			Printf("No backup file\n");
			error = HBERR_FILE_OPEN_FAILED;
		     } else {
			Printf("Backup hardblocks to `%s'\n", file);
			error = BackupHardBlocks(&rdb, file);
		     }
		  }
		  FreeHardBlocks(&rdb);
	       }
	    }

	    /* Delete rigid disk block */
	    if (!error && argv[ARGUMENT_REMOVE]) {
	       Printf("Removing hardblocks from unit %ld of `%s'\n", unit,
								    device);
	       if (safety_check(device, unit) == TRUE) {
		  error = RemoveHardBlocks(device, unit);
	       }
	    }

	    /* Close output file handle opened for show */
	    if (argv[ARGUMENT_SHOW] && argv[ARGUMENT_OUTPUT]) {
	       Close(fh);
	    }

	    /* Print error msg */
	    if (error) {
	       Printf("Error: primary=%d   secondary=%ld\n", error, IoErr());
	    } else {
	       return_code = RETURN_OK;
	    }
	 }
#ifndef LINK_TEST
	 CloseLibrary(HardBlocksBase);
      }
#endif LINK_TEST
      CloseLibrary(ArpBase);
   }

   /* MANX crt0.asm forget to close DOS library, so we have to do it */
   CloseLibrary(DOSBase);
   return(return_code);
}
	/* Safety check before any writing to device unit */

   STATIC BOOL
safety_check(BYTE *device, ULONG unit)
{
   BYTE buffer[MaxInputBuf];
   BOOL answer = FALSE;

   Printf("DANGER: Do you really want to change hardblocks on unit %ld of\n"
	  "        device `%s' (YES|NO)? ", unit, device);
   ReadLine(&buffer[0]);
   if (strcmp(&buffer[0], "YES")) {
      Puts("Change aborted");
   } else {
      answer = TRUE;
   }
   return(answer);
}
