MODULE ListDemo;

(* This little demo will show, how to write a MUI-Application using
** a list object and how to manage to set up the columns with a hook.
**
** We will implement just a list and put some things into it.
**
** Written 20.12.1993 by Christian 'Kochtopf' Scholz
** Email : ruebe@pool.informatik.rwth-aachen.de
**   or, if pool does not work, try
**   ruebe@tschil.informatik.rwth-aachen.de
**
** Updated Nov 27, 1995 by Olaf Peters:
**  - does not use MUIOBSOLETE tags any longer
**  - uses "the ideal input loop for an object oriented MUI application"
**      (see MUI_Application.doc/MUIM_Application_NewInput)
*)

(* 
** First some imports
*)

(*$ StackChk:=FALSE *)

IMPORT  MD:MuiD;
IMPORT  MM:MuiMacros;
IMPORT  ExecD;
FROM    MuiSupport  IMPORT DoMethod, DOMethod, fail;
FROM    UtilityD    IMPORT HookPtr, Hook, tagEnd;
FROM    DosD        IMPORT ctrlC ;
FROM    ExecL       IMPORT Wait;
FROM    Storage     IMPORT ALLOCATE, DEALLOCATE;
FROM    SYSTEM      IMPORT TAG, ADR, LONGSET, ADDRESS, CAST;
FROM    MuiMacros   IMPORT set, MakeHook, NoteClose, MakeID,
                           (* These are for the list !! *)
                           STRING, STRPTR, STRARR, STRARRPTR;

(*
** Types
*)

TYPE    tagbuffer   = ARRAY[0..30] OF LONGINT;  (* for the taglists *)
        (* Now the type for the list we want to have displayed *)
        ListPtr     = POINTER TO ListContents;
        (* we want 3 columns *)
        ListContents  = RECORD
                            Column1 : STRING;
                            Column2 : STRING;
                            Column3 : STRING;
                        END;
        EntryArr      = ARRAY[0..5] OF ListPtr;



(*
** Lets define some CONST for some Objects
*)

CONST   True =1;
        False=0;

        (* Lets define some entries for our little list.
        ** normally you would do this by creating a new node of type ListContents
        ** e.g. with ALLOCATE(newptr, SIZE(ListContents)) where newptr is defined
        ** as ListPtr. Then you have to fill this new record and pass it to
        ** MUIListInsert. But beware that you have to pass a pointer to a pointer.
        ** So you have to write
        ** DoMethod(list, TAG(buffer, MD.mmListInsert, ADR(newptr), 
        **                              1, MD.mvListInsertBottom));
        **
        ** So remember to pass the type POINTER to ListPtr. ( or ADR(ListPtr) )
        *)


        e1   =ListContents{Column1 : "this",
                         Column2 : "is the",
                         Column3 : "first"};
        e2   =ListContents{Column1 : "this",
                         Column2 : "is the",
                         Column3 : "second"};
        e3   =ListContents{Column1 : "yeah!",
                         Column2 : "the",
                         Column3 : "third"};
        e4   =ListContents{Column1 : "and this",
                         Column2 : "is the",
                         Column3 : "fourth"};
        e5   =ListContents{Column1 : "last",
                         Column2 : "but not",
                         Column3 : "least"};

        (* This is an entry with 5 elements of ListPtr.
        ** we have to give a pointer to this array to the ListInsert-Method.
        *)
        entries = EntryArr{ADR(e1),ADR(e2),ADR(e3),ADR(e4),ADR(e5),NIL};


(*
** Now some Variables for some objects
*)

VAR     app, window, list,
        listview            : MD.APTR;
        msg                 : LONGINT;
        signals             : LONGSET;
        running             :=BOOLEAN{TRUE};
        buffer, buffer1     : tagbuffer;
        DspHook             : HookPtr;          (* this is for my display-hook *)

(* Lets define some lovely hook-functions *)


