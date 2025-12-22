/* This is a Triton demo in AmigaE
   Example code done by Frank Verheyen on 17/10/1994
   Use it, and....
   consider learning E, it's a great language!

   To make this source ready for compilation, you should pump it through Mac2E (by Lionel Vintenat), which is really easy:

   use the new compilation script which invokes Mac2E automatically,
   OR convert it yourself with mac2e
*/
/*------------------------ invoke Mac2EFront -------------------------------*/
/* MAC2E triton */ -> this comment invokes Mac2EFront for you
/*-------------------- some needed modules ---------------------------------*/
OPT OSVERSION=37

MODULE 'triton','utility/tagitem'  -> needed for triton-handling
MODULE 'ReqTools'				-> not needed for triton-handling, but for the filerequester in this demo
MODULE 'exec/lists', 'exec/nodes', 'utility/tagitem'
/*--------------------------------------------------------------------------*/
DEF	llist=NIL:PTR TO mlh			-> Exec list holds listview items

/*------------------------- object definition of message -------------------*/
OBJECT tr_Message
	trm_Project:LONG	-> tr_Project
	trm_ID
	trm_Class
	trm_Data
	trm_Code
	trm_Qualifier
	trm_Seconds
	trm_Micros
	trm_App:LONG		-> tr_App
ENDOBJECT

/*-------------------------- main() ----------------------------------------*/
PROC main()
	DEF	application=NIL	-> application pointer.  This will be the master of our projects (each triton-defined-window is called a project)

	NEW llist
	initList(llist)		-> Init exec list to hold listview items.  Starts out empty.

	IF tritonbase:=OpenLibrary(TRITONNAME,TRITON10VERSION)
		IF (application := Tr_CreateApp([TRCA_Name, 'AmigaEExample',
			TRCA_LongName, 'AmigaE Demo Application',
			TRCA_Version, '0.0',
			TAG_DONE]))
			doMainApplication(application)	-> this routine sets up everything
			Tr_DeleteApp(application)
          ELSE
          	WriteF('Could not create application\n')
          	CleanUp(20)
         	ENDIF
	ELSE
     	WriteF('Could not open triton.library\n')
     	CleanUp(20)
	ENDIF

	IF tritonbase THEN CloseLibrary(tritonbase)
ENDPROC
/*--------------------------------------------------------------------------*/

