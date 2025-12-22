/* 
 *  Runs the NewGUI-Engine (guimessage-handling) in a seperate Task
 * -===============================================================-
 * 
 * 
 */

OPT     LARGE 
OPT     OSVERSION = 37

MODULE  'dos/dos'
MODULE  'newgui/newgui'
MODULE  'newgui/ng_guitask'
MODULE  'newgui/ng_showerror'

ENUM    GUI_MAIN = 1,
        GUI_WIN2

DEF     info:PTR TO guitaskinfo                 -> Guitaskinfo-Structure

PROC main()     HANDLE
 opengui()                                      -> Open the gui (in a other task!)

  dootherthings()                               -> Do other things (like calculations...)

EXCEPT DO                                       -> Exception-Handling, but do it every time the program ends
 ng_endtask(info)                               -> End and kill the gui-task
  IF exception THEN ng_showerror(exception)     -> If any exception happened then show it
 CleanUp(exception)                             -> Cleanup (with exception as return-code)
ENDPROC

PROC opengui()                                  -> Should open the gui!
  info:=ng_newtask(                             -> initialize a new task for the GUI!!!!
       [NG_WINDOWTITLE,         'NewGUI-Task-Demo',
        NG_AUTOOPEN,    TRUE,
        NG_GUIID,       GUI_MAIN,
        NG_GUI,
                [EQCOLS,
                [SPACEH],
                        [SBUTTON,0,'End!'],
                [SPACEH]
                ],
        NG_NEXTGUI,
->
       [NG_WINDOWTITLE,         'NewGUI-Task-Window2',
        NG_AUTOOPEN,    TRUE,
        NG_GUIID,       GUI_WIN2,
        NG_GUI, 
                [EQCOLS,
                [SPACEH],
                        [SBUTTON,{test},'Test'],
                [SPACEH]
                ],
->
        NIL,NIL],
        NIL,NIL],NG_STACK_SIZE)                 -> NG_STACK_SIZE is Standart-Size of 4096 bytes!
ENDPROC

PROC dootherthings()                            -> Do other important things...
 DEF    a=0
  Wait(info.sig OR SIGBREAKF_CTRL_C)            -> Wait until the GUI is ready (or Break!)
   WHILE (ng_checkgui(info)=FALSE)              -> Wait until the GUI will be closed
    Delay(1)                                    -> Give other Tasks our CPU-Time...
     WriteF('\d ',a)                            -> Output the actual value of a
    a++                                         -> calculate a(=a+1)
   ENDWHILE
ENDPROC

PROC test()                                     -> Test-Message!
 WriteF('\ntest!\n')
ENDPROC
