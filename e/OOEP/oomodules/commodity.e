OPT MODULE
OPT OSVERSION=37

MODULE  'oomodules/library/commodities',
        'oomodules/object',

        'commodities',
        'libraries/commodities',
        'exec/ports'


DEF nb:PTR TO newbroker,
    hotkey, hotkeyID,

    cxlib:PTR TO commodities

EXPORT OBJECT commodity OF object
/****** object/commodity ******************************

    NAME
        commodity of object -- Commodity object. Installs a commodity in the
            system.

    PURPOSE
        Add commodity facilities to your application.

    ATTRIBUTES
        broker:LONG -- Pointer to broker structure as returned and used
            by the commodities.library

        messagePort:PTR TO mp -- Message port of the commodity. Messages
            arrive here when we press the hotkey, enable the commodity and
            so on.

        openGUIProc:LONG -- Address of the proc to call when the commodity is
            told to open the gui (via hotkey or exchange program). No
            arguments.

        closeGUIProc:LONG -- The opposite of the open gui proc.

        killProc:LONG -- Address of proc to call when the commodity is told
            to quit. If left NIL a standard proc is called that removes the
            commodity from the system, frees the message port and other
            allocated resources. That standard proc is removeFromSystem().
            You may put your own proc here and call removeFromSystem() when
            you're finished. See autodoc of that proc.

    NOTES
        A quick & dirty implementation from one of my old sources. I'm sure it
        isn't finished.

    SEE ALSO
        object

********/
  broker
  messagePort:PTR TO mp
  openGUIProc
  closeGUIProc
  killProc
ENDOBJECT

PROC init() OF commodity
/****** commodity/init ******************************

    NAME
        init() of commodity -- Initialization of the object.

    SYNOPSIS
        commodity.init()

    FUNCTION
        Opens commodities library if needed and creates message port. Some
        flags are set. The commodity is set to be unique.

    SEE ALSO
        commodity

********/

  NEW cxlib.new()

  self.messagePort := CreateMsgPort()
  NEW nb

  nb.unique := NBU_UNIQUE OR NBU_NOTIFY
  nb.flags := COF_SHOW_HIDE
  nb.port := self.messagePort

  hotkeyID := 1

  SUPER self.init()

ENDPROC

PROC select(opts,i) OF commodity
/****** commodity/select ******************************

    NAME
        select() of commodity -- Selection of action.

    SYNOPSIS
        commodity.select(LONG, LONG)

        commodity.select(opts, i)

    FUNCTION
        The following tags are recognized:
            "name" -- Name of cx.

            "title" -- Title of cx. Some simple line that says who did it.

            "desc" -- Short description line ('OS3 version', 'Testversion')

            "vers" -- Version byte

            "hotk" -- Hotkey string, e.g. 'control alt d'

            "open" -- Pointer to proc that will be called if the cx is told
                to open the gui. No arguments are passed.

            "clos" -- Pointer to proc that will be called if the cx is told
                to close the gui. No arguments are passed.

            "kill" -- Pointer to proc that will be called if the cx is told
                to kill the gui. No arguments are passed. If you use this tag
                be sure to call removeFromSystem().

            "now" -- If this tag is found in the list the cx is added to the
                system at once. Do *NOT* provide any more tags, this one has
                to be the last one in the list. If you do, behaviour is
                undefined.

        The tags "name", "titl", "desc" and "hotkey" have to be provided.
        However, this is not checked. If you forget one, behaviour is
        undefined.

    INPUTS
        opts:LONG -- Option list.

        i:LONG -- Index of optionlist.

    RESULT
        LONG -- Current index we are at.

    EXAMPLE
         NEW cx.new(["name", 'DevEnv',
                     "titl", 'DevEnv 0.5ß © 1995,6 Gregor Goldbach',
                     "desc", 'E Development Environment',
                     "vers", 5,
                     "hotk", 'control alt d',
                     "open", {showMainWindow},
                     "now"])
    SEE ALSO
        commodity

********/
DEF item

  item:=ListItem(opts,i)


  SELECT item

    CASE "name"

      INC i
      nb.name := ListItem(opts,i)

    CASE "titl"

      INC i
      nb.title := ListItem(opts,i)

    CASE "desc"

      INC i
      nb.descr := ListItem(opts,i)

    CASE "hotk"

      INC i
      hotkey := ListItem(opts,i)

    CASE "vers"

      INC i
      nb.version := ListItem(opts,i)

    CASE "now"

      self.addToSystem()
      END nb

    CASE "open"

      INC i
      self.openGUIProc := ListItem(opts,i)

    CASE "clos"

      INC i
      self.closeGUIProc := ListItem(opts,i)

    CASE "kill"

      INC i
      self.killProc := ListItem(opts,i)

  ENDSELECT

ENDPROC i

