/*	This procedure was given to me by Wouter van Oortmerssen, the Amiga E author.
It replaces the DoMethod() function (included in the amiga.lib library) for E users. */

PROC domethod( obj:PTR TO object, msg:PTR TO msg )

	DEF h:PTR TO hook, o:PTR TO object, dispatcher

	IF obj
		o := obj-SIZEOF object	 /* instance data is to negative offset */
		h := o.class
		dispatcher := h.entry 	 /* get dispatcher from hook in iclass */
		MOVEA.L h,A0
		MOVEA.L msg,A1
		MOVEA.L obj,A2		   /* probably should use CallHookPkt, but the */
		MOVEA.L dispatcher,A3    /*	original code (DoMethodA()) doesn't. */
		JSR (A3)				   /* call classDispatcher() */
		MOVE.L D0,o
		RETURN o
	ENDIF

ENDPROC NIL
