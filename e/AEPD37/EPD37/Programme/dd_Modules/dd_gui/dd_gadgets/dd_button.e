MUIA_List_Active,0)
   set(st_Brian   ,MUIA_String_AttachedList,lv_Brian)


/*
** Everything's ready, lets launch the application. We will
** open the master window now.
*/

   set(wi_Master,MUIA_Window_Open,MUI_TRUE);


/*
** This is the main loop. As you can see, it does just nothing.
** Everything is handled by MUI, no work for the programmer.
**
** The only thing we do here is to react on a double click
** in the volume list (which causes an ID_NEWVOL) by setting
** a new directory name for the directory list. If you want
** to see a real file requester with MUI, wait for the
** next release of MFR :-)
*/


   running := TRUE  /* Not for MUI -> no need to use MUI_TRUE */

   WHILE running

      result := doMethod(ap_Demo, [MUIM_Application_Input, {signal} ])

      SELECT result

	 CASE MUIV_Application_ReturnID_Quit
	    running := FALSE

	 CASE ID_NEWVOL
	    doMethod(lv_Volumes, [MUIM_List_GetEntry, MUIV_List_GetEntry_Active, {buf} ])
	    set(lv_Directory, MUIA_Dirlist_Directory, buf)

	 CASE ID_NEWBRI
	    get(lv_Brian, MUIA_List_Active, {buf} )
	    set(st_Brian, MUIA_String_Contents, lvt_Brian[buf] )

	 CASE ID_ABOUT
	    Mui_RequestA(ap_Demo, wi_Master, 0, NIL, 'OK', 'MUI-Demo\n© 1992-94 by Stefan Stuntz',NIL)

      ENDSELECT

      IF signal THEN Wait(signal)

   ENDWHILE

/*
** Call the exception handling with ER_NON, this will dispose the
** application object, close "muimaster.library" and end the program.
*/

  Raise(ER_NON)

EXCEPT
  IF ap_Demo THEN Mui_DisposeObject(ap_Demo)
  IF muimasterbase THEN CloseLibra