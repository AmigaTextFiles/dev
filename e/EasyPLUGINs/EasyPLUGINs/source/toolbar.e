
/*

    $VER: toolbar_plugin 1.1 (25.3.98)

    Author:         Ali Graham ($01)
                    <agraham@hal9000.net.au>

    PLUGIN id:      $03

    Desc.:          Toolbar that displays multiple gadgets.

    Tags:           PLA_ToolBar_Contents             [I..]
                    PLA_ToolBar_Disabled             [ISG]
                    PLA_ToolBar_DisplayAll           [I..]
                    PLA_ToolBar_Font                 [I.G]
                    PLA_ToolBar_Function             [IS.]
                    PLA_ToolBar_Vertical             [I..]

*/

OPT MODULE, PREPROCESS, OSVERSION=37, NOWARN

->> toolbar_plugin: Modules

MODULE 'tools/easygui', 'graphics/text', 'tools/ghost',
       'gadtools', 'libraries/gadtools',
       'intuition/gadgetclass',
       'intuition/intuition', 'graphics/rastport'

MODULE 'utility', 'utility/tagitem'

-><

/* $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ */

->> toolbar_plugin: Definitions

EXPORT OBJECT toolbar_plugin OF plugin PRIVATE

    contents:PTR TO LONG
    disabled
    display_all
    font:PTR TO textattr
    function:PTR TO LONG
    vertical

    total_gadgets
    valid_gadgets
    gadget_ptrs:PTR TO LONG

ENDOBJECT

#define GadgetWidth(text, font) (IntuiTextLength([1, 0, RP_JAM1,\
                                 0, 0, font, text, NIL]:intuitext) + 12)

#define GadgetHeight(font)      (font.ysize + 4)

-> PROGRAMMER_ID | MODULE_ID
->      $01      |   $03


EXPORT ENUM PLA_ToolBar_Contents=$81030001,     -> [I..]
            PLA_ToolBar_Disabled,               -> [ISG]
            PLA_ToolBar_DisplayAll,             -> [I..]
            PLA_ToolBar_Font,                   -> [I.G]
            PLA_ToolBar_Function,               -> [IS.]
            PLA_ToolBar_Vertical                -> [I..]

CONST X_GAP=3, Y_GAP=2

-><

/* $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ */

->> toolbar_plugin: toolbar() & end()

PROC toolbar(tags=NIL:PTR TO tagitem) OF toolbar_plugin

    IF utilitybase

        self.contents    := GetTagData(PLA_ToolBar_Contents, ['Default'], tags)
        self.disabled    := GetTagData(PLA_ToolBar_Disabled, FALSE, tags)
        self.display_all := GetTagData(PLA_ToolBar_DisplayAll, FALSE, tags)
        self.function    := GetTagData(PLA_ToolBar_Function, NIL, tags)
        self.font        := GetTagData(PLA_ToolBar_Font, NIL, tags)
        self.vertical    := GetTagData(PLA_ToolBar_Vertical, FALSE, tags)

    ELSE

        Raise("util")

    ENDIF

    IF self.contents

        IF ListLen(self.contents)>0

            self.total_gadgets:=ListLen(self.contents)

            self.gadget_ptrs:=List(self.total_gadgets)

        ENDIF

    ENDIF

ENDPROC

PROC end() OF toolbar_plugin

    IF self.gadget_ptrs THEN Dispose(self.gadget_ptrs)

ENDPROC

-><

->> toolbar_plugin: set() & get()

PROC set(attr, value) OF toolbar_plugin

    DEF a

    SELECT attr

        CASE PLA_ToolBar_Disabled

            IF self.disabled<>value

                self.disabled:=value

                FOR a:=0 TO (self.valid_gadgets-1)

                    IF (self.gadget_ptrs[a])

                        Gt_SetGadgetAttrsA(self.gadget_ptrs[a], self.gh.wnd, NIL, [GA_DISABLED, self.disabled, TAG_DONE])

                    ENDIF

                ENDFOR

            ENDIF

        CASE PLA_ToolBar_Function

            self.function:=value

    ENDSELECT

ENDPROC

PROC get(attr) OF toolbar_plugin

    SELECT attr

        CASE PLA_ToolBar_Disabled;  RETURN self.disabled, TRUE
        CASE PLA_ToolBar_Font;      RETURN self.font, TRUE

    ENDSELECT

ENDPROC -1, FALSE

-><

