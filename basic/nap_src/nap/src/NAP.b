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

{* Header *******************************************************************
**                                                                         **
** Program     :  NAP (New ACE Preprocessor)                               **
** Author      :  Daniel Seifert <dseifert@berlin.sireco.net>              **
**                                                                         **
** Version     :  2     Revision    :  03                                  **
**                                                                         **
** work done at:  02,04-07,14-17,23,28-29-March-1996                       **
**                28-April-1996                                            **
**                04,07,10-May-1996                                        **
**                19-20,23-30-June-1996                                    **
**                01-04,07,12,15-19,22-24,26-July-1996                     **
**                01-04,11,17,25,31-August-1996                            **
**                01-05,08,18,23-24-September-1996                         **
**                01-03-October-1996                                       **
**                31-March-1997                                            **
**                1-7,9-10,13,20-April-1997                                **
**                6,9-10-May-1997                                          **
**                19-June-1997                                             **
**                24-July-1997                                             **
**                13-August-1997                                           **
**                28-September-1997                                        **
****************************************************************************}

#DEFINE __VERSION "2.03"
#DEFINE __COPYEAR "1996/1997"


DEFint a-Z

GLOBAL SHORTINT inComment

{* opt is used to save the options got from the CLI-line and Temp- **
** file contains the name of the temporary file whereas InFile and **
** Outfile specifies the files to read from or write to.           *}
STRING opt SIZE 100
STRING InFile,OutFile,TempFile SIZE 50
STRING argument SIZE 64
STRING token,value,object SIZE 128

' For buffer handling
GLOBAL LONGINT MaxBuffer
GLOBAL ADDRESS BufferPtrBase

' For file handling
GLOBAL ADDRESS PathPtr

