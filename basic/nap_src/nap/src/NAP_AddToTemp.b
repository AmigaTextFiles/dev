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

{* This sub program adds a specific file to the TempFile.          **
** Params :  filenumber  - next free filenumber                    **
**           filename    - name (incl path) of file to be included *}

SUB AddToTemp (SHORTINT filenumber,address filename)
 SHARED Options,ListBases
 SHORTINT i

 DIM ADDRESS BufferPtr(9,1) ADDRESS BufferPtrBase
 DIM STRING Path(9) SIZE PathSize ADDRESS PathPtr

 ON BREAK CALL ende
 BREAK ON

 STRING spaces SIZE 20
 spaces=STRING$(filenumber,_space_)
 IF Options->Tracing THEN PRINT spaces;"";filenumber;""; ~
                                string$(15-filenumber,_space_);""; ~
                                CSTR(filename);" ..";

 FOR i=0 to 9
  open "I",filenumber,Path(i)+CSTR(filename)
  IF handle(filenumber) THEN exit for
 NEXT
 IF handle(filenumber)=0 THEN
  PrErr (0,"Could not open "+CSTR(filename)+"!")
  EXIT SUB
 END IF

 IF Options->Tracing THEN PRINT ".. ok"
 IF Options->Comment_source THEN PRINT #1,"' Line 1 : "+CSTR(filename)

 ADDRESS FileReady
 FileReady=ReserveMem(filenumber)

 STRING   object,toparse,param SIZE 256
 STRING   fname SIZE 50
 STRING   name_of_struct, command SIZE 32

 STRING   text,BigText,replace,comment SIZE 256

 SHORTINT in_Struct,if_depth,valid_depth,FoundSth
 ADDRESS  length, actLine

 DECLARE STRUCT _List *substruct
 DECLARE STRUCT Node *EmptyNode
 DECLARE STRUCT DefineNode *EmptyDefine
 DECLARE STRUCT StructNode *EmptyStruct

 WHILE PEEK(fileready)=0

  text=convert(lese(filenumber,bufferptrbase))
  ++ActLine

  length = LEN(text) + @text - 1
  WHILE PEEK(length)=126 OR PEEK(length)=92
   POKE length,0
   BigText = convert(lese(filenumber,bufferptrbase))
   ++ActLine
   length = length + LEN(BigText) - 1
   text = text + BigText
  WEND

  ' REMOVE COMMENTS

