
{$I   "Include:Utility/TagItem.i"}

{

  Achtung (1) !  Diese Funktion läuft nur unter PCQ-Pascal 1.2d !!!
  Achtung (2) !  Die Utility Library muß vorher geöffnet werden !!!


  In PCQ-Pascal mußte man Tag-Listen so definieren:
   MyTags[0].ti_Tag:=WA_Left;
   MyTags[0].ti_Data:=50;
   MyTags[1].ti_Tag:=WA_Top;
   MyTags[1].ti_Data:=100;
   MyTags[2].ti_Tag:=WA_Width;
   MyTags[2].ti_Data:=200;
   MyTags[3].ti_tag:=WA_Height;
   MyTags[3].ti_Data:=60;
   MyTags[4].ti_Tag:=WA_Title;
   MyTags[4].ti_Data:=Integer("Test");
   MyTags[5].ti_Tag:=TAG_DONE;

 Das war mir viel zu umständlich.
 Darum habe ich die Funktion CreateTagList geschrieben.
 Dieses Beispiel bewirkt das gleiche wie das Beispiel oben:

 TagList:=CreateTagList(
                     WA_Left,      50,
                     WA_Top,      100,
                     WA_Width,    200,
                     WA_Height,    60,
                     WA_Title, "Test",
                     TAG_DONE );

 Zum Schluß muß TAG_END oder TAG_DONE angegeben werden.
 Es können maximal 40 TagItems angegeben werden, der Rest wir überlesen.
 Wenn Sie mehr TagItems benötigen, dann geben Sie für die Konstante
 MaxNumTags eine höhere Zahl an.

 Die so generierte Tagliste muß nach Gebrauch unbedingt mit der
 Funktion FreeTagItems (utility.library)  freigegeben werden !

 Copyright © 1994 by Andreas Tetzl

}                                                                    


{$C+}

FUNCTION CreateTagList(...) : Address;

CONST   MaxNumTags = 40;

VAR ArgPtr     : Address;
    i          : Integer;
    NewTagList : Address;
    MyTags     : Array[1..MaxNumTags] of TagItem;

BEGIN
  VA_Start(ArgPtr);

  i:=0;
  REPEAT

    Inc(i);
    MyTags[i].ti_Tag := VA_Arg( ArgPtr, Integer );

    IF   MyTags[i].ti_tag  <> TAG_DONE
    THEN MyTags[i].ti_Data := VA_Arg(ArgPtr,Integer);

  UNTIL (MyTags[i].ti_tag=TAG_DONE) OR (i=MaxNumTags);

  IF i = MaxNumTags
   THEN MyTags[MaxNumTags].ti_tag := TAG_DONE;

  NewTagList    := CloneTagItems(adr(MyTags));
  CreateTagList := NewTagList;

END;
{$C-}


