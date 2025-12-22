-> easyrexx.e - source for easyrexx.m
-> 
-> (C) 1994,1995 Ketil Hunn
->
-> Converted from C to E by Leon Woestenberg (leon@stack.urc.tue.nl)

OPT MODULE

MODULE 'exec/ports'
MODULE 'utility/tagitem'
MODULE 'rexx/errors'
MODULE 'exec/io'
MODULE 'graphics/text'
MODULE 'dos/rdargs'
MODULE 'exec/lists'
MODULE 'exec/memory'
MODULE 'rexx/storage'
MODULE 'intuition/intuition'

EXPORT OBJECT arexxcommandtable
  id:LONG
  command:PTR TO CHAR
  cmdtemplate:PTR TO CHAR
  userdata:LONG
ENDOBJECT

EXPORT OBJECT arexxcommandshell
  commandwindow:PTR TO window
  readport:PTR TO mp
  writeport:PTR TO mp
  readreq:PTR TO iostd
  writereq:PTR TO iostd
  prompt:PTR TO CHAR
  buffer[256]:ARRAY OF CHAR
  ibuf:CHAR
  inbuffer:CHAR
  cursor:CHAR
  font:PTR TO textfont
ENDOBJECT

EXPORT OBJECT arexxcontext
  port:PTR TO mp
  table:PTR TO arexxcommandtable
  argcopy:PTR TO CHAR
  -> Will contain the actual name of the ARexx port
  portname:PTR TO CHAR
  maxargs:CHAR
  rdargs:PTR TO rdargs
  msg:PTR TO rexxmsg
  flags:LONG
  id:LONG
  argv:PTR TO LONG
  -> FROM HERE AND DOWN; ONLY AVAILABLE FROM V2
  queue:LONG
  author:PTR TO CHAR
  copyright:PTR TO CHAR
  version:PTR TO CHAR
  lasterror:PTR TO CHAR
  reservedcommands:PTR TO arexxcommandtable
  shell:PTR TO arexxcommandshell
  signals:LONG
  result1:LONG
  result2:LONG
  asynchport:PTR TO mp
ENDOBJECT

EXPORT OBJECT arexxmacrodata
  list:PTR TO lh
ENDOBJECT

EXPORT CONST
  ER_RECORDPOINTERWIDTH=16,
  ER_RECORDPOINTERHEIGHT=17,
  ER_RECORDPOINTEROFFSET=-1

-> EASYREXX TAGS
EXPORT CONST
 ER_TagBase                  =TAG_USER
EXPORT CONST
 ER_Portname                 =ER_TagBase+1,  -> Name of AREXX port
 ER_CommandTable             =ER_TagBase+2,  -> Table of supported AREXX commands
 ER_ReturnCode               =ER_TagBase+3   -> Primary result (return code)
EXPORT CONST
 ER_Result                   =ER_ReturnCode, -> Alias for ER_ReturnCode
 ER_Result1                  =ER_ReturnCode  -> Alias for ER_ReturnCode
EXPORT CONST
 ER_Result2                  =ER_TagBase+4,  -> Secondary result (string)
 ER_Port                     =ER_TagBase+5,  -> Use already created port
 ER_ResultString             =ER_TagBase+6,  -> Secondary result (string)
 ER_ResultLong               =ER_TagBase+7   -> Secondary result (long)

-> EASYREXX V2 TAGS
EXPORT CONST
 ER_Asynch                   =ER_TagBase+8,  -> Send ARexx command asyncronously
 ER_Context                  =ER_TagBase+9,  -> Pointer to an ARexxContext
 ER_Author                   =ER_TagBase+10, -> Pointer to an author string
 ER_Copyright                =ER_TagBase+11, -> Pointer to an copyright string
 ER_Version                  =ER_TagBase+12, -> Pointer to an version string
 ER_Prompt                   =ER_TagBase+13, -> Pointer to a prompt string
 ER_Close                    =ER_TagBase+14, -> Close CommandShell
 ER_ErrorMessage             =ER_TagBase+15, -> Pointer to an error message
 ER_Flags                    =ER_TagBase+16, -> LONG of flags
 ER_Font                     =ER_TagBase+17, -> Pointer to a struct TextFont

-> EASYREXX V3 TAGS
 ER_Macro                    =ER_TagBase+18, -> Pointer to ARexxMacro
 ER_MacroFile                =ER_TagBase+19, -> Pointer to a macrofile
 ER_Record                   =ER_TagBase+20, -> Really record macro command
 ER_File                     =ER_TagBase+21, -> Send file
 ER_String                   =ER_TagBase+22, -> Send string
 ER_Command                  =ER_TagBase+23, -> Pointer to commandstring
 ER_Arguments                =ER_TagBase+24  -> Var-array of arguments
EXPORT CONST
 ER_Argument                 =ER_Arguments,
 ER_ArgumentsLength          =ER_TagBase+25  -> CharLength of command+arguments
EXPORT CONST
 ER_ArgumentLength           =ER_ArgumentsLength

-> module private pointer
DEF recordpointer

-> This function serves the ER_RecordPointer, which must be in CHIPMEM.
EXPORT PROC er_RecordPointer()
  -> if this is the first call, make sure it is in chipmem
  IF recordpointer=NIL
    -> get a pointer to the static data
    recordpointer:={static}
    -> check if it is not in chipmem yet
    IF (TypeOfMem(recordpointer) AND MEMF_CHIP)=0
      -> allocate some chip memory for the static data
      recordpointer:=NewM(38*2,MEMF_CHIP)
      -> the memory will be freed automagically be the E compiler upon exit
      -> copy to chipmem, quick because every number is divisible by 4.
      CopyMemQuick({static},recordpointer,38*2)
    ENDIF
  ENDIF
ENDPROC recordpointer

-> make sure static is longword alligned, so we can use CopyMemQuick
LONG 0
-> the recordpointer data
static:
INT $0000,$0000,$c000,$4000,$7000,$b000,$3c00,$4c00,$3f00,$4300,$1fc0,$20c0,$1fc0,$2000,$0f00,$1100,$0d80,$1280,$04c0,$0940,$0460,$08a0,$0020,$0040,$0000,$0000,$0000,$e798,$0000,$9424,$0000,$e720,$0000,$9424,$0000,$9798,$0000,$0000

