/*
 * Games Master System - demo-source
 *
 * Name: DPrintF.e
 * Type: Demonstrates how to use DPrintF() in E.
 * Version: 1.0
 * Author: G. W. Thomassen
 * GMS version: 1.0
 */

MODULE 'gms/dpkernel','gms/dpkernel/dpkernel',
       'gms/system/debug'

ENUM NONE,ERR_LIB

PROC main() HANDLE
  DEF str[65]:STRING

  IF (dpkbase:=OpenLibrary('GMS:Libs/dpkernel.library',1))=NIL THEN Raise(ERR_LIB)

  WriteF('Run IceBreaker to monitor the output..\n')

  -> Just make it easy to find it in the IceBreaker window
  DprintF(' #####',['--dprintf---------------------------'])

  -> Output a string first
  StrCopy(str,'It\as pretty easy when you know how!',ALL)
  DprintF('##',['%s',str])

  -> Then try a string and a decimal
  DprintF('##',['%s %d','The number is: ',12])

  -> You can put some text into the first array too..
  DprintF('####',['%s or not!!','belive it'])

  -> You can put some text into the first array too and add a hex!
  DprintF('##',['Hex number: $%x',$44])

  -> The End!
  DprintF('##',['The End!'])

  DprintF('######## (gWt^98)',['---------------------------dprintf--'])
  Raise(NONE)   -> No error...
EXCEPT DO
  CloseDPK()
  IF exception=ERR_LIB THEN WriteF('Error: Couldn\at open dpkernel.library\n')
ENDPROC