PROCEDURE DspFunc(hook : HookPtr; array : MD.APTR; listPtr : MD.APTR) : MD.APTR;
    BEGIN
    
        (* if listPtr is NIL then we have to provide the titles *)
        IF listPtr#NIL THEN (* normal entry *)
        
        (* Yeah! Wild casts ;-)
        ** What we do here is to convert some strings to the format used
        ** by C.
        ** In C string-arrays are defined the following way :
        **      array -> elem1 -> "string1"
        **               elem2 -> "string2"
        **                 .
        **                 .
        **                 .
        ** So we have a pointer called 'array' which points to an array.
        ** This array consists of pointers to strings.
        ** Now we have to build that in M2.
        ** The type of elem1 is STRPTR (a pointer to a string)
        ** The type of array is STRARRPTR ( a pointer to a string array)
        ** So look in MuiMacros.def where STRPTR, STRARR and STRARRPTR are defined.
        ** So the array we get passed to our hook is an C-Array. So we have
        ** to cast it to STRARRPTR, since it is one of these.
        ** This is done by CAST(STRARRPTR, array).
        ** Since this is a pointer we have to derefernce it with ^.
        ** Then we have an array of type STRARR.
        ** There we have to fill in the right pointers to our columns.
        ** This is done by [0], [1] and [2].
        ** The second CAST in a line casts the MD.APTR which holds the pointer to
        ** the element, we have to display to our real List-Type (here ListPtr).
        ** Then we can dereference our ColumnX and fill in the address of it
        ** in the array, which we get from MUI to fill in our strings.
        ** Ofcourse we just fill in the pointer to the string (ADR).
        ** (another way to do this is defining the ListContents-Type as follows :
        ** TYPE ListContent = RECORD
        **                      col1    : STRPTR;
        **                      col2    : STRPTR;
        **                      ...
        ** The we do not need the ADR but must fill in directly the address of
        ** the string.) Clear ?
        ** (or just copy this code and modify it ;-)
        *)

            CAST(STRARRPTR, array)^[0]:= ADR(CAST(ListPtr, listPtr)^.Column1);
            CAST(STRARRPTR, array)^[1]:= ADR(CAST(ListPtr, listPtr)^.Column2);
            CAST(STRARRPTR, array)^[2]:= ADR(CAST(ListPtr, listPtr)^.Column3);
        
        ELSE (* return titles ( centered, underlined ) *)
            CAST(STRARRPTR, array)^[0]:= ADR("\033n\0333\033c\033uErste Spalte");
            CAST(STRARRPTR, array)^[1]:= ADR("\033c\0333\033uZweite Spalte");
            CAST(STRARRPTR, array)^[2]:= ADR("\033c\0333\033uDritte Spalte");
        END;
        RETURN 0; (* dummy return value *)
    END DspFunc;



BEGIN
    MakeHook(DspFunc, DspHook);             (* generate the hook *)

    (* lets create some objects *)

    list:=MM.ListObject(TAG(buffer,
                MD.maFrame,                 MD.mvFrameInputList,
                MD.maListDisplayHook,       DspHook,            (* here put the hook *)
                (* our format string *)
                MD.maListFormat,            ADR("P=\033c\033b D=8,P=\033c,P=\033c"),
                80423E66H,                  TRUE,               (* missing in 1.4 *)
                (*MD.maListTitle,             TRUE,               (* give it titles *)*)
               tagEnd));
    listview:=MM.ListviewObject(TAG(buffer,
                MD.maListviewList,          list,               (* put here our list *)
                tagEnd));

    (* now the window *)

    window:=MM.WindowObject(TAG(buffer,
                MD.maWindowTitle,       ADR("List-Demonstration"),
                MD.maWindowID,          MakeID("LDEM"),
                MM.WindowContents,
                        MM.VGroup(TAG(buffer1,
                            MD.maFrame,                 MD.mvFrameGroup,
                            MD.maFrameTitle,            ADR("Do the list, err, twist"),
                            MM.Child,                   listview,       (* just our list *)
                            tagEnd)),
                tagEnd));

    app:=MM.ApplicationObject(TAG(buffer,
                       MD.maApplicationTitle,      ADR("List-Demonstration"),
                       MD.maApplicationAuthor,     ADR("Christian Scholz"),
                       MD.maApplicationVersion,    ADR("$VER: ListDemo V0.1 (20.12.1993)"),
                       MD.maApplicationCopyright,  ADR("© 1993 by Christian 'Kochtopf' Scholz"),
                       MD.maApplicationDescription,ADR("Shows how to implement a list with MUI"),
                       MD.maApplicationBase,       ADR("LD"),
                       MM.SubWindow,               window,
                       tagEnd));
    IF app=NIL THEN fail(app,"failed to create app"); END;

    (* some notification *)

    NoteClose(app,window,MD.mvApplicationReturnIDQuit);
    
    (* set up the cycle chain *)

    set(listview, MD.maCycleChain, LONGINT(TRUE)) ;

    (* set the active object *)

    set(window, MD.maWindowActiveObject, listview);

    (* open the window *)

    set(window, MD.maWindowOpen, True);


    set(list, MD.maListQuiet, True);    (* that you don't see updating *)

    (* Insert something in the list
    ** Here we call mmListInsert with an array of ListPtr, which shall be
    ** inserted in our list. This array must be terminated with a NIL
    ** and the count-value must be -1. (refer to autodocs)
    *)

    DoMethod(list, TAG(buffer,
            MD.mmListInsert, ADR(entries), -1, MD.mvListInsertBottom));

    (* and again! *)

    DoMethod(list, TAG(buffer,
            MD.mmListInsert, ADR(entries), -1, MD.mvListInsertBottom));


    set(list, MD.maListQuiet, False);   (* show the list *)


    (* Main loop *)

    signals := LONGSET{} ;

    LOOP
      IF DOMethod(app, TAG(buffer, MD.mmApplicationNewInput, ADR(signals))) = MD.mvApplicationReturnIDQuit THEN EXIT END ;

      IF signals # LONGSET{} THEN
        INCL(signals, ctrlC) ;
        signals := Wait(signals) ;
        IF ctrlC IN signals THEN EXIT END ;
      END (* IF *) ;
    END (* WHILE *) ;
 
    set(window,MD.maWindowOpen,False);          (* close window *)

    fail(app,"");                               (* say bye to the application *)

END ListDemo.

