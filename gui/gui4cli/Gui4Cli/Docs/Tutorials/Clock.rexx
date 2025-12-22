/***********************************************************************/
/* This is a small arexx program which gets called from a Gui4Cli      */
/* gui, as follows :                                                   */
/*     > SendRexx AREXX 'Clock.rexx GuiName RoutineName'               */
/* OR  > RUN 'RX Clock.gc GuiName RoutineName'                         */
/* where :                                                             */
/* GuiName     is the name of the calling gui, whose variables will    */
/*             be set and which contains the routine that'll be called */
/* RoutineName is the name of a routine in the above Gui, which will   */
/*             be called every minute.                                 */
/* The variables "time" "date" etc can then be used as needed          */
/***********************************************************************/

/* add the rexxsuport.library which provides the Delay() command       */
call addlib('rexxsupport.library',0,-30,0)

/* parse the arguments we were sent, into variables "gui" and "routine"*/
parse arg gui routine

/* this variable is needed below - see loop after the delay function   */
guifile = "ENV:Gui4Cli/" || gui

/* talk to Gui4Cli */
address "Gui4Cli"

/* Now we can just issue the Gui4Cli arexx commands directly, as if    */
/* we were in a gui. However, we have to take care of the quotes, so   */
/* that Gui4Cli receives the arguments as it expects them..            */
/* That's what the '"' || things are for.                              */
/* The resulting string will be something like :                       */
/* > SETVAR MYGUI.GC/date "23 Nov 1997"                                */

do forever
   setvar   gui || "/time"     '"' || time('c') || '"'
   setvar   gui || "/date"     '"' || date()    || '"'
   setvar   gui || "/day"      '"' || date('w') || '"'
   setvar   gui || "/month"    '"' || date('m') || '"'
   gosub    gui routine

   /* Now we have to delay for a minute until we do the loop again..   */
   /* Note that the delay function will return a result - we must put  */
   /* this result somewhere (in this case we store it in "dumy")       */
   /* otherwise arexx would send it to Gui4Cli which wouldn't know     */
   /* what to do with it */

   dumy = delay(3000)                          /* delay for one minute */

   /* After the delay, we have to check if the gui that called us is   */
   /* still in business. We do this by checking if the gui's file name */
   /* is present in Gui4Cli's env: directory - I'm going to add        */
   /* some way to do this better, but for the moment it suffices..     */

   if ~exists(guifile) then
       exit

end
exit

