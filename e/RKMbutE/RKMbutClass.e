
/****

	RKMbutClass.e

	Translated from RKMbutClass.c by Vidar Hokstad <vidarh@rforum.no>

	Please notice that this code is not as commented as it should
	have been, and some of the utility code should have been
	placed in it's own module. An improved version will be submitted
	to AEE shortly.

****/

OPT OSVERSION=37
OPT PREPROCESS

MODULE 'exec/types','intuition/intuition','intuition/classes',
		'intuition/classes','intuition/classusr','intuition/imageclass',
		'intuition/gadgetclass','intuition/cghooks','intuition/icclass',
		'utility/tagitem','utility/hooks','devices/inputevent',
		'tools/boopsi','graphics/rastport','utility',
		'intuition/screens','tools/installhook'


#define INST_DATA(cl,o) ((o)+(cl.instoffset))

/***********************************************************/
/****************      Class specifics      ****************/
/***********************************************************/

#define RKMBUT_PULSE   (TAG_USER + 1)

OBJECT butINST
	midx,midy	-> Coordinates of middle of gadget
ENDOBJECT

/* The functions in this module:

	Class *initRKMButGadClass(void);
	BOOL   freeRKMButGadClass(Class *);
	ULONG  dispatchRKMButGad(Class *, Object *, Msg);
	void   notifyPulse(Class *, Object *, ULONG, LONG, struct gpInput *);
	ULONG  renderRKMBut(Class *, struct Gadget *, struct gpRender *);
	void   geta4(void);
	void   mainLoop(ULONG, ULONG);

***/

/*************************************************************************************************/
/* The main() function connects an RKMButClass object to a Boopsi integer gadget, which displays */
/* the RKMButClass gadget's RKMBUT_Pulse value.  The code scales and move the gadget while it is */
/* in place.                                                                                     */
/*************************************************************************************************/

DEF pulse2int:PTR TO LONG

#define INTWIDTH  40
#define INTHEIGHT 20

DEF w:PTR TO window
DEF rkmbutcl:PTR TO iclass
DEF integer:PTR TO gadget,but:PTR TO gadget
DEF msg:PTR TO intuimessage

PROC main()

	pulse2int:= [ RKMBUT_PULSE, STRINGA_LONGVAL,TAG_END,0]

	IF utilitybase:= OpenLibrary('utility.library', 37)
		IF w:= OpenWindowTagList(NIL,
				[WA_FLAGS,
					WFLG_DEPTHGADGET OR WFLG_DRAGBAR OR WFLG_CLOSEGADGET OR WFLG_SIZEGADGET,
					WA_IDCMP, IDCMP_CLOSEWINDOW, WA_WIDTH,640,
					WA_HEIGHT, 200, TAG_END,0])

			WindowLimits(w, 450, 200, 640, 200)

			IF rkmbutcl := initRKMButGadClass()
				IF integer:= NewObjectA(NIL,'strgclass',[
												GA_ID,1,
												GA_TOP, w.bordertop + 5,
 												GA_LEFT,w.borderleft+ 5,
												GA_WIDTH,INTWIDTH,
												GA_HEIGHT,INTHEIGHT,
												STRINGA_LONGVAL,0,
												STRINGA_MAXCHARS, 5,
												TAG_END,0])

					IF but:= NewObjectA(rkmbutcl,NIL,
									[GA_ID,2,
									GA_TOP,w.bordertop + 5,
 									GA_LEFT,integer.leftedge +
										integer.width + 5,
									GA_WIDTH,40,
									GA_HEIGHT,INTHEIGHT,
									GA_PREVIOUS,integer,
									ICA_MAP, pulse2int,
									ICA_TARGET,integer,
									TAG_END])

						AddGList(w, integer, -1, -1, NIL)
						RefreshGList(integer, w, NIL, -1);

						SetWindowTitles(w,'<-- Click to resize gadget Height',NIL)
						mainLoop(TAG_DONE,0)

						SetWindowTitles(w,'<-- Click to resize gadget Width',NIL)
						mainLoop(GA_HEIGHT,100)

						SetWindowTitles(w,'<-- Click to resize gadget Y position',NIL)
						mainLoop(GA_WIDTH,100)

						SetWindowTitles(w,'<-- Click to resize gadget X position',NIL)
						mainLoop(GA_TOP, but.topedge + 20)

						SetWindowTitles(w,'<-- Click to quit', NIL)
						mainLoop(GA_LEFT, but.leftedge + 20)

						RemoveGList(w, integer, -1)
						DisposeObject(but)
					ENDIF
					DisposeObject(integer)
				ENDIF
				freeRKMButGadClass(rkmbutcl)
			ENDIF
			CloseWindow(w)
		ENDIF	
		CloseLibrary(utilitybase)
	ENDIF
