/*
	PPI 2.0 - Copyright 1994 - 1995 Vincent Platt
	All Rights Reserved

	Requires E 3.0a+ to compile; and requires AmigaDOS 2.04+ and
	 bgui.library to execute.
*/

OPT OSVERSION=37
OPT PREPROCESS

MODULE	'libraries/bgui', 'libraries/bgui_macros', 'bgui',
	'libraries/gadtools', 'libraries/asl', 'asl',
	'gadtools',
	'tools/boopsi',
	'utility/tagitem',
	'intuition/classes',
	'intuition/classusr',
	'intuition/gadgetclass',
	'intuition/intuition',
	'intuition/icclass'

-> For simple ids for message handling, etc.
ENUM EDITOR_STRING, COMPILER_STRING, ACTION1_STRING, ACTION2_STRING,
	EDITOR_BUTTON, COMPILER_BUTTON, ACTION1_BUTTON, ACTION2_BUTTON,
	PICK_BUTTON, SAVE_LOCAL_BUTTON, SAVE_DEFAULT_BUTTON, KILL_CHECKBOX,
	WORKFILE_STRING

-> Gadget Pointers
DEF editor_but, compiler_but, action1_but, action2_but, pick_but, save_local_but, save_default_but
DEF editor_str, compiler_str, action1_str, action2_str
DEF workfile, cb, bgui_window, win_ptr

-> String & ASL vars
DEF strpickfile[256]:STRING, strcompile[256]:STRING, stredit[256]:STRING,
	straction1[256]:STRING, straction2[256]:STRING, a_path[256]:STRING,
	a_req, version, localname[1025]:STRING

-> For the checkbox
DEF checked=FALSE

-> For IBox structure which is used to save window's position and width
DEF ibox_obj:ibox


PROC main()

 DEF running = TRUE, rc = 0, signal

 version:='$VER: PPI 2.0 By Vincent Platt'
 IF bguibase := OpenLibrary( 'bgui.library', 37 )


	NEW ibox_obj				-> alloc mem for the ibox
	get_local()					-> establish name of local prefs file
	loadsettings()				-> load prefs for the program

	-> Set up the ASL requester for future use
	 a_req:=FileReqObject,EndObject

	-> Create a window object
	bgui_window := WindowObject,
	 WINDOW_TITLE,'PPI 2.0 - © 1995 Vincent Platt',
	 WINDOW_BOUNDS, ibox_obj,			-> open window according to defs or prefs
	 WINDOW_RMBTRAP, TRUE,				-> stop menu bar from flashing on RMB
	 WINDOW_SMARTREFRESH, TRUE,
	 WINDOW_LOCKHEIGHT, TRUE,			-> height is unchangeable
	 WINDOW_SCALEWIDTH, 1,				-> window width = small as possible
	 WINDOW_SIZEBOTTOM, FALSE,          -> bottom doesn't appear sizeable
	 WINDOW_SIZERIGHT, TRUE,			-> right side of window is sizeable
     WINDOW_AUTOASPECT, TRUE,			-> let bgui make some ratio decisions
	 WINDOW_MASTERGROUP,				-> start defining objects in window group

	-> Define all objects in window.
	 VGroupObject, Spacing(4), VOffset(4), HOffset(4), FixMinHeight,
	  StartMember, HGroupObject,

	   StartMember, VGroupObject,
	    StartMember,editor_str:=StringG('Editor:',stredit,200,EDITOR_STRING),EndMember,
	    StartMember,compiler_str:=StringG('Compiler:',strcompile,200,COMPILER_STRING),EndMember,
	    StartMember,action1_str:=StringG('Action 1:',straction1,200,ACTION1_STRING),EndMember,
	    StartMember,action2_str:=StringG('Action 2:',straction2,200,ACTION2_STRING),EndMember,
   	  	StartMember,workfile:=InfoFixed('Workfile:',strpickfile,0,1),EndMember,
        StartMember,cb:=CheckBoxNF('Kill Ext?',checked,KILL_CHECKBOX), FixMinWidth, EndMember,
	   EndObject, FixMinHeight, EndMember,

	   StartMember, VGroupObject,HOffset(4),
	    StartMember,editor_but:=KeyButton('_Edit',EDITOR_BUTTON),EndMember,
	    StartMember,compiler_but:=KeyButton('_Compile',COMPILER_BUTTON),EndMember,
	    StartMember,action1_but:=KeyButton('Action _1',ACTION1_BUTTON),EndMember,
	    StartMember,action2_but:=KeyButton('Action _2',ACTION2_BUTTON),EndMember,
	    StartMember,pick_but:=KeyButton('_Pick Workfile',PICK_BUTTON),EndMember,
	    StartMember,save_local_but:=KeyButton('Save _Local',SAVE_LOCAL_BUTTON),EndMember,
	    StartMember,save_default_but:=KeyButton('Save _Default',SAVE_DEFAULT_BUTTON),EndMember,
 	   EndObject, FixMinWidth, FixMinHeight, EndMember,
	  EndObject, EndMember,

	 EndObject,
	EndObject

	GadgetKey(bgui_window, editor_but,      'e')
	GadgetKey(bgui_window, compiler_but,    'c')
	GadgetKey(bgui_window, action1_but,     '1')
	GadgetKey(bgui_window, action2_but,     '2')
	GadgetKey(bgui_window, pick_but,        'p')
	GadgetKey(bgui_window, save_local_but,  'l')
	GadgetKey(bgui_window, save_default_but,'d')

	/*
	**      Object created OK?
	**/
	IF bgui_window
		/*
		**      Open up the window.
		**/

		IF win_ptr:=WindowOpen( bgui_window )
			/*
			**      Obtain signal mask.
			**/
			get_local()
			GetAttr( WINDOW_SIGMASK, bgui_window, {signal} )
				/*
			**      Poll messages.
			**/
			WHILE running = TRUE
				/*
				**      Wait for the signal.
				**/


				Wait( signal )
				/*
				**      Call upon the event handler.
				**/
				WHILE ( rc := HandleEvent( bgui_window )) <> WMHI_NOMORE

					SELECT rc
						CASE    WMHI_CLOSEWINDOW
							running := FALSE

						CASE	EDITOR_BUTTON
							update_strings()
							launch(EDITOR_BUTTON)

						CASE	COMPILER_BUTTON
							update_strings()
							launch(COMPILER_BUTTON)

						CASE	ACTION1_BUTTON
							update_strings()
							launch(ACTION1_BUTTON)

						CASE	ACTION2_BUTTON
							update_strings()
							launch(ACTION2_BUTTON)

						CASE	PICK_BUTTON
							pickfile()

						CASE	SAVE_LOCAL_BUTTON
							update_strings()
							savesettings(SAVE_LOCAL_BUTTON)

						CASE	SAVE_DEFAULT_BUTTON
							update_strings()
							savesettings(SAVE_DEFAULT_BUTTON)
					ENDSELECT

				ENDWHILE
			ENDWHILE
		ENDIF
		/*
		**      Disposing of the object
		**      will automatically close the window
		**      and dispose of all objects that
		**      are attached to the window.
		**/
		DisposeObject( bgui_window )
	ELSE
		WriteF( 'Unable to create a window object\n' )
	ENDIF
 Dispose(ibox_obj)
 CloseLibrary(bguibase)
 ELSE
	WriteF( 'Unable to open the bgui.library\n' )
 ENDIF
