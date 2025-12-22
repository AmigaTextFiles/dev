LIBRARY DEVICE 'bla.device', 37, 1, 'bla.device by nisse 2001'

MODULE 'exec/devices'
MODULE 'exec/io'

-> YAEC1.9a : now opens exec,dos,intui,gfx automatically.

/* NOTE1 : LIBRARY mode is not for beginners ! */

/* NOTE2 : DEVICE mode is for experts ! */

/* NOTE4 : do NOT pass out exceptions from devicecode */

/* NOTE5 : filename of device will be src-filename without .e */

/* NOTE6 : this is just a very thin skeleton-device */

/* NOTE7 : it does not do anything as is, you have to code the rest */

/* NOTE8 : DEVICE mode is not tested yet ! (dont be shy..) */

/* NOTE9 : UNDER CONSTRUCTION.. (I have never written a device..) */

/* NOTEA : Ptr to the device is in the global "libbase" */

/* NOTEB : the library/device-base is READ-ONLY. */

/* the two required entries of a device, starting at -30 */

ENTRY BeginIO(iostd)(a1) IS beginIO(A1) -> dont change

ENTRY AbortIO(iostd)(a1) IS abortIO(A1) -> dont change


/* the four required standard functions */
/* see amiga dev cd x.x (RKM) for info about theese functions */
/* for example, do NOT call functions that could break Forbid() ! */
/* picky stuff like opencount, removing us etc.. is taken care of */


/* system loading us up from disk */
/* we got exec and dos ready */
PROC Init() -> gets called when loaded from disk !
   -> do stuff
ENDPROC TRUE  -> return TRUE for success.

/* user calling OpenDevice() on us */
PROC Open(iob:PTR TO iostd,
          unitnum:LONG,
          flags:LONG) 
   -> do stuff
ENDPROC TRUE  -> return TRUE for success.

/* User calling CloseDevice() on us */
PROC Close(iob:PTR TO iostd) 
   -> do stuff
ENDPROC

/* if we have no openers, the system might give us a chance to exit. */
/* do we want to exit ? */
/* if so, cleanup resources and return <> NIL */
/* if not, just return NIL */
PROC Expunge() 
   -> do stuff
ENDPROC TRUE  -> You should normally return TRUE here.
              -> Returning <> NIL allows removing of lib
              -> (returning NIL will abort expunge!)

/* empty device functions */

PROC beginIO(iob:PTR TO iostd)
  ->do stuff here
ENDPROC

PROC abortIO(iob:PTR TO iostd)
   -> do stuff here
ENDPROC

