
(*##############################*)
 IMPLEMENTATION MODULE TagsUtils;    (* $VER: TagsUtils.mod 0.0 (3.3.94) *)
(*##############################*)

FROM Utility     IMPORT Tag, TagDone, TagEnd, TagItem;

FROM Assertions0 IMPORT Assert;

(*-------------------------------------------------------*)
 PROCEDURE FindTagsEnd(VAR Tags:ARRAY OF TagItem):INTEGER;
(*-------------------------------------------------------*)

VAR  i :INTEGER;

BEGIN

i := 0;
WHILE i <= INTEGER(HIGH(Tags)) DO
   IF Tags[i].tiTag = TagDone THEN
      RETURN i;
   END;
   INC(i);
END;

Assert(FALSE, "FindTagsEnd overrun");

END FindTagsEnd;

(*----------------------------------------------------------------------------*)
 PROCEDURE AsgTagPos(i:INTEGER; VAR Tags:ARRAY OF TagItem; t0:Tag; d0:LONGCARD);
(*----------------------------------------------------------------------------*)

BEGIN

Tags[i].tiTag := t0;
Tags[i].tiData := d0;
Tags[i+1].tiTag := TagDone;

END AsgTagPos;

(*=================================================================*)
 PROCEDURE AsgTag(VAR Tags:ARRAY OF TagItem; t0:Tag; d0:LONGCARD);
(*=================================================================*)

BEGIN

Tags[0].tiTag := t0;
Tags[0].tiData := d0;
Tags[1].tiTag := TagDone;

END AsgTag;

(*=================================================================*)
 PROCEDURE AsgTags2(VAR Tags:ARRAY OF TagItem; t0:Tag; d0:LONGCARD;
                    t1:Tag; d1:LONGCARD);
(*=================================================================*)

BEGIN

AsgTag(Tags, t0, d0);
CatTag(Tags, t1, d1);

END AsgTags2;

(*===========================================================================*)
 PROCEDURE AsgTags3(VAR Tags:ARRAY OF TagItem;
                 t0:Tag; d0:LONGCARD; t1:Tag; d1:LONGCARD; t2:Tag; d2:LONGCARD);
(*===========================================================================*)

BEGIN

AsgTags2(Tags, t0, d0, t1, d1);
CatTag(Tags, t2, d2);

END AsgTags3;

(*===========================================================================*)
 PROCEDURE AsgTags4(VAR Tags:ARRAY OF TagItem;
                 t0:Tag; d0:LONGCARD; t1:Tag; d1:LONGCARD; t2:Tag; d2:LONGCARD;
                 t3:Tag; d3:LONGCARD);
(*===========================================================================*)

BEGIN

AsgTags3(Tags, t0, d0, t1, d1, t2, d2);
CatTag(Tags, t3, d3);

END AsgTags4;

(*===========================================================================*)
 PROCEDURE AsgTags5(VAR Tags:ARRAY OF TagItem;
                 t0:Tag; d0:LONGCARD; t1:Tag; d1:LONGCARD; t2:Tag; d2:LONGCARD;
                 t3:Tag; d3:LONGCARD; t4:Tag; d4:LONGCARD);
(*===========================================================================*)

BEGIN

AsgTags3(Tags, t0, d0, t1, d1, t2, d2);
CatTags2(Tags, t3, d3, t4, d4);

END AsgTags5;

(*===========================================================================*)
 PROCEDURE AsgTags6(VAR Tags:ARRAY OF TagItem;
                    t0:Tag; d0:LONGCARD; t1:Tag; d1:LONGCARD; t2:Tag; d2:LONGCARD;
                    t3:Tag; d3:LONGCARD; t4:Tag; d4:LONGCARD; t5:Tag; d5:LONGCARD);
(*===========================================================================*)

BEGIN

AsgTags4(Tags, t0, d0, t1, d1, t2, d2, t3, d3);
CatTags2(Tags, t4, d4, t5, d5);

END AsgTags6;

(*===========================================================================*)
 PROCEDURE AsgTags7(VAR Tags:ARRAY OF TagItem;
                    t0:Tag; d0:LONGCARD; t1:Tag; d1:LONGCARD; t2:Tag; d2:LONGCARD;
                    t3:Tag; d3:LONGCARD; t4:Tag; d4:LONGCARD; t5:Tag; d5:LONGCARD;
                    t6:Tag; d6:LONGCARD);
(*===========================================================================*)

BEGIN

AsgTags5(Tags, t0, d0, t1, d1, t2, d2, t3, d3, t4, d4);
CatTags2(Tags, t5, d5, t6, d6);

END AsgTags7;

(*===========================================================================*)
 PROCEDURE AsgTags8(VAR Tags:ARRAY OF TagItem;
                    t0:Tag; d0:LONGCARD; t1:Tag; d1:LONGCARD; t2:Tag; d2:LONGCARD;
                    t3:Tag; d3:LONGCARD; t4:Tag; d4:LONGCARD; t5:Tag; d5:LONGCARD;
                    t6:Tag; d6:LONGCARD; t7:Tag; d7:LONGCARD);
 (*===========================================================================*)

BEGIN

AsgTags4(Tags, t0, d0, t1, d1, t2, d2, t3, d3);
CatTags4(Tags, t4, d4, t5, d5, t6, d6, t7, d7);

END AsgTags8;

(*===========================================================================*)
 PROCEDURE AsgTags9(VAR Tags:ARRAY OF TagItem;
                    t0:Tag; d0:LONGCARD; t1:Tag; d1:LONGCARD; t2:Tag; d2:LONGCARD;
                    t3:Tag; d3:LONGCARD; t4:Tag; d4:LONGCARD; t5:Tag; d5:LONGCARD;
                    t6:Tag; d6:LONGCARD; t7:Tag; d7:LONGCARD; t8:Tag; d8:LONGCARD);
(*===========================================================================*)

BEGIN

AsgTags5(Tags, t0, d0, t1, d1, t2, d2, t3, d3, t4, d4);
CatTags4(Tags, t5, d5, t6, d6, t7, d7, t8, d8);

END AsgTags9;

(*===========================================================================*)
 PROCEDURE AsgTags10(VAR Tags:ARRAY OF TagItem;
                    t0:Tag; d0:LONGCARD; t1:Tag; d1:LONGCARD; t2:Tag; d2:LONGCARD;
                    t3:Tag; d3:LONGCARD; t4:Tag; d4:LONGCARD; t5:Tag; d5:LONGCARD;
                    t6:Tag; d6:LONGCARD; t7:Tag; d7:LONGCARD; t8:Tag; d8:LONGCARD;
                    t9:Tag; d9:LONGCARD);
(*===========================================================================*)

BEGIN

AsgTags6(Tags, t0, d0, t1, d1, t2, d2, t3, d3, t4, d4, t5, d5);
CatTags4(Tags, t6, d6, t7, d7, t8, d8, t9, d9);

END AsgTags10;

(*================================================================*)
 PROCEDURE CatTag(VAR Tags:ARRAY OF TagItem; t0:Tag; d0:LONGCARD);
(*================================================================*)

BEGIN

AsgTagPos(FindTagsEnd(Tags), Tags, t0, d0);

END CatTag;

(*=================================================================*)
 PROCEDURE CatTags2(VAR Tags:ARRAY OF TagItem; t0:Tag; d0:LONGCARD;
                    t1:Tag; d1:LONGCARD);
(*=================================================================							*)

VAR  i :INTEGER;

BEGIN

i := FindTagsEnd(Tags);

AsgTagPos(i, Tags, t0, d0);
AsgTagPos(i+1, Tags, t1, d1);

END CatTags2;

(*============================================================================*)
 PROCEDURE CatTags4(VAR Tags:ARRAY OF TagItem; t0:Tag; d0:LONGCARD;
                    t1:Tag; d1:LONGCARD; t2:Tag; d2:LONGCARD; t3:Tag; d3:LONGCARD);
(*============================================================================*)

VAR  i :INTEGER;

BEGIN

i := FindTagsEnd(Tags);

AsgTagPos(i, Tags, t0, d0);
AsgTagPos(i+1, Tags, t1, d1);
AsgTagPos(i+2, Tags, t2, d2);
AsgTagPos(i+3, Tags, t3, d3);

END CatTags4;

(*----------------------*)
 BEGIN (* mod init code *)
(*----------------------*)

NullTag.tiTag := TagEnd;

END TagsUtils.
