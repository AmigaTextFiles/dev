
OPT OSVERSION=37

/* The following MODULE statements come from EPP.  EPP came up with these
statements given the following PMODULE statements:

PMODULE 'eheaders:exec/types'
PMODULE 'eheaders:workbench/workbench'
PMODULE 'eheaders:workbench/startup'
PMODULE 'eheaders:exec/libraries'
*/


MODULE 'exec/types'
MODULE 'exec/nodes'
MODULE 'exec/lists'
MODULE 'exec/tasks'
MODULE 'graphics/gfx'
MODULE 'exec/ports'
MODULE 'exec/semaphores'
MODULE 'utility/hooks'
MODULE 'graphics/clip'
MODULE 'graphics/copper'
MODULE 'graphics/gfxnodes'
MODULE 'graphics/monitor'
MODULE 'hardware/custom'
MODULE 'graphics/view'
MODULE 'graphics/rastport'
MODULE 'graphics/layers'
MODULE 'utility/tagitem'
MODULE 'graphics/text'
MODULE 'exec/io'
MODULE 'devices/serial'
MODULE 'devices/inputevent'
MODULE 'intuition/intuition'
MODULE 'workbench/workbench'
MODULE 'dos/dos'
MODULE 'workbench/startup'
MODULE 'exec/libraries'
MODULE 'icon'
MODULE 'wb'

DEF appmsg:PTR TO appmessage
DEF args:PTR TO wbarg

DEF dropcount
DEF x
DEF dobj:PTR TO diskobject
DEF myport:PTR TO mp
DEF appcon:PTR TO appicon

PROC main()

    IF (iconbase:=OpenLibrary('icon.library',37))
    IF (workbenchbase:=OpenLibrary('workbench.library',37))
      IF (dobj:=GetDefDiskObject(WBDISK))
        dobj.type:=NIL
        IF (myport:=CreateMsgPort())
          IF (appcon:=AddAppIconA(NIL,NIL,'TestAppIcon',myport,NIL,dobj,NIL))
            dropcount:=0
            WriteF('Drop files on the AppIcon.\n')
            WriteF('Example exits after 3 drops.\n')

            WHILE dropcount < 3
              WaitPort(myport)
              WHILE appmsg:=GetMsg(myport)
                IF appmsg.numargs = 0
                  WriteF('User activated the AppIcon.\nA window here would be nice.\n')
                ELSEIF appmsg.numargs>0
                  WriteF('User dropped \d icons on the AppIcon.\n',appmsg.numargs)
                  args:=appmsg.arglist
                  FOR x:= 1 TO appmsg.numargs
                     WriteF('#\d name = "\s"\n',x,args[].name++)
                  ENDFOR
                ENDIF
                ReplyMsg(appmsg)
              ENDWHILE
              INC dropcount
            ENDWHILE
            RemoveAppIcon(appcon)
            WHILE appmsg:=GetMsg(myport)
              ReplyMsg(appmsg)
            ENDWHILE
            DeleteMsgPort(myport)
            FreeDiskObject(dobj)
            CloseLibrary(workbenchbase)
            CloseLibrary(iconbase)
          ENDIF
        ENDIF
      ENDIF
    ENDIF
  ENDIF
ENDPROC