ENDPROC


PROC mainLoop(attr,value)

    SetGadgetAttrsA(but, w, NIL,[attr, value, TAG_DONE,0])

	LOOP
      WaitPort(w.userport)
		WHILE msg:= GetMsg(w.userport)
			IF msg.class = IDCMP_CLOSEWINDOW THEN RETURN TRUE
            ReplyMsg(msg)
		ENDWHILE
	ENDLOOP
ENDPROC



/***********************************************************/
/**    Make the class and set up the dispatcher's hook    **/
/***********************************************************/

PROC initRKMButGadClass()

	DEF cl:PTR TO iclass

	cl:=0

	IF cl:=MakeClass(NIL,'gadgetclass',NIL,SIZEOF butINST,0)

		-> Initialize the dispatcher hook

		installhook(cl.dispatcher,{dispatchRKMButGad})
	ENDIF
ENDPROC cl


/***********************************************************/
/******************     Free the class      ****************/
/***********************************************************/

PROC freeRKMButGadClass(cl)
ENDPROC FreeClass(cl)


/***********************************************************/
/**********       The RKMBut class dispatcher      *********/
/***********************************************************/

PROC dispatchRKMButGad(cl:PTR TO iclass,o:PTR TO object,msg:PTR TO msg)

	DEF inst:PTR TO butINST
	DEF retval = FALSE
	DEF object:PTR TO object,methodID
	DEF g:PTR TO gadget,gpi:PTR TO gpinput,ie:PTR TO inputevent
	DEF rp:PTR TO rastport
	DEF x,y,w,h,code,pens:PTR TO INT

	methodID:=msg.methodid
	SELECT methodID
        CASE OM_NEW      /* First, pass up to superclass */

			IF object := dosupermethod(cl, o, msg)

				g := object

				-> Initial local instance data

				inst := INST_DATA(cl, object)
				inst.midx := g.leftedge + (g.width / 2)
				inst.midy := g.topedge + (g.height / 2)
				inst.hidden:= FALSE

                retval := object
			ENDIF

		CASE GM_HITTEST

			-> Since this is a rectangular gadget this
			-> method always returns GMR_GADGETHIT.

			retval := GMR_GADGETHIT

		CASE GM_GOACTIVE

            inst := INST_DATA(cl, o)
						/* Only become active if the GM_GOACTIVE   */
						/* was triggered by direct user input.     */
			IF (msg::gpinput.ievent)
                       /* This gadget is now active, change    */
                       /* visual state to selected and render. */
				o::gadget.flags := o::gadget.flags OR GFLG_SELECTED
				renderRKMBut(cl,o,msg)
				retval := GMR_MEACTIVE
			ELSE		/* The GM_GOACTIVE was not         */
						/* triggered by direct user input. */
				retval := GMR_NOREUSE
			ENDIF
		CASE GM_RENDER
            retval	:= renderRKMBut(cl,o,msg)
		CASE GM_HANDLEINPUT   /* While it is active, this gadget sends its superclass an        */
                               /* OM_NOTIFY pulse for every IECLASS_TIMER event that goes by     */
                               /* (about one every 10th of a second).  Any object that is        */
                               /* connected to this gadget will get A LOT of OM_UPDATE messages. */

			g := o
			gpi := msg
			ie:= gpi.ievent

			inst:= INST_DATA(cl, o)

			retval:= GMR_MEACTIVE

			IF (ie.class = IECLASS_RAWMOUSE)
				code:=ie.code
				SELECT code
					CASE SELECTUP	/* The user let go of the gadget so return GMR_NOREUSE    */
									/* to deactivate and to tell Intuition not to reuse       */
									/* this Input Event as we have already processed it.      */

									/*If the user let go of the gadget while the mouse was    */
									/*over it, mask GMR_VERIFY into the return value so       */
									/*Intuition will send a Release Verify (GADGETUP).        */

						x:=gpi.mousex;y:=gpi.mousey


						IF (x < 0) OR
							(x > g.width) OR
							(y < 0) OR
							(y > g.height)

							retval := GMR_NOREUSE
						ELSE
							retval := GMR_NOREUSE OR GMR_VERIFY
						ENDIF
                                   /* Since the gadget is going inactive, send a final   */
								   /* notification to the ICA_TARGET.                    */
						notifyPulse(cl,o,0,inst.midx,msg)
					CASE MENUDOWN /* The user hit the menu button. Go inactive and let      */
                                  /* Intuition reuse the menu button event so Intuition can */
                                  /* pop up the menu bar.                                   */
						retval := GMR_REUSE

								/* Since the gadget is going inactive, send a final   */
								/* notification to the ICA_TARGET.                    */
						notifyPulse(cl , o, 0,inst.midx,msg)
					DEFAULT
						retval := GMR_MEACTIVE
				ENDSELECT
			ELSEIF (ie.class = IECLASS_TIMER)
	                    /* If the gadget gets a timer event, it sends an interim OM_NOTIFY */
				notifyPulse(cl, o, OPUF_INTERIM, inst.midx, gpi) /*     to its superclass. */

			ENDIF
		CASE GM_GOINACTIVE           /* Intuition said to go inactive.  Clear the GFLG_SELECTED */
                                      /* bit and render using unselected imagery.                */
			o::gadget.flags := And(o::gadget.flags,Not(GFLG_SELECTED))
			renderRKMBut(cl,o,msg)

		CASE OM_SET /* Although this class doesn't have settable attributes, this gadget class   */
                    /* does have scaleable imagery, so it needs to find out when its size and/or */
                    /* position has changed so it can erase itself, THEN scale, and rerender.    */

			inst:= INST_DATA(cl, o)

			g:= o

			x:= g.leftedge
			y:= g.topedge
			w:= g.width
			h:= g.height

			IF( FindTagItem(GA_WIDTH, msg::opset.attrlist) OR
                 FindTagItem(GA_HEIGHT,msg::opset.attrlist) OR
                 FindTagItem(GA_TOP, msg::opset.attrlist) OR
                 FindTagItem(GA_LEFT, msg::opset.attrlist) )

                retval:= dosupermethod(cl, o, msg)

				-> Get pointer to RastPort for gadget.

				IF rp:= ObtainGIRPort( msg::opset.ginfo)

					pens:= msg::opset.ginfo::gadgetinfo.drinfo::drawinfo.pens

					SetAPen(rp, pens[BACKGROUNDPEN])
					SetDrMd(rp, RP_JAM1)		-> Erase the old gadget.
					RectFill(rp, x, y, x+w, y+h)

					inst.midx := g.leftedge + (g.width / 2)	-> Recalculate where the
					inst.midy := g.topedge + (g.height / 2)	-> center of the gadget is.

					-> Rerender the gadget.

					domethod(o,[GM_RENDER, msg::opset.ginfo, rp, GREDRAW_REDRAW])
					ReleaseGIRPort(rp);
				ENDIF
            ELSE
                retval := dosupermethod(cl, o, msg)
			ENDIF
		DEFAULT	-> rkmbutclass does not recognize the methodID, let the superclass's
				-> dispatcher take a look at it.
			retval := dosupermethod(cl, o, msg)
	ENDSELECT
