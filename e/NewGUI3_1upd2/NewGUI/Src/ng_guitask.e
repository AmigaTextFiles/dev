/* 
 *  Asynchron NewGUI-Handling with a subtask
 * -========================================-
 * 
 * © 1998 THE DARK FRONTIER Softwareentwicklungen
 * 
 */

OPT     OSVERSION = 37
OPT     MODULE

MODULE  'amigalib/tasks'
MODULE  'dos/dos'
MODULE  'exec/tasks'
MODULE  'newgui/newgui'
MODULE  'other/ecode'

EXPORT OBJECT  guitaskinfo
 maintask       :PTR TO tc
 guitask        :PTR TO tc
 tags           :PTR TO LONG
 gui            :PTR TO guihandle
 sig            :LONG
 signum         :INT
ENDOBJECT

EXPORT CONST   NG_STACK_SIZE = 4096             -> Std-Stack-Size (increase it if needed!)

PROC handlegui()                                -> Gui-Handling (Task-Code)
 DEF    task=NIL:PTR TO tc,                     -> PTR to our Task (for userdata = guitaskinfo!!!)
        info:PTR TO guitaskinfo,                -> guitaskinfo (for maintask, tags and guihandle!)
        gui=NIL:PTR TO guihandle,               -> Guihandle to our gui!
        res=-1                                  -> resultcode of the gui(s)
  task:=FindTask(NIL)                           -> Find our Task
   info:=task.userdata                          -> Get the guitaskinfo-structure
    gui:=guiinitA(info.tags,NIL)                -> open our gui with the given tags
     info.gui:=gui                              -> Save the gui-ptr (because it could be that our task is killed until we had closed the gui!)
      Signal(info.maintask,info.sig)            -> signal our main-Task that we are ready!
      WHILE (res<0)                             -> normal message-handling-loop
       Wait(gui.sig)
       res:=guimessage(gui)
      ENDWHILE
     IF (gui<>NIL) THEN cleangui(gui,TRUE)      -> clean our gui with the sub-guis
    info.gui:=NIL                               -> set the guihandle in the guitaskinfo-structure to NIL
   Signal(info.maintask,info.sig)               -> signal our main-Task that it should close (us)
  Wait(NIL)                                     -> Wait unti we are killed
ENDPROC res                                     -> Unneccesary, because we are killed, so return-codes are nonsens!

EXPORT PROC ng_newtask(tags,stacksize)          -> Init the new Task
 DEF    task=NIL:PTR TO tc,                     -> The new Task
        code=NIL,                               -> The code for the guihandling
        info:PTR TO guitaskinfo                 -> guitaskinfo-structure
   IF (code:=eCodeTask({handlegui}))            -> Make the Code read for task-use
    NEW info                                    -> Allocate the guitaskinfo-structure
     info.maintask:=FindTask(NIL)               -> Save the adress from the main-task in the structure
      info.tags:=tags                           -> save the given tags for the gui
       info.signum:=-1                          -> Preset Signal-Value
        info.signum:=AllocSignal(-1)            -> Allocate a Signalbit
       IF (info.signum=-1) THEN Raise(ERR_NG_SIGNAL)    -> Could not allocate Signal-Bit
      info.sig:=Shl(1,info.signum)              -> Get the Signalbit our of the given Signal-number
     IF (task:=createTask('NewGUI',-1,code,stacksize,info))     -> Create the Task (with the guitaskinfo as task.userdata!!)
      task.userdata:=info                       -> ???
      info.guitask:=task                        -> Save our Task-Address for later useage (Killing!)
     ELSE
      Raise(ERR_NG_TASK)                        -> Error with createTask()
     ENDIF
   ELSE
    Raise(ERR_NG_CODE)                          -> Error with eCodeTask()
   ENDIF
ENDPROC info                                    -> Return the guitaskinfo-structure

EXPORT PROC ng_endtask(info:PTR TO guitaskinfo) -> End the Task and remove all related things
 DEF    task:PTR TO tc                          -> PTR to our task-structure
  task:=info.guitask                            -> get the PTR to our gui-task out of the guitaskinfo
   Forbid()                                     -> Forbit the task-switching!
    deleteTask(task)                            -> Remove the Task and kill it!
   Permit()                                     -> Permit the task-switching!
  FreeSignal(info.signum)                       -> Free the allocated Signal-Bit
 IF (info.gui<>NIL) THEN cleangui(info.gui,TRUE)-> If there is a opened gui -> Close it!
 END info                                       -> Free the allocated info-Structure
ENDPROC

EXPORT PROC ng_checkgui(info:PTR TO guitaskinfo)        IS IF (SetSignal(NIL,NIL) AND info.sig) THEN TRUE ELSE FALSE
                                                -> Check if the signal from the sub-(gui-)task arrived
                                                -> Should be called sometimes!
