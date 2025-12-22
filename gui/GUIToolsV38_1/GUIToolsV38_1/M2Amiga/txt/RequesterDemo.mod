(**********************************************************************
:Program.    RequesterDemo.mod
:Contents.   guitools.library demonstration: using requesters
:Author.     Carsten Ziegeler
:Address.    Augustin-Wibbelt-Str.7, 33106 Paderborn, Germany
:Copyright.  Freeware, refer to documentation
:Language.   Modula-2
:Translator. M2Amiga V4.1
:Remark.     OS 2.0 required
:Remark.     requires guitools.library V38.1
:History.    v1.0  Carsten Ziegeler  17-Mar-94
***********************************************************************)
MODULE RequesterDemo;

(* This example shows all available requesters on the public screen.
   The requesters are not redirected ! The windowPtr field of the
   process structure is used ! (Usually this is NIL) *)

  FROM SYSTEM    IMPORT ADR, ADDRESS, TAG;
  FROM Arts      IMPORT Assert;
  FROM GUIToolsD IMPORT okReqKind, doitReqKind, yncReqKind, fileReqKind,
                        dirReqKind, reqDo, reqNo, reqYes, reqAslOK, SrTags;
  FROM GUIToolsL IMPORT guitoolsBase, ShowRequester, ShowRequesterP;

CONST version = ADR('$VER: RequesterDemo 1.0 (17.03.94)\n');

VAR choose : LONGINT;
    file, dir : ARRAY[0..255] OF CHAR;
    tagbuf : ARRAY[0..19] OF LONGCARD;
    args : ARRAY[0..4] OF ADDRESS; (* for the arguments *)
BEGIN
  Assert(guitoolsBase^.version>37, ADR('guitools.library V38 required !'));

  (* No return value, ok requester *)
  ShowRequesterP(NIL, ADR('This is the requester demo !\nEnjoy it !'),
                 okReqKind, NIL);

  (* doitReqKind *)
  WHILE ShowRequester(NIL, ADR('Do you want to see this requester again ?'),
                      doitReqKind, NIL) = reqDo DO
  END;

  (* Yes/no/cancel  requester *)
  choose := ShowRequester(NIL, ADR('Do you want to see some asl requesters ?'),
                          yncReqKind, NIL);
  IF    choose = reqYes THEN
    IF (guitoolsBase^.version = 38) AND (guitoolsBase^.revision = 0) THEN
      ShowRequesterP(NIL, ADR('Oh.. I am sorry ! But for the asl requesters\n'+
                              'you need at least version 38.1 !'),
                     okReqKind, NIL);
    ELSE
      (* And now the asl requesters provided by GUITools *)

      file := 'guitools.library';
      dir  := 'sys:libs';
      (* First a requester to choose the best library ! *)
      IF ShowRequester(NIL, ADR('Choose the best library'), fileReqKind,
                       TAG(tagbuf, srAslPattern, ADR('#?.library'),
                                   srAslFileBuffer, ADR(file),
                             srAslDirBuffer, ADR(dir), NIL)) = reqAslOK THEN
        args[0] := ADR(dir);
        args[1] := ADR(file);
        ShowRequesterP(NIL, ADR('You choice was:\ndir :%s\nfile:%s'),
                       okReqKind, TAG(tagbuf, srArgs, ADR(args), NIL));
      ELSE
        ShowRequesterP(NIL, ADR('You cancelled it ! (Sniff..)'),
                       okReqKind, NIL);
      END;

      (* And now a save dir requester with no pattern gadget *)
      dir := 'ram:t';
      IF ShowRequester(NIL, ADR('Choose directory to save something...'),
                       dirReqKind, TAG(tagbuf, srAslNameBuffer, ADR(dir),
                                               srAslPattern, NIL,
                                       srAslSave, TRUE, NIL)) = reqAslOK THEN

        args[0] := ADR(dir);
        ShowRequesterP(NIL, ADR('You selected directory:\n%s'),
                       okReqKind, TAG(tagbuf, srArgs, ADR(args), NIL));
      ELSE
        ShowRequesterP(NIL, ADR('You cancelled it ! (Snuff..)'),
                       okReqKind, NIL);
      END;
    END;
  ELSIF choose = reqNo  THEN
    ShowRequesterP(NIL, ADR('Click OK to quit !'), okReqKind, NIL);
  END;
END RequesterDemo.