{* This is the path and filename of the temporary file. I suspect  **
** T: to point to RAM:t. I hope that's the same with you.          *}
TempFile="t:NAP.temp"

{* In the following array the directory names to be searched thru  **
** for include files are stored.                                   *}
CONST PathSize = 50%
DIM STRING Path(9) SIZE PathSize
PathPtr=@Path(0)
Path(1)="ACEINCLUDE:"
Path(2)="ACE:"         {* This is only for compatibility with ACPP *}
Path(3)="ACE:Include/" {* but I expect it to get changed in ACEIN- *}
                       {* CLUDE: always                            *}


{* In the following array the beginnings and the sizes of the file **
** buffers will be stored.                                         *}
DIM ADDRESS BufferPtr(9,1)
BufferPtrBase=@BufferPtr(0,0)

GLOBAL STRING precoms1 SIZE 48
GLOBAL STRING precoms2 SIZE 48
GLOBAL STRING reserved SIZE 64
GLOBAL STRING declaration SIZE 16
GLOBAL STRING definition SIZE 16

definition  = "STRUCT "
declaration = "DECLARE STRUCT "

reserved = " LONGINT SHORTINT END STRUCT BYTE ADDRESS STRING    { } ' "
precoms1 = " IF UNDEF IFDEF IFNDEF "
precoms2 = " IF ELSE ELIF ENDIF DEFINE INCLUDE "

' structure definition

STRUCT Node                           {* Node is from EXEC/NODES.H *}
 ADDRESS   ln_Succ
 ADDRESS   ln_Pred
 BYTE      ln_Type
 BYTE      ln_Pri
 ADDRESS   ln_Name
END STRUCT

STRUCT _List
 ADDRESS   lh_Head
 ADDRESS   lh_Tail
 ADDRESS   lh_TailPred
 BYTE      lh_Type
 BYTE      l_pad
END STRUCT

STRUCT StructNode
 ADDRESS   ln_Succ
 ADDRESS   ln_Pred
 BYTE      ln_Type
 BYTE      ln_Pri
 ADDRESS   ln_Name
 ADDRESS   member_types_list
END STRUCT

STRUCT DefineNode
 ADDRESS   ln_Succ
 ADDRESS   ln_Pred
 BYTE      ln_Type
 BYTE      ln_Pri
 ADDRESS   ln_Name
 ADDRESS   replace
 SHORTINT  countparam
END STRUCT

{*
** This structure is used to save the different conditions.
*}

STRUCT optionStruct
 BYTE Remove_Structs
 BYTE Remove_Comments
 BYTE Remove_Defines
 BYTE Const_Defines
 BYTE Replace_Defines
 BYTE Print_Errors
 BYTE ShowTime
 BYTE Tracing
 BYTE Remove_Lines
 BYTE Comment_Source
END STRUCT

' For list handling
STRUCT listbasesStruct
 ADDRESS defines
 ADDRESS include
 ADDRESS needed_structs
 ADDRESS structures
END STRUCT

LIBRARY dos
declare function ADDRESS _Read (ADDRESS filehandle,ADDRESS buffer,longint bytes) library dos
declare function ADDRESS _Write (ADDRESS filehandle,ADDRESS buffer,longint bytes) library dos
declare function ADDRESS Seek (ADDRESS filehandle,longint offset,longint modus) library dos

library exec
declare function Remove(ADDRESS nodeptr) library exec
declare function ADDRESS AddTail(ADDRESS listptr,ADDRESS nodeptr) library exec
declare function ADDRESS FindName(ADDRESS listptr,ADDRESS stringptr) library exec
declare function ADDRESS FreeMem(ADDRESS memoryblock,longint bytesize) library exec
declare function ADDRESS AllocMem(longint bytesize,longint requirements) library exec

' All these sub programs are in NAP_Mods.o to be linked with BLINK.
DECLARE SUB ADDRESS  Copy (STRING text) EXTERNAL
DECLARE SUB          StringCopy (ADDRESS source, ADDRESS destination) EXTERNAL
DECLARE SUB SHORTINT legal (ADDRESS textptr,SHORTINT position) EXTERNAL
DECLARE SUB STRING   Get_name_of_object (SHORTINT startpos, ADDRESS textptr) EXTERNAL
DECLARE SUB STRING   Get_name_of_object_alt (SHORTINT startpos, ADDRESS textptr) EXTERNAL
DECLARE SUB SINGLE   ParseExpr (STRING expression) EXTERNAL
DECLARE SUB STRING   lese(shortint filenumber,ADDRESS BufferBase) EXTERNAL
DECLARE SUB          texts(shortint code) EXTERNAL
DECLARE SUB          StripWS (ADDRESS stringptr) EXTERNAL

DECLARE STRUCT _List *liste
DECLARE STRUCT DefineNode *emptydefine
DECLARE STRUCT optionStruct *Options
DECLARE STRUCT listbasesStruct *ListBases

ListBases = ALLOC(SIZEOF(listbasesStruct),7)

global shortint normalexit

GOTO Start      {* The one and only GOTO in this program. I put it **
                ** here so that the compiled program mustn't jump  **
                ** from sub to end sub all the many subs. (It does **
                ** speed the whole thing a little bit up :)        *}

{ ----------------------------------------------------------------- }

{* ENDE closes all files and kills the temporary file.  It is used **
** when doing a CTRL-C or when NAP finishs.                        *}
SUB ende
 SHARED TempFile,OutFile
 SHORTINT i
 DIM ADDRESS BufferPtr(9,1) ADDRESS BufferPtrBase

 FOR i=1 TO 9
  CLOSE #i
  IF BufferPtr(i,0) > 0 THEN CALL FreeMem(BufferPtr(i,0),BufferPtr(i,1))
 NEXT

 CLEAR ALLOC
 IF TempFile<>OutFile THEN KILL TempFile
 IF normalexit = 1 then system 0 else system 10
END SUB


{* This routine prints an error message to standard output. There- **
** fore the Print_Errors variable must be set, otherwise the error **
** message would be suppressed.                                    *}
sub PrErr (shortint code,STRING text)
 SHARED Options

 IF Options->Print_Errors THEN
  IF code=0 THEN ? "--ERROR : "text ELSE CALL texts(code)
 END IF
END sub

{* This sub program is made to replace the "PUT #" command. It is  **
** much faster and 100% compatible with the "PUT #" command !      *}

SUB schreibe(STRING text)
 GLOBAL ADDRESS asmvar1
 asmvar1 = @text

 ASSEM
  movem.l d0/a0,-(a7)
  move.l  _asmvar1,a0
  moveq.l #0,d0

SearchEnd:

  addq.w  #1,d0
  cmp.b   #0,(a0)+
  bne.s   SearchEnd

  move.b  #10,-(a0)
  move.l  d0,_asmvar1

  movem.l (a7)+,d0/a0
 END ASSEM

 IF _Write(handle(1),@text,asmvar1) < asmvar1 THEN
  texts (101)
  ende
 END IF
END SUB

{* ReplaceDefines - Checks every word within a string whether it's **
**                  a define and replaces it if necessary          **
**                                                                 **
**   Syntax : ReplaceDefines(textptr)                              **
**                                                                 **
**     textptr        : (address) string to be checked             *}

SUB ReplaceDefines (ADDRESS textptr)
 shared listbases

 on break call ende
 break on

 STRING object SIZE 48
 STRING replace,param SIZE 256
 STRING char SIZE 2
 STRING string_dummy SIZE 384

 SHORTINT cparam,found,foundsth,position
 DECLARE STRUCT definenode *DefNode

 foundsth = 1
 REPEAT
  object=Get_name_of_object_alt(foundsth,textptr)
  foundsth=instr(foundsth,cstr(textptr),object)
  DefNode=FindName(ListBases->defines,@object)
  IF DefNode>0 AND Legal(textptr,foundsth) = 1 THEN
   replace=cstr(DefNode->replace)

   ' Do we have to parse?
   IF DefNode->countparam THEN
    ' yes - look for begin of parameter list
    position=instr(foundsth,cstr(textptr),"(")
    IF position = 0 THEN
     ' Funny. There have to be params but there are none :(
     PrErr (0,"Corrupt define "+cstr(DefNode->ln_name))
    ELSE
     cparam=0
     WHILE peek(textptr+position-1)<>41        ' 41 = ")"
      param=get_name_of_object_alt(position,textptr)
      position=position+LEN(param)
      ++position
      ++cparam
      char=chr$(cparam)
      found=instr(replace,char)
      WHILE found
       ++found
       replace=LEFT$(replace,found-2)+param+MID$(replace,found)
       found=instr(found,replace,char)
      WEND
     WEND
     ++position
    END IF
   ELSE
    position=foundsth+LEN(object)
   END IF
   string_dummy = LEFT$(CSTR(textptr),foundsth-1)+~
                  replace+MID$(CSTR(textptr),position)
   StringCopy (@string_dummy,textptr)
   foundsth=foundsth+LEN(replace)
  else
   foundsth=foundsth+LEN(object)
  END IF
 UNTIL peek(@object) = 0
END sub

{* This routine replaces C-comments (/* and */) through ACE ones   **
** and checks whether there is a define                            *}
SUB STRING Convert (STRING text)
 SHORTINT foundSth
 {* Why should we waste time by using this sub program if the      **
 ** string is empty ?                                              *}
 IF peek(@text)=0 THEN Convert="":exit sub

 foundSth = 0
 REPEAT
  IF inComment>0 THEN
   foundsth = instr (foundSth+1,text,"*/")
   IF foundSth THEN
    --inComment
    text = LEFT$(text,foundsth-1) + "}" + MID$(text,foundsth+2)
   END IF
  END IF

  foundsth = instr (foundSth+1,text,"/*")
  IF FoundSth > 0 THEN
   IF Legal(@text,FoundSth) THEN
    text = LEFT$(text,foundsth-1) + "{" + MID$(text,foundsth+2)
    ++inComment
   END IF
  END IF
 UNTIL foundSth = 0

 Convert=text
END SUB

SUB ADDRESS ReserveMem (shortint filenumber)
 ADDRESS ActBuffer
 longint filesize

 DIM ADDRESS BufferPtr(9,1) ADDRESS BufferPtrBase

 filesize=LOF(filenumber)

 {* The filebuffer is as long as the b option specifies it, except **
 ** the file is shorter than the specified size. Then we are very  **
 ** flexible and the filebuffer is as long as the file, therefore  **
 ** we does not waste memory. BTW, if you have only less memory a  **
 ** buffersize of 4-5 or lower can help processing files without   **
 ** an "out of memory" failure.                                    *}

 IF filesize<MaxBuffer THEN filesize=filesize+5 else filesize=MaxBuffer+5
 ActBuffer=AllocMem(fileSize,65536&)

 IF ActBuffer=0 THEN CALL PrErr(102,""):CALL ende

 BufferPtr(filenumber,0)=ActBuffer
 BufferPtr(filenumber,1)=filesize
 ReserveMem=ActBuffer+filesize-1
END SUB

{ ----------------------------------------------------------------- }

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
 spaces=STRING$(filenumber," ")
 IF Options->Tracing THEN PRINT spaces;"";filenumber;""; ~
                                string$(15-filenumber," ");""; ~
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

  text=convert(lese(filenumber,BufferPtrBase))
  ++ActLine
  length = LEN(text) + @text - 1
  WHILE PEEK(length)=126 OR PEEK(length)=92
   POKE length,0
   BigText = convert(lese(filenumber,BufferPtrBase))
   ++ActLine
   length = length + LEN(BigText) - 1
   text = text + BigText
  WEND

  ' REMOVE COMMENTS

  {*
  ** This routine tries to remove comments.
  ** As of now, block comments and ' comments
  ** are valid.
  ** Earlier versions did also remove REMs,
  ** but as REM is a BASIC specific command,
  ** it isn't removed anymore.
  *}
  FoundSth = 0
  REPEAT
   {*
   ** Look for the next block comment.
   *}
   FoundSth=instr(foundSth+1,text,"{")
   {*
   ** Is there one? And if, is this comment really a comment?
   *}
   IF (FoundSth>0) AND (Legal(@text,FoundSth) > 0) THEN
    {*
    ** Yeah, it is ;) So let's take the rest of the line as
    ** comment and preserve the first part.
    *}
    comment = MID$(text,FoundSth + 1)
    IF FoundSth > 1 THEN BigText = LEFT$(text,FoundSth-1) ELSE BigText = ""

    {*
    ** Might it happen by accident, that the comment ends at
    ** the same line?
    *}
    FoundEnd=instr(comment,"}")
    IF FoundEnd>0 THEN
     IF Options->Remove_Comments = 0 THEN CALL schreibe ("{"+LEFT$(comment,FoundEnd))
     text=MID$(comment,FoundEnd+1)
    ELSE
     IF Options -> Remove_Comments = 0 THEN CALL schreibe ("{"+comment)
     REPEAT
      comment = Convert(lese(filenumber,BufferPtrBase))
      ++ActLine
      FoundEnd=instr(comment,"}")
      IF FoundEnd=0 THEN
       IF Options->Remove_Comments=0 THEN
        schreibe(comment)
       ELSE
        IF Options->Remove_Lines=0 THEN CALL schreibe("")
       END IF
      END IF
     UNTIL FoundEnd>0 OR PEEK(FileReady) = 1
     IF FoundEnd = 0 THEN FoundSth = 0
     IF Options->Remove_Comments = 0 THEN call schreibe(left$(comment,FoundEnd))
     text = MID$(comment,FoundEnd+1)
    END IF
    text = BigText + text
   ' IF FoundSth > 1 THEN --FoundSth
   END IF
  UNTIL foundSth = 0

  IF Options->Remove_Comments THEN
   REPEAT
    FoundSth=instr(foundSth+1,text,"'")
    IF FoundSth THEN
     IF Legal(@text,FoundSth) THEN text=LEFT$(text,FoundSth-1) : FoundSth = 0
    END IF
   UNTIL FoundSth = 0
  END IF

  {* 1st look for preprocessor commands.  These commands work with **
  ** tokens defined via #define. Therefore defines must not be re- **
  ** placed !                                                      *}

  ' is there a preprocessor command within this line?
  IF PEEK(@text)=35 THEN                 { 35 = "#" }
   BigText=UCASE$(text)
   command=get_name_of_object(2,@BigText)

   IF instr(precoms1,command+" ") THEN
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
       found=instr(5,BigText,object)
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
   IF instr(precoms2,command+" ") THEN
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
      spaces=STRING$(filenumber," ")
      IF options->comment_source THEN PRINT #1,"' Line";ActLine;" of ";CSTR(filename)
     END IF
    END IF

    IF command="DEFINE" AND Options->Remove_Defines=0 THEN
     EmptyDefine=ALLOC(sizeof(DefineNode),7)
     EmptyDefine->ln_name=Copy(get_name_of_object_alt(8,@text))
     toparse=get_name_of_object(8,@text)
     foundsth=instr(8,text,toparse)
     replace=MID$(text,foundsth+LEN(toparse))

     cparam=0
     foundsth=instr(toparse,"(")

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
         found=instr(found,replace,param)
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
     if instr(precoms1,command+" ")=0 then call PrErr (0,"#"+command+" - unknown command")
    end if
   end if

   foundsth=instr(text,"{")
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
    struct_def=instr(BigText,definition)

    If struct_def THEN
     struct_dec=instr(Bigtext,declaration)

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
      IF instr(reserved," "+name_of_struct+" ")=0 THEN
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
 IF Options->Tracing THEN PRINT STRING$(filenumber," ");" finished"
 BREAK OFF
 CLOSE #filenumber
 FreeMem(BufferPtr(filenumber,0),BufferPtr(filenumber,1))
 BufferPtr(filenumber,0)=0