PROC doMainApplication(app)
	DEF close_me=FALSE,
     	trmsg:PTR TO tr_Message,
     	project,
     	class,id,data,
     	file[240]:STRING
	DEF cycleEntries

     cycleEntries := ['Entry One  ','Entry Two  ','Entry Three  ',NIL]

	IF (project:=Tr_OpenProject(app,[WindowTitle('AmigaE Triton Demo'), WindowPosition(TRWP_CENTERDISPLAY), WindowUnderscore('~'), WindowID(1),
                 HorizGroupA,
                   Space,
                   VertGroupA,
                     Space,
			      HorizGroupA,
			        Space,
			        VertGroupAC,
                         Space,
                         NamedFrameBox('Cycle talks to integer-box'),
			          VertGroupA,
                           Space,
                           HorizGroupS,
                             SpaceS,
				         CycleGadget(cycleEntries,0,1),
				         SpaceS,
				         IntegerBox(0,1,1),
     	                   SpaceS,
                           EndGroup,
                           SpaceS,
                         EndGroup,
			          Space,
			          Button('Pop up a requester',2),
			          Space,
                         NamedFrameBox('File'),
                         VertGroupA,
                           SpaceS,
			            HorizGroupA,
			              SpaceS,
	                        StringGadgetM('This filename is a dummy...',4,240),
	                        Space,
			              GetFileButton(3),
			              SpaceS,
                           EndGroup,
                           Space,
                         EndGroup,
			          Space,
                         NamedFrameBox('Slider talks to integer-box'),
			          VertGroupEAC,
                           SpaceS,
                           HorizGroup,
                             SpaceS,
				         SliderGadget(0,1000,10,5),
				         SpaceS,
				         IntegerID(0,5,4),
				         SpaceS,
                           EndGroup,
                           SpaceS,
                         EndGroup,
                         Space,
                         NamedFrameBox('Progress indicator in action'),
                         HorizGroupA,
                           Space,
                           VertGroupA,
			              Space,
			              Button('Start the action',6),
			              Space,
                           EndGroup,
                           Space,
                         EndGroup,
                         Space,
                         NamedFrameBox('ListView in action'),
                         HorizGroupA,
                           Space,
                           VertGroupA,
			              Space,
			              Button('Let\as have a look',7),
			              Space,
                           EndGroup,
                           Space,
                         EndGroup,
                         Space,
			        EndGroup,
			        Space,
			      EndGroup,
			      Space,
                   EndGroup,
                   Space,
                 EndGroup,
			EndProject]))

		WHILE (close_me=FALSE)
			Tr_Wait(app,NIL)
			IF (trmsg:=Tr_GetMsg(app))
				IF (trmsg.trm_Project=project)
					class := trmsg.trm_Class
					id := trmsg.trm_ID
                        	->WriteF('class= \h, id= \d, data= \d, code= \d \n',class,id,trmsg.trm_Data,trmsg.trm_Code)
					SELECT class
						CASE TRMS_CLOSEWINDOW
                                   close_me := quitRequest(app)
						CASE TRMS_ERROR
							WriteF('\s\n',Tr_GetErrorString(trmsg.trm_Data))
                              CASE TRMS_ACTION
                              	id := trmsg.trm_ID
                              	->WriteF('User pressed button \d ',id)
							SELECT id
								CASE 2
									->WriteF(', requester popping up...\n')
									askRequest(app)
								CASE 3
									->WriteF(', filerequester popping up...\n')
									IF openreqtools()
										filerequest('Pick a file',file)
										->WriteF('User picked file <\s>\n',file)
                                                  Tr_SetAttribute(project,4,0,file)
										closereqtools()
									ENDIF
								CASE 6
									Tr_LockProject(project)
									doProgress(app)
									Tr_UnlockProject(project)
                                        CASE 7
									Tr_LockProject(project)
									doListView(app)
									Tr_UnlockProject(project)
							ENDSELECT
                              CASE TRMS_NEWVALUE
							id := trmsg.trm_ID
                                   SELECT id
                                        CASE 1
                                        	data := Tr_GetAttribute(project, id, 0)
                                        	->WriteF(', The chosen entry is \d\n',data)
								CASE 4
                                             data := Tr_GetAttribute(project, id, 0)
                                             ->WriteF(', the string entered = <\s>\n',data)
							ENDSELECT
					ENDSELECT
				ENDIF
				Tr_ReplyMsg(trmsg)
			ENDIF
		ENDWHILE
		Tr_CloseProject(project)
     ELSE
		DisplayBeep(NIL)
     ENDIF
ENDPROC
/*--------------------------------------------------------------------------*/
PROC doListView(app)
	DEF	trmsg:PTR TO tr_Message,
		close_me,
     	subproject,class,id

	IF (subproject:=Tr_OpenProject(app,
		[WindowTitle('ListView'), WindowPosition(TRWP_CENTERDISPLAY), WindowID(2),
		  HorizGroupA,
		    Space,
		    VertGroupA,
		      Space,
                NamedFrameBox('ListView gadget'),
		      VertGroupA,
		        Space,
		        HorizGroupA,
		          Space,
		          ListSS(llist,1,0,0),
                    Space,
                  EndGroup,
                  SpaceS,
                  HorizGroupA,
                  	Space,
                  	Button('  Add  ',2),
                  	Space,
                  	Button('Delete ',3),
                  	Space,
                  EndGroup,
                  Space,
                    HorizGroupA,
                   	  Space,
                      StringGadgetM('testing',4,240),
                  	Space,
                  EndGroup,
                  Space,
                EndGroup,
                Space,
              EndGroup,
              Space,
            EndGroup,
          EndProject]))

		close_me := FALSE
		WHILE close_me=FALSE
			Tr_Wait(app,NIL)
			IF (trmsg:=Tr_GetMsg(app))
				IF (trmsg.trm_Project=subproject)
					class := trmsg.trm_Class
					id := trmsg.trm_ID
					->WriteF('class= \h, id= \d, data= \d, code= \d \n',class,id,trmsg.trm_Data,trmsg.trm_Code)
					SELECT class
						CASE TRMS_CLOSEWINDOW
	                         	->WriteF('User closed ListView Window\n')
							close_me := TRUE	/* don't bother to ask for confirmation this time */
						CASE TRMS_ERROR
							WriteF('\s\n',Tr_GetErrorString(trmsg.trm_Data))
						CASE TRMS_ACTION
							->WriteF('User pressed button \d ',id)
							SELECT id
								CASE 2
     								addToList(subproject,1,Tr_GetAttribute(subproject,4,0))
	     						CASE 3
                                             deleteFromList(subproject,1,Tr_GetAttribute(subproject,1,TRAT_Value))
							ENDSELECT
                              CASE TRMS_NEWVALUE
							->WriteF('New value for ID \d \n',id)
                                   SELECT id
                                        CASE 1
									Tr_SetAttribute(subproject,4,0,getNodeName(llist,Tr_GetAttribute(subproject,1,TRAT_Value)))
							ENDSELECT
					ENDSELECT
	               ENDIF
				Tr_ReplyMsg(trmsg)
			ENDIF
	     ENDWHILE
		Tr_CloseProject(subproject)
	ELSE
		DisplayBeep(NIL)
	ENDIF