EXPORT PROC addToSystem() OF commodity
/****** commodity/addToSystem ******************************

    NAME
        addToSystem() of commodity -- Adds commodity to the system.

    SYNOPSIS
        commodity.addToSystem()

    FUNCTION
        The commodity is installed by the commodities library, arguments set
        in select() will be used. Check self.broker to know if the creation
        was successful or not. There may be an exception for this in the
        future.

    SEE ALSO
        commodity

********/
DEF filter, sender, translate

  IF nb

    self.broker:=CxBroker(nb,0) -> Create broker with the filled nb structure

    IF self.broker


        /* Create a filter which checks *
         * input events for our hotkey. */
        IF filter:=CreateCxObj(CX_FILTER,hotkey,0)
           /* We have to attach the filter to *
            * our broker.                     */
          AttachCxObj(self.broker,filter)
           /* Create a sender which sends us *
            * hotkey/data info to our port   */
          IF sender:=CreateCxObj(CX_SEND,self.messagePort,hotkeyID)
            /* Attach the sender to the filter */
            AttachCxObj(filter,sender)
            /* Create a translator which 'eats' *
             * the input event if it was ours.  */
            IF translate:=CreateCxObj(CX_TRANSLATE,0,0)
              /* Attach also the translator to the filter */
              AttachCxObj(filter,translate)
              /* Global error-check on our filter */
              IF (CxObjError(filter)=0)
                /* No errors. Let's go! */
                ActivateCxObj(self.broker,TRUE)
                /* We use a subroutine now         *
                 * (only to have a cleaner source) */
              ENDIF
            ENDIF
          ENDIF
        ENDIF
      ENDIF
    ENDIF

ENDPROC

PROC removeFromSystem() OF commodity
/****** commodity/removeFromSystem ******************************

    NAME
        removeFromSystem() of commodity --

    SYNOPSIS
        commodity.removeFromSystem()

    FUNCTION

    RESULT

    EXAMPLE

    CREATION

    HISTORY

    NOTES

    SEE ALSO
        commodity

********/

  DeleteCxObjAll(self.broker)
  DeleteMsgPort(self.messagePort)

  END cxlib

ENDPROC

EXPORT PROC handleInputs() OF commodity
/****** commodity/handleInputs ******************************

    NAME
        handleInputs() of commodity --

    SYNOPSIS
        commodity.handleInputs()

    FUNCTION

    RESULT

    EXAMPLE

    CREATION

    HISTORY

    NOTES

    SEE ALSO
        commodity

********/
DEF msg,msgid,msgtype,rcode,
    proc

  REPEAT
    rcode:=0        /* reset main LOOP RETURN code */

    /* Wait for any message at our port */

    WaitPort(self.messagePort)


    /* Get the message :) */

    IF msg:=GetMsg(self.messagePort)

      /* Get more data from message for CX */

      msgid:=CxMsgID(msg)
      msgtype:=CxMsgType(msg)

      /* Reply (here OR later but important!) */

      ReplyMsg(msg)

      /* Check for CXM_IEVENT (Hotkey) */

      IF msgtype=CXM_IEVENT

        /* Was it our hotkey? */

        IF msgid=hotkeyID

          /*** Here the hotkey action takes place! ***/

          proc := self.openGUIProc
          IF proc THEN proc()

        ENDIF

      /* Check for CXM_COMMAND (Exchange, ...) */

      ELSEIF msgtype=CXM_COMMAND

        /* Exchange command Disable */

        IF msgid=CXCMD_DISABLE

          /*** Remove patches / stop cx-action here ***/

          ActivateCxObj(self.broker,FALSE)

          /* Exchange command Enable */

        ELSEIF msgid=CXCMD_ENABLE

          /*** Install patches / start our cx-action here ***/

          ActivateCxObj(self.broker,TRUE)

          /* Exchange command Show (if COF_SHOW_HIDE flag is SET) */

        ELSEIF msgid=CXCMD_APPEAR

          /*** Open our GUI/window here ***/

          proc := self.openGUIProc
          IF proc THEN proc()

          /* Exchange command Hide (see CMD_APPEAR) */

        ELSEIF msgid=CXCMD_DISAPPEAR

          /*** Close our GUI/window here ***/


          /* We were started again by a stupid user, *
           * so we tell him and ask to quit.         *
           * (CXCMD_UNIQUE if nb.unique filled)      *
           * rcode becomes 1 if user wants to quit   */

          proc := self.closeGUIProc
          IF proc THEN proc()

        ELSEIF msgid=CXCMD_UNIQUE

          rcode:=EasyRequestArgs(0,[20,0,'CX 37.0','CX already works.\nQuit it now?','Quit|Cancel'],0,0)

          /* Exchange Killer command */

        ELSEIF msgid=CXCMD_KILL

          proc := self.killProc
          IF proc THEN proc()

          rcode:=1

          /* COMMAND check end */

        ENDIF

      /* COMMAND & IEVENT check end */

      ENDIF

    /* message scanned & replied */

    ENDIF

  /* get the next message from our master */

  UNTIL rcode

ENDPROC

/*EE folds
-1
17 44 19 30 22 115 25 56 
EE folds*/
