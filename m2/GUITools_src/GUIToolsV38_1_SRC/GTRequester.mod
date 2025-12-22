(**********************************************************************
:Program.    GTRequester.mod
:Contents.   Functions for creating and using GUIs
:Author.     Carsten Ziegeler
:Address.    Augustin-Wibbelt-Str.7, 33106 Paderborn, Germany
:Copyright.  Freeware, refer to GUITools-Documentation
:Language.   Modula-2
:Translator. M2Amiga V4.1
:Remark.     OS 2.0 required
:Remark.     see GUITools-Documentation for detailled information
:History.    v38.1  Carsten Ziegeler  20-May-94
**********************************************************************)
IMPLEMENTATION MODULE GTRequester;

  FROM SYSTEM     IMPORT ADR, ADDRESS, CAST, LONGSET, TAG;
  FROM ExecD      IMPORT MemReqs, MemReqSet;
  FROM ExecL      IMPORT AllocMem, FreeMem;
  FROM IntuitionD IMPORT EasyStructPtr, EasyStruct, IDCMPFlagSet;
  FROM String     IMPORT Copy, LastPos, Length, Concat, ConcatChar;
  FROM UtilityD   IMPORT tagUser, Tag, TagItemPtr, TagItem, tagEnd,
                         tagFilterNOT;

IMPORT AslD, AslL, IL:IntuitionL, UL:UtilityL;

(* Here all constants and tags again to avoid a cross-importation and to avoid
   mistakes while updating the requester-possibilities *)

CONST
 generalReqKind = 0;
 okReqKind      = 1;
 doitReqKind    = 2;
 yncReqKind     = 3;
 fileReqKind    = 4;
 dirReqKind     = 5;

 reqYes    = 1;  (* yncReqKind *)
 reqNo     = 2;
 reqCancel = 0;
 reqOK     = 0;  (* okReqKind *)
 reqDo     = 1;  (* doitReqKind *)
 reqLeave  = 0;
 reqAslCancel = 0; (* all Asl-requesters *)
 reqAslOK     = 1;

TYPE SrTags=(srDummy:=tagUser+017000H,
             srGadgets, srArgs, srFlags, srTitle, srIDCMP, srReqWindow,
             srAslPattern, srAslNameBuffer, srAslFileBuffer, srAslDirBuffer,
             srAslSave);

     STRPTR = POINTER TO ARRAY[0..511] OF CHAR;
     AslReqData = RECORD
                    CASE :INTEGER OF
                      0 : ad : ADDRESS;
                    | 1 : fi : AslD.FileRequesterPtr;
                    END;
                    name, drawer : ARRAY[0..255] OF CHAR;
                    tagbuf   : ARRAY[0..7] OF TagItem;
                    filebuf, dirbuf : STRPTR;
                    pattern, buffer : STRPTR;
                    flags1 : AslD.FRFlag1Set;
                    flags2 : AslD.FRFlag2Set;
                  END;
     AslReqDataPtr = POINTER TO AslReqData;

     TAGARRAY=ARRAY[0..11] OF Tag;

