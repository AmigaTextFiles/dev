
/*

    $VER: bar_plugin 1.0 (25.5.98)

    Author:         Ali Graham
                    <agraham@hal9000.net.au>

    Desc.:          Replacement for BAR with percentile width.

*/


OPT MODULE, OSVERSION=37

MODULE 'tools/easygui',
       'intuition/intuition',
       'utility', 'utility/tagitem'

EXPORT OBJECT bar_plugin OF plugin PRIVATE

    percent
    vertical

ENDOBJECT

-> PROGRAMMER_ID | MODULE_ID
->      $01      |   $08


EXPORT ENUM PLA_Bar_Percent=$81080001,     ->[IS.]
            PLA_Bar_Vertical               ->[I..]

PROC bar(tags=NIL:PTR TO tagitem) OF bar_plugin

    IF utilitybase

        self.percent  := GetTagData(PLA_Bar_Percent, 100, tags)
        IF self.percent<0 THEN self.percent:=0; IF self.percent>100 THEN self.percent:=100

        self.vertical:= GetTagData(PLA_Bar_Vertical, FALSE, tags)

    ELSE

        Raise("util")

    ENDIF

ENDPROC

PROC set(attr, value) OF bar_plugin

    SELECT attr

        CASE PLA_Bar_Percent

            IF self.percent<>value

                self.percent:=value

                self.draw()

            ENDIF

    ENDSELECT

ENDPROC

PROC draw(win=NIL:PTR TO window) OF bar_plugin

    DEF width, height, gap

    IF (win=NIL) THEN win:=self.gh.wnd

    SetStdRast(win.rport)

    Box(self.x, self.y, self.x + self.xs -1, self.y + self.ys -1, 0)

    IF self.percent>0

        IF self.vertical

            height:=((self.ys * self.percent) / 100)
            gap:=(self.ys - height)/2

            Line((self.x + 1), (self.y + gap), (self.x + 1), ((self.y + self.ys - 1) - gap), 1)
            Line((self.x + 2), (self.y + gap), (self.x + 2), ((self.y + self.ys - 1) - gap), 2)

        ELSE

            width:=((self.xs * self.percent) / 100)
            gap:=(self.xs - width)/2

            Line((self.x + gap), (self.y + 1), ((self.x + self.xs - 1) - gap), (self.y + 1), 1)
            Line((self.x + gap), (self.y + 2), ((self.x + self.xs - 1) - gap), (self.y + 2), 2)

        ENDIF

    ENDIF

ENDPROC

PROC min_size(ta,fh) OF bar_plugin

    DEF ret_x, ret_y

    IF self.vertical

        ret_x:=4
        ret_y:=8

    ELSE

        ret_x:=8
        ret_y:=4

    ENDIF

ENDPROC ret_x, ret_y

PROC will_resize() OF bar_plugin IS (IF self.vertical THEN RESIZEY ELSE RESIZEX)

PROC render(ta, x, y, xs, ys, win:PTR TO window) OF bar_plugin

    self.draw(win)

ENDPROC