END SUB

{ -------------------------------------------------------------------------- }

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
  text=lese(2,BufferPtrBase)
  BigText=UCASE$(text)

  ' REMOVE STRUCTS

  IF in_Struct=0 THEN
   struct_def=instr(Bigtext,definition)

   IF struct_def THEN
    proceed=1
    IF instr(Bigtext,declaration) THEN
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
       text=UCASE$(lese(2,BufferPtrBase))
      UNTIL instr(text,"END STRUCT") OR PEEK(FileReady)
      text=lese(2,BufferPtrBase)
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

{ -------------------------------------------------------------------------- }

SUB Usage
 texts (1%)
 Ende
END SUB

{ ----------------------------------------------------------------- }

SUB AddDefaultDefines
 SHARED ListBases
 STRING datum, zeit SIZE 16

 DECLARE STRUCT DefineNode *EmptyNode

 datum = CHR$(34) + date$ + CHR$(34)
 zeit  = CHR$(34) + time$ + CHR$(34)

 EmptyNode = ALLOC(SIZEOF(DefineNode),7)
 EmptyNode->ln_Name    = Copy("__DATE")
 EmptyNode->replace    = Copy(datum)
 EmptyNode->CountParam = 0
 AddTail (ListBases->Defines,EmptyNode)

 EmptyNode = ALLOC(SIZEOF(DefineNode),7)
 EmptyNode->ln_Name    = Copy("__TIME")
 EmptyNode->replace    = Copy(zeit)
 EmptyNode->CountParam = 0
 AddTail (ListBases->Defines,EmptyNode)