ENDPROC NIL


PROC launch(whichone)
 DEF orgstr[256]:STRING
 DEF str[256]:STRING
 DEF x, test[1]:STRING
 DEF oldpickfile[256]:STRING
 StrCopy(str,'',ALL)

 /* this is done so the compile section can mess with the strpickfile
 strpickfile is restored when everything is done */
 StrCopy(oldpickfile,strpickfile,ALL)

 SELECT whichone

  CASE EDITOR_BUTTON
   StrCopy(orgstr,stredit,ALL)

  CASE COMPILER_BUTTON
   IF checked
    FOR x:= StrLen(strpickfile)-1 TO 0 STEP -1
     MidStr(test,strpickfile,x,1)
     IF StrCmp(test,'.',ALL)
      StrCopy(strpickfile,strpickfile,x)
     ENDIF
    ENDFOR
   ENDIF
   StrCopy(orgstr,strcompile,ALL)

  CASE ACTION1_BUTTON
   StrCopy(orgstr,straction1,ALL)

  CASE ACTION2_BUTTON
   StrCopy(orgstr,straction2,ALL)

 ENDSELECT

 FOR x:= 0 TO StrLen(orgstr)-1
  MidStr(test,orgstr,x,1)
  IF StrCmp(test,'%',ALL)
   MidStr(test,orgstr,x+1,1)
   IF StrCmp(test,'s',ALL)
    StrAdd(str,strpickfile,ALL)
    INC x /* inc to skip the s as well as the % */
    JUMP z /* don't add % and s chars now that they have been handled */
   ELSE
    StrAdd(str,'%',ALL)
   ENDIF
  ENDIF
  StrAdd(str,test,ALL)
  z:
 ENDFOR

 Execute(str,0,0)
 StrCopy(strpickfile,oldpickfile,ALL)
ENDPROC


