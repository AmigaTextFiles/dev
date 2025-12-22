
/*

    $VER: multitext_plugin 1.5 (25.5.98)

    Author:         Ali Graham ($01)
                    <agraham@hal9000.net.au>

    PLUGIN id:      $02

    Desc.:          TEXT replacement with a number of features.

    Tags:           PLA_MultiText_Text                   [I..]
                    PLA_MultiText_Highlight              [IS.]
                    PLA_MultiText_ThreeD                 [IS.]
                    PLA_MultiText_Justification          [IS.]
                    PLA_MultiText_DrawBar                [IS.]
                    PLA_MultiText_Font                   [I..]
                    PLA_MultiText_Disabled               [IS.]
                    PLA_MultiText_ShowWhenDisabled       [IS.]
                    PLA_MultiText_GapHorizontal          [i..]
                    PLA_MultiText_GapVertical            [i..]
                    PLA_MultiText_Resize                 [I..]

    Values:         PLV_MultiText_JustifyCenter
                    PLV_MultiText_JustifyLeft
                    PLV_MultiText_JustifyRight

*/

OPT MODULE, PREPROCESS, OSVERSION=37

->> multitext_plugin: Modules

MODULE 'tools/easygui', 'graphics/text', 'tools/ghost',
       'intuition/intuition', 'intuition/screens',
       'graphics/rastport'

MODULE 'utility', 'utility/tagitem'

-><

/* $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ */

->> multitext_plugin: Definitions
EXPORT OBJECT multitext_plugin OF plugin PRIVATE

    contents:PTR TO LONG
    highlight
    three_d
    justification
    draw_bar
    font:PTR TO textattr
    disabled
    disabled_show
    resize
    gap_h
    gap_v

    num_lines

    texts_width
    texts_height

    default_font:PTR TO textattr

ENDOBJECT

-> PROGRAMMER_ID | MODULE_ID
->      $01      |   $02

EXPORT ENUM PLA_MultiText_Text=$81020001,        ->[I..]
            PLA_MultiText_Highlight,             ->[IS.]
            PLA_MultiText_ThreeD,                ->[IS.]
            PLA_MultiText_Justification,         ->[IS.]
            PLA_MultiText_DrawBar,               ->[IS.]
            PLA_MultiText_Font,                  ->[I..]
            PLA_MultiText_Disabled,              ->[IS.]
            PLA_MultiText_ShowWhenDisabled,      ->[IS.]
            PLA_MultiText_GapHorizontal,         ->[i..]
            PLA_MultiText_GapVertical,           ->[i..]
            PLA_MultiText_Resize                 ->[I..]

EXPORT ENUM PLV_MultiText_JustifyCenter=0,
            PLV_MultiText_JustifyLeft,
            PLV_MultiText_JustifyRight

-><

/* $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ */

->> multitext_plugin: multitext()
PROC multitext(tags=NIL:PTR TO tagitem) OF multitext_plugin

    IF utilitybase

        self.contents       := GetTagData(PLA_MultiText_Text, [' '], tags)
        self.highlight      := GetTagData(PLA_MultiText_Highlight, FALSE, tags)
        self.three_d        := GetTagData(PLA_MultiText_ThreeD, FALSE, tags)
        self.font           := GetTagData(PLA_MultiText_Font, NIL, tags)
        self.justification  := GetTagData(PLA_MultiText_Justification, PLV_MultiText_JustifyCenter, tags)
        self.draw_bar       := GetTagData(PLA_MultiText_DrawBar, FALSE, tags)
        self.disabled       := GetTagData(PLA_MultiText_Disabled, FALSE, tags)
        self.disabled_show  := GetTagData(PLA_MultiText_ShowWhenDisabled, TRUE, tags)
        self.resize         := GetTagData(PLA_MultiText_Resize, TRUE, tags)
        self.gap_h          := GetTagData(PLA_MultiText_GapHorizontal, 2, tags)
        self.gap_v          := GetTagData(PLA_MultiText_GapVertical, 1, tags)

    ELSE

        Raise("util")

    ENDIF

    IF self.contents THEN self.num_lines:=ListLen(self.contents)

ENDPROC
-><

->> multitext_plugin: set() & get()