ENDPROC retval



/*************************************************************************************************/
/************** Build an OM_NOTIFY message for RKMBUT_Pulse and send it to the superclass. *******/
/*************************************************************************************************/

PROC notifyPulse(cl:PTR TO iclass,o:PTR TO object,flags,mid,gpi:PTR TO gpinput)
	DEF tags:PTR TO LONG,msg:PTR TO LONG,inst:PTR TO butINST

	inst:= INST_DATA(cl,o)

	tags:= [RKMBUT_PULSE,mid - (gpi.mousex + o::gadget.leftedge),
			GA_ID, o::gadget.gadgetid, TAG_DONE,0]

	msg:= [OM_NOTIFY, tags, gpi.ginfo, flags]
	msg[0]:=OM_NOTIFY			-> Because this field will be changed
								-> we have to reset it, since E's
								-> lists are static unless they are NEW'ed

    dosupermethod(cl, o, msg)

ENDPROC


/*************************************************************************************************/
/*******************************   Erase and rerender the gadget.   ******************************/
/*************************************************************************************************/

PROC renderRKMBut(cl:PTR TO iclass,g:PTR TO gadget,msg:PTR TO gprender)
	DEF inst:PTR TO butINST
	DEF rp:PTR TO rastport

	DEF retval = TRUE
	DEF pens:PTR TO INT
	DEF back,shine,shadow,w,h,x,y

	inst:=INST_DATA(cl,g)
	pens:= msg.ginfo::gadgetinfo.drinfo::drawinfo.pens

	IF msg.methodid = GM_RENDER	/* If msg is truly a GM_RENDER message (not a gpInput that */
                                /* looks like a gpRender), use the rastport within it...   */
		rp := msg.rport
	ELSE						/* ...Otherwise, get a rastport using ObtainGIRPort().     */
        rp := ObtainGIRPort(msg.ginfo)
	ENDIF

	IF rp
		IF And(g.flags,GFLG_SELECTED)	-> If the gadget is selected, reverse the meanings of the
										-> pens.
			back   := pens[FILLPEN]
			shine  := pens[SHADOWPEN]
			shadow := pens[SHINEPEN]
		ELSE
			back   := pens[BACKGROUNDPEN]
			shine  := pens[SHINEPEN]
			shadow := pens[SHADOWPEN]
		ENDIF

		SetDrMd(rp,RP_JAM1)

		SetAPen(rp, back)	-> Erase the old gadget.

		RectFill(rp, g.leftedge,
	             g.topedge,
	             g.leftedge + g.width,
	             g.topedge + g.height)

		SetAPen(rp, shadow)	-> Draw shadow edge.

		Move(rp, g.leftedge + 1, g.topedge + g.height)
		Draw(rp, g.leftedge + g.width, g.topedge + g.height)
		Draw(rp, g.leftedge + g.width, g.topedge + 1)


		w := g.width / 4		-> Draw Arrows - Sorry, no frills imagery
		h := g.height / 2
		x := g.leftedge + (w/2)
		y := g.topedge + (h/2)

		Move(rp, x, inst.midy)
		Draw(rp, x + w, y)
		Draw(rp, x + w, y + g.height - h)
		Draw(rp, x, inst.midy)

		x := g.leftedge + (w/2) + (g.width / 2)

		Move(rp, x + w, inst.midy)
		Draw(rp, x, y)
		Draw(rp, x, y  + g.height - h)
		Draw(rp, x + w, inst.midy)


		SetAPen(rp, shine)	-> Draw shine edge.

		Move(rp, g.leftedge,g.topedge + g.height - 1)
		Draw(rp, g.leftedge,g.topedge)
		Draw(rp, g.leftedge + g.width - 1, g.topedge)

		IF (msg.methodid <> GM_RENDER)	-> If we allocated a rastport, give it back.
			ReleaseGIRPort(rp)
		ENDIF
	ELSE
		retval := FALSE
	ENDIF
ENDPROC retval


PROC dosupermethod(cl:PTR TO iclass,obj:PTR TO object,msg:PTR TO msg)
  DEF h:PTR TO hook,o:PTR TO object,dispatcher
  IF obj
    h:=cl.super
    dispatcher:=h.entry      /* get dispatcher from hook in superclass */
    MOVE.L h,A0
    MOVE.L msg,A1
    MOVE.L obj,A2
    MOVE.L dispatcher,A3
    JSR (A3)                 /* call classDispatcher() */
    RETURN D0
  ENDIF
ENDPROC NIL


CHAR	'\0$VER: RKMbutClass 37.1',0