ENDPROC
/*---------------------------- progress demo -------------------------------*/
PROC doProgress(app)
	DEF	done,slowcount,
     	trmsg:PTR TO tr_Message,
     	subproject,class,id

	IF (subproject:=Tr_OpenProject(app,
		[WindowTitle('Progress'), WindowPosition(TRWP_CENTERDISPLAY), WindowID(2),
		  HorizGroupA,
		    Space,
		    VertGroupA,
		      Space,
                NamedFrameBox('Progress indicator counting from 0 to 1000'),
		      VertGroupA,
		        Space,
		        HorizGroupA,
		          Space,
		          Progress(1000,0,1),
		          Space,
                  EndGroup,
                  Space,
		        VertGroupA,
		          Space,
		          HorizGroupA,
		            Space,
                      Button('Abort',2),
                      Space,
                      Button('Restart',3),
		            Space,
                    EndGroup,
                    Space,
                  EndGroup,
		      EndGroup,
		      Space,
              EndGroup,
              Space,
            EndGroup,
		EndProject]))

		done := FALSE
		slowcount := 0
		WHILE done=FALSE
			IF (trmsg:=Tr_GetMsg(app))
				IF (trmsg.trm_Project=subproject)
					class := trmsg.trm_Class
					SELECT class
						CASE TRMS_CLOSEWINDOW
                                   ->WriteF('clicked closewindow\n')
							done := Tr_EasyRequest(app, '%3Abort the action?','Yes|No',NIL)
						CASE TRMS_ERROR
							->WriteF('\s',Tr_GetErrorString(trmsg.trm_Data))
                              CASE TRMS_ACTION
                              	id := trmsg.trm_ID
                              	->WriteF('ID of gadget = \d\n',id)
                                   SELECT id
                                   	CASE 2
									done := Tr_EasyRequest(app, '%3Abort the action?','Yes|No',NIL)
                                        CASE 3
                                             slowcount := 0
                                   ENDSELECT
					ENDSELECT
	               ENDIF
				Tr_ReplyMsg(trmsg)
			ENDIF
               Tr_SetAttribute(subproject,1,TRAT_Value,slowcount)

               /* Normally, you would put your action here */

			INC slowcount
			IF slowcount>=1000 THEN done := TRUE
		ENDWHILE
		Tr_CloseProject(subproject)
	ELSE
		DisplayBeep(NIL)
	ENDIF
ENDPROC
/*--------------------------- a simple request -----------------------------*/
PROC askRequest(app)
     DEF answer
     answer := Tr_EasyRequest(app, 'This is an EasyRequester\n%3This should be 3D-text\n%bThis is bold text\n%hThis is highlighted text',
			'OK|Dummy option...|Another dummy option|Cancel',NIL)
     ->WriteF('\nUser selected button \d in the requester\n\n',answer)
ENDPROC
/*--------------------------- quitting request -----------------------------*/
PROC quitRequest(app) IS Tr_EasyRequest(app, '%3Do you really want to QUIT?','Yes|No',NIL)
/*---------------------------- reqtools opening / closing ------------------*/
PROC openreqtools()
	IF reqtoolsbase:=OpenLibrary('reqtools.library',37)
		RETURN TRUE
	ELSE
		WriteF('Could not open reqtools.library!\n')
		CleanUp(0)
	ENDIF
ENDPROC

PROC closereqtools()
	IF reqtoolsbase THEN CloseLibrary(reqtoolsbase)