#INCLUDE "ACE:Projekte/NAP/NAP_RemCom.b"

  {* 1st look for preprocessor commands.  These commands work with **
  ** tokens defined via #define. Therefore defines must not be re- **
  ** placed !                                                      *}

  ' is there a preprocessor command within this line?
  IF PEEK(@text)=35 THEN                 { 35 = "#" }
   BigText=UCASE$(text)
   command=get_name_of_object(2,@BigText)

   IF search2(1,@precoms1,command+_space_) THEN
    IF command="UNDEF" THEN
     ' what shall we undefine?
     object=get_name_of_object(8,@text)
     emptydefine=FindName(ListBases->defines,@object)
     IF emptydefine=0 THEN
      PrErr (0,"Could not undefine "+object)
     else
      Remove(emptydefine)
     END IF
    END IF

    {* This is for  "#IF DEFINED <token>"  commands. The other #IF  **
    ** variation can be found further down.                         *}
    IF command="IF" THEN                       ' <expression>
     object=get_name_of_object(5,@BigText)
     IF object="DEFINED" THEN
      IF valid_depth=if_depth THEN
       found=search2(5,@BigText,object)
       object=get_name_of_object_alt(found+8,@text)
       IF FindName(ListBases->defines,@object) THEN ++valid_depth
      END IF
      ++if_depth
      {* Since we processed this variation of the "#IF" command, we **
      ** must prevent the other #IF-processing routine to process   **
      ** this one again. So we destroy it.                          *}
      command="UNDEF" 'has already been processed so don't care ;-)
     END IF
    END IF

    IF command="IFDEF" or command="IFNDEF" THEN
     object=get_name_of_object_alt(8,@text)
     if FindName(ListBases->defines,@object) then
      IF command="IFDEF" then ++valid_depth
     else
      if command="IFNDEF" then ++valid_depth
     end if
     ++if_depth
     if if_depth > 30000 then beep
    end if
   END IF

   {* Now we test again of existing preprocessor commands. But this **
   ** time tokens must be replaced!                                 *}

   IF Options->Replace_Defines THEN CALL ReplaceDefines(@text)
   IF search2(1,@precoms2,command+_space_) THEN
    BigText=UCASE$(text)

    IF command="ELIF" THEN                      ' <expression>
     IF if_depth=valid_depth THEN
      IF if_depth=0 THEN
       PrErr(103,"")
      ELSE
       --valid_depth
      END IF
     ELSE
      IF valid_depth+1=if_depth THEN
       IF ParseExpr(MID$(text,7)) THEN ++valid_depth
      END IF
     END IF
    END IF

    IF command="ENDIF" THEN
     IF valid_depth=if_depth THEN --valid_depth
     --if_depth
     IF if_depth<0 THEN
      PrErr (104,"")
      if_depth=0
      valid_depth=0
     END IF
    END IF

    IF command="IF" THEN
     IF if_depth=valid_depth AND ParseExpr(MID$(text,5)) THEN ++valid_depth
     ++if_depth
    END IF

    IF command="ELSE" THEN
     IF if_depth=valid_depth THEN
      --valid_depth
     else
      if if_depth-1=valid_depth then ++valid_depth
     end if
    END IF

    IF command="INCLUDE" THEN
     fname=get_name_of_object(10,@BigText)
     fname=MID$(fname,2,LEN(fname)-2)

     ' file already included? If not, THEN
     IF FindName(ListBases->include,@fname)=0 THEN
      ' save include file name
      EmptyNode=ALLOC(sizeof(Node),7)
      EmptyNode->ln_name=Copy(fname)
      AddTail(ListBases->include,EmptyNode)

      ' include file
      AddToTemp(filenumber+1,Copy(fname))

      ' reset string contents
      POKEW @command,&H1F00
      spaces=STRING$(filenumber,_space_)
      IF options->comment_source THEN PRINT #1,"' Line";ActLine;" of ";CSTR(filename)
     END IF
    END IF

    IF command="DEFINE" AND Options->Remove_Defines=0 THEN
     EmptyDefine=ALLOC(sizeof(DefineNode),7)
     EmptyDefine->ln_name=Copy(get_name_of_object_alt(8,@text))
     toparse=get_name_of_object(8,@text)
     foundsth=search2(8,@text,toparse)
     replace=MID$(text,foundsth+LEN(toparse))

     cparam=0
     foundsth=search2(1,@toparse,"(")

     IF foundsth THEN
      IF Options->Const_Defines THEN
       PrErr (0,toparse+" is not legal when option Q is used !")
      ELSE
       length=LEN(toparse)
       WHILE peek(@toparse+foundsth-1)<>41 AND foundsth<Length
        param=get_name_of_object_alt(foundsth,@toparse)
        foundsth=foundsth+LEN(param)
        ++foundsth
        ++cparam
        found=1
        REPEAT
         found=search2(found,@replace,param)
        UNTIL param=get_name_of_object_alt(found-1,@replace) or found=0
        IF found THEN replace=LEFT$(replace,found-1)+CHR$(cparam)+~
                              MID$(replace,found+LEN(param))
       WEND
      END IF
     END IF

     emptydefine->replace=Copy(replace)
     emptydefine->countparam=cparam

     IF Options->Const_Defines THEN
      schreibe("CONST "+cstr(emptydefine->ln_name)+"="+STR$(VAL(replace)))
      IF cparam=0 THEN call AddTail(ListBases->defines,emptydefine)
     else
      AddTail(ListBases->defines,emptydefine)
     END IF
    END IF
   else
    if peek(@command) then
     if search2(1,@precoms1,command+_space_)=0 then call PrErr (0,"#"+command+" - unknown command")
    end if
   end if

   foundsth=search2(1,@text,"{")
   IF foundsth THEN text=MID$(text,foundsth) else POKE @text,0

  ELSE

   IF if_depth>valid_depth THEN
    POKE @text,0
    POKE @BigText,0
   else
    IF Options->Replace_Defines THEN CALL ReplaceDefines(@text)
    BigText=UCASE$(text)
   END IF

   {*
   ** Shall we remove unused structures ?
   *}
   IF Options->Remove_Structs THEN
    ' is there a structure definition?
    struct_def=search2(1,@BigText,definition)

    If struct_def THEN
     struct_dec=search2(1,@Bigtext,declaration)

     IF struct_dec THEN
      IF legal(@text,struct_dec) THEN
       ' save name of declared structure in list
       EmptyNode=ALLOC(sizeof(node),7)
       emptynode->ln_name=copy(get_name_of_object(15+struct_dec,@BigText))
       IF Options->Tracing THEN PRINT spaces;" found declaration for structure ";cstr(emptynode->ln_name)
       AddTail(ListBases->needed_structs,EmptyNode)
      END IF
     ELSE
      IF legal(@text,struct_def) and in_Struct=0 THEN
       proceed=1
       IF struct_def>1 THEN
        IF get_name_of_object_alt(struct_def-1,@text)<>definition THEN proceed=0
       END IF

       IF proceed THEN
        in_struct=1
        ' yes, it is -> save name of structure in list
        EmptyStruct=ALLOC(sizeof(structnode),7)
        EmptyStruct->ln_name=Copy(get_name_of_object(6+struct_def,@Bigtext))
        EmptyStruct->member_types_list=ALLOC(SIZEOF(_list),7)
        substruct=emptystruct->member_types_list
        IF Options->Tracing THEN PRInT spaces;" found definition for structure ";cstr(emptystruct->ln_name)
        AddTail(ListBases->structures,EmptyStruct)
        substruct->lh_Head=substruct+4
        substruct->lh_TailPred=substruct
       END IF
      END IF
     END IF
    END IF

    IF in_Struct=1 THEN
     ' name of substruct
     name_of_struct=get_name_of_object(1,@BigText)
     IF name_of_struct="END" THEN
      in_Struct=0
     else
      IF search2(1,@reserved,_space_+name_of_struct+_space_)=0 THEN
       IF FindName(substruct,name_of_struct)=0 THEN
        emptynode=ALLOC(sizeof(node),7)
        emptynode->ln_name=copy(name_of_struct)
        IF Options->Tracing THEN PRINT spaces;"   -> needed struct : ";name_of_Struct
        AddTail(substruct,emptynode)
       END IF
      END IF
     END IF
    END IF
   END IF
  END IF

  IF LEN(text)>0 or Options->Remove_Lines=0 THEN
   schreibe(text)
   KillEmpty=0
  ELSE
   IF KillEmpty=0 THEN
    schreibe("")
    ++KillEmpty
   END IF
  END IF

 WEND

 IF if_depth THEN CALL PrErr(105,"")
 IF Options->Tracing THEN PRINT STRING$(filenumber,_space_);" finished"
 BREAK OFF
 CLOSE #filenumber
 FreeMem(BufferPtr(filenumber,0),BufferPtr(filenumber,1))
 BufferPtr(filenumber,0)=0
END SUB

