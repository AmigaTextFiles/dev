MODULE MultiCol;
(*
**      MULTICOL.C
**
**      (C) Copyright 1995 Jaba Development.
**      (C) Copyright 1995 Jan van den Baard.
**          All Rights Reserved.
**
**          Oberon conversion - Larry Kuhns 12/??/96
*)

IMPORT
  b   := Bgui,
  bm  := BguiMacro,
         CFunc,
  d   := Dos,
  dc  := DemoCode,
  e   := Exec,
  g   := Graphics,
  i   := Intuition,
  ie  := InputEvent,
  st  := Strings,
  spf := SPrintf,
  u   := Utility,
  y   := SYSTEM;


(*
**      This is the data were going to add
**      to the listview object. It is a simple
**      structure in which the file-information
**      is stored. This data is created in the
**      LISTV_Resource hook from a pointer
**      to a ExAllData structure.
*)
TYPE
  FileInfoPtr *= UNTRACED POINTER TO FileInfo;
  FileInfo *= STRUCT
    fileName *: ARRAY 108 OF CHAR;
    size     *: ARRAY 11 OF CHAR;
    date     *: ARRAY 32 OF CHAR;
    isDir    *: BOOLEAN;
  END;


CONST
  idQuit   *= 1;
  idList   *= 2;
  idNewDir *= 3;
(*
**      We use 16 pixels as a minimum inner-column spacing.
*)
  InnerSpace *= 16;
(*
**      The default DrawInfo pens. Just in case we don't
**      get them from the system.
*)
  DefDriPens = i.DRIPenArray( 0, 1, 1, 2, 1, 3, 1, 0, 2, 1, 2, 1 );


VAR
(*
**      The hook structures as added to the
**      listview object and window object.
**
**      If your compiler complaints about the
**      HOOKFUNC typedef uncomment the below line.
*)

  ResourceHook : u.Hook;
  DisplayHook  : u.Hook;
  CompareHook  : u.Hook;
  ScrollHook   : u.Hook;
(*
**      The listview will have three columns.
**
**      Name            Size            Date
**
**      The following globals will contain the maximum
**      width of each of these columns.
*)
  MaxName : INTEGER;
  MaxSize : INTEGER;
  MaxDate : INTEGER;
(*
**      This global stores the total width of the
**      listview drawing area.
*)
  TotalWidth : INTEGER;