ENDPROC
/*--------------------------- reqtools filerequester -----------------------*/
PROC filerequest(title,returnvalue)
	DEF filename[120]:STRING,test[2]:STRING,dir,req
	returnvalue[0]:=0
	IF reqtoolsbase
		IF req:=RtAllocRequestA(0,0)
			filename[0]:=0
			test[0]:=0
			IF RtFileRequestA(req,filename,title,0)
				MOVE.L req,A0
				MOVE.L 16(A0),dir
				StrCopy(returnvalue,dir,ALL)		/* get the path */

				RightStr(test,returnvalue,1)
                    IF StrCmp(test,'/',1)=FALSE AND StrCmp(test,':',1)=FALSE AND StrLen(dir)>0
					StrAdd(returnvalue,'/',1);	/* add slash if necessary */
				ENDIF

				StrAdd(returnvalue,filename,ALL)   /* add the filename */
			ENDIF
			RtFreeRequest(req)
		ENDIF
	ELSE
		WriteF('error: reqtools.library not opened\n');
		RETURN FALSE
     ENDIF
ENDPROC returnvalue
/*--------------------------------------------------------------------------*/
PROC initList(l:PTR TO mlh)	-> Initialize an exec list
	l.head:=l+4
	l.tail:=NIL
	l.tailpred:=l
ENDPROC

PROC addToList(project,id,content)
	DEF newNode=NIL:PTR TO ln, node:PTR TO ln,len,
		done=FALSE,itemPosition=0

	IF (len:=StrLen(content))=0 THEN RETURN	-> Don't add if there's nothing to add.

	NEW newNode						-> Create a node and a string to add to the listview.
	newNode.name:=String(len)
	StrCopy(newNode.name, content, ALL)

	Tr_SetAttribute(project,id,0,NIL)		-> Detach the exec list from the listview gadget.

	-> Decide where to insert the new item.  Sorted on first character, for example
/*
	node:=llist.head
	IF llist.tailpred=llist
		AddHead(llist, newNode)
	ELSEIF Char(node.name)>content[]
		AddHead(llist, newNode)
	ELSEIF node=llist.tailpred
		AddTail(llist, newNode)
	ELSE
		WHILE done=FALSE
			node:=node.succ
			INC itemPosition
			IF Char(node.name)>content[]
				done:=TRUE
			ELSEIF node.succ=NIL
				done:=TRUE
			ENDIF
		ENDWHILE
		Insert(llist, newNode, node.pred)
	ENDIF
*/

->	Or, simply at the end OF the LIST, which is more natural.
	node:=llist.head
	IF llist.tailpred=llist
		AddHead(llist, newNode)
	ELSEIF node=llist.tailpred
		AddTail(llist, newNode)
	ELSE
		WHILE done=FALSE				-> hunt for last item in the list
			node:=node.succ
			INC itemPosition
			IF node.succ=NIL
				done:=TRUE			-> ah, found it...
			ENDIF
		ENDWHILE
		Insert(llist, newNode, node.pred)
	ENDIF

	Tr_SetAttribute(project,id,0,llist)	->	Reattach the exec list to the listview gadget.
ENDPROC

PROC deleteFromList(project,id,itemPosition)
	DEF node:PTR TO ln, i
	IF (itemPosition=-1) OR (llist.tailpred=llist) THEN RETURN 	-> Don't delete if no item is selected.
	Tr_SetAttribute(project,id,0,NIL)		-> Detach the exec list from the listview gadget.
	node:=llist.head					-> Find the node that corresponds to itemPosition in the exec list.
	i := 1
	WHILE (i<=itemPosition) AND (node<>llist.tailpred) AND (node.succ<>NIL)
		node := node.succ
		INC i
	ENDWHILE

	Remove(node)						-> Remove and deallocate the node's data
	Dispose(node.name)
	Dispose(node)
	Tr_SetAttribute(project,id,0,llist)	-> Reattach the exec list to the listview gadget.
ENDPROC

PROC getNodeName(lst:PTR TO mlh,itemPosition) -> return a stringptr, from an index (itemPosition) in a linked list (lst)
	DEF node:PTR TO ln, i
	node:=lst.head
	i := 1				-> note: this is safer than the FOR..ENDFOR B.Wills originally used.
	WHILE (i<=itemPosition) AND (node<>lst.tailpred) AND (node.succ<>NIL)
		node := node.succ
		INC i
	ENDWHILE
ENDPROC node.name

/*----------------------------- end of source ------------------------------*/
