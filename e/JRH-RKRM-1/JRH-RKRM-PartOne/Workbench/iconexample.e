-> iconexample.e - Workbench icon startup, creation, and parsing example

MODULE 'icon',
       'dos/dos',
       'intuition/intuition',
       'workbench/startup',
       'workbench/workbench'

ENUM ERR_NONE, ERR_LIB, ERR_OPEN, ERR_WRITE, ERR_MAKE

RAISE ERR_LIB   IF OpenLibrary()=NIL,
      ERR_OPEN  IF Open()=NIL,
      ERR_WRITE IF Write()=-1

DEF projIcon:diskobject

PROC main() HANDLE
  DEF wbenchMsg:PTR TO wbstartup, wbarg:PTR TO wbarg, file=NIL, i, olddir,
      projname, deftoolname, iconImageData, iconGadget, toolTypes
  projname:='RAM:Example_Project'
  deftoolname:='iconexample'
  toolTypes:=['FILETYPE=text', 'FLAGS=BOLD|ITALICS', NIL]
                 -> Plane 0
  iconImageData:=[$0000,$0000,$0000,$1000,$0000,$0000,$0000,$3000,
                  $0FFF,$FFFC,$0000,$3000,$0800,$0004,$0000,$3000,
                  $0800,$07FF,$FFC0,$3000,$08A8,$A400,$00A0,$3000,
                  $0800,$0400,$0090,$3000,$08AA,$A400,$0088,$3000,
                  $0800,$042A,$A0FC,$3000,$082A,$A400,$0002,$3000,
                  $0800,$0400,$0002,$3000,$0800,$A42A,$A0A2,$3000,
                  $0800,$0400,$0002,$3000,$0950,$A42A,$8AA2,$3000,
                  $0800,$0400,$0002,$3000,$082A,$A400,$0002,$3000,
                  $0800,$042A,$2AA2,$3000,$0FFF,$FC00,$0002,$3000,
                  $0000,$0400,$0002,$3000,$0000,$07FF,$FFFE,$3000,
                  $0000,$0000,$0000,$3000,$7FFF,$FFFF,$FFFF,$F000,
                 -> Plane 1
   	          $FFFF,$FFFF,$FFFF,$E000,$D555,$5555,$5555,$4000,
		  $D000,$0001,$5555,$4000,$D7FF,$FFF9,$5555,$4000,
		  $D7FF,$F800,$0015,$4000,$D757,$5BFF,$FF55,$4000,
		  $D7FF,$FBFF,$FF65,$4000,$D755,$5BFF,$FF75,$4000,
		  $D7FF,$FBD5,$5F01,$4000,$D7D5,$5BFF,$FFFD,$4000,
		  $D7FF,$FBFF,$FFFD,$4000,$D7FF,$5BD5,$5F5D,$4000,
		  $D7FF,$FBFF,$FFFD,$4000,$D6AF,$5BD5,$755D,$4000,
		  $D7FF,$FBFF,$FFFD,$4000,$D7D5,$5BFF,$FFFD,$4000,
		  $D7FF,$FBD5,$D55D,$4000,$D000,$03FF,$FFFD,$4000,
		  $D555,$53FF,$FFFD,$4000,$D555,$5000,$0001,$4000,
		  $D555,$5555,$5555,$4000,$8000,$0000,$0000,$0000]:INT
  -> E-Note: C version uses obsolete gadget flags
  iconGadget:=[NIL,                        -> Next Gadget Pointer
               97, 12, 52, 23,             -> Left, Top, Width, Height
               GFLG_GADGIMAGE OR GFLG_GADGHBOX,  -> Flags
               GACT_IMMEDIATE OR GACT_RELVERIFY, -> Activation Flags
               GTYP_BOOLGADGET,            -> Gadget Type
                [0, 0,           -> Top Corner
                 52, 22, 2,      -> Width, Height, Depth
                 iconImageData,  -> Image Data
                 3, 0,           -> PlanePick, PlaneOnOff
                 NIL]:image,     -> Next Image
               NIL,                        -> Select Image
               NIL,                        -> Gadget Text
               NIL,                        -> Mutual Exclude
               NIL,                        -> Special Info
               0,                          -> Gadget ID
               NIL]:gadget                 -> User Data
  -> E-Note: a list can't be used for a diskobject because of the nested gadget
  projIcon.magic:=WB_DISKMAGIC
  projIcon.version:=WB_DISKVERSION
  CopyMem(iconGadget, projIcon.gadget, SIZEOF gadget)
  projIcon.type:=WBPROJECT
  projIcon.defaulttool:=deftoolname
  projIcon.tooltypes:=toolTypes
  projIcon.currentx:=NO_ICON_POSITION
  projIcon.currenty:=NO_ICON_POSITION
  projIcon.drawerdata:=NIL
  projIcon.toolwindow:=NIL
  projIcon.stacksize:=4000

  -> Open icon.library
  iconbase:=OpenLibrary('icon.library',33)

  -> If started from CLI, this example will create a small text file
  -> RAM:Example_Project, and create an icon for the file which points
  -> to this program as its default tool.
  IF wbmessage=NIL
    -> Make a sample project (data) file
    file:=Open(projname, NEWFILE)
    Write(file, 'Have a nice day\n', STRLEN)

    -> Now save/update icon for this data file
    makeIcon(projname, toolTypes, deftoolname)
    WriteF('\s data file and icon saved.\n', projname)
    WriteF('Use Workbench menu Icon Information to examine the icon.\n')
    WriteF('Then copy this example (iconexample) to RAM:\n')
    WriteF('and double-click the \s project icon\n', projname)
  ELSE -> Else we are from WB - ie. we were either started by a tool icon,
       -> or as in this case, by being the default tool of a project icon.
    -> E-Note: WriteF opens its own window if necessary
    wbenchMsg:=wbmessage

    -> First arg is our executable (tool).  Any additional args are projects
    -> or icons passed to us via either extend select or default tool method.
    wbarg:=wbenchMsg.arglist
    FOR i:=0 TO wbenchMsg.numargs-1
      -> If there's a directory lock for this wbarg, CD there
      olddir:=-1
      IF wbarg.lock AND (wbarg.name[]<>0) THEN olddir:=CurrentDir(wbarg.lock)

      showToolTypes(wbarg)

      IF (i>0) AND (wbarg.name[]<>0)
        WriteF('In Main. We could open the \s file here\n', wbarg.name)
      ENDIF
      IF olddir<>-1 THEN CurrentDir(olddir)  -> CD back where we were
      wbarg++
    ENDFOR
    Delay(500)
    WriteF('\nPress RETURN to close window\n')
  ENDIF
