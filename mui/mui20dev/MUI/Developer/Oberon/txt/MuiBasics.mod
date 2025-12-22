(*------------------------------------------
  :Module.      MuiBasics.mod
  :Author.      Albert Weinert  [awn]
  :Address.     Felblumenweg 2 , 50769 Köln, Germany
  :EMail.       Usenet_> a.weinert@darkness.gun.de
  :EMail.       Z-Netz_> A.WEINERT@DARKNESS.ZER
  :Phone.       0221 / 700 83 82
  :Revision.    R.13
  :Date.        05-Feb-1994
  :Copyright.   FreeWare.
  :Language.    Oberon-2
  :Translator.  AmigaOberon V3.11
  :Contents.    Die Makros die in "mui.h" definiert waren als Prozeduren
  :Imports.     <Importiertes, Name/ShortCut des Autors>
  :Remarks.     Bei VCenter, HCenter, Popup ist es etwas anders.
  :Bugs.        <Bekannte Fehler>
  :Usage.       <Angaben zur Anwendung>
  :History.     .1     [awn] 22-Aug-1993 : Die Prozeduren die in Mui.mod waren nun
  :History.            entfernt und ein seperates Modul daraus gemacht, so das
  :History.            man nicht darauf angewiesen dies in seinem Interfaces zu haben.
  :History.     .2     [awn] 24-Aug-1993 : Kräftig aufgeräumt um den erzeugten
  :History.            Maschinencode so kurz wie möglich zu halten.
  :History.     .3     [awn] 24-Aug-1993 : PopupEnd() so erweitert das nun ein
  :History.            Objekt mit angeben werden kann, dies ist dafür gedacht wenn
  :History.            man das Popup zu einem anderen Objekt anordnet (z.B String )
  :History.     .4     [awn] 24-Aug-1993 : Im Zuge der Popup Änderung wurde eine
  :History.            eigene Speziell auf Mui abgestimmte Hook Parameter übergabe
  :History.            erstellt (Allerdings OS Konform eingebettet). Der Parameter
  :History.            Deklaration der Hook-Prozedur muss nun so aussehen wie der
  :History.            Typ `HookDef'.
  :History.     .5     [awn] 25-Aug-1993 : Tipfehler bei TagItem2() und TagItem3()
  :History.            entfernt.
  :History.     .6     [awn] 25-Aug-1993 : Die Groups und Frames wieder mit der
  :History.            Möglichkeit versehen dort TagListen zu übergeben.
  :History.     .7     [awn] 30-Aug-1993 : PageGroup() hizugefügt.
  :History.     .8     [awn] 14-Sep-1993 : Fehler bei Strings() dort wurde in der
  :History.            Deklaration 2 mal A1 benutzt.
  :History.     .9     [awn] 03-Oct-1993 : Eine einfache Plausibiltätsprüfung eingebaut.
  :History.            Für jede #?Object() Prozedur gibt es nun ein End#?() Prozedure,
  :History.            wenn der Objekt Typ nicht übereinstimmt wird ein NIL zurückgeben.
  :History.            Dies ist dafür um während der Programmentwicklung Abstürze zu
  :History.            umgehen, wenn das Programm einmal steht sind diese nicht mehr
  :History.            notwendig, aber brauchen nicht entfernt zu werden.
  :History.     .10    [awn] 30-Oct-1993 : An MUI 1.4 angepasst, die neuen Objekte
  :History.            hinzugefügt (Coloradjust, Colorfield, Palette, Virtgroup, Scrollgroup
  :History.            und Scrmodelist), die Group Prozeduren gibt es nun auch für Virtgroups
  :History.            z.B. HGroupV(). Sonstige neue Prozeduren, KeyRadio(), Slider(), KeySlider(),
  :History.            LLabel?() und KeyLLabel?().
  :History.     .11    [awn] 31-Jan-1994 : Angepasst an MUI 1.5, Fehler bei SliderObject()
  :History.            entfernt (Rief RadioObject auf). Es gibt nun für *jede* Objekt ein
  :History.            passendes. Bei Popupend() wird nun auch das Background Image gesetzt.
  :History.     .12    [awn] 02-Feb-1994 : INewObject() und IEnd() aufgenommen, der Aufruf
  :History.            von INewObject() ist wie der von Intuition.NewObject() nur ohne
  :History.            Rückgabeparamter. INewObject() muss *anstatt* Intuition.NewObject()
  :History.            aufgerufen werden wenn die Objekte direkt mit ins Layout sollen.
  :History.            INewObject() *muss* ein IEnd() bzw. iEnd() folgen. siehe Class1.mod
  :History.     .13    [awn] 05-Feb-1994 : VSlider() und KeyVSlider() aufgenommen.

--------------------------------------------*)

MODULE MuiBasics;

IMPORT Exec, Utility, Intuition, SYSTEM, Mui;

CONST   ArrayAdd = 16;

TYPE
  TagArray * = UNTRACED POINTER TO ARRAY OF Utility.TagItem;
  Class    * = UNTRACED POINTER TO ClassDesc;
  Args     * = UNTRACED POINTER TO ArgsDesc;
  Hook     * = UNTRACED POINTER TO HookDesc;

  ClassDesc = STRUCT( n : Exec.Node );
                name   : ARRAY 32 OF CHAR;
                iclass : Intuition.IClassPtr;
                tags   : TagArray;
                tagnum : LONGINT;
                tagdata : BOOLEAN;
              END;

  ArgsDesc * = STRUCT END;

  PopupArgs * = STRUCT ( d : ArgsDesc );
                  linkedObj : Mui.Object (* Das Objekt zu dem das Popup Object gelinkt ist *)
                END;
  HookDef * = PROCEDURE ( hook : Hook; object : Mui.Object; args : Args ):LONGINT;


(* Hook-Example.
 *
 *  TYPE  PopWindowArgs = STRUCT( d : MuiBasics.ArgsDesc );
 *                          window : Mui.Object;
 *                        END;
 *
 *  VAR myHook : MuiBasics.Hook;
 *      button : Mui.Object;
 *      window : Mui.Object;
 *
 *  PROCEDURE PopWindow( hook : Hook; object : Mui.Object; args : Args ) : LONGINT;
 *    BEGIN
 *      IF args # NIL THEN
 *        IF args(PopWindowArgs).window # NIL THEN
 *          Mui.DoMethod( args(PopWindowArgs).window, Mui.mWindowToFront );
 *        END;
 *      END;
 *      RETURN 0;
 *    END PopWindow;
 *
 *  BEGIN
 *    [... create Application Windows ...]
 *
 *    myHook := MuiBasics.MakeHook( PopWindow );
 *    IF myHook # NIL THEN
 *      Mui.DoMethod( button, Mui.mNotify, Mui.aPressed, Exec.false,
 *                    button, 3, Mui.mCallHook, myHook, window );
 *    END;
 *    [... Do the other magic ...]
 *
 * Note: Typed on the fly, no warranty is given that this piece of code reallay work.
 *)

  HookDesc * = STRUCT( minNode : Exec.MinNode );
             entry     : PROCEDURE ( hook{8}   : Hook;
                                     object{10}: Mui.Object;
                                     args{9}: Args ):LONGINT;
             subEntry  : HookDef;
             a5 : Exec.APTR;

             object : Mui.Object;
           END;

VAR no : Exec.List;

  (* ---- MuiBasics Hook-Dispatcher ---- *)
  PROCEDURE HookEntry*(hook{8}: Hook;               (* $SaveRegs+ $StackChk- *)
                       object{10}: Mui.Object;
                       args{9}: Args): LONGINT;
  (*
   * Calls hook.subEntry. The contents of A5 have to be stored in hook.a5,
   * else A5 would not be set correctly.
   *)
  
  BEGIN
    SYSTEM.SETREG(13,hook.a5);
    RETURN hook.subEntry(hook,object,args);
  END HookEntry;

  PROCEDURE MakeHook* ( entry: HookDef ):Hook;
  (*------------------------------------------
    :Input.     entry : Prozedure die gestartet werden soll, wenn der Hook
    :Input.             aufgerufen wird.
    :Output.    Hook der direkt einsatzfähig ist (oder NIL, falls es nicht
    :Output.    geklappt haben sollte).
    :Semantic.  Erstellt einen Hook und bindet die Prozedure ein.
    :Note.
    :Update.    24-Aug-1993 [awn] - erstellt.
  --------------------------------------------*)
    VAR hook : Hook;
  BEGIN
    NEW( hook );
    IF hook # NIL THEN
      hook.entry := HookEntry;
      hook.subEntry := entry;
      hook.a5 := SYSTEM.REG(13);
    END;
    RETURN hook;
  END MakeHook;

  PROCEDURE SetHookObject*( hook : Hook; object : Mui.Object );
  (*------------------------------------------
    :Input.     hook : Initialisierte Hook;
    :Input.     object : Das Object zu wem der Hook gelinkt ist.
    :Output.
    :Semantic.  Trägt in die Hook-Struktur ein Object ein, so
    :Semantic.  das man später noch darauf zugreifen kann.
    :Note.
    :Update.    24-Aug-1993 [awn] - erstellt.
  --------------------------------------------*)
    BEGIN
      IF hook # NIL THEN
        hook.object := object;
      END;
    END SetHookObject;

  PROCEDURE GetHookObject*( hook : Hook ):Mui.Object;
  (*------------------------------------------
    :Input.     hook : Ein Hook
    :Output.    Das Objekt welches in der Hook Struktur eingetragen ist
    :Semantic.
    :Note.
    :Update.    24-Aug-1993 [awn] - erstellt.
  --------------------------------------------*)
    BEGIN
      IF hook # NIL THEN
        RETURN hook.object;
      END;
    END GetHookObject;

  PROCEDURE Init();
    BEGIN
      no.head := SYSTEM.ADR( no.tail );
      no.tail := NIL;
      no.tailPred := SYSTEM.ADR( no.head );
    END Init;

  PROCEDURE NewClass*();
  (* $SaveRegs+ *)
    VAR cl : Class;
    BEGIN
      NEW( cl );

      (* $IF GarbageCollector *)

      Exec.AddTail( no, cl );

      (* $ELSE *)

      IF cl # NIL THEN
        Exec.AddTail( no, SYSTEM.VAL( Exec.CommonNodePtr, cl ) );
        cl.tagdata := FALSE;
      END;

      (* $END *)
    END NewClass;

  PROCEDURE CheckAndExpandTags( cl : Class;  n : LONGINT);
  (* $SaveRegs+ *)
    VAR newtags : TagArray;
        ShouldLen, MaxLen, i : LONGINT;

    BEGIN
      IF n = 0 THEN RETURN END;
      IF cl.tags # NIL THEN
        ShouldLen := cl.tagnum + n;
        MaxLen := LEN( cl.tags^ )-1;
        IF ShouldLen >= MaxLen THEN
          INC( ShouldLen, ArrayAdd );
          SYSTEM.ALLOCATE( newtags, ShouldLen );
          FOR i := 0 TO cl.tagnum-1 DO
            newtags[i] := cl.tags[i];
          END;

          (* $IF GarbageCollector *)

            cl.tags := newtags;

          (* $ELSE *)

            DISPOSE( cl.tags );
            cl.tags := newtags;

          (* $END *)
        END;
      ELSE
        ShouldLen := ArrayAdd + n ;
        NEW( cl.tags, ShouldLen );
        cl.tagnum := 0;
      END;
    END CheckAndExpandTags;

  PROCEDURE clTag ( cl : Class;  tag : Exec.APTR );
  (* $SaveRegs+ *)
    BEGIN
      CheckAndExpandTags( cl, 1 );
      IF cl.tags # NIL THEN
        IF cl.tagdata THEN
          cl.tags[cl.tagnum].data := tag;
          cl.tagdata := FALSE;
          INC( cl.tagnum );
        ELSE
          cl.tags[cl.tagnum].tag := tag;
          cl.tagdata := TRUE;
        END;
      END;
    END clTag;

  PROCEDURE clTagItem ( cl : Class;  tag, data : Exec.APTR );
  (* $SaveRegs+ *)
    BEGIN
      CheckAndExpandTags( cl, 1 );
      IF cl.tags # NIL THEN
        cl.tags[cl.tagnum].data := data;
        cl.tags[cl.tagnum].tag := tag;
        INC( cl.tagnum );
      END;
    END clTagItem;

  PROCEDURE countTag( tags{9} : Utility.TagListPtr) : LONGINT;
  (* $SaveRegs+ *)
    VAR i : LONGINT;
    BEGIN
      IF tags = NIL THEN RETURN( 0 ) END;
      i:=0;
      WHILE tags[i].tag # Utility.end DO INC(i); END;
      RETURN i;
    END countTag;

  PROCEDURE clTagsA*( cl{8} : Class;  tags{9} : Utility.TagListPtr );
  (* $SaveRegs+ *)
    VAR  i : LONGINT;

    BEGIN
      IF tags = NIL THEN RETURN END;
      CheckAndExpandTags( cl, countTag( tags ) );
      i:=0;
      IF cl.tags # NIL THEN
        WHILE tags[i].tag # Utility.end DO
          cl.tags[cl.tagnum] := tags[i];
          INC(cl.tagnum); INC(i);
        END;
      END;
    END clTagsA;

  PROCEDURE clTags{"MuiBasics.clTagsA"} ( cl{8} : Class;  tags{9}.. : Utility.Tag );

  PROCEDURE TagsA*( tags{9} : Utility.TagListPtr );
  (* $SaveRegs+ *)
    BEGIN
      IF no.tailPred # SYSTEM.ADR( no.head ) THEN;
        clTagsA( SYSTEM.VAL( Class, no.tailPred ), tags );
      END;
    END TagsA;

  PROCEDURE Tags*{"MuiBasics.TagsA"} ( tags{9}.. : Utility.Tag );

  PROCEDURE Tag*( tag : Exec.APTR );
  (* $SaveRegs+ *)
    BEGIN
      IF no.tailPred # SYSTEM.ADR( no.head )  THEN
        clTag( SYSTEM.VAL( Class, no.tailPred ), tag );
      END;
    END Tag;

  PROCEDURE TagItem*( tag, data : Exec.APTR );
  (* $SaveRegs+ *)
    BEGIN
      IF no.tailPred # SYSTEM.ADR( no.head )  THEN
        clTagItem( SYSTEM.VAL( Class, no.tailPred ), tag, data );
      END;
    END TagItem;

  PROCEDURE TagItem2*( tag1, data1, tag2, data2 : Exec.APTR );
  (* $SaveRegs+ *)
    BEGIN
      IF no.tailPred # SYSTEM.ADR( no.head )  THEN
        clTagItem( SYSTEM.VAL( Class, no.tailPred ), tag1, data1 );
        clTagItem( SYSTEM.VAL( Class, no.tailPred ), tag2, data2 );
      END;
    END TagItem2;

  PROCEDURE TagItem3*( tag1, data1, tag2, data2, tag3, data3 : Exec.APTR );
  (* $SaveRegs+ *)
    BEGIN
      IF no.tailPred # SYSTEM.ADR( no.head )  THEN
        clTagItem( SYSTEM.VAL( Class, no.tailPred ), tag1, data1 );
        clTagItem( SYSTEM.VAL( Class, no.tailPred ), tag2, data2 );
        clTagItem( SYSTEM.VAL( Class, no.tailPred ), tag3, data3 );
      END;
    END TagItem3;

  PROCEDURE DEnd(mui : BOOLEAN):Mui.Object;
    VAR cl : Exec.NodePtr;
        ret : Exec.APTR;

    BEGIN
      ret := NIL;
      cl := no.tailPred;
      WITH cl : Class DO

        IF cl.tags # NIL THEN
          cl.tags[cl.tagnum].tag:=Utility.end;
          IF mui THEN
            ret := Mui.NewObject( cl.name, Utility.more, SYSTEM.ADR(cl.tags^) );
          ELSE
            IF cl.iclass # NIL THEN
              ret := Intuition.NewObject( cl.iclass, NIL, Utility.more, SYSTEM.ADR(cl.tags^) );
            ELSE
              ret := Intuition.NewObject( NIL, cl.name, Utility.more, SYSTEM.ADR(cl.tags^) );
            END;
          END;
        ELSE
          IF mui THEN
            ret := Mui.NewObject( cl.name );
          ELSE
            IF cl.iclass # NIL THEN
              ret := Intuition.NewObject( cl.iclass, NIL );
            ELSE
              ret := Intuition.NewObject( NIL, cl.name );
            END;
          END;
        END;

        Exec.Remove( cl );

        (* $IFNOT GarbageCollector *)

          DISPOSE( cl.tags );
          DISPOSE( cl );

        (* $END *)


        IF no.tailPred # SYSTEM.ADR( no.head ) THEN
          clTag( SYSTEM.VAL( Class, no.tailPred ), ret );
        END;

      END;
      RETURN ret;
    END DEnd;

  PROCEDURE End*():Mui.Object;
    BEGIN
      RETURN DEnd( TRUE );
    END End;

  PROCEDURE end*();
    BEGIN
      SYSTEM.SETREG( 0, End() );
    END end;

  PROCEDURE IEnd*():Mui.Object;
    BEGIN
      RETURN DEnd( FALSE );
    END IEnd;

  PROCEDURE iEnd*();
    BEGIN
      SYSTEM.SETREG( 0, IEnd() );
    END iEnd;

  PROCEDURE EndApplication*():Mui.Object;
    BEGIN
      IF Mui.cApplication # no.tailPred(Class).name THEN RETURN NIL END;
      RETURN End();
    END EndApplication;

  PROCEDURE EndNotify*():Mui.Object;
    BEGIN
      IF Mui.cNotify # no.tailPred(Class).name THEN RETURN NIL END;
      RETURN End();
    END EndNotify;

  PROCEDURE EndWindow*():Mui.Object;
    BEGIN
      IF Mui.cWindow # no.tailPred(Class).name THEN RETURN NIL END;
      RETURN End();
    END EndWindow;

  PROCEDURE EndRectangle*():Mui.Object;
    BEGIN
      IF Mui.cRectangle # no.tailPred(Class).name THEN RETURN NIL END;
      RETURN End();
    END EndRectangle;

  PROCEDURE EndImage*():Mui.Object;
    BEGIN
      IF Mui.cImage # no.tailPred(Class).name THEN RETURN NIL END;
      RETURN End();
    END EndImage;

  PROCEDURE EndText*():Mui.Object;
    BEGIN
      IF Mui.cText # no.tailPred(Class).name THEN RETURN NIL END;
      RETURN End();
    END EndText;

  PROCEDURE EndString*():Mui.Object;
    BEGIN
      IF Mui.cString # no.tailPred(Class).name THEN RETURN NIL END;
      RETURN End();
    END EndString;

  PROCEDURE EndProp*():Mui.Object;
    BEGIN
      IF Mui.cProp # no.tailPred(Class).name THEN RETURN NIL END;
      RETURN End();
    END EndProp;

  PROCEDURE EndSlider*():Mui.Object;
    BEGIN
      IF Mui.cSlider # no.tailPred(Class).name THEN RETURN NIL END;
      RETURN End();
    END EndSlider;

  PROCEDURE EndList*():Mui.Object;
    BEGIN
      IF Mui.cList # no.tailPred(Class).name THEN RETURN NIL END;
      RETURN End();
    END EndList;

  PROCEDURE EndFloattext*():Mui.Object;
    BEGIN
      IF Mui.cFloattext # no.tailPred(Class).name THEN RETURN NIL END;
      RETURN End();
    END EndFloattext;

  PROCEDURE EndVolumelist*():Mui.Object;
    BEGIN
      IF Mui.cVolumelist # no.tailPred(Class).name THEN RETURN NIL END;
      RETURN End();
    END EndVolumelist;

  PROCEDURE EndDirlist*():Mui.Object;
    BEGIN
      IF Mui.cDirlist # no.tailPred(Class).name THEN RETURN NIL END;
      RETURN End();
    END EndDirlist;

  PROCEDURE EndGroup*():Mui.Object;
    BEGIN
      IF Mui.cGroup # no.tailPred(Class).name THEN RETURN NIL END;
      RETURN End();
    END EndGroup;

  PROCEDURE EndScrollbar*():Mui.Object;
    BEGIN
      IF Mui.cScrollbar # no.tailPred(Class).name THEN RETURN NIL END;
      RETURN End();
    END EndScrollbar;

  PROCEDURE EndListview*():Mui.Object;
    BEGIN
      IF Mui.cListview # no.tailPred(Class).name THEN RETURN NIL END;
      RETURN End();
    END EndListview;

  PROCEDURE EndRadio*():Mui.Object;
    BEGIN
      IF Mui.cRadio # no.tailPred(Class).name THEN RETURN NIL END;
      RETURN End();
    END EndRadio;

  PROCEDURE EndCycle*():Mui.Object;
    BEGIN
      IF Mui.cCycle # no.tailPred(Class).name THEN RETURN NIL END;
      RETURN End();
    END EndCycle;

  PROCEDURE EndGauge*():Mui.Object;
    BEGIN
      IF Mui.cGauge # no.tailPred(Class).name THEN RETURN NIL END;
      RETURN End();
    END EndGauge;

  PROCEDURE EndScale*():Mui.Object;
    BEGIN
      IF Mui.cScale # no.tailPred(Class).name THEN RETURN NIL END;
      RETURN End();
    END EndScale;

  PROCEDURE EndBoopsi*():Mui.Object;
    BEGIN
      IF Mui.cBoopsi # no.tailPred(Class).name THEN RETURN NIL END;
      RETURN End();
    END EndBoopsi;

  PROCEDURE EndColorfield*():Mui.Object;
    BEGIN
      IF Mui.cColorfield # no.tailPred(Class).name THEN RETURN NIL END;
      RETURN End();
    END EndColorfield;

  PROCEDURE EndColoradjust*():Mui.Object;
    BEGIN
      IF Mui.cColoradjust # no.tailPred(Class).name THEN RETURN NIL END;
      RETURN End();
    END EndColoradjust;

  PROCEDURE EndPalette*():Mui.Object;
    BEGIN
      IF Mui.cPalette # no.tailPred(Class).name THEN RETURN NIL END;
      RETURN End();
    END EndPalette;

  PROCEDURE EndVirtgroup*():Mui.Object;
    BEGIN
      IF Mui.cVirtgroup # no.tailPred(Class).name THEN RETURN NIL END;
      RETURN End();
    END EndVirtgroup;

  PROCEDURE EndScrollgroup*():Mui.Object;
    BEGIN
      IF Mui.cScrollgroup # no.tailPred(Class).name THEN RETURN NIL END;
      RETURN End();
    END EndScrollgroup;

  PROCEDURE EndPopstring*():Mui.Object;
    BEGIN
      IF Mui.cPopstring # no.tailPred(Class).name THEN RETURN NIL END;
      RETURN End();
    END EndPopstring;

  PROCEDURE EndPopobject*():Mui.Object;
    BEGIN
      IF Mui.cPopobject # no.tailPred(Class).name THEN RETURN NIL END;
      RETURN End();
    END EndPopobject;

  PROCEDURE EndPopasl*():Mui.Object;
    BEGIN
      IF Mui.cPopasl # no.tailPred(Class).name THEN RETURN NIL END;
      RETURN End();
    END EndPopasl;

  PROCEDURE EndScrmodelist*():Mui.Object;
    BEGIN
      IF Mui.cScrmodelist # no.tailPred(Class).name THEN RETURN NIL END;
      RETURN End();
    END EndScrmodelist;

  PROCEDURE EndVGroup*():Mui.Object;
    BEGIN
      RETURN EndGroup();
    END EndVGroup;

  PROCEDURE EndHGroup*():Mui.Object;
    BEGIN
      RETURN EndGroup();
    END EndHGroup;

  PROCEDURE EndColGroup*():Mui.Object;
    BEGIN
      RETURN EndGroup();
    END EndColGroup;

  PROCEDURE EndRowGroup*():Mui.Object;
    BEGIN
      RETURN EndGroup();
    END EndRowGroup;

  PROCEDURE EndPageGroup*():Mui.Object;
    BEGIN
      RETURN EndGroup();
    END EndPageGroup;

  PROCEDURE EndVGroupV*():Mui.Object;
    BEGIN
      RETURN EndGroup();
    END EndVGroupV;

  PROCEDURE EndHGroupV*():Mui.Object;
    BEGIN
      RETURN EndGroup();
    END EndHGroupV;

  PROCEDURE EndColGroupV*():Mui.Object;
    BEGIN
      RETURN EndGroup();
    END EndColGroupV;

  PROCEDURE EndRowGroupV*():Mui.Object;
    BEGIN
      RETURN EndGroup();
    END EndRowGroupV;

  PROCEDURE EndPageGroupV*():Mui.Object;
    BEGIN
      RETURN EndGroup();
    END EndPageGroupV;

  PROCEDURE NewObjectA*( name{8} : Exec.STRPTR; tags{9} : Utility.TagListPtr );
  (* $SaveRegs+ *)
    BEGIN
      NewClass();
      COPY( name^, no.tailPred(Class).name );
      TagsA( tags );
    END NewObjectA;

  PROCEDURE NewObject{"MuiBasics.NewObjectA"} ( name {8} : ARRAY OF CHAR; tags{9}.. : Utility.Tag );

  PROCEDURE INewObjectA*( iclass{8} : Intuition.IClassPtr; name{9}: Exec.STRPTR; tags{10} : Utility.TagListPtr );
    BEGIN
      NewClass();
      IF name # NIL THEN
        COPY( name^, no.tailPred(Class).name );
      END;
      no.tailPred(Class).iclass := iclass;
      TagsA( tags );
    END INewObjectA;

  PROCEDURE INewObject*{"MuiBasics.INewObjectA"}( iclass{8} : Intuition.IClassPtr; name {9} : ARRAY OF CHAR; tags{10}.. : Utility.Tag );

(***************************************************************************
** Class Tree
****************************************************************************
**
** rootclass
**    Notify
**       Application
**       Window
**       Area
**          Rectangle
**          Image
**          Text
**          String
**          Prop
**          Slider
**          List
**             Floattext
**             Volumelist
**             Dirlist
**          Group
**             Scrollbar
**             Listview
**             Radio
**             Cycle
**          Gauge
**          Scale
**          Boopsi
**************************************************************)

(**************************************************************************
**
** Object Generation
** -----------------
**
** The xxxObject (and xChilds) procedures generate new instances of MUI classes.
** Every xxxObject can be followed by tagitems specifying initial create
** time attributes for the new object and must be terminated with the
** End macro:
**
** StringObject;
**          TagItem2( Mui.aStringContents, "foo",
**                    Mui.aStringMaxLen  , 40 );
** obj := End();
**
** With the Child, SubWindow and WindowContents shortcuts you can
** construct a complete GUI within one command:
**
** ApplicationObject;
**
**          ...
**
**          SubWindow; WindowObject;
**             WindowContents; VGroup;
**                Child; String("foo",40);
**                Child; String("bar",50);
**                Child; HGroup;
**                   Child; CheckMark(TRUE);
**                   Child; CheckMark(FALSE);
**                   end;
**                end;
**             end;
**
**          SubWindow; WindowObject;
**             WindowContents; HGroup;
**                Child; ...;
**                Child; ...;
**                end;
**             end;
**
**          ...
**
** app := End();
**
***************************************************************************)

  PROCEDURE WindowObjectA*( tags{9} : Utility.TagListPtr );
  (* $SaveRegs+ *)
    BEGIN
      NewObjectA( SYSTEM.ADR( Mui.cWindow ), tags );
    END WindowObjectA;

  PROCEDURE WindowObject*{"MuiBasics.WindowObjectA"} ( tags{9}.. : Utility.Tag);

  PROCEDURE ImageObjectA*( tags{9} : Utility.TagListPtr );
  (* $SaveRegs+ *)
    BEGIN
      NewObjectA( SYSTEM.ADR( Mui.cImage ), tags );
    END ImageObjectA;

  PROCEDURE ImageObject*{"MuiBasics.ImageObjectA"} ( tags{9}.. : Utility.Tag);

  PROCEDURE NotifyObjectA*( tags{9} : Utility.TagListPtr );
  (* $SaveRegs+ *)
    BEGIN
      NewObjectA( SYSTEM.ADR( Mui.cNotify ), tags );
    END NotifyObjectA;

  PROCEDURE NotifyObject*{"MuiBasics.NotifyObjectA"} ( tags{9}.. : Utility.Tag);

  PROCEDURE ApplicationObjectA*( tags{9} : Utility.TagListPtr );
  (* $SaveRegs+ *)
    BEGIN
      NewObjectA( SYSTEM.ADR( Mui.cApplication ), tags );
    END ApplicationObjectA;

  PROCEDURE ApplicationObject*{"MuiBasics.ApplicationObjectA"} ( tags{9}.. : Utility.Tag);

  PROCEDURE TextObjectA*( tags{9} : Utility.TagListPtr );
  (* $SaveRegs+ *)
    BEGIN
      NewObjectA( SYSTEM.ADR( Mui.cText ), tags );
    END TextObjectA;

  PROCEDURE TextObject*{"MuiBasics.TextObjectA"} ( tags{9}.. : Utility.Tag);

  PROCEDURE RectangleObjectA*( tags{9} : Utility.TagListPtr );
  (* $SaveRegs+ *)
    BEGIN
      NewObjectA( SYSTEM.ADR( Mui.cRectangle ), tags );
    END RectangleObjectA;

  PROCEDURE RectangleObject*{"MuiBasics.RectangleObjectA"} ( tags{9}.. : Utility.Tag);

  PROCEDURE ListObjectA*( tags{9} : Utility.TagListPtr );
  (* $SaveRegs+ *)
    BEGIN
      NewObjectA( SYSTEM.ADR( Mui.cList ), tags );
    END ListObjectA;

  PROCEDURE ListObject*{"MuiBasics.ListObjectA"} ( tags{9}.. : Utility.Tag);

  PROCEDURE PropObjectA*( tags{9} : Utility.TagListPtr );
  (* $SaveRegs+ *)
    BEGIN
      NewObjectA( SYSTEM.ADR( Mui.cProp ), tags );
    END PropObjectA;

  PROCEDURE PropObject*{"MuiBasics.PropObjectA"} ( tags{9}.. : Utility.Tag);

  PROCEDURE StringObjectA*( tags{9} : Utility.TagListPtr );
  (* $SaveRegs+ *)
    BEGIN
      NewObjectA( SYSTEM.ADR( Mui.cString ), tags );
    END StringObjectA;

  PROCEDURE StringObject*{"MuiBasics.StringObjectA"} ( tags{9}.. : Utility.Tag);

  PROCEDURE ScrollbarObjectA*( tags{9} : Utility.TagListPtr );
  (* $SaveRegs+ *)
    BEGIN
      NewObjectA( SYSTEM.ADR( Mui.cScrollbar ), tags );
    END ScrollbarObjectA;

  PROCEDURE ScrollbarObject*{"MuiBasics.ScrollbarObjectA"} ( tags{9}.. : Utility.Tag);

  PROCEDURE ListviewObjectA*( tags{9} : Utility.TagListPtr );
  (* $SaveRegs+ *)
    BEGIN
      NewObjectA( SYSTEM.ADR( Mui.cListview), tags );
    END ListviewObjectA;

  PROCEDURE ListviewObject*{"MuiBasics.ListviewObjectA"} ( tags{9}.. : Utility.Tag);

  PROCEDURE RadioObjectA*( tags{9} : Utility.TagListPtr );
  (* $SaveRegs+ *)
    BEGIN
      NewObjectA( SYSTEM.ADR( Mui.cRadio ), tags );
    END RadioObjectA;

  PROCEDURE RadioObject*{"MuiBasics.RadioObjectA"} ( tags{9}.. : Utility.Tag);

  PROCEDURE VolumelistObjectA*( tags{9} : Utility.TagListPtr );
  (* $SaveRegs+ *)
    BEGIN
      NewObjectA( SYSTEM.ADR( Mui.cVolumelist), tags );
    END VolumelistObjectA;

  PROCEDURE VolumelistObject*{"MuiBasics.VolumelistObjectA"} ( tags{9}.. : Utility.Tag);

  PROCEDURE FloattextObjectA*( tags{9} : Utility.TagListPtr );
  (* $SaveRegs+ *)
    BEGIN
      NewObjectA( SYSTEM.ADR( Mui.cFloattext), tags );
    END FloattextObjectA;

  PROCEDURE FloattextObject*{"MuiBasics.FloattextObjectA"} ( tags{9}.. : Utility.Tag);

  PROCEDURE DirlistObjectA*( tags{9} : Utility.TagListPtr );
  (* $SaveRegs+ *)
    BEGIN
      NewObjectA( SYSTEM.ADR( Mui.cDirlist ), tags );
    END DirlistObjectA;

  PROCEDURE DirlistObject*{"MuiBasics.DirlistObjectA"} ( tags{9}.. : Utility.Tag);


  PROCEDURE SliderObjectA*( tags{9} : Utility.TagListPtr );
  (* $SaveRegs+ *)
    BEGIN
      NewObjectA( SYSTEM.ADR( Mui.cSlider ), tags );
    END SliderObjectA;

  PROCEDURE SliderObject*{"MuiBasics.SliderObjectA"} ( tags{9}.. : Utility.Tag);

  PROCEDURE CycleObjectA*( tags{9} : Utility.TagListPtr );
  (* $SaveRegs+ *)
    BEGIN
      NewObjectA( SYSTEM.ADR( Mui.cCycle ), tags );
    END CycleObjectA;

  PROCEDURE CycleObject*{"MuiBasics.CycleObjectA"} ( tags{9}.. : Utility.Tag);

  PROCEDURE GaugeObjectA*( tags{9} : Utility.TagListPtr );
  (* $SaveRegs+ *)
    BEGIN
      NewObjectA( SYSTEM.ADR( Mui.cGauge ), tags );
    END GaugeObjectA;

  PROCEDURE GaugeObject*{"MuiBasics.GaugeObjectA"} ( tags{9}.. : Utility.Tag);

  PROCEDURE ScaleObjectA*( tags{9} : Utility.TagListPtr );
  (* $SaveRegs+ *)
    BEGIN
      NewObjectA( SYSTEM.ADR( Mui.cScale ), tags );
    END ScaleObjectA;

  PROCEDURE ScaleObject*{"MuiBasics.ScaleObjectA"} ( tags{9}.. : Utility.Tag);

  PROCEDURE BoopsiObjectA*( tags{9} : Utility.TagListPtr );
  (* $SaveRegs+ *)
    BEGIN
      NewObjectA( SYSTEM.ADR( Mui.cBoopsi ), tags );
    END BoopsiObjectA;

  PROCEDURE BoopsiObject*{"MuiBasics.BoopsiObjectA"} ( tags{9}.. : Utility.Tag);

  PROCEDURE ColorfieldObjectA*( tags{9} : Utility.TagListPtr );
  (* $SaveRegs+ *)
    BEGIN
      NewObjectA( SYSTEM.ADR( Mui.cColorfield ), tags );
    END ColorfieldObjectA;

  PROCEDURE ColorfieldObject*{"MuiBasics.ColorfieldObjectA"} ( tags{9}.. : Utility.Tag);

  PROCEDURE ColoradjustObjectA*( tags{9} : Utility.TagListPtr );
  (* $SaveRegs+ *)
    BEGIN
      NewObjectA( SYSTEM.ADR( Mui.cColoradjust ), tags );
    END ColoradjustObjectA;

  PROCEDURE ColoradjustObject*{"MuiBasics.ColoradjustObjectA"} ( tags{9}.. : Utility.Tag);

  PROCEDURE PaletteObjectA*( tags{9} : Utility.TagListPtr );
  (* $SaveRegs+ *)
    BEGIN
      NewObjectA( SYSTEM.ADR( Mui.cPalette ), tags );
    END PaletteObjectA;

  PROCEDURE PaletteObject*{"MuiBasics.PaletteObjectA"} ( tags{9}.. : Utility.Tag);

  PROCEDURE GroupObjectA*( tags{9} : Utility.TagListPtr );
  (* $SaveRegs+ *)
    BEGIN
      NewObjectA( SYSTEM.ADR( Mui.cGroup), tags );
    END GroupObjectA;

  PROCEDURE GroupObject*{"MuiBasics.GroupObjectA"} ( tags{9}.. : Utility.Tag);

  PROCEDURE VirtgroupObjectA*( tags{9} : Utility.TagListPtr );
  (* $SaveRegs+ *)
    BEGIN
      NewObjectA( SYSTEM.ADR( Mui.cVirtgroup ), tags );
    END VirtgroupObjectA;

  PROCEDURE VirtgroupObject*{"MuiBasics.VirtgroupObjectA"} ( tags{9}.. : Utility.Tag);

  PROCEDURE ScrollgroupObjectA*( tags{9} : Utility.TagListPtr );
  (* $SaveRegs+ *)
    BEGIN
      NewObjectA( SYSTEM.ADR( Mui.cScrollgroup ), tags );
    END ScrollgroupObjectA;

  PROCEDURE ScrollgroupObject*{"MuiBasics.ScrollgroupObjectA"} ( tags{9}.. : Utility.Tag);

  PROCEDURE PopstringObjectA*( tags{9} : Utility.TagListPtr );
  (* $SaveRegs+ *)
    BEGIN
      NewObjectA( SYSTEM.ADR( Mui.cPopstring ), tags );
    END PopstringObjectA;

  PROCEDURE PopstringObject*{"MuiBasics.PopstringObjectA"} ( tags{9}.. : Utility.Tag);

  PROCEDURE PopobjectObjectA*( tags{9} : Utility.TagListPtr );
  (* $SaveRegs+ *)
    BEGIN
      NewObjectA( SYSTEM.ADR( Mui.cPopobject ), tags );
    END PopobjectObjectA;

  PROCEDURE PopobjectObject*{"MuiBasics.PopobjectObjectA"} ( tags{9}.. : Utility.Tag);

  PROCEDURE PopaslObjectA*( tags{9} : Utility.TagListPtr );
  (* $SaveRegs+ *)
    BEGIN
      NewObjectA( SYSTEM.ADR( Mui.cPopasl ), tags );
    END PopaslObjectA;

  PROCEDURE PopaslObject*{"MuiBasics.PopaslObjectA"} ( tags{9}.. : Utility.Tag);

  PROCEDURE ScrmodelistObjectA*( tags{9} : Utility.TagListPtr );
  (* $SaveRegs+ *)
    BEGIN
      NewObjectA( SYSTEM.ADR( Mui.cScrmodelist ), tags );
    END ScrmodelistObjectA;

  PROCEDURE ScrmodelistObject*{"MuiBasics.ScrmodelistObjectA"} ( tags{9}.. : Utility.Tag);

  PROCEDURE VGroupA*( tags{9} : Utility.TagListPtr );
  (* $SaveRegs+ *)
    BEGIN
      NewObjectA( SYSTEM.ADR( Mui.cGroup ), tags );
      TagsA( tags );
    END VGroupA;

  PROCEDURE VGroup*{"MuiBasics.VGroupA"}( tags{9}.. : Utility.Tag );

  PROCEDURE HGroupA*( tags{9} : Utility.TagListPtr );
  (* $SaveRegs+ *)
    BEGIN
      NewObject( Mui.cGroup, Mui.aGroupHoriz, Exec.true, Utility.end );
      TagsA( tags );
    END HGroupA;

  PROCEDURE HGroup*{"MuiBasics.HGroupA"}( tags{9}.. : Utility.Tag );

  PROCEDURE ColGroupA*( cols{3} : LONGINT; tags{9} : Utility.TagListPtr  );
  (* $SaveRegs+ *)
    BEGIN
      NewObject( Mui.cGroup, Mui.aGroupColumns, cols, Utility.end );
      TagsA( tags );
    END ColGroupA;

  PROCEDURE ColGroup*{"MuiBasics.ColGroupA"} ( cols{3} : LONGINT; tags{9}.. : Utility.Tag );

  PROCEDURE RowGroupA*( rows{3} : LONGINT; tags{9} : Utility.TagListPtr  );
  (* $SaveRegs+ *)
    BEGIN
      NewObject( Mui.cGroup, Mui.aGroupRows, rows, Utility.end );
      TagsA( tags );
    END RowGroupA;

  PROCEDURE RowGroup*{"MuiBasics.RowGroupA"}( rows{3} : LONGINT; tags{9}.. : Utility.Tag  );

  PROCEDURE PageGroupA*( tags{9} : Utility.TagListPtr );
  (* $SaveRegs+ *)
    BEGIN
      NewObject( Mui.cGroup, Mui.aGroupPageMode, Exec.true, Utility.end );
      TagsA( tags );
    END PageGroupA;

  PROCEDURE PageGroup*{"MuiBasics.PageGroupA"}( tags{9}.. : Utility.Tag );

  PROCEDURE VGroupAV*( tags{9} : Utility.TagListPtr );
  (* $SaveRegs+ *)
    BEGIN
      NewObjectA( SYSTEM.ADR( Mui.cVirtgroup ), tags );
      TagsA( tags );
    END VGroupAV;

  PROCEDURE VGroupV*{"MuiBasics.VGroupAV"}( tags{9}.. : Utility.Tag );

  PROCEDURE HGroupAV*( tags{9} : Utility.TagListPtr );
  (* $SaveRegs+ *)
    BEGIN
      NewObject( Mui.cVirtgroup, Mui.aGroupHoriz, Exec.true, Utility.end );
      TagsA( tags );
    END HGroupAV;

  PROCEDURE HGroupV*{"MuiBasics.HGroupAV"}( tags{9}.. : Utility.Tag );

  PROCEDURE ColGroupAV*( cols{3} : LONGINT; tags{9} : Utility.TagListPtr  );
  (* $SaveRegs+ *)
    BEGIN
      NewObject( Mui.cVirtgroup, Mui.aGroupColumns, cols, Utility.end );
      TagsA( tags );
    END ColGroupAV;

  PROCEDURE ColGroupV*{"MuiBasics.ColGroupAV"} ( cols{3} : LONGINT; tags{9}.. : Utility.Tag );

  PROCEDURE RowGroupAV*( rows{3} : LONGINT; tags{9} : Utility.TagListPtr  );
  (* $SaveRegs+ *)
    BEGIN
      NewObject( Mui.cVirtgroup, Mui.aGroupRows, rows, Utility.end );
      TagsA( tags );
    END RowGroupAV;

  PROCEDURE RowGroupV*{"MuiBasics.RowGroupAV"}( rows{3} : LONGINT; tags{9}.. : Utility.Tag  );

  PROCEDURE PageGroupAV*( tags{9} : Utility.TagListPtr );
  (* $SaveRegs+ *)
    BEGIN
      NewObject( Mui.cVirtgroup, Mui.aGroupPageMode, Exec.true, Utility.end );
      TagsA( tags );
    END PageGroupAV;

  PROCEDURE PageGroupV*{"MuiBasics.PageGroupAV"}( tags{9}.. : Utility.Tag );

  PROCEDURE Child*();
  (* $SaveRegs+ *)
    BEGIN
      Tag( Mui.aGroupChild );
    END Child;

  PROCEDURE SubWindow*();
  (* $SaveRegs+ *)
    BEGIN
      Tag( Mui.aApplicationWindow );
    END SubWindow;

  PROCEDURE WindowContents*();
  (* $SaveRegs+ *)
    BEGIN
      Tag( Mui.aWindowRootObject );
    END WindowContents;

(***************************************************************************
**
** Frame Types
** -----------
**
** These procedures may be used to specify one of MUI's different frame types.
** Note that every procedure consists of one or more { ti_Tag, ti_Data }
** pairs.
**
** GroupFrameT() is a special kind of frame that contains a centered
** title text.
**
** HGroup; GroupFrameT("Horiz Groups");
**    Child; RectangleObject; TextFrame  ; end;
**    Child; RectangleObject; StringFrame; end;
**    Child; RectangleObject; ButtonFrame; end;
**    Child; RectangleObject; ListFrame  ; end;
**    end;
**
***************************************************************************)

  PROCEDURE NoFrameA*( tags{9} : Utility.TagListPtr );
    BEGIN
      TagItem( Mui.aFrame , Mui.vFrameNone );
      TagsA( tags );
    END NoFrameA;

  PROCEDURE NoFrame*{"MuiBasics.NoFrameA"} ( tags{9}.. : Utility.Tag );

  PROCEDURE ButtonFrameA*( tags{9} : Utility.TagListPtr  );
    BEGIN
      TagItem( Mui.aFrame , Mui.vFrameButton );
      TagsA( tags );
    END ButtonFrameA;

  PROCEDURE ButtonFrame*{"MuiBasics.ButtonFrameA"} ( tags{9}.. : Utility.Tag  );

  PROCEDURE ImageButtonFrameA*( tags{9} : Utility.TagListPtr );
    BEGIN
      TagItem( Mui.aFrame , Mui.vFrameImageButton );
      TagsA( tags );
    END ImageButtonFrameA;

  PROCEDURE ImageButtonFrame*{"MuiBasics.ImageButtonFrameA"} ( tags{9}.. : Utility.Tag );

  PROCEDURE TextFrameA*( tags{9} : Utility.TagListPtr );
    BEGIN
      TagItem( Mui.aFrame , Mui.vFrameText );
      TagsA( tags );
    END TextFrameA;

  PROCEDURE TextFrame*{"MuiBasics.TextFrameA"} ( tags{9}.. : Utility.Tag );

  PROCEDURE StringFrameA*( tags{9} : Utility.TagListPtr );
    BEGIN
      TagItem( Mui.aFrame , Mui.vFrameString );
      TagsA( tags );
    END StringFrameA;

  PROCEDURE StringFrame*{"MuiBasics.StringFrameA"} ( tags{9}.. : Utility.Tag );

  PROCEDURE ReadListFrameA*( tags{9} : Utility.TagListPtr );
    BEGIN
      TagItem(  Mui.aFrame , Mui.vFrameReadList );
      TagsA( tags );
    END ReadListFrameA;

  PROCEDURE ReadListFrame*{"MuiBasics.ReadListFrameA"} ( tags{9}.. : Utility.Tag );

  PROCEDURE InputListFrameA*( tags{9} : Utility.TagListPtr );
    BEGIN
      TagItem( Mui.aFrame , Mui.vFrameInputList );
      TagsA( tags );
    END InputListFrameA;

  PROCEDURE InputListFrame*{"MuiBasics.InputListFrameA"} ( tags{9}.. : Utility.Tag );

  PROCEDURE PropFrameA*( tags{9} : Utility.TagListPtr );
    BEGIN
      TagItem( Mui.aFrame , Mui.vFrameProp );
      TagsA( tags );
    END PropFrameA;

  PROCEDURE PropFrame*{"MuiBasics.PropFrameA"} ( tags{9}.. : Utility.Tag );

  PROCEDURE SliderFrameA*( tags{9} : Utility.TagListPtr );
    BEGIN
      TagItem( Mui.aFrame , Mui.vFrameSlider );
      TagsA( tags );
    END SliderFrameA;

  PROCEDURE SliderFrame*{"MuiBasics.SliderFrameA"} ( tags{9}.. : Utility.Tag );

  PROCEDURE GaugeFrameA*( tags{9} : Utility.TagListPtr );
    BEGIN
      TagItem( Mui.aFrame , Mui.vFrameGauge );
      TagsA( tags );
    END GaugeFrameA;

  PROCEDURE GaugeFrame*{"MuiBasics.GaugeFrameA"} ( tags{9}.. : Utility.Tag );

  PROCEDURE VirtualFrameA*( tags{9} : Utility.TagListPtr );
    BEGIN
      TagItem( Mui.aFrame , Mui.vFrameVirtual );
      TagsA( tags );
    END VirtualFrameA;

  PROCEDURE VirtualFrame*{"MuiBasics.VirtualFrameA"} ( tags{9}.. : Utility.Tag );

  PROCEDURE GroupFrameA*( tags{9} : Utility.TagListPtr );
    BEGIN
      TagItem( Mui.aFrame , Mui.vFrameGroup );
      TagsA( tags );
    END GroupFrameA;

  PROCEDURE GroupFrame*{"MuiBasics.GroupFrameA"} ( tags{9}.. : Utility.Tag );

  PROCEDURE GroupFrameTA*( s{8} : Exec.STRPTR; tags{9} : Utility.TagListPtr );
    BEGIN
      TagItem2( Mui.aFrame, Mui.vFrameGroup, Mui.aFrameTitle, s );
      TagsA( tags );
    END GroupFrameTA;

  PROCEDURE GroupFrameT*{"MuiBasics.GroupFrameTA"}( s{8} : ARRAY OF CHAR; tags{9}.. : Utility.Tag );

(***************************************************************************
**
** Spacing Procedures
** ------------------
**
***************************************************************************)

  PROCEDURE GroupSpacing*( x: LONGINT );
    BEGIN
      TagItem( Mui.aGroupSpacing, x );
    END GroupSpacing;

  PROCEDURE HVSpace*();
    BEGIN
      Tag( Mui.NewObject( Mui.cRectangle, Utility.done ) );
    END HVSpace;


  PROCEDURE HSpace*( x : LONGINT );
    VAR t : Utility.Tags3;
    BEGIN
      IF x # 0 THEN
        t[0].tag := Mui.aFixWidth;
        t[0].data := x;
      ELSE
        t[0].tag := Utility.ignore;
      END;
      t[1] := Utility.TagItem( Mui.aVertWeight, 0 );
      t[2] := Utility.TagItem( Utility.done, 0 );
      Tag( Mui.NewObjectA( Mui.cRectangle, t ) );
    END HSpace;

  PROCEDURE VSpace*( x : LONGINT );
    VAR t : Utility.Tags3;
    BEGIN
      IF x # 0 THEN
        t[0].tag := Mui.aFixHeight;
        t[0].data := x;
      ELSE
        t[0].tag := Utility.ignore;
      END;
      t[1] := Utility.TagItem( Mui.aHorizWeight, 0 );
      t[2] := Utility.TagItem( Utility.done, 0 );
      Tag( Mui.NewObjectA( Mui.cRectangle, t ) );
    END VSpace;


  PROCEDURE HCenterBegin*();
    BEGIN
      HGroup; GroupSpacing( 0 );
        Child; HSpace( 0 );
    END HCenterBegin;

  PROCEDURE HCenterEnd*();
    BEGIN
        Child; HSpace( 0 );
      end;
    END HCenterEnd;

  PROCEDURE VCenterBegin*();
    BEGIN
      VGroup; GroupSpacing( 0 );
        Child ; VSpace( 0 );
    END VCenterBegin;

  PROCEDURE VCenterEnd*();
    BEGIN
        Child ; VSpace( 0 );
      end;
    END VCenterEnd;

  PROCEDURE InnerSpacing*( h, v : LONGINT );
    BEGIN
      Tags( Mui.aInnerLeft   , h,
            Mui.aInnerRight  , h,
            Mui.aInnerTop    , v,
            Mui.aInnerBottom , v,
            Utility.end );
    END InnerSpacing;


(***************************************************************************
**
** String-Object
** -------------
**
** The following procedure creates a simple string gadget.
**
***************************************************************************)

  PROCEDURE StringA*( contents{8} : Exec.STRPTR; maxlen{3} : LONGINT ):Mui.Object;
    BEGIN
      StringObject;
        StringFrame;
        TagItem2( Mui.aStringMaxLen, maxlen,
                  Mui.aStringContents, contents );
      RETURN End();
    END StringA;

  PROCEDURE String * {"MuiBasics.StringA"} ( contents{8} : Exec.STRPTR; maxlen{3} : LONGINT ):Mui.Object;
  PROCEDURE string * {"MuiBasics.StringA"} ( contents{8} : Exec.STRPTR; maxlen{3} : LONGINT );

  PROCEDURE KeyStringA*( contents{8} : Exec.STRPTR; maxlen{3} : LONGINT; controlchar{4} : LONGINT ):Mui.Object;
    BEGIN
      StringObject;
        StringFrame;
        TagItem3( Mui.aStringMaxLen, maxlen,
                  Mui.aStringContents, contents,
                  Mui.aControlChar, controlchar );
      RETURN End();
    END KeyStringA;

  PROCEDURE KeyString * {"MuiBasics.KeyStringA"} ( contents{8} : Exec.STRPTR; maxlen{3} : LONGINT; controlchar{4}: CHAR ):Mui.Object;
  PROCEDURE keyString * {"MuiBasics.KeyStringA"} ( contents{8} : Exec.STRPTR; maxlen{3} : LONGINT; controlchar{4}: CHAR );

(***************************************************************************
**
** CheckMark-Object
** ----------------
**
** The following procedure creates a checkmark gadget.
**
***************************************************************************)

  PROCEDURE CheckMarkA*( checked{4} : BOOLEAN ):Mui.Object;
   BEGIN
      ImageObject;
        ImageButtonFrame;
          Tags( Mui.aInputMode , Mui.vInputModeToggle,
                Mui.aImageSpec    , Mui.iCheckMark,
                Mui.aImageFreeVert, Exec.true,
                Mui.aSelected     , SYSTEM.VAL( SHORTINT, checked ),
                Mui.aBackground   , Mui.iButtonBack,
                Mui.aShowSelState , Exec.false,
                Utility.end );
      RETURN End();
    END CheckMarkA;

  PROCEDURE CheckMark * {"MuiBasics.CheckMarkA"}( checked{4} : BOOLEAN ):Mui.Object;
  PROCEDURE checkMark * {"MuiBasics.CheckMarkA"}( checked{4} : BOOLEAN );

  PROCEDURE KeyCheckMarkA*( checked{4} : Exec.LONGBOOL; key{3} : LONGINT ):Mui.Object;
   BEGIN
      ImageObject;
        ImageButtonFrame;
          Tags( Mui.aInputMode    , Mui.vInputModeToggle,
                Mui.aImageSpec    , Mui.iCheckMark,
                Mui.aImageFreeVert, Exec.true,
                Mui.aSelected     , checked,
                Mui.aBackground   , Mui.iButtonBack,
                Mui.aShowSelState , Exec.false,
                Mui.aControlChar  , key,
                Utility.end );
      RETURN End();
    END KeyCheckMarkA;

  PROCEDURE KeyCheckMark *{"MuiBasics.KeyCheckMarkA"}( checked{4} : Exec.LONGBOOL; key{3} : CHAR ):Mui.Object;
  PROCEDURE keyCheckMark *{"MuiBasics.KeyCheckMarkA"}( checked{4} : Exec.LONGBOOL; key{3} : CHAR );

(***************************************************************************
**
** Button-Objects
** --------------
**
** Note: Use small letters for KeyButtons, e.g.
**       KeyButton("Cancel",'c')  and not  KeyButton("Cancel",'C') !!
**
***************************************************************************)

  PROCEDURE SimpleButtonA * ( name{8} : Exec.STRPTR; tags{9} : Utility.TagListPtr ):Mui.Object;
  (* $SaveRegs+ *)
    BEGIN
      TextObject;
        ButtonFrame;
          Tags( Mui.aTextContents, name,
                Mui.aTextPreParse, SYSTEM.ADR("\033c"),
                Mui.aTextSetMax  , Exec.false,
                Mui.aInputMode   , Mui.vInputModeRelVerify,
                Mui.aBackground  , Mui.iButtonBack,
                Utility.end );
        TagsA( tags );
      RETURN End();
    END SimpleButtonA;

  PROCEDURE SimpleButton * {"MuiBasics.SimpleButtonA"} ( name{8} : ARRAY OF CHAR; tags{9}.. : Utility.Tag ):Mui.Object;
  PROCEDURE simpleButton * {"MuiBasics.SimpleButtonA"} ( name{8} : ARRAY OF CHAR; tags{9}.. : Utility.Tag );

  PROCEDURE KeyButtonA * ( name{8} : Exec.STRPTR; key{4} : LONGINT; tags{9} : Utility.TagListPtr ):Mui.Object;
  (* $SaveRegs+ *)
    BEGIN
      TextObject;
        ButtonFrame;
         Tags( Mui.aTextContents, name,
               Mui.aTextPreParse, SYSTEM.ADR("\033c"),
               Mui.aTextSetMax  , Exec.false,
               Mui.aTextHiChar  , key,
               Mui.aControlChar , key,
               Mui.aInputMode   , Mui.vInputModeRelVerify,
               Mui.aBackground  , Mui.iButtonBack,
               Utility.end );
        TagsA( tags );
      RETURN End();
    END KeyButtonA;

  PROCEDURE KeyButton * {"MuiBasics.KeyButtonA"} ( name{8} : ARRAY OF CHAR; key{4} : CHAR; tags{9}.. : Utility.TagListPtr ):Mui.Object;
  PROCEDURE keyButton * {"MuiBasics.KeyButtonA"} ( name{8} : ARRAY OF CHAR; key{4} : CHAR; tags{9}.. : Utility.TagListPtr );

(***************************************************************************
**
** Cycle-Object
** ------------
**
***************************************************************************)

  PROCEDURE CycleA * ( entries{10} : Exec.APTR; tags{9} : Utility.TagListPtr ):Mui.Object;
  (* $SaveRegs+ *)
    BEGIN
      CycleObject( Mui.aCycleEntries, entries, Utility.end );
        TagsA( tags );
      RETURN End();
    END CycleA;

  PROCEDURE Cycle * {"MuiBasics.CycleA"} ( entries{10} : Exec.APTR; tags{9}.. : Utility.Tag ):Mui.Object;
  PROCEDURE cycle * {"MuiBasics.CycleA"} ( entries{10} : Exec.APTR; tags{9}.. : Utility.Tag );

  PROCEDURE KeyCycleA * ( entries{10} : Exec.APTR; key{4} : LONGINT; tags{9} : Utility.TagListPtr ):Mui.Object;
  (* $SaveRegs+ *)
    BEGIN
      CycleObject( Mui.aCycleEntries, entries,
                   Mui.aControlChar, key,
                   Utility.end );
        TagsA( tags );
      RETURN End();
    END KeyCycleA;

  PROCEDURE KeyCycle * {"MuiBasics.KeyCycleA"} ( entries{10} : Exec.APTR; key{4} : CHAR; tags{9}.. : Utility.Tag ):Mui.Object;
  PROCEDURE keyCycle * {"MuiBasics.KeyCycleA"} ( entries{10} : Exec.APTR; key{4} : CHAR; tags{9}.. : Utility.Tag );

(***************************************************************************
**
** Radio-Object
** ------------
**
***************************************************************************)

  PROCEDURE RadioA * ( name{8}: Exec.STRPTR; entries{10} : Exec.APTR; tags{9} : Utility.TagListPtr ):Mui.Object;
  (* $SaveRegs+ *)
    BEGIN
      RadioObject;
        GroupFrameT( name^ );
          TagItem( Mui.aRadioEntries, entries );
        TagsA( tags );
      RETURN End();
    END RadioA;

  PROCEDURE Radio * {"MuiBasics.RadioA"} ( name{8} : ARRAY OF CHAR; entries{10} : Exec.APTR; tags{9}.. : Utility.Tag ):Mui.Object;
  PROCEDURE radio * {"MuiBasics.RadioA"} ( name{8} : ARRAY OF CHAR; entries{10} : Exec.APTR; tags{9}.. : Utility.Tag );

  PROCEDURE KeyRadioA * ( name{8}: Exec.STRPTR; entries{10} : Exec.APTR; key{4} : LONGINT; tags{9} : Utility.TagListPtr ):Mui.Object;
  (* $SaveRegs+ *)
    BEGIN
      RadioObject;
        GroupFrameT( name^ );
          TagItem2( Mui.aRadioEntries, entries,
                    Mui.aControlChar, key );
        TagsA( tags );
      RETURN End();
    END KeyRadioA;

  PROCEDURE KeyRadio * {"MuiBasics.KeyRadioA"} ( name{8} : ARRAY OF CHAR; entries{10} : Exec.APTR; key{4} : CHAR; tags{9}.. : Utility.Tag ):Mui.Object;
  PROCEDURE keyRadio * {"MuiBasics.KeyRadioA"} ( name{8} : ARRAY OF CHAR; entries{10} : Exec.APTR; key{4} : CHAR; tags{9}.. : Utility.Tag );

(***************************************************************************
**
** Slider-Object
** -------------
**
***************************************************************************)

  PROCEDURE SliderA * ( min{2}, max{3}, level{4} : LONGINT; tags{9} : Utility.TagListPtr ):Mui.Object;
  (* $SaveRegs+ *)
    BEGIN
      SliderObject( Mui.aSliderMin, min,
                    Mui.aSliderMax, max,
                    Mui.aSliderLevel, level,
                    Utility.end );
        TagsA( tags );
      RETURN End();
    END SliderA;

  PROCEDURE Slider * {"MuiBasics.SliderA"} ( min{2}, max{3}, level{4} : LONGINT; tags{9}.. : Utility.Tag ):Mui.Object;
  PROCEDURE slider * {"MuiBasics.SliderA"} ( min{2}, max{3}, level{4} : LONGINT; tags{9}.. : Utility.Tag );

  PROCEDURE KeySliderA * ( min{2}, max{3}, level{4}, key{5} : LONGINT; tags{9} : Utility.TagListPtr ):Mui.Object;
  (* $SaveRegs+ *)
    BEGIN
      SliderObject( Mui.aSliderMin, min,
                    Mui.aSliderMax, max,
                    Mui.aSliderLevel, level,
                    Mui.aControlChar, key,
                    Utility.end );
        TagsA( tags );
      RETURN End();
    END KeySliderA;

  PROCEDURE KeySlider * {"MuiBasics.KeySliderA"} ( min{2}, max{3}, level{4} : LONGINT; key{5} : CHAR; tags{9}.. : Utility.Tag ):Mui.Object;
  PROCEDURE keySlider * {"MuiBasics.KeySliderA"} ( min{2}, max{3}, level{4} : LONGINT; key{5} : CHAR; tags{9}.. : Utility.Tag );

  PROCEDURE VSliderA * ( min{2}, max{3}, level{4} : LONGINT; tags{9} : Utility.TagListPtr ):Mui.Object;
  (* $SaveRegs+ *)
    BEGIN
      SliderObject( Mui.aSliderMin, min,
                    Mui.aSliderMax, max,
                    Mui.aSliderLevel, level,
                    Mui.aGroupHoriz, Exec.false,
                    Utility.end );
        TagsA( tags );
      RETURN End();
    END VSliderA;

  PROCEDURE VSlider * {"MuiBasics.VSliderA"} ( min{2}, max{3}, level{4} : LONGINT; tags{9}.. : Utility.Tag ):Mui.Object;
  PROCEDURE vSlider * {"MuiBasics.VSliderA"} ( min{2}, max{3}, level{4} : LONGINT; tags{9}.. : Utility.Tag );

  PROCEDURE KeyVSliderA * ( min{2}, max{3}, level{4}, key{5} : LONGINT; tags{9} : Utility.TagListPtr ):Mui.Object;
  (* $SaveRegs+ *)
    BEGIN
      SliderObject( Mui.aSliderMin, min,
                    Mui.aSliderMax, max,
                    Mui.aSliderLevel, level,
                    Mui.aGroupHoriz, Exec.false,
                    Mui.aControlChar, key,
                    Utility.end );
        TagsA( tags );
      RETURN End();
    END KeyVSliderA;

  PROCEDURE KeyVSlider * {"MuiBasics.KeySliderA"} ( min{2}, max{3}, level{4} : LONGINT; key{5} : CHAR; tags{9}.. : Utility.Tag ):Mui.Object;
  PROCEDURE keyVSlider * {"MuiBasics.KeySliderA"} ( min{2}, max{3}, level{4} : LONGINT; key{5} : CHAR; tags{9}.. : Utility.Tag );

(***************************************************************************
**
** Popup-Object
** ------------
**
** An often needed GUI element is a string gadget with a little button
** that opens up a (small) window with a list containing possible entries
** for this gadget. Together with the Popup and the String macro,
** such a thing would look like
**
** VGroup;
**    Child; PopupBegin;
**             Child; STFont := String( "helvetica/13", 32 );
**           PopupEnd( hook, Mui.iPopUp, STFont );
**    ...;
**
** STFont will hold a pointer to the embedded string gadget and can
** be used to set and get its contents as with every other string object.
**
** For Hook description see below.
** The hook will be called with the string gadget as object whenever
** the user releases the popup button and could look like this:
**
** PROCEDURE FontReq( hook : Hook; obj : Mui.Object : args : Args) : LONGINT;
**   VAR window : Intuition.WindowPtr;
**       l, t, w, h : LONGINT;
**       req : ASL.AslRequesterPtr;
** BEGIN
**    ...
**
**    (* put our application to sleep while displaying the requester *)
**      Set( Application, Mui.aApplicationSleep, Exec.true );
**
**    (* get the calling objects window and position *)
**      Get( obj, Mui.aWindow  , window );
**      Get( obj, Mui.aLeftEdge, l );
**      Get( obj, Mui.aTopEdge , t );
**      Get( obj, Mui.aWidth   , w );
**      Get( obj, Mui.aHeight  , h );
**
**    req := Mui.AllocAslRequestTags( ASL.fontRequest, Utility.done )
**    IF req # NIL THEN
**
**       IF (Mui.AslRequestTags(req,
**               ASL.foWindow         ,window,
**               ASL.foPrivateIDCMP   ,TRUE,
**               ASL.foTitleText      ,"Select Font",
**               ASL.foInitialLeftEdge,window->LeftEdge + l,
**               ASL.foInitialTopEdge ,window->TopEdge  + t+h,
**               ASL.foInitialWidth   ,w,
**               ASL.foInitialHeight  ,250,
**               Utility.done ) ) THEN
**
**          (* set the new contents for our string gadget *)
**                              Set( args(PopupArgs).linkedObj, Mui.aStringContents, req(ASL.FontRequester).attr.name);
**       END;
**       Mui.FreeAslRequest( req );
**   END;
**
**    (* wake up our application again *)
**      Set(Application, Mui.aApplicationSleep, Exec.false );
**
**      RETURN( 0);
** END FontReq:
**
** Note: This Procedure is translated to Oberon on the fly, no warranty is given
**       that this piece of code works.
**
***************************************************************************)

  PROCEDURE PopupBegin * ();
    VAR dummy : Mui.Object;
    BEGIN
      HGroup; GroupSpacing( 1 );
    END PopupBegin;

  PROCEDURE PopupEnd * ( hook : Hook; img : LONGINT; obj : Mui.Object ):Mui.Object;
    VAR dummy : Mui.Object;
    BEGIN
        Child; ImageObject;
                 ImageButtonFrame;
                 Tags( Mui.aImageSpec, img,
                       Mui.aImageFontMatchWidth, Exec.true,
                       Mui.aImageFreeVert, Exec.true,
                       Mui.aInputMode, Mui.vInputModeRelVerify,
                       Mui.aBackground, Mui.iButtonBack,
                       Utility.end );
               dummy := End();
               IF (obj # NIL) & (dummy # NIL) & (hook # NIL) THEN
                 SetHookObject( hook, dummy );
                 Mui.DoMethod( dummy, Mui.mNotify, Mui.aPressed, Exec.false,
                               dummy, 3, Mui.mCallHook, hook, obj );
               END;
      end;
      RETURN dummy;
    END PopupEnd;

  PROCEDURE popupEnd * {"MuiBasics.PopupEnd"} ( hook : Hook; img : LONGINT; obj : Mui.Object );

(***************************************************************************
**
** Labeling Objects
** ----------------
**
** Labeling objects, e.g. a group of string gadgets,
**
**   Small: |foo   |
**  Normal: |bar   |
**     Big: |foobar|
**    Huge: |barfoo|
**
** is done using a 2 column group:
**
** ColGroup(2);
**      Child; Label2( "Small:"  );
**    Child; StringObject; end;
**      Child; Label2( "Normal:" );
**    Child; StringObject; end;
**      Child; Label2( "Big:"    );
**    Child; StringObject; end;
**      Child; Label2( "Huge:"   );
**    Child; StringObject; end;
**    end;
**
** Note that we have three versions of the label procedure, depending on
** the frame type of the right hand object:
**
** Label1(): For use with standard frames (e.g. checkmarks).
** Label2(): For use with double high frames (e.g. string gadgets).
** Label() : For use with objects without a frame.
**
** These procedures ensure that your label will look fine even if the
** user of your application configured some strange spacing values.
** If you want to use your own labeling, you'll have to pay attention
** on this topic yourself.
**
***************************************************************************)

  PROCEDURE Label * ( label : ARRAY OF CHAR ):Mui.Object;
  (* $CopyArrays- *)
    BEGIN
      TextObject( Mui.aTextPreParse, SYSTEM.ADR( "\033r" ),
                  Mui.aTextContents, SYSTEM.ADR( label ),
                  Mui.aWeight      , 0,
                  Mui.aInnerLeft   , 0,
                  Mui.aInnerRight  , 0,
                  Utility.end );
      RETURN End();
    END Label;

  PROCEDURE Label1 * ( label : ARRAY OF CHAR ):Mui.Object;
  (* $CopyArrays- *)
    BEGIN
      TextObject( Mui.aTextPreParse, SYSTEM.ADR( "\033r" ),
                  Mui.aTextContents, SYSTEM.ADR( label ),
                  Mui.aWeight      , 0,
                  Mui.aInnerLeft   , 0,
                  Mui.aInnerRight  , 0,
                  Utility.end );
        ButtonFrame;
          TagItem( Mui.aFramePhantomHoriz, Exec.true );
      RETURN End();
    END Label1;

  PROCEDURE Label2 * ( label : ARRAY OF CHAR ):Mui.Object;
  (* $CopyArrays- *)
    BEGIN
      TextObject( Mui.aTextPreParse, SYSTEM.ADR( "\033r" ),
                  Mui.aTextContents, SYSTEM.ADR( label ),
                  Mui.aWeight      , 0,
                  Mui.aInnerLeft   , 0,
                  Mui.aInnerRight  , 0,
                  Utility.end );
        StringFrame;
         TagItem( Mui.aFramePhantomHoriz, Exec.true );
      RETURN End();
    END Label2;

  PROCEDURE LLabel * ( label : ARRAY OF CHAR ):Mui.Object;
  (* $CopyArrays- *)
    BEGIN
      TextObject( Mui.aTextContents, SYSTEM.ADR( label ),
                  Mui.aWeight      , 0,
                  Mui.aInnerLeft   , 0,
                  Mui.aInnerRight  , 0,
                  Utility.end );
      RETURN End();
    END LLabel;

  PROCEDURE LLabel1 * ( label : ARRAY OF CHAR ):Mui.Object;
  (* $CopyArrays- *)
    BEGIN
      TextObject( Mui.aTextContents, SYSTEM.ADR( label ),
                  Mui.aWeight      , 0,
                  Mui.aInnerLeft   , 0,
                  Mui.aInnerRight  , 0,
                  Utility.end );
        ButtonFrame;
          TagItem( Mui.aFramePhantomHoriz, Exec.true );
      RETURN End();
    END LLabel1;

  PROCEDURE LLabel2 * ( label : ARRAY OF CHAR ):Mui.Object;
  (* $CopyArrays- *)
    BEGIN
      TextObject( Mui.aTextContents, SYSTEM.ADR( label ),
                  Mui.aWeight      , 0,
                  Mui.aInnerLeft   , 0,
                  Mui.aInnerRight  , 0,
                  Utility.end );
        StringFrame;
         TagItem( Mui.aFramePhantomHoriz, Exec.true );
      RETURN End();
    END LLabel2;

  PROCEDURE KeyLabel * ( label : ARRAY OF CHAR; hichar : CHAR ):Mui.Object;
  (* $CopyArrays- *)
    BEGIN
      TextObject( Mui.aTextPreParse, SYSTEM.ADR( "\033r" ),
                  Mui.aTextContents, SYSTEM.ADR( label ),
                  Mui.aTextHiChar  , ORD( hichar ),
                  Mui.aWeight      , 0,
                  Mui.aInnerLeft   , 0,
                  Mui.aInnerRight  , 0,
                  Utility.end );
      RETURN End();
    END KeyLabel;

  PROCEDURE KeyLabel1 * ( label : ARRAY OF CHAR; hichar : CHAR ):Mui.Object;
  (* $CopyArrays- *)
    BEGIN
      TextObject( Mui.aTextPreParse, SYSTEM.ADR( "\033r" ),
                  Mui.aTextContents, SYSTEM.ADR( label ),
                  Mui.aTextHiChar  , ORD( hichar ),
                  Mui.aWeight      , 0,
                  Mui.aInnerLeft   , 0,
                  Mui.aInnerRight  , 0,
                  Utility.end );
        ButtonFrame;
          TagItem( Mui.aFramePhantomHoriz, Exec.true );
      RETURN End();
    END KeyLabel1;

  PROCEDURE KeyLabel2 * ( label : ARRAY OF CHAR; hichar : CHAR ):Mui.Object;
  (* $CopyArrays- *)
    BEGIN
      TextObject( Mui.aTextPreParse, SYSTEM.ADR( "\033r" ),
                  Mui.aTextContents, SYSTEM.ADR( label ),
                  Mui.aTextHiChar  , ORD( hichar ),
                  Mui.aWeight      , 0,
                  Mui.aInnerLeft   , 0,
                  Mui.aInnerRight  , 0,
                  Utility.end );
        StringFrame;
          TagItem( Mui.aFramePhantomHoriz, Exec.true );
      RETURN End();
    END KeyLabel2;

  PROCEDURE KeyLLabel * ( label : ARRAY OF CHAR; hichar : CHAR ):Mui.Object;
  (* $CopyArrays- *)
    BEGIN
      TextObject( Mui.aTextContents, SYSTEM.ADR( label ),
                  Mui.aTextHiChar  , ORD( hichar ),
                  Mui.aWeight      , 0,
                  Mui.aInnerLeft   , 0,
                  Mui.aInnerRight  , 0,
                  Utility.end );
      RETURN End();
    END KeyLLabel;

  PROCEDURE KeyLLabel1 * ( label : ARRAY OF CHAR; hichar : CHAR ):Mui.Object;
  (* $CopyArrays- *)
    BEGIN
      TextObject( Mui.aTextContents, SYSTEM.ADR( label ),
                  Mui.aTextHiChar  , ORD( hichar ),
                  Mui.aWeight      , 0,
                  Mui.aInnerLeft   , 0,
                  Mui.aInnerRight  , 0,
                  Utility.end );
        ButtonFrame;
          TagItem( Mui.aFramePhantomHoriz, Exec.true );
      RETURN End();
    END KeyLLabel1;

  PROCEDURE KeyLLabel2 * ( label : ARRAY OF CHAR; hichar : CHAR ):Mui.Object;
  (* $CopyArrays- *)
    BEGIN
      TextObject( Mui.aTextContents, SYSTEM.ADR( label ),
                  Mui.aTextHiChar  , ORD( hichar ),
                  Mui.aWeight      , 0,
                  Mui.aInnerLeft   , 0,
                  Mui.aInnerRight  , 0,
                  Utility.end );
        StringFrame;
          TagItem( Mui.aFramePhantomHoriz, Exec.true );
      RETURN End();
    END KeyLLabel2;

  PROCEDURE label * {"MuiBasics.Label"} ( lab : ARRAY OF CHAR );

  PROCEDURE label1 * {"MuiBasics.Label1"} ( lab : ARRAY OF CHAR );

  PROCEDURE label2 * {"MuiBasics.Label2"} ( lab : ARRAY OF CHAR );

  PROCEDURE lLabel * {"MuiBasics.LLabel"} ( lab : ARRAY OF CHAR );

  PROCEDURE lLabel1 * {"MuiBasics.LLabel1"} ( lab : ARRAY OF CHAR );

  PROCEDURE lLabel2 * {"MuiBasics.LLabel2"} ( lab : ARRAY OF CHAR );

  PROCEDURE keyLabel * {"MuiBasics.KeyLabel"} ( lab : ARRAY OF CHAR; hichar : CHAR );

  PROCEDURE keyLabel1 * {"MuiBasics.KeyLabel1"} ( lab : ARRAY OF CHAR; hichar : CHAR );

  PROCEDURE keyLabel2 * {"MuiBasics.KeyLabel2"} ( lab : ARRAY OF CHAR; hichar : CHAR );

  PROCEDURE lKeyLabel * {"MuiBasics.LKeyLabel"} ( lab : ARRAY OF CHAR; hichar : CHAR );

  PROCEDURE lKeyLabel1 * {"MuiBasics.LKeyLabel1"} ( lab : ARRAY OF CHAR; hichar : CHAR );

  PROCEDURE lKeyLabel2 * {"MuiBasics.LKeyLabel2"} ( lab : ARRAY OF CHAR; hichar : CHAR );

(***************************************************************************
**
** Controlling Objects
** -------------------
**
** Set() and Get() are two short stubs for BOOPSI GetAttr() and SetAttrs()
** calls:
**
**
**    VAR x : Exec.STRPTR;
**
**    Set(obj,MUIA_String_Contents, SYSTEM.ADR("foobar") );
**    Get(obj,MUIA_String_Contents, x);
**
**    Dos.PrintF( "gadget contains '%s'\n" , x );
**
** NNset() sets an attribute without triggering a possible notification.
**
**
***************************************************************************)

  PROCEDURE Set*( obj : Mui.Object; attr, value : Exec.APTR );
    BEGIN
      IF Intuition.SetAttrs( obj, attr, value, Utility.end ) = 0 THEN END
    END Set;

  PROCEDURE Get*( obj : Mui.Object; attr : LONGINT ; VAR store : ARRAY OF Exec.BYTE );
    BEGIN
      IF Intuition.GetAttr( attr, obj, store) = 0 THEN END
    END Get;

  PROCEDURE NNSet( obj : Mui.Object; attr, value : Exec.APTR );
    BEGIN
      IF Intuition.SetAttrs( obj, Mui.aNoNotify, Exec.LTRUE, attr, value, Utility.end ) = 0 THEN END
    END NNSet;

  PROCEDURE SetMutex * ( obj : Mui.Object; n : LONGINT );
    BEGIN
      Set( obj, Mui.aRadioActive, n );
    END SetMutex;

  PROCEDURE SetCycle * ( obj : Mui.Object; n : LONGINT );
    BEGIN
      Set( obj, Mui.aCycleActive, n );
    END SetCycle;

  PROCEDURE SetString * ( obj : Mui.Object; s : Exec.STRPTR );
    BEGIN
      Set( obj, Mui.aStringContents, s );
    END SetString;

  PROCEDURE SetCheckmark * ( obj : Mui.Object; b : BOOLEAN );
    BEGIN
      Set( obj, Mui.aSelected, SYSTEM.VAL(SHORTINT,b) );
    END SetCheckmark;

  PROCEDURE SetSlider * ( obj : Mui.Object; l : LONGINT );
    BEGIN
      Set( obj, Mui.aSliderLevel, l );
    END SetSlider;

BEGIN
  Init();
END MuiBasics.

