OPT     OSVERSION =37
OPT     MODULE
OPT     EXPORT

MODULE  'newgui/newgui'

PROC ng_showerror(code)
 IF (code>0) AND (code<ERR_NG_END)
  SELECT code
        CASE    ERR_NG_MENU
                WriteF('Unable to generate the menu-bar!\n')
        CASE    ERR_NG_BIG
                WriteF('Gui is to big or font too large!\n')
        CASE    ERR_NG_VISUAL
                WriteF('Couldn`t get the VisualInfo from the Screen!\n')
        CASE    ERR_NG_WINOPEN
                WriteF('Unable to open the GUI-window!\n')
        CASE    ERR_NG_LIB
                WriteF('Unable to open a needed library!\n')
        CASE    ERR_NG_SCREEN
                WriteF('Wrong Screen-definition!\n')
        CASE    ERR_NG_MSGPORT
                WriteF('Couldn`t create a message-port!\n')
        CASE    ERR_NG_CONTEXT
                WriteF('Couldn`t create the GadTools-Context!\n')
        CASE    ERR_NG_GUI
                WriteF('Error in calculating the GUI-Offsets, maybe too big REL-Sizes!\n')
        CASE    ERR_NG_SYNTAX
                WriteF('Syntax Error! Unexpected Element in GUI-Description!\n')
        CASE    ERR_NG_FEWARGS
                WriteF('Too Few Arguments for one element!\n')
        CASE    ERR_NG_PLUGIN
                WriteF('Plugin is NIL! Maybe memory-Low ?!\n')
        CASE    ERR_NG_CREATEGAD
                WriteF('Couldn`t create Gadget!\n')
  ENDSELECT
 ELSE
  WriteF('Not an NewGUI-Errorcode!\n')
 ENDIF
ENDPROC