EXCEPT DO
  IF file THEN Close(file)
  SELECT exception
  CASE ERR_LIB;   WriteF('Can''t open icon.library\n')
  CASE ERR_OPEN;  WriteF('Can''t open file "\s"\n', projname)
  CASE ERR_WRITE; WriteF('Error writing data file\n')
  CASE ERR_MAKE;  WriteF('Error writing icon\n')
  ENDSELECT
  RETURN IF exception=ERR_NONE THEN RETURN_OK ELSE RETURN_FAIL
ENDPROC

PROC makeIcon(name, newtooltypes, newdeftool)
  DEF dobj:PTR TO diskobject, oldtooltypes, olddeftool, success=FALSE
  IF dobj:=GetDiskObject(name)
    -> If file already has an icon, we will save off any fields we need to
    -> update, update those fields, put the object, restore the old field
    -> pointers and then free the object.  This will preserve any custom
    -> imagery the user has, and the user's current placement of the icon.
    -> If your application does not know where the user currently keeps your
    -> application, you should not update his dobj.defaulttool.
    oldtooltypes:=dobj.tooltypes
    olddeftool:=dobj.defaulttool

    dobj.tooltypes:=newtooltypes
    dobj.defaulttool:=newdeftool

    success:=PutDiskObject(name, dobj)

    -> We must restore the original pointers before freeing
    dobj.tooltypes:=oldtooltypes
    dobj.defaulttool:=olddeftool
    FreeDiskObject(dobj)
  ENDIF
  -> Else, put our default icon
  IF success=FALSE THEN success:=PutDiskObject(name, projIcon)
  IF success=FALSE THEN Raise(ERR_MAKE)
ENDPROC

PROC showToolTypes(wbarg:PTR TO wbarg)
  DEF dobj:PTR TO diskobject, toolarray, s, success=FALSE
  WriteF('\nWBArg Lock=$\h, Name=\s ($\h)\n',
         wbarg.lock, wbarg.name, wbarg.name[])

  IF (wbarg.name[]<>0) AND (dobj:=GetDiskObject(wbarg.name))
    WriteF('  We have read the DiskObject (icon) for this arg\n')
    toolarray:=dobj.tooltypes

    IF s:=FindToolType(toolarray, 'FILETYPE')
      WriteF('    Found tooltype FILETYPE with value \s\n', s)
    ENDIF
    IF s:=FindToolType(toolarray, 'FLAGS')
      WriteF('    Found tooltype FLAGS with value \s\n', s)
      IF MatchToolValue(s, 'BOLD')
        WriteF('      BOLD flag requested\n')
      ENDIF
      IF MatchToolValue(s, 'ITALICS')
        WriteF('      ITALICS flag requested\n')
      ENDIF
    ENDIF
    -> Free the diskobject we got
    FreeDiskObject(dobj)
    success:=TRUE
  ELSEIF wbarg.name[]=0
    WriteF('  Must be a disk or drawer icon\n')
  ELSE
    WriteF('  Can''t find any DiskObject (icon) for this WBArg\n')
  ENDIF
ENDPROC success