END SUB

{ ----------------------------------------------------------------- }

Start:
 ADDRESS start2
 start2=TIMER
 Texts(4)

 Options = ALLOC(SIZEOF(optionStruct),7)

 ' Set the defaults.

 Options->Tracing         = 0   ' do not trace
 Options->ShowTime        = 0   ' do not show elapsed time
 Options->Remove_Structs  = 0   ' do not remove unused structures
 Options->Remove_Comments = 1   ' do remove EVERY comment
 Options->Remove_Defines  = 0   ' do not ignore defines
 Options->Const_Defines   = 0   ' do not replace defines by CONST
 Options->Replace_Defines = 1   ' but do replace defines directly
 Options->Print_Errors    = 1   ' do print errors/warnings
 Options->Remove_Lines    = 1   ' do remove empty lines
 Options->Comment_Source  = 0   ' do not comment source

 FOR i=0 TO 3
  liste=ALLOC(SIZEOF(_list),7)
  POKEL ListBases+i*4&,liste
  liste->lh_head  = liste+4
  liste->lh_tailpred = liste
 NEXT

 AddDefaultDefines

 SHORTINT escape
 ADDRESS  ptr

 FOR i=1 TO ARGCOUNT
  argument=ARG$(i)
  IF PEEK(@argument)=45 THEN         ' 45 = "-"
   escape=0
   FOR j=2 TO LEN(argument)
    opt=UCASE$(MID$(argument,j,1))
    CASE
     opt="B":BLOCK
              MaxBuffer=val(MID$(argument,j+1))
              ++escape
              IF MaxBuffer>640 THEN CALL PrErr (106,"")
             END BLOCK
     opt="L":Options->Remove_Lines=1
     opt="Z":Options->ShowTime=1
     opt="T":Options->Tracing=1
     opt="S":Options->Remove_Structs=0
     opt="C":Options->Remove_Comments=0
     opt="I":SWAP Options->Remove_Defines,Options->Replace_Defines
     opt="Q":Options->Const_Defines=1
     opt="E":Options->Print_Errors=0
     opt="X":Options->Comment_source=1
     opt="D":BLOCK
              token=get_name_of_object_alt(j+1,@argument)
              value=MID$(argument,instr(3,argument,token)+LEN(token)+1)
              IF peek(@value)=0 THEN value="1"
              emptydefine=ALLOC(sizeof(definenode),7)
              emptydefine->ln_name=copy(token)
              emptydefine->replace=copy(value)
              emptydefine->countparam=0
              AddTail(ListBases->defines,emptydefine)
              ++escape
             END BLOCK
     opt="P":BLOCK
              object=MID$(argument,j+1)
              FOR x=2 TO 9
               IF peek(@Path(x))=0 THEN Path(x)=object:EXIT FOR
              NEXT
              ++escape
             END BLOCK
     opt="U":BLOCK
              token=MID$(argument,j+1)
              ptr = FindName(ListBases->defines,@token)
              IF ptr THEN CALL Remove(ptr) ELSE CALL PrErr (0,"Can not #UNDEF <"+token+">")
             END BLOCK
     100=100:CALL usage
    END CASE
    IF escape THEN escape=0:exit for
   NEXT
  ELSE
   IF peek(@InFile)=0 THEN
    InFile=argument
   ELSE
    IF peek(@OutFile) THEN CALL Usage
    OutFile=argument
   END IF
  END IF
 NEXT

 IF peek(@OutFile)=0 THEN CALL Usage
 IF MaxBuffer=0 or MaxBuffer>640 THEN MaxBuffer=100
 MaxBuffer=MaxBuffer*1024

 OPEN "O",1,OutFile
 CLOSE #1
 IF Err THEN CALL PrErr (107,""):ende

 OPEN "I",2,InFile
 CLOSE #2
 IF ERR THEN CALL PrErr (109,""):ende

 IF Options->Remove_Defines > 0 THEN Options->Const_Defines=0
 IF Options->Const_Defines > 0 THEN Options->Replace_Defines=0
 IF Options->Remove_Structs=0 THEN TempFile=OutFile
 IF Options->Tracing THEN call texts(2%)

 OPEN "O",1,TempFile
 AddToTemp(2,@InFile)

 liste=ListBases->structures
 IF Options->Remove_Structs THEN
  CLOSE #1
  OPEN "I",2,TempFile
  OPEN "O",1,OutFile
  IF liste->lh_head <> liste+4 THEN
   IF Options->Tracing THEN PRINT
   RemoveStuff
  ELSE
   {* Why should we try to remove structures, if there are none ?? *}

   LONGINT gelesen,written
   ADDRESS buffer
   MaxBuffer=LOF(2)

   buffer=ALLOC(MaxBuffer,7)
   while buffer=0
    MaxBuffer=shr(MaxBuffer,1)
    if MaxBuffer<100 then
     PrErr(108,"")
     Texts(3%)
     OutFile=TempFile
     buffer=-1
    else
     buffer=alloc(MaxBuffer,7)
    end if
   wend
   if buffer>0 then
    repeat
     gelesen=_Read(handle(2),buffer,MaxBuffer)
     if gelesen then written=_Write(handle(1),buffer,gelesen)
    until gelesen<MaxBuffer or written<gelesen
   END IF
  END IF
 END IF

 IF Options->ShowTime THEN ? "Elapsed time :"TIMER-start2
normalexit=1
ende