PROC savesettings(whichone)

 DEF tibox_obj:ibox
 DEF tmp[256]:STRING
 DEF file

 SELECT whichone
   CASE SAVE_DEFAULT_BUTTON
     file:= Open('s:PPI2.Prefs', NEWFILE)

   CASE SAVE_LOCAL_BUTTON
     file:= Open(localname, NEWFILE)
 ENDSELECT

 IF file
  Fputs(file,'PPI2 Prefs\n')

  Fputs(file,strpickfile)
  Fputs(file,'\n')

  Fputs(file,stredit)
  Fputs(file,'\n')

  Fputs(file,strcompile)
  Fputs(file,'\n')

  Fputs(file,straction1)
  Fputs(file,'\n')

  Fputs(file,straction2)
  Fputs(file,'\n')

  IF checked
   Fputs(file,'T\n')
  ELSE
   Fputs(file,'F\n')
  ENDIF

  GetAttr( WINDOW_BOUNDS, bgui_window, tibox_obj)

  StringF(tmp,'\d\0',tibox_obj.left)
  Fputs(file,tmp)
  Fputs(file,'\n')

  StringF(tmp,'\d\0',tibox_obj.top)
  Fputs(file,tmp)
  Fputs(file,'\n')

  StringF(tmp,'\d\0',tibox_obj.width)
  Fputs(file,tmp)
  Fputs(file,'\n')

  StringF(tmp,'\d\0',tibox_obj.height)
  Fputs(file,tmp)
  Fputs(file,'\n')

  Close(file)
 ENDIF
ENDPROC


PROC loadsettings()

 DEF buf[260]:STRING, file
 file:=NIL
 file:= Open(localname, OLDFILE)
 IF file=NIL
   file:= Open('s:PPI2.Prefs', OLDFILE)
 ENDIF

 IF file
  ibox_obj.left := -1			-> use .left as a success flag
  Fgets(file,buf,260)

  StrCopy(buf,'',ALL)
  Fgets(file,buf,260)
  StrCopy(strpickfile,buf,StrLen(buf)-1)

  StrCopy(buf,'',ALL)
  Fgets(file,buf,260)
  StrCopy(stredit,buf,StrLen(buf)-1)

  StrCopy(buf,'',ALL)
  Fgets(file,buf,260)
  StrCopy(strcompile,buf,StrLen(buf)-1)

  StrCopy(buf,'',ALL)
  Fgets(file,buf,260)
  StrCopy(straction1,buf,StrLen(buf)-1)

  StrCopy(buf,'',ALL)
  Fgets(file,buf,260)
  StrCopy(straction2,buf,StrLen(buf)-1)

  StrCopy(buf,'',ALL)
  Fgets(file,buf,260)
  StrCopy(buf,buf,StrLen(buf)-1)

  IF StrCmp(buf,'F',ALL)
   checked:=FALSE
  ELSE
   checked:=TRUE
  ENDIF

  StrCopy(buf,'',ALL)
  Fgets(file,buf,260)
  ibox_obj.left:= Val(buf)

  StrCopy(buf,'',ALL)
  Fgets(file,buf,260)
  ibox_obj.top:= Val(buf)

  StrCopy(buf,'',ALL)
  Fgets(file,buf,260)
  ibox_obj.width:= Val(buf)

  StrCopy(buf,'',ALL)
  Fgets(file,buf,260)
  ibox_obj.height:= Val(buf)
 ENDIF

 IF ibox_obj.left = -1		-> if no prefs were loaded fill the structure
	ibox_obj.left:=0
	ibox_obj.top:=0
	ibox_obj.width:=600
	ibox_obj.height:=4000
 ENDIF

 Close(file)
ENDPROC


PROC pickfile()
	DEF ret

	ret:=DoRequest(a_req)
	IF ret = FRQ_CANCEL THEN RETURN
	IF ret = FRQ_ERROR_NO_MEM
		WriteF('Out of memory.  Could not open an ASL requester.\n')
		RETURN
	ENDIF

    -> get chosen filename from req w/o checking for non-existent entries
	GetAttr(FRQ_PATH, a_req, {a_path})

	StrCopy(strpickfile, a_path, ALL)
	change_work_text()
ENDPROC


PROC change_work_text()
	SetGadgetAttrsA(workfile, win_ptr, NIL, [INFO_TEXTFORMAT,strpickfile])
ENDPROC


PROC update_strings()
	GetAttr(STRINGA_TEXTVAL, editor_str, {stredit})
	GetAttr(STRINGA_TEXTVAL, compiler_str, {strcompile})
	GetAttr(STRINGA_TEXTVAL, action1_str, {straction1})
	GetAttr(STRINGA_TEXTVAL, action2_str, {straction2})
	GetAttr(GA_SELECTED, cb, {checked})
ENDPROC


PROC get_local()
/* This PROC gets us the directory where the copy of PPI was executed.  This
is done for the Save Local (Prefs). It also sets up the localname var.*/

 DEF lock
 DEF tmpstr[1025]:ARRAY /* of bytes */
 DEF a[2]:STRING

 lock:=GetProgramDir()
 NameFromLock(lock,tmpstr,1025)
 tmpstr[1025]:=0
 StrCopy(localname,tmpstr,ALL)
 RightStr(a,localname,StrLen(localname))

 /* tack a '/' on to the end of localname if the last char of localname is not
 ':'  */

 MidStr(a,localname,StrLen(localname)-1,ALL)
 IF (StrCmp(a,':',ALL)=FALSE)
  StrAdd(localname,'/',ALL)
 ENDIF
 StrAdd(localname,'PPI2.Prefs',ALL)

ENDPROC
