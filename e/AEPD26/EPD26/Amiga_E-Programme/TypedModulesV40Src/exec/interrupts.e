OPT MODULE
OPT EXPORT

OPT PREPROCESS

MODULE 'exec/lists',
       'exec/nodes',
       'graphics/displayinfo',
       'graphics/text',
       'workbench/startup'

#define ASLNAME 'asl.library'

CONST ASL_TB=$80080000,
      ASL_FILEREQUEST=0,
      ASL_FONTREQUEST=1,
      ASL_SCREENMODEREQUEST=2

OBJECT filerequester
  reserved0[4]:ARRAY
  file:LONG
  drawer:LONG
  reserved1[10]:ARRAY
  leftedge:INT
  topedge:INT
  wid