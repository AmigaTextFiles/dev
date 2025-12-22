-> fontreq.e

MODULE 'asl',
       'graphics/text',
       'libraries/asl'

ENUM ERR_NONE, ERR_ASL, ERR_KICK, ERR_LIB

RAISE ERR_ASL  IF AllocAslRequest()=NIL,
      ERR_KICK IF KickVersion()=FALSE,
      ERR_LIB  IF OpenLibrary()=NIL

PROC main() HANDLE
  DEF fr=NIL:PTR TO fontrequester
  KickVersion(37)  -> E-Note: requires V37
  aslbase:=OpenLibrary('asl.library', 37)
  fr:=AllocAslRequest(ASL_FONTREQUEST,
          -> Tell the requester to use my custom mode names:
          -> Our replacement strings for the "mode" cycle gadget.  The first
          -> string is the cycle gadget's label.  The other strings are the
          -> actual strings that will appear on the cycle gadget.
          [ASL_MODELIST, ['RKM Modes', 'Mode 0', 'Mode 1', 'Mode 2',
                          'Mode 3', 'Mode 4',NIL],
           -> Supply initial values for requester
           ASL_FONTNAME,   'topaz.font',
           ASL_FONTHEIGHT, 11,
           ASL_FONTSTYLES, FSF_BOLD OR FSF_ITALIC,
           ASL_FRONTPEN,   0,
           ASL_BACKPEN,    1,

           -> Only display font sizes between 8 and 14, inclusive.
           ASL_MINHEIGHT,  8,
           ASL_MAXHEIGHT,  14,

           -> Give all the gadgetry, but only display fixed width fonts
           ASL_FUNCFLAGS,  FONF_FRONTCOLOR OR FONF_BACKCOLOR OR
                           FONF_DRAWMODE OR FONF_STYLES OR FONF_FIXEDWIDTH,
           NIL])
  -> Pop up the requester
  IF AslRequest(fr, NIL)
    -> The user selected something,  report their choice
    WriteF('\s\n  YSize = \d  Style = $\h   Flags = $\h\n'+
           '  FPen = $\h   BPen = $\h   DrawMode = $\h\n',
           fr.attr.name, fr.attr.ysize, fr.attr.style, fr.attr.flags,
           fr.frontpen,  fr.backpen,    fr.drawmode)
  ELSE
    -> The user cancelled the requester, or some kind of error occurred
    -> preventing the requester from opening.
    WriteF('Request Cancelled\n')
  ENDIF
EXCEPT DO
  IF fr THEN FreeAslRequest(fr)
  IF aslbase THEN CloseLibrary(aslbase)
  SELECT exception
  CASE ERR_ASL;  WriteF('Error: Could not allocate ASL request\n')
  CASE ERR_KICK; WriteF('Error: Requires V37\n')
  CASE ERR_LIB;  WriteF('Error: Could not open ASL library\n')
  ENDSELECT
ENDPROC

vers: CHAR 0, '$VER: fontreq 37.0', 0
