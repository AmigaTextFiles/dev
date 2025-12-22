OPT MODULE

MODULE  'oomodules/file/textfile/document'

EXPORT OBJECT hyperTextDocument OF document
  nodeList:PTR TO LONG
ENDOBJECT

EXPORT OBJECT hyperTextNode OF textBlock
  identifier:PTR TO CHAR
  title:PTR TO CHAR
ENDOBJECT

PROC display() OF hyperTextDocument IS EMPTY

PROC edit() OF hyperTextDocument IS EMPTY

PROC buildNodeList() OF hyperTextDocument IS EMPTY