->> toolbar_plugin: min_size() & will_resize()
PROC min_size(font:PTR TO textattr, font_height) OF toolbar_plugin

    DEF width=0, height=0, a

    IF self.total_gadgets

        IF self.display_all

            FOR a:=0 TO (self.total_gadgets-1)

                IF self.vertical

                    width:=Max(width, GadgetWidth(self.contents[a], (IF self.font THEN self.font ELSE font)))
                    height:=height + GadgetHeight(IF self.font THEN self.font ELSE font)

                    IF (a < (self.total_gadgets-1)) THEN height:=height + Y_GAP

                ELSE

                    width:=width + GadgetWidth(self.contents[a], (IF self.font THEN self.font ELSE font))

                    IF (a < (self.total_gadgets-1)) THEN width:=width + X_GAP

                ENDIF

            ENDFOR

        ELSE

            IF self.vertical

                FOR a:=0 TO (self.total_gadgets-1)

                    width:=Max(width, GadgetWidth(self.contents[a], (IF self.font THEN self.font ELSE font)))

                ENDFOR

            ELSE

                width:=GadgetWidth(self.contents[0], (IF self.font THEN self.font ELSE font))

            ENDIF

        ENDIF

        IF (self.display_all=FALSE) OR (self.vertical=FALSE)

            height:=GadgetHeight(IF self.font THEN self.font ELSE font)

        ENDIF

    ENDIF

ENDPROC width, height

PROC will_resize() OF toolbar_plugin IS (IF self.vertical THEN RESIZEY ELSE RESIZEX)
-><

->> toolbar_plugin: gtrender()
PROC gtrender(gl, vis, font:PTR TO textattr, x, y, xs, ys, win:PTR TO window) OF toolbar_plugin

    DEF a, x_loc, y_loc, g_width, g_height

    self.valid_gadgets:=NIL

    IF self.vertical

        y_loc:=y

        g_height:=GadgetHeight(IF self.font THEN self.font ELSE font)

        FOR a:=0 TO (self.total_gadgets-1)

            EXIT ((y_loc + g_height) > (y + ys))

            self.gadget_ptrs[a]:=CreateGadgetA(BUTTON_KIND, (IF (a=0) THEN gl ELSE self.gadget_ptrs[a-1]),
                                               [x, y_loc, xs, g_height, self.contents[a],
                                               (IF self.font THEN self.font ELSE font),
                                                (a + 1), NIL, vis, FALSE]:newgadget,
                                               [GA_DISABLED, self.disabled,
                                                TAG_DONE])

            self.valid_gadgets:=self.valid_gadgets + 1

            y_loc:=y_loc + g_height + Y_GAP

        ENDFOR

        IF (y_loc < (y + ys)) AND (self.valid_gadgets=self.total_gadgets)

            ghost(win, x, y_loc, xs, ((y + ys) - y_loc))

                ->WriteF('toolbar $\h\n x = \d\n xs = \d\n  y = \d\n ys = \d\n y_loc = \d\n y + ys - y_loc = \d\n',
                ->       self, x, xs, y, ys, y_loc, y + ys - y_loc)

            ->ENDIF

        ENDIF

    ELSE

        x_loc:=x

        FOR a:=0 TO (self.total_gadgets-1)

            g_width:=GadgetWidth(self.contents[a], (IF self.font THEN self.font ELSE font))

            EXIT ((x_loc + g_width) > (x + xs))

            self.gadget_ptrs[a]:=CreateGadgetA(BUTTON_KIND, (IF (a=0) THEN gl ELSE self.gadget_ptrs[a-1]),
                                               [x_loc, y, g_width, ys, self.contents[a],
                                               (IF self.font THEN self.font ELSE font),
                                                (a + 1), NIL, vis, FALSE]:newgadget,
                                               [GA_DISABLED, self.disabled,
                                                TAG_DONE])

            self.valid_gadgets:=self.valid_gadgets + 1

            x_loc:=x_loc + g_width + X_GAP

        ENDFOR

        IF (x_loc < (x + xs)) AND (self.valid_gadgets=self.total_gadgets)

            ghost(win, x_loc, y, ((x + xs) - x_loc), ys)

        ENDIF

    ENDIF

ENDPROC (IF self.valid_gadgets>0 THEN self.gadget_ptrs[self.valid_gadgets-1] ELSE gl)
-><

->> toolbar_plugin: message_test() & message_action()

PROC message_test(imsg:PTR TO intuimessage, win:PTR TO window) OF toolbar_plugin

    DEF a, ret=FALSE, gadget:PTR TO newgadget

    IF imsg.class=IDCMP_GADGETUP

        FOR a:=0 TO (self.valid_gadgets-1)

            IF (imsg.iaddress=self.gadget_ptrs[a])

                gadget:=self.gadget_ptrs[a]

                gadget.userdata:=TRUE
                ret:=TRUE

            ENDIF

            EXIT ret

        ENDFOR

    ENDIF

ENDPROC ret

PROC message_action(class, qual, code, win:PTR TO window) OF toolbar_plugin

    DEF a, gadget:PTR TO newgadget, function:PTR TO LONG

    IF class=IDCMP_GADGETUP

        FOR a:=0 TO (self.valid_gadgets-1)

            IF (gadget:=self.gadget_ptrs[a])

                IF gadget.userdata

                    function:=self.function

                    function(self, (a+1))
                    gadget.userdata:=FALSE

                ENDIF

            ENDIF

        ENDFOR

    ENDIF

ENDPROC FALSE

-><
