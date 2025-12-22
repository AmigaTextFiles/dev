{
   NAP 2.03, a preprocessor for ACE
   Copyright (C) 1997/98 by Daniel Seifert 

		contact me at:  dseifert@berlin.sireco.net

				Daniel Seifert
				Elsenborner Weg 25
				12621 Berlin
				GERMANY

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or   
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software 
   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}


SUB RemoveStuff
 ' removes unused structs

 SHARED options,ListBases

 DIM ADDRESS BufferPtr(9,1) ADDRESS BufferPtrBase

 ADDRESS FileReady
 FileReady=ReserveMem(2)

 ON BREAK CALL ende
 BREAK ON

 STRING   object,text,BigText SIZE 256
 STRING   name_of_struct SIZE 32

 SHORTINT in_Struct
 ADDRESS  next_node

 definition="STRUCT "
 declaration="DECLARE STRUCT "

 DECLARE STRUCT _List *structs,*substruct
 DECLARE STRUCT Node *EmptyNode
 DECLARE STRUCT StructNode *EmptyStruct

 if Options->Tracing then call texts(5)
 structs=ListBases->structures
 REPEAT
  EmptyStruct=structs->lh_Head
  FoundSth=0
  WHILE EmptyStruct->ln_Succ
   object=cstr(EmptyStruct->ln_name)
   IF FindName(ListBases->needed_structs,object) THEN
    substruct=emptystruct->member_types_list
    emptynode=substruct->lh_head
    WHILE emptynode->ln_succ
     object=cstr(emptynode->ln_name)
     next_node=emptynode->ln_succ
     IF FindName(ListBases->needed_structs,object)=0 THEN
      if Options->Tracing then ? "     add "object" to list of needed structures"
      AddTail(ListBases->needed_structs,emptynode)
      FoundSth=1
     END IF
     emptynode=next_node
    WEND
   END IF
   emptystruct=emptystruct->ln_succ
  WEND
 UNTIL FoundSth=0

 IF Options->Tracing THEN
  ? "  Result:"
  structs=ListBases->structures
  emptystruct=structs->lh_head
  WHILE emptystruct->ln_succ
   object=CSTR(emptystruct->ln_name)
   ? "     ";
   IF FindName(ListBases->needed_structs,object) THEN ? "need"; ELSE ? "remove";
   print " structure "object
   emptystruct=emptystruct->ln_succ
  WEND
 END IF

 WHILE peek(FileReady)=0
  text=lese(2,bufferptrbase)
  BigText=UCASE$(text)

  ' REMOVE STRUCTS

  IF in_Struct=0 THEN
   struct_def=search2(1,@Bigtext,definition)

   IF struct_def THEN
    proceed=1
    IF search2(1,@Bigtext,declaration) THEN
     proceed=0
    else
     IF struct_def>1 THEN
      IF get_name_of_object_alt(struct_def-1,@BigText)<>definition THEN proceed=0
     END IF
    END IF

    IF proceed AND legal(@text,struct_def) THEN
     ' If it is really a definition and if it is not within a comment,
     ' then get the name of the struct
     name_of_struct=get_name_of_object(struct_def+6,@BigText)

     ' does we need this struct?
     IF FindName(ListBases->needed_structs,name_of_struct)=0 THEN
      ' no
      REPEAT
       text=UCASE$(lese(2,bufferptrbase))
      UNTIL search2(1,@text,"END STRUCT") OR PEEK(FileReady)
      text=lese(2,bufferptrbase)
     ELSE
      in_Struct=1
     END IF
    END IF
   END IF
  END IF

  IF in_Struct THEN
   IF UCASE$(get_name_of_object(1,@text))="END" THEN in_Struct=0
  END IF

  schreibe(text)
 WEND

 {* The BREAK OFF is life-rescuing: If the user would press CTRL-C **
 ** after the memory is freed but before this is stored, the ENDE- **
 ** routine would free the memory again -> would cause a 81000009! *}
 BREAK OFF
 FreeMem(BufferPtr(1,0),BufferPtr(1,1))
 BufferPtr(1,0)=0
END SUB