(*
**      This boolean determines wether the hook must
**      re-compute the column sizes.
*)
  ReCompCols : BOOLEAN;


  (*
  **      The LISTV_Resource hook is used to create
  **      the FILEINFO structures from a struct ExAllData
  **      at create time. At delete time the FILEINFO
  **      structure is simply deallocated.
  *)
  (* APTR ResourceHookFunc( struct Hook *hook,  Object *obj,  struct lvResource *lvr ) *)
  PROCEDURE ResourceHookFunc( hook : u.HookPtr; obj : b.Object; lvr : b.Args ): LONGINT;
    VAR
      ead : d.ExAllDataPtr;
      fi  : FileInfoPtr;
      dt  : d.DateTime;
      returnCode : e.APTR;
    BEGIN
      returnCode:= NIL;

      (*
      **      What must we do?
      *)
      CASE lvr(b.Resource).command OF

      | b.lvrcMake:
          (*
          **      Create a FILEINFO structure.
          **      BGUI has passed us a pointer to a
          **      ExAllData structure. Here we
          **      convert it to a FILEINFO structure
          **      which, eventually, get's added to
          **      the listview.
          *)
          fi:= e.AllocVec( SIZE( fi^ ), LONGSET{ e.public });
          IF fi # NIL THEN
            (*
            **      Pick up the ExAllData.
            *)
            ead:= lvr(b.Resource).entry;
            (*
            **      Copy the name.
            *)
            COPY( ead.name^, fi.fileName );
            (*
            **      Format the size text. We can do all sorts of
            **      fancy stuff here like using the locale.library
            **      formatting stuff but hey, it's just a demo ;)
            *)
            IF ead.type < 0  THEN
              fi.isDir:= FALSE;
              spf.SPrintF( fi.size, "%ld", ead.size );
            ELSE
              fi.isDir:= TRUE;
              COPY( "(dir)", fi.size );
            END;
            (*
            **      Convert the date to a string.
            *)
            dt.stamp.days  := ead.days;
            dt.stamp.minute:= ead.mins;
            dt.stamp.tick  := ead.ticks;
            dt.format      := d.formatCDN;
            dt.flags       := SHORTSET{ d.subst, d.future };
            dt.strDay      := NIL;
            dt.strDate     := y.ADR( fi.date );
            dt.strTime     := NIL;
            (*
            **      Format date.
            *)
            IF d.DateToStr( dt ) THEN END;
            (*
            **      Return a pointer to the created
            **      FILEINFO structure.
            *)
            returnCode:= y.VAL( e.APTR, fi );
          END; (* IF fi # NIL *)


      | b.lvrcKill:
          (*
          **      Simply deallocate the FILEINFO
          **      structure which has been created with
          **      LVRC_MAKE above.
          *)
          e.FreeVec( lvr(b.Resource).entry );
      ELSE
      END; (* CASE lvr(b.Resource).command *)
      (*
      **      Pointer to FILEINFO or NULL.
      *)
      RETURN returnCode;
    END ResourceHookFunc;


  (*
  **      This routine re-computes the minimum column
  **      sizes when necessary.
  *)
  (* VOID ReComputeColumns( struct RastPort *rp, Object *obj, UWORD list_width ) *)
  PROCEDURE ReComputeColumns( rp : g.RastPortPtr; obj : b.Object; listWidth : INTEGER );
    VAR
      fi    : FileInfoPtr;
      tmp   : INTEGER;
      total : INTEGER;
    BEGIN
      (*
      **      A re-computation is necessary when:
      **
      **      1) The ReCompCols flag is TRUE.
      **      2) The with of the listview has changed.
      *)
      IF ReCompCols OR ( TotalWidth # listWidth ) THEN
        (*
        **      Our listview also has a title entry.
        **      Here we compute the default column
        **      sizes accoording to this title.
        *)
        MaxName:= g.TextLength( rp, "Name:", 6 ) + InnerSpace;
        MaxSize:= g.TextLength( rp, "Size:", 6 ) + InnerSpace;
        MaxDate:= g.TextLength( rp, "Date:", 6 );
        (*
        **      Now we loop through the entries to find
        **      out the largest width of the three columns.
        *)
        fi:= bm.FirstEntry( obj );
        IF fi # NIL THEN
          (*
          **      Loop until all are done.
          *)
          WHILE fi # NIL DO
            (*
            **      Compute width of the Name: column
            **      for this entry.
            *)
            tmp:= g.TextLength( rp, fi.fileName, st.Length( fi.fileName )) + InnerSpace;
            (*
            **      Is it bigger than the last one?
            **      If so store it.
            *)
            IF  tmp > MaxName THEN  MaxName:= tmp END;
            (*
            **      Compute width of the Size: column
            **      for this entry.
            *)
            tmp:= g.TextLength( rp, fi.size, st.Length( fi.size )) + InnerSpace;
            (*
            **      Is it bigger than the last one?
            **      If so store it.
            *)
            IF tmp > MaxSize THEN MaxSize:= tmp END;
            (*
            **      Compute width of the Date: column
            **      for this entry.
            *)
            tmp:= g.TextLength( rp, fi.date, st.Length( fi.date ));
            (*
            **      Is it bigger than the last one?
            **      If so store it.
            *)
            IF tmp > MaxDate THEN MaxDate:= tmp END;
            (*
            **      Pick up the next entry.
            *)
            fi:= bm.NextEntry( obj, fi );
          END; (* WHILE fi # MIL *)
        END; (* IF fi # NIL *)
        (*
        **      Compute the total columns width.
        *)
        total:= MaxName + MaxSize + MaxDate;
        (*
        **      If there's room left over we
        **      distribute it between the columns so
        **      we get a nice even spacing between
        **      them.
        **
        **      If you don't want the wide spacing in the
        **      listview, comment out the next IF statement.
        **      [lak]  06-Dec-1996
        *)
        IF listWidth > total THEN
          MaxName:= MaxName + ASH(( listWidth - total ), -1 );
          MaxSize:= MaxSize + ASH(( listWidth - total ), -1 );
        END;
        (*
        **      All done. Set the re-compute flag to
        **      FALSE and store the list width.
        *)
        ReCompCols:= FALSE;
        TotalWidth:= listWidth;
      END; (* IF ReCompCols OR ( TotalWidth # listWidth ) *)
    END ReComputeColumns;


  (*
  **      Listview rendering hook. Here's where the magic starts ;)
  *)
  (* UBYTE *DisplayHookFunc( struct Hook *hook, Object obj,  struct lvRender *lvr ) *)
  PROCEDURE DisplayHookFunc( hook : u.HookPtr; obj : b.Object; lvr : b.Args ): LONGINT;
    VAR
      te    : g.Textextent;
      str   : e.LSTRPTR;
      fi    : FileInfoPtr;
      pens  : i.DRIPenArrayPtr;
      numc  : LONGINT;
      w, l  : INTEGER;
      cw, h : INTEGER;
      dPen  : INTEGER;
    BEGIN
      fi:= lvr(b.Render).entry;
      (*
      **      Pick up the DrawInfo pen array.
      *)
      IF lvr(b.Render).drawInfo # NIL THEN
        pens:= lvr(b.Render).drawInfo.pens;
      ELSE
        pens:=  y.ADR( DefDriPens );
      END;
      (*
      **      Pick up the width of the list.
      *)
      w:= lvr(b.Render).bounds.maxX - lvr(b.Render).bounds.minX + 1;
      (*
      **      Pick up the list left-edge;
      *)
      l:= lvr(b.Render).bounds.minX;
      (*
      **      Pick up the height of the entry.
      *)
      h:= lvr(b.Render).bounds.maxY - lvr(b.Render).bounds.minY + 1;
      (*
      **      First we render the background.
      *)
      IF lvr(b.Render).state = b.lvrsSelected THEN dPen:= i.fillPen ELSE dPen:= i.backGroundPen END;
      g.SetAPen( lvr(b.Render).rPort, pens[ dPen ] );
      g.SetDrMd( lvr(b.Render).rPort, g.jam1 );

      g.RectFill( lvr(b.Render).rPort, lvr(b.Render).bounds.minX,
                                       lvr(b.Render).bounds.minY,
                                       lvr(b.Render).bounds.maxX,
                                       lvr(b.Render).bounds.maxY );

      (*
      **      When we are passed a NULL entry pointer
      **      we are presumed to render the title. If your
      **      listview does not have a title simply
      **      recompute the columns and return NULL.
      **      We have a title so here we go.
      *)
      IF fi = NIL THEN
        (*
        **      Recompute the column sizes. The routine
        **      itself will decide if it's necessary.
        *)
        ReComputeColumns( lvr(b.Render).rPort, obj, w );
        (*
        **      Set the pen for the title-entry.
        *)
        g.SetAPen( lvr(b.Render).rPort, pens[ i.fillPen ] );
      ELSE
        (*
        **      Set the pen for a non-title entry. Ofcourse
        **      we can (should?) differenciate between normal and
        **      selected here but I wont ;)
        *)
        IF fi.isDir THEN g.SetAPen( lvr(b.Render).rPort, pens[ i.highLightTextPen ] );
        ELSE             g.SetAPen( lvr(b.Render).rPort, pens[ i.textPen ] ) END;
      END; (* IF = NIL *)
      (*
      **      Obtain Name: column width. We check it against the
      **      total list width so we do not go outside the
      **      given area.
      *)
      IF MaxName < w THEN cw:= MaxName ELSE cw:= w END;

      (*
      **      Pick up the name string or, when this
      **      is a title call, the string "Name:".
      *)
      IF fi # NIL THEN str:= y.ADR( fi.fileName ) ELSE str:= y.ADR( "Name:" ) END;

      (*
      **      Compute the number of character we
      **      can render.
      *)
      numc:= g.TextFit( lvr(b.Render).rPort, str^, st.Length( str^ ), y.ADR( te ), NIL, 0, cw, h );

      (*
      **      If the number of characters is
      **      0 we can stop right here and now.
      *)
      IF numc = NIL THEN RETURN NIL END;

      (*
      **      Move to the correct position
      **      and render the text.
      *)
      g.Move( lvr(b.Render).rPort, l, lvr(b.Render).bounds.minY + lvr(b.Render).rPort.txBaseline );
      g.Text( lvr(b.Render).rPort, str^, numc );

      (*
      **      Adjust the left-edge and width to
      **      get past the Name: column.
      *)
      l:= l + cw; (* l += cw *);
      IF ( w - cw ) > 0 THEN w:= w - cw ELSE w:= 0 END;
      (*
      **      Obtain Size: column width. We check it against the
      **      total list width so we do not go outside the
      **      given area.
      *)
      IF MaxSize < w THEN cw:= MaxSize ELSE cw:= w END;

      (*
      **      Pick up the size string or, when this
      **      is a title call, the string "Size:".
      *)
      IF fi # NIL THEN str:= y.ADR( fi.size ) ELSE str:= y.ADR( "Size:" ) END;

      (*
      **      Compute the number of character we
      **      can render.
      *)
      numc:= g.TextFit( lvr(b.Render).rPort, str^, st.Length( str^ ), y.ADR( te ), NIL, 0, cw, h );

      (*
      **      If the number of characters is
      **      0 we can stop right here and now.
      *)
      IF numc = 0 THEN RETURN NIL END;

      (*
      **      Move to the correct position
      **      and render the text.
      *)
      g.Move( lvr(b.Render).rPort, l, lvr(b.Render).bounds.minY + lvr(b.Render).rPort.txBaseline );
      g.Text( lvr(b.Render).rPort, str^, numc );

      (*
      **      Adjust the left-edge and width to
      **      get past the Size: column.
      *)
      l:= l + cw;  (* l += cw *)
      IF ( w - cw ) > 0 THEN w:= w - cw ELSE w:= 0 END;

      (*
      **      Obtain Date column width. We check it against the
      **      total list width so we do not go outside the
      **      given area.
      *)
      IF MaxDate < w THEN cw:= MaxDate ELSE cw:= w END;
      (*
      **      Pick up the date string or, when this
      **      is a title call, the string "Date:".
      *)
      IF fi # NIL THEN str:= y.ADR( fi.date ) ELSE str:= y.ADR("Date:") END;

      (*
      **      Compute the number of character we
      **      can render.
      *)
      numc:= g.TextFit( lvr(b.Render).rPort, str^, st.Length( str^ ), y.ADR( te ), NIL, 0, cw, h );

      (*
      **      If the number of characters is
      **      0 we can stop right here and now.
      *)
      IF numc = 0 THEN RETURN NIL END;

      (*
      **      Move to the correct position
      **      and render the text.
      *)
      g.Move( lvr(b.Render).rPort, l, lvr(b.Render).bounds.minY + lvr(b.Render).rPort.txBaseline );
      g.Text( lvr(b.Render).rPort, str^, numc );

      (*
      **      Return NULL. This is important. If we return a non-NULL
      **      value the listview class will think it is a pointer to
      **      the text to render and try to render it.
      *)
      RETURN NIL;
    END DisplayHookFunc;

  (*
  **      The comparrison hook. We do a simple name, dir/file
  **      comparrison here.
  *)
  (* LONG CompareHookFunc( struct Hook *hook, Object obj, struct lvCompare *lvc ) *)
  PROCEDURE CompareHookFunc( hook : u.HookPtr; obj : b.Object; lvc : b.Args ): LONGINT;
    VAR
      a1, b1 : FileInfoPtr;
    BEGIN
      a1:= lvc(b.Compare).entryA;
      b1:= lvc(b.Compare).entryB;

      (*
      **      First we do a type comparrison to get the
      **      directories at the top of the list.
      *)
      IF     a1.isDir & ~b1.isDir THEN RETURN -1;
      ELSIF ~a1.isDir &  b1.isDir THEN RETURN  1 END;

      (*
      **      Otherwise we do a simple, case insensitive,
      **      name string comparrison.
      *)
      RETURN CFunc.StriCmp( a1.fileName, b1.fileName );
    END CompareHookFunc;

  (*
  **      A IDCMP hook for the window which allows us
  **      to control the listview from the keyboard.
  *)
  (* VOID ScrollHookFunc( struct Hook *hook, Object obj, struct IntuiMessage *msg ) *)
  PROCEDURE ScrollHookFunc( hook : u.HookPtr; obj : b.Object; arg : b.Args ) : LONGINT;
    VAR
      msg    : i.IntuiMessagePtr;
      window : i.WindowPtr;
      lvObj  : i.GadgetPtr; (* Object - coerced for actions below *)
      rc     : LONGINT;
    BEGIN
      lvObj:= y.VAL( i.GadgetPtr, hook.data );
      msg  := y.VAL( i.IntuiMessagePtr, arg );
      (*
      **      Obtain window pointer.
      *)
      rc:= i.GetAttr( b.windowWindow, obj, window );

      (*
      **      What key is pressed?
      *)
      CASE msg.code OF

      | 04CH :
         (*
         **      UP              - Move entry up.
         **      SHIFT + UP      - Move page up.
         **      CTRL + UP       - Move to the top.
         *)
         IF    msg.qualifier * SET{ ie.lShift, ie.rShift } # SET{} THEN
           rc:= i.SetGadgetAttrs( lvObj^, window, NIL, b.listvSelect, b.listvSelectPageUp, u.done );
         ELSIF msg.qualifier * SET{ ie.control } # SET{} THEN
           rc:= i.SetGadgetAttrs( lvObj^, window, NIL, b.listvSelect, b.listvSelectFirst, u.done );
         ELSE
           rc:= i.SetGadgetAttrs( lvObj^, window, NIL, b.listvSelect, b.listvSelectPrevious, u.done );
         END;

      | 04DH:
         (*
         **      DOWN            - Move entry down.
         **      SHIFT + DOWN    - Move page down.
         **      CTRL + DOWN     - Move to the end.
         *)
         IF    msg.qualifier * SET{ ie.lShift, ie.rShift } # SET{} THEN
           rc:= i.SetGadgetAttrs( lvObj^, window, NIL, b.listvSelect, b.listvSelectPageDown, u.done );
         ELSIF msg.qualifier * SET{ ie.control } # SET{} THEN
           rc:= i.SetGadgetAttrs( lvObj^, window, NIL, b.listvSelect, b.listvSelectLast, u.done );
         ELSE
           rc:= i.SetGadgetAttrs( lvObj^, window, NIL, b.listvSelect, b.listvSelectNext, u.done );
         END;

      | 043H,
        044H:
         (*
         **      RETURN or ENTER - Report the listview ID to the event handler.
         *)
         b.DoMethod( obj, b.wmReportID, lvObj.gadgetID, 0 );
      ELSE
      END; (* CASE msg->Code *)
    END ScrollHookFunc;


  (*
  **      Scan the directory "name".
  *)
  (* VOID ScanDirectory( UBYTE *name, Object *obj ) *)
  PROCEDURE ScanDirectory( name : e.LSTRPTR; obj : b.Object );
    VAR
      eac    : d.ExAllControlPtr;
      ead    : d.ExAllDataPtr;
      tmp    : d.ExAllDataPtr;
      lock   : d.FileLockPtr;
      ismore : BOOLEAN;
      fib    : d.FileInfoBlockPtr;
      rc     : LONGINT;
      res    : b.Resource;
    BEGIN
      (*
      **      We need to recompute the columns.
      *)
      ReCompCols:= TRUE;

      (*
      **      Get a lock to the directory.
      *)
      lock:= d.Lock( name^, d.read );
      IF lock # NIL THEN
        (*
        **      Allocate a FileInfoBlock structure.
        *)
        fib:= d.AllocDosObject( d.fib, NIL );
        IF fib  # NIL THEN
          (*
          **      Examine the lock.
          *)
          IF d.Examine( lock, fib^ ) THEN
            (*
            **      Is this a directory?
            *)
            IF fib.dirEntryType > 0 THEN
              (*
              **      Allocate ExAll() control structure.
              *)
              eac:= d.AllocDosObject( d.exAllControl, NIL);
              IF eac # NIL THEN
                (*
                **      Set key to NULL.
                *)
                eac.lastKey:= NIL;
                (*
                **      Allocate ExAll() buffer.
                *)
                ead:= e.AllocVec( 10 * SIZE( ead^ ), LONGSET{ e.public });
                IF ead # NIL THEN
                  (*
                  **      Read directory.
                  *)
                  LOOP
                    (*
                    **      Fill buffer.
                    *)
                    ismore:= d.ExAll( lock, ead^, 10 * SIZE( ead^ ), d.date, eac );

                    (*
                    **      Errors? Done?
                    *)
                    IF  ~ismore & ( d.IoErr() # d.noMoreEntries ) THEN EXIT END;

                    (*
                    **      Entries read?
                    *)
                    IF eac.entries # 0 THEN

                      (*
                      **      Pick up data pointer.
                      *)
                      tmp:= ead;

                      (*
                      **      Add the entries.
                      *)
                      WHILE tmp # NIL DO
                        bm.AddEntry( NIL, obj, tmp, b.lvapSorted );
                        (*
                        **      Next...
                        *)
                        tmp:= tmp.next;
                      END;
                    END; (* eac.entries # 0 *)

                    IF ~ismore THEN EXIT END;
                  END; (* LOOP *)
                  (*
                  **      Deallocate ExAll() buffer.
                  *)
                  e.FreeVec( ead );
                END; (* IF ead # NIL *)
                (*
                **      Deallocate ExAll() control structure.
                *)
                d.FreeDosObject( d.exAllControl, eac );
              END; (* IF eac # NIL THEN *)
            END; (* IF fib.dirEntryType > 0 *)
          END; (* IF d.Examine( lock, fib ) *)
          (*
          **      Deallocate FileInfoBlock structure.
          *)
          d.FreeDosObject( d.fib, fib );
        END; (* IF fib  # NIL *)
        (*
        **      Release lock.
        *)
        d.UnLock( lock );
      END; (* IF loc # NIL *)
    END ScanDirectory;

  PROCEDURE RefreshDir( win : i.WindowPtr; wObj, dObj : b.Object; name : e.LSTRPTR );
    BEGIN
      bm.WindowBusy( wObj );
      bm.ClearList( win, dObj );
      ScanDirectory( name, dObj );
      bm.RefreshList( win, dObj );
      bm.WindowReady( wObj );
    END RefreshDir;

TYPE
  rdArgsPtr = UNTRACED POINTER TO rdArgs;
  rdArgs = STRUCT( dum : d.ArgsStruct )
    dname : e.STRPTR;
    END;

  (*
  **      And were off...
  *)
  (* VOID StartDemo( void ) *)
  PROCEDURE StartDemo;
    VAR
      win       : i.WindowPtr;
      woDirWin  : b.Object;
      goDirList : b.Object;
      goQuit    : b.Object;
      goNewDir  : b.Object;
      fi        : FileInfoPtr;
      signal    : LONGSET;
      rc        : LONGINT;
      running   : BOOLEAN;
      vg1       : b.Object;
      vg1a      : b.Object;
      hg1b      : b.Object;
      name      : ARRAY 512 OF CHAR;
      gad       : i.GadgetPtr;
      ra        : d.RDArgsPtr;
      args      : rdArgs;
      ptr       : e.LSTRPTR;
    BEGIN

      woDirWin  := NIL;
      args.dname:= NIL;
      running   := TRUE;

      (*
      **      Parse command line?
      *)
      ra:= d.ReadArgs( "NAME", args, NIL );

      IF ra # NIL THEN
        (*
        **      Copy the name into the buffer.
        *)
        IF args.dname # NIL THEN COPY( args.dname^, name );
        ELSE                name:= "" END;
        (*
        **      Create the listview object.
        *)
        goDirList:= bm.ListviewObject(
           b.listvResourceHook, y.ADR( ResourceHook ),
           b.listvDisplayHook,  y.ADR( DisplayHook ),
           b.listvTitleHook,    y.ADR( DisplayHook ),
           b.listvCompareHook,  y.ADR( CompareHook ),
           i.gaID,              idList,
           u.done );
        (*
        **      Put it in the IDCMP hook.
        *)
        ScrollHook.data:= y.VAL( e.APTR, goDirList );
        (*
        **      Create the window.
        *)

        goNewDir:= bm.KeyString( NIL, y.ADR( name ), 512, idNewDir );

        vg1a:= bm.VGroupObject(
           b.groupMember, goDirList, u.done, 0,
           b.groupMember, goNewDir,
                          b.lgoFixMinHeight, e.true,  (* FixMinHeight *)
                          u.done, 0,
           u.done );

        goQuit:= bm.KeyButton( y.ADR("_Quit"), idQuit );

        hg1b:= bm.HGroupObject(
           b.groupSpaceObject, b.defaultWeight,   (* VarSpace(defaultWeight) *)
           b.groupMember, goQuit, u.done, 0,
           b.groupSpaceObject, b.defaultWeight,   (* VarSpace(defaultWeight) *)
           u.done );

        vg1:= bm.VGroupObject(
           b.groupHorizOffset, 4,                  (* HOffset(4) *)
           b.groupVertOffset,  4,                  (* VOffset(4) *)
           b.groupSpacing,     4,                  (* Spacing(4) *)
           b.groupBackfill,    b.shineRaster,
           b.groupMember, vg1a,  u.done, 0,
           b.groupMember, hg1b,
                          b.lgoFixMinHeight, e.true,  (* FixMinHeight *)
                          u.done, 0,
           u.done );

        woDirWin:= bm.WindowObject(
           b.windowTitle,         y.ADR("MultiCol"),
           b.windowRMBTrap,       e.true,
           b.windowScaleWidth,    50,
           b.windowScaleHeight,   30,
           b.windowAutoAspect,    e.true,
           b.windowSmartRefresh,  e.true,
           b.windowIDCMPHookBits, LONGSET{ i.rawKey },
           b.windowIDCMPHook,     y.ADR( ScrollHook ),
           b.windowMasterGroup,   vg1,
           u.done );

        (*
        **      Window created OK?
        *)
        IF woDirWin # NIL THEN
          (*
          **      Add gadget key.
          *)
          IF bm.GadgetKeyA( woDirWin, goQuit, y.ADR("q")) # 0 THEN
            (*
            **      Open the window.
            *)
            win:= bm.WindowOpen( woDirWin );
            IF win # NIL THEN
              (*
              **      Obtain signal mask.
              *)
              rc:= i.GetAttr( b.windowSigMask, woDirWin, signal );
              (*
              **      Read in the directory.
              *)
              bm.WindowBusy( woDirWin );
              ScanDirectory( y.ADR( name ), goDirList );
              bm.WindowReady( woDirWin );
              (*
              **      Refresh the list.
              *)
              bm.RefreshList( win, goDirList );
              (*
              **      Poll messages...
              *)
              WHILE running DO
                y.SETREG( 0, e.Wait( signal ));
                LOOP
                  CASE bm.HandleEvent( woDirWin ) OF
                    | b.wmhiNoMore      : EXIT;
                    | idQuit,
                      b.wmhiCloseWindow :  running:= FALSE;

                    | idList:
                       (*
                       **      Get selected entry.
                       *)
                         (*
                         **      Is the entry a directory?
                         *)
                         fi:= bm.FirstSelected( goDirList );
                         IF fi.isDir THEN
                           (*
                           **      AddPart() the name to the buffer.
                           *)
                           IF d.AddPart( name, fi.fileName, 512 ) THEN END;
                           (*
                           **      Refresh the string gadget.
                           *)
                           gad:= y.VAL( i.GadgetPtr, goNewDir );
                           rc:= i.SetGadgetAttrs( gad^, win, NIL, i.stringaTextVal,
                                                  y.ADR( name ), u.done );
                           (*
                           **      Re-read the list.
                           *)
                           RefreshDir( win, woDirWin, goDirList, y.ADR( name ));
                         END; (* IF fi.isDir *)

                    | idNewDir:
                        (*
                        **      Copy the new name to the buffer.
                        *)
                        rc:= i.GetAttr( i.stringaTextVal, goNewDir, ptr );
                        RefreshDir( win, woDirWin, goDirList, ptr );
                  ELSE
                  END; (* CASE rc *)
                END; (* LOOP *)
              END; (* WHILE running *)
            END; (* IF win # NIL *)
          END; (* IF bm.GadgetKey( woDirWin, goQuit, y.ADR("q") # 0 *)
          (*
          **      Kill the object.
          *)
          i.DisposeObject( woDirWin );
        END; (* IF woDirWin # NIL *)
        (*
        **      Delete the ReadArgs structure.
        *)
        d.FreeArgs( ra );
      END; (* IF ra # NIL THEN *)
    END StartDemo;

BEGIN
  TotalWidth:= 0;
  ReCompCols:= TRUE;

  b.MakeHook( ResourceHook, ResourceHookFunc );
  b.MakeHook( DisplayHook,  DisplayHookFunc  );
  b.MakeHook( CompareHook,  CompareHookFunc  );
  b.MakeHook( ScrollHook,   ScrollHookFunc   );

  StartDemo;

END MultiCol.