CONST NOASLTAGS = TAGARRAY{Tag(srGadgets), Tag(srArgs), Tag(srFlags),
                           Tag(srTitle), Tag(srIDCMP), Tag(srReqWindow),
                           Tag(srAslPattern), Tag(srAslNameBuffer),
                           Tag(srAslFileBuffer), Tag(srAslDirBuffer),
                           Tag(srAslSave), tagEnd};



  PROCEDURE GTRequester(req : GTReqArgsPtr; text : ADDRESS;
                        kind : LONGCARD; tags : TagItemPtr) : LONGINT;
  VAR return : LONGINT;
      next   : TagItemPtr;
      taglist: TagItemPtr;
      request: AslReqDataPtr;

    PROCEDURE EasyReq;
    VAR request: EasyStructPtr;
        idcmpP : POINTER TO IDCMPFlagSet;
        args   : ADDRESS;
        idcmp  : IDCMPFlagSet;
    BEGIN
      idcmp  := IDCMPFlagSet{};
      args   := NIL;
      idcmpP := ADR(idcmp);
      request := AllocMem(SIZE(EasyStruct), MemReqSet{memClear});
      IF request # NIL THEN
        WITH request ^DO
          structSize := SIZE(EasyStruct);
          textFormat := text;
          IF    kind = okReqKind   THEN gadgetFormat := ADR('OK');
          ELSIF kind = doitReqKind THEN gadgetFormat := ADR('YES|NO');
          ELSIF kind = yncReqKind  THEN gadgetFormat := ADR('YES|NO|CANCEL');
          END;
        END;
        IF tags # NIL THEN
          next := UL.NextTagItem(taglist);
          WHILE next # NIL DO
            CASE next^.tag OF
              Tag(srGadgets) : request^.gadgetFormat := ADDRESS(next^.data);
            | Tag(srArgs)    : args := ADDRESS(next^.data);
            | Tag(srFlags)   : request^.flags := CAST(LONGSET, next^.data);
            | Tag(srTitle)   : request^.title := ADDRESS(next^.data);
            | Tag(srIDCMP)   : idcmpP := ADDRESS(next^.data);
            | Tag(srReqWindow) : req^.window := ADDRESS(next^.data);
            ELSE
            END;
            next := UL.NextTagItem(taglist);
          END;
        END;
        IF CAST(LONGINT, req^.window) # -1 THEN
          return := IL.EasyRequestArgs(req^.window, request^, idcmpP^, args);
        END;
        FreeMem(request, SIZE(EasyStruct));
      END;
    END EasyReq;

    PROCEDURE AslFileDirReq;
    VAR pos, i : INTEGER;
    BEGIN
      WITH request^ DO
        pattern := ADR('\o\o');
        flags1 := AslD.FRFlag1Set{AslD.frPrivateIDCMP};
        IF kind = dirReqKind THEN
          flags2 := AslD.FRFlag2Set{AslD.frDrawersOnly};
        END;
      END;
      IF tags # NIL THEN
        next := UL.NextTagItem(taglist);
        WHILE next # NIL DO
          CASE next^.tag OF
            Tag(srTitle) : text := ADDRESS(next^.data);
          | Tag(srReqWindow)  : req^.window := ADDRESS(next^.data);
          | Tag(srAslPattern) : request^.pattern := ADDRESS(next^.data);
          | Tag(srAslNameBuffer) : request^.buffer := ADDRESS(next^.data);
          | Tag(srAslFileBuffer) : request^.filebuf := ADDRESS(next^.data);
          | Tag(srAslDirBuffer)  : request^.dirbuf := ADDRESS(next^.data);
          | Tag(srAslSave) : IF next^.data = 0 THEN
                               EXCL(request^.flags1, AslD.frDoSaveMode);
                             ELSE
                               INCL(request^.flags1, AslD.frDoSaveMode);
                             END;
          ELSE
          END;
          next := UL.NextTagItem(taglist);
        END;
      END;
      WITH request^ DO
        IF pattern # NIL THEN INCL(flags1, AslD.frDoPatterns) END;
        IF dirbuf  # NIL THEN Copy(drawer, dirbuf^)  END;
        IF filebuf # NIL THEN Copy(name, filebuf^)  END;
        IF buffer # NIL THEN    (* Divide into path and file *)
          Copy(drawer, buffer^);
          Copy(name, buffer^);
          IF kind # dirReqKind THEN
            pos := LastPos(name, CAST(CARDINAL, -1) , '/');
            IF pos < 0 THEN
              pos := LastPos(name, CAST(CARDINAL, -1), ':');
            END;
            IF pos >= 0 THEN
              IF drawer[pos] = ':' THEN
                drawer[pos+1] := 0C;
              ELSE
                drawer[pos] := 0C;
              END;
              INC(pos);
              FOR i := pos TO Length(name) DO
                name[i-pos] := name[i];
              END;
              name[i] := 0C;
            ELSE
              drawer[0] := 0C;
            END;
          END;
        END;
        ad := AslL.AllocAslRequest(AslD.aslFileRequest, TAG(tagbuf,
                            AslD.tfrWindow, req^.window,
                            AslD.tfrTitleText, text,
                            AslD.tfrInitialFile, ADR(name),
                            AslD.tfrInitialDrawer, ADR(drawer),
                            AslD.tfrInitialPattern, pattern,
                            AslD.tfrFlags1, flags1,
                            AslD.tfrFlags2, flags2, tagEnd));
        IF ad # NIL THEN
          IF CAST(LONGINT, req^.window) # -1 THEN
            IF UL.FilterTagItems(tags, ADR(NOASLTAGS), tagFilterNOT) = 0 THEN END;
            IF AslL.AslRequest(ad, tags) THEN
              IF dirbuf # NIL THEN
                Copy(dirbuf^, CAST(STRPTR, fi^.dir)^);
              END;
              IF filebuf # NIL THEN
                Copy(filebuf^, CAST(STRPTR, fi^.file)^);
              END;
              IF buffer # NIL THEN
                Copy(buffer^, CAST(STRPTR, fi^.dir)^);
                IF kind # dirReqKind THEN
                  IF (Length(buffer^) > 0) AND
                     (buffer^[Length(buffer^)-1] # ':') AND
                     (buffer^[Length(buffer^)-1] # '/') THEN
                    ConcatChar(buffer^, '/');
                  END;
                  Concat(buffer^, CAST(STRPTR, fi^.file)^);
                END;
              END;
              return := reqAslOK;
            END;
          END;
          AslL.FreeAslRequest(ad);
        END;
      END;
    END AslFileDirReq;

  BEGIN
    return := reqCancel;
    tags := UL.CloneTagItems(tags);
    taglist := tags;
    IF kind < fileReqKind THEN
      EasyReq;
    ELSE
      request := AllocMem(SIZE(AslReqData), MemReqSet{memClear});
      IF request # NIL THEN
        CASE kind OF
          fileReqKind,
          dirReqKind  : AslFileDirReq;
        ELSE
        END;
        FreeMem(request, SIZE(AslReqData));
      END;
    END;
    UL.FreeTagItems(tags);
    RETURN return;
  END GTRequester;

END GTRequester.
