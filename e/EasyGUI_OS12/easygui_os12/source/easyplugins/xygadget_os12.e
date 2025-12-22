
/*

    $VER: xygadget_plugin 1.2 (28.11.97)

    Author:         Ali Graham ($01)
                    <agraham@hal9000.net.au>

    PLUGIN id:      $04

    Desc.:          Gadget that resizes in both X and Y directions.

    Tags:           PLA_XYGadget_Text           [ISG]
                    PLA_XYGadget_Disabled       [ISG]

*/

OPT MODULE
OPT PREPROCESS

-> RST: Added conditional EASY_OS12 support
#define EASY_OS12

#ifdef EASY_OS12
  MODULE 'tools/easygui_os12', 'hybrid/tagdata'
  #define GetTagData getTagData
#endif
#ifndef EASY_OS12
  OPT OSVERSION=37
  MODULE 'tools/easygui', 'utility'
#endif

MODULE 'intuition/intuition',
       'graphics/text', 'intuition/gadgetclass',
       'gadtools', 'libraries/gadtools',
       'utility/tagitem'

EXPORT OBJECT xygadget_plugin OF plugin PRIVATE

    contents:PTR TO CHAR
    disabled

    gad:PTR TO gadget

ENDOBJECT

-> PROGRAMMER_ID | MODULE_ID
->      $01      |   $04


EXPORT ENUM PLA_XYGadget_Text=$81040001,
            PLA_XYGadget_Disabled

PROC xygadget(tags=NIL:PTR TO tagitem) OF xygadget_plugin

#ifndef EASY_OS12
    IF utilitybase
#endif

        self.contents:=GetTagData(PLA_XYGadget_Text, '', tags)
        self.disabled:=GetTagData(PLA_XYGadget_Disabled, FALSE, tags)

#ifndef EASY_OS12
    ELSE

        Raise("util")

    ENDIF
#endif

ENDPROC

->> xygadget_plugin: set() & get()

PROC set(attr, value) OF xygadget_plugin

    SELECT attr

        CASE PLA_XYGadget_Text

            IF self.contents<>value

                self.contents:=value

                IF (self.gad AND self.gh.wnd)

                    Gt_SetGadgetAttrsA(self.gad, self.gh.wnd, NIL, [GA_TEXT, self.contents, TAG_DONE])

                ENDIF

            ENDIF

        CASE PLA_XYGadget_Disabled

            IF self.disabled<>value

                self.disabled:=value

                IF (self.gad AND self.gh.wnd)

                    Gt_SetGadgetAttrsA(self.gad, self.gh.wnd, NIL, [GA_DISABLED, self.disabled, TAG_DONE])

                ENDIF

            ENDIF

    ENDSELECT

ENDPROC

PROC get(attr) OF xygadget_plugin

    SELECT attr

        CASE PLA_XYGadget_Text;             RETURN self.contents, TRUE
        CASE PLA_XYGadget_Disabled;         RETURN self.disabled, TRUE

    ENDSELECT

ENDPROC -1, FALSE

-><

PROC min_size(ta:PTR TO textattr, fh) OF xygadget_plugin
ENDPROC (IntuiTextLength([1, 0, NIL, 0, 0, ta, self.contents, NIL]:intuitext)+16), (fh+12)

->PROC will_resize() OF xygadget_plugin IS (RESIZEX OR RESIZEY)

PROC gtrender(gl, vis, ta:PTR TO textattr, x, y, xs, ys, win:PTR TO window) OF xygadget_plugin

    self.gad:=CreateGadgetA(BUTTON_KIND, gl,
                            [x, y, xs, ys, self.contents, ta, NIL, 0, vis, 0]:newgadget,
                            [GA_DISABLED, self.disabled,
                             TAG_DONE])

ENDPROC self.gad

PROC message_test(imsg:PTR TO intuimessage, win:PTR TO window) OF xygadget_plugin

  IF imsg.class=IDCMP_GADGETUP THEN RETURN (imsg.iaddress=self.gad)

ENDPROC FALSE

-> this ensures that the defined action in the EasyGUI layout is called
PROC message_action(class, qual, code, win:PTR TO window) OF xygadget_plugin IS TRUE

/* &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& */