PROC set(attr, value) OF multitext_plugin

    SELECT attr

        CASE PLA_MultiText_Highlight

            IF self.highlight<>value

                self.highlight:=value

                IF (self.disabled=FALSE) OR self.disabled_show THEN  self.draw(self.gh.wnd)

            ENDIF

        CASE PLA_MultiText_ThreeD

            IF self.three_d<>value

                self.three_d:=value

                IF (self.disabled=FALSE) OR self.disabled_show THEN  self.draw(self.gh.wnd)

            ENDIF

        CASE PLA_MultiText_Justification

            IF self.justification<>value

                IF (value >= PLV_MultiText_JustifyCenter) AND (value <= PLV_MultiText_JustifyRight)

                    self.justification:=value

                    IF (self.disabled=FALSE) OR self.disabled_show THEN  self.draw(self.gh.wnd)

                ENDIF

            ENDIF

        CASE PLA_MultiText_DrawBar

            IF self.draw_bar<>value

                self.draw_bar:=value

                IF (self.disabled=FALSE) OR self.disabled_show THEN  self.draw(self.gh.wnd)

            ENDIF

        CASE PLA_MultiText_Disabled

            IF self.disabled<>value

                self.disabled:=value

                self.draw(self.gh.wnd)

            ENDIF

        CASE PLA_MultiText_ShowWhenDisabled

            IF self.disabled_show<>value

                self.disabled_show:=value

                IF self.disabled THEN self.draw(self.gh.wnd)

            ENDIF

    ENDSELECT

ENDPROC

PROC get(attr) OF multitext_plugin IS -1, FALSE

-><

->> multitext_plugin: draw()
PROC draw(win:PTR TO window) OF multitext_plugin

    DEF justification, a, cursor_height,
        left_side, right_side, text_start,
        text_width, line_height,
        font:PTR TO textattr

    IF win

        SetStdRast(win.rport)

        clear(win, self.x, self.y, self.xs, self.ys)

        IF (self.disabled=FALSE) OR self.disabled_show

            font:=(IF self.font THEN self.font ELSE self.default_font)

            justification:=self.justification

            cursor_height:=self.y + self.gap_h
            line_height:=cursor_height + (font.ysize / 2)

            FOR a:=0 TO (self.num_lines-1)

                left_side:=self.x + self.gap_h
                right_side:=self.x + self.xs - (self.gap_v + 1)

                text_width:=IntuiTextLength([1, 0, RP_JAM1, 0, 0, font, self.contents[a], NIL]:intuitext)

                SELECT justification

                    CASE PLV_MultiText_JustifyLeft

                        print_text(self, self.contents[a], font, left_side, cursor_height)
                        IF self.draw_bar THEN draw_line((left_side + text_width + 4), right_side, line_height)

                    CASE PLV_MultiText_JustifyRight

                        IF self.draw_bar THEN draw_line(left_side, (right_side - (text_width + 4)), line_height)
                        print_text(self, self.contents[a], font, (right_side - text_width), cursor_height)

                    DEFAULT

                        text_start:=left_side + (((right_side - left_side) - text_width) / 2) + 1

                        IF self.draw_bar THEN draw_line(left_side, (text_start - 4), line_height)
                        print_text(self, self.contents[a], font, text_start, cursor_height)
                        IF self.draw_bar THEN draw_line((text_start + text_width + 4), right_side, line_height)

                ENDSELECT

                cursor_height:=cursor_height + font.ysize + 2
                line_height:=cursor_height + (font.ysize / 2)

            ENDFOR

        ENDIF

        IF self.disabled THEN ghost(win, self.x, self.y, self.xs, self.ys)

    ENDIF
    
ENDPROC
-><

->> multitext_plugin: min_size() & will_resize()
PROC min_size(font:PTR TO textattr, font_height) OF multitext_plugin

    DEF a

    self.texts_width:=0
    self.texts_height:=0

    IF self.font

        font:=self.font
        font_height:=self.font.ysize

    ENDIF

    FOR a:=0 TO (self.num_lines-1)

        self.texts_width:=Max(self.texts_width, IntuiTextLength([1, 0, RP_JAM1, 0, 0, font, self.contents[a], NIL]:intuitext))

        self.texts_height:=self.texts_height + font_height + 2

    ENDFOR

ENDPROC (self.texts_width + (self.gap_h * 2)), (self.texts_height + (self.gap_v * 2))

PROC will_resize() OF multitext_plugin IS (IF self.resize THEN COND_RESIZEX ELSE FALSE)

-><

->> multitext_plugin: render()

PROC render(font:PTR TO textattr, x, y, xs, ys, win:PTR TO window) OF multitext_plugin

    self.default_font:=font

    self.draw(win)

ENDPROC

-><

->> private to multitext_plugin.draw(): draw_line() & print_text()
PROC draw_line(x1, x2, y)

    Line(x1, y, x2, y, 1)
    Line(x1, y+1, x2, y+1, 2)

ENDPROC

PROC print_text(m:PTR TO multitext_plugin, text:PTR TO CHAR, font:PTR TO textattr, x, y)

    DEF bt_col, ft_col

    IF m.highlight

        bt_col:=1; ft_col:=2

    ELSE

        bt_col:=2; ft_col:=1

    ENDIF

    IF m.three_d THEN PrintIText(stdrast, [bt_col, 0, RP_JAM1, 1, 1, font, text, NIL]:intuitext, x, y)

    PrintIText(stdrast, [ft_col, 0, RP_JAM1, 0, 0, font, text, NIL]:intuitext, x, y)

ENDPROC
-><



