MODULE FieldListH;

(*
** FIELDLIST.H
**
** (C) Copyright 1995-1996 Jaba Development.
** (C) Copyright 1995-1996 Jan van den Baard.
**     All Rights Reserved.
**
**     Oberon Conversion - Larry Kuhns  12/01/96
**
** This is a simple subclass of the Listview class which
** will allow drops from another Listview object, positioned
** drops and sortable drops.
**
** It is included in the demonstration programs that make
** use of it.
**
** Tags:
**   FL_DropAccept -- A pointer to the listview object from
**        which drops will be accepted. Ofcourse
**        you are responsible to make sure that
**        the entries of this object are of the
**        same format as the entries of the
**        target object.
**
**   FL_SortDrops -- When TRUE the class will sort the drops
**       automatically. When FALSE the drops may
**       be positioned by the user.
*)

IMPORT
  b   := Bgui,
  bm  := BguiMacro,
  clf := Classface,
  e   := Exec,
  i   := Intuition,
  u   := Utility,
  y   := SYSTEM;

CONST
(* Tags for this subclass. *)

  flAcceptDrop *= u.user + 2000H; (* IS--- *)
  flSortDrops  *= u.user + 2001H; (* IS--- *)

TYPE
(* Object instance data. *)

  FldPtr *= UNTRACED POINTER TO Fld;
  Fld    *= STRUCT
    fldAccept    *: b.Object;   (* Accept drops from this object. *)
    fldSortDrops *: LONGINT;    (* Auto-sort drops.               *)
    END;


(* Set attributes. *)

PROCEDURE SetFLAttr * ( fld : FldPtr; attr : u.TagListPtr );
  VAR
    tag    : u.TagItemPtr;
    tState : u.TagItemPtr;
  BEGIN
    tState:= y.VAL( u.TagItemPtr, attr );

    (* Scan attribute list. *)

    LOOP
      tag:= u.NextTagItem( tState );
      IF tag = NIL THEN EXIT END;
      CASE tag.tag OF

        | flAcceptDrop : fld.fldAccept:= y.VAL( b.Object, tag.data );

        | flSortDrops  : fld.fldSortDrops:= tag.data;
      ELSE
      END; (* CASE tag.tiTag *)

    END; (* LOOP *)
  END SetFLAttr;

(*
PROCEDURE DispatchFL * ( cl{8} : i.IClassPtr; obj{10} : b.Object; msg{9} : i.MsgPtr ): e.APTR;
*)
PROCEDURE DispatchFL * ( cl : i.IClassPtr; obj : b.Object; msg : i.MsgPtr ): e.APTR;
  VAR
    fld   : FldPtr;
    entry : e.APTR;
    ib    : i.IBoxPtr;
    rc    : e.APTR;
    spot  : LONGINT;
  BEGIN

    (*  What do they want... *)
    CASE msg.methodID OF

    | i.new:
      (*  Let the superclass make the object. *)
      rc:= clf.DoSuperMethodA( cl, obj, msg^ );
      IF rc # NIL THEN

        (*  Get instance data. *)
        fld:= clf.InstData( cl, rc );

        (*  Set ELSE *)
        fld.fldAccept   := NIL;
        fld.fldSortDrops:= e.false;

        (*  Get attributes. *)
        SetFLAttr( fld, msg(i.OpSet).attrList );
      END;


    | i.set:
      (*  First the superclass. *)
      rc:= clf.DoSuperMethodA( cl, obj, msg^ );

      (*  Then we have a go. *)
      fld:= clf.InstData( cl, obj );
      SetFLAttr( fld, msg(i.OpSet).attrList );


    | b.baseDragQuery:
      (*
      ** We only allow drops from ourselves and from
      ** the object specified with FL_AcceptDrop.
      *)

      (*
      ** We let the superclass worry about it when
      ** the requesting object request is us.
      *)

      IF msg(b.mDragPoint).source = obj THEN
        RETURN clf.DoSuperMethodA( cl, obj, msg^ );
      END;

      (*  Get instance data. *)
      fld:= clf.InstData( cl, obj );

      (*  Is it the object specified with FL_AcceptDrop? *)
      IF msg(b.mDragPoint).source = fld.fldAccept THEN

        (*  Get the listview class list bounds. *)
        rc:= i.GetAttr( b.listvViewBounds, obj, ib );

        (*
        ** Mouse inside view bounds? Since the superclass
        ** starts sending this message when the mouse goes
        ** inside the hitbox we only need to check if it
        ** is not located right of the view area.
        *)
        IF msg(b.mDragPoint).mouse.x < ib.width  THEN
          RETURN b.bqrAccept;
        END;
      END;

      (*  Screw the rest... *)
      rc:= b.bqrReject;

    | b.baseDropped:
      (*
      ** If the drop comes from ourself we let the
      ** superclass handle it.
      *)
      IF  msg(b.mDropped).source = obj THEN
        RETURN clf.DoSuperMethodA( cl, obj, msg^ );
      END;

      (*  Get instance data. *)
      fld:= clf.InstData( cl, obj );

      (*  Find out where the drop was made. *)
      rc:= i.GetAttr( b.listvDropSpot, obj, spot );

      (*
      ** Simply pick up all selected entries
      ** from the dragged object.
      *)
      LOOP
        entry:= bm.FirstSelected( msg(b.mDropped).source );
        IF entry = NIL THEN EXIT END;

        (*
        ** Set it on ourselves. We insert it when we are
        ** not sortable. We add them sorted when we are
        ** sortable.
        *)

        IF fld.fldSortDrops = e.false THEN
          b.DoMethod( obj, b.lvmInsertSingle, NIL, spot, entry, LONGSET{b.lvasfSelect} );
        ELSE
          b.DoMethod( obj, b.lvmAddSingle, NIL, entry, b.lvapSorted, LONGSET{b.lvasfSelect} );
        END;

        (*  Remove it from the dropped object. *)
        b.DoMethod( msg(b.mDropped).source, b.lvmRemEntry, NIL, entry );

      END;

      (*
      ** Refresh the dragged object. We do not have to
      ** refresh ourselves since the base class will
      ** do this for us when we are deactivated.
      *)
      (*
      rc:= b.DoGadgetMethod( msg(b.mDropped).source,
                             msg(b.mDropped).sourceWin,
                             msg(b.mDropped).sourceReq,
                             b.lvmRefresh, NIL );
      *)
      b.DoMethod( msg(b.mDropped).source, b.lvmRefresh, msg(b.mDropped).gInfo );
      rc:= 1;

    ELSE
      (*  Let's the superclass handle the rest. *)
      rc:= clf.DoSuperMethodA( cl, obj, msg^ );
    END; (* CASE msg->MethodID *)

    RETURN rc;

  END DispatchFL;

(*  Simple class initialization. *)
PROCEDURE InitClass * () : i.IClassPtr;
  VAR
    super : i.IClassPtr;
    cl    : i.IClassPtr;
  BEGIN
    cl:= NIL;

    (*
    ** Obtain the ListviewClass pointer which
    ** will be our superclass.
    *)

    super:= b.GetClassPtr( b.listviewGadget );
    IF super  # NIL THEN

      (*  Create the class. *)

      cl:= i.MakeClass( NIL, NIL, super, SIZE( Fld ), LONGSET{} );
      IF cl # NIL THEN

        (*  Setup dispatcher. *)
        u.InitHook( cl, y.VAL( u.HookFunc, DispatchFL ));
      END;
    END;

    RETURN cl;

  END InitClass;

END FieldListH.
