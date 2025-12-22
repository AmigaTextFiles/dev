
/*

    $VER: iconbox_plugin 1.4 (30.1.98)

    Author:         Ali Graham ($01)
                    <agraham@hal9000.net.au>

    PLUGIN id:      $01

    Desc.:          A box to display icon images and accept icon drops.

    Tags:           PLA_IconBox_IconName            [ISG]
                    PLA_IconBox_ShowSelected        [ISG]
                    PLA_IconBox_Disabled            [ISG]

*/

OPT MODULE, OSVERSION=37

->> iconbox_plugin: Modules
MODULE 'tools/easygui', 'graphics/text',
       'intuition/intuition', 'graphics/rastport'

MODULE 'utility', 'utility/tagitem'

MODULE 'workbench/workbench', 'workbench/startup', 'icon'

MODULE 'tools/ghost'

-><

/* $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ */

->> iconbox_plugin: Definitions
EXPORT OBJECT iconbox_plugin OF plugin PRIVATE

    name
    selected
    disabled

    icon:PTR TO diskobject

ENDOBJECT

-> PROGRAMMER_ID | MODULE_ID
->      $01      |   $01

EXPORT ENUM PLA_IconBox_IconName=$81010001,
            PLA_IconBox_ShowSelected,
            PLA_IconBox_Disabled

-><

/* $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ */

->> iconbox_plugin: iconbox() & end()

PROC iconbox(tags=NIL:PTR TO tagitem) OF iconbox_plugin

    IF (utilitybase AND iconbase)

        self.name     := self.set(PLA_IconBox_IconName, GetTagData(PLA_IconBox_IconName, '', tags))
        self.selected := GetTagData(PLA_IconBox_ShowSelected, FALSE, tags)
        self.disabled := GetTagData(PLA_IconBox_Disabled, FALSE, tags)

    ELSE

        Raise("iblb")

    ENDIF

ENDPROC

PROC end() OF iconbox_plugin IS self.set(PLA_IconBox_IconName, NIL)

-><

->> iconbox_plugin: set() & get()

PROC set(attr, value) OF iconbox_plugin

    SELECT attr

        CASE PLA_IconBox_IconName

            IF self.name<>value

                IF self.icon

                    FreeDiskObject(self.icon)
                    self.icon:=NIL

                ENDIF

                IF value

                    IF StrLen(value)>0

                        self.name:=value
                        self.icon:=GetDiskObject(self.name)

                    ENDIF

                ENDIF

                IF (self.disabled=FALSE) THEN  self.draw(self.gh.wnd)

            ENDIF

        CASE PLA_IconBox_ShowSelected

            IF self.selected<>value

                self.selected:=value

                IF (self.disabled=FALSE) THEN self.draw(self.gh.wnd)

            ENDIF

        CASE PLA_IconBox_Disabled

            IF self.disabled<>value

                self.disabled:=value

                self.draw(self.gh.wnd)

            ENDIF

    ENDSELECT

ENDPROC

PROC get(attr) OF iconbox_plugin

    SELECT attr

        CASE PLA_IconBox_IconName;      RETURN self.name, TRUE
        CASE PLA_IconBox_ShowSelected;  RETURN self.selected, TRUE
        CASE PLA_IconBox_Disabled;      RETURN self.disabled, TRUE

    ENDSELECT

ENDPROC -1, FALSE

-><

->> iconbox_plugin: draw()
PROC draw(win:PTR TO window) OF iconbox_plugin

    IF win

        SetStdRast(win.rport)

        Box(self.x, self.y, (self.x+(self.xs-1)), (self.y+(self.ys-1)), 0)

        IF self.icon AND (self.disabled=FALSE)

            IF (self.icon.gadget.width < self.xs) AND (self.icon.gadget.height < self.ys)

                DrawImage(win.rport,
                          IF self.selected THEN self.icon.gadget.selectrender ELSE self.icon.gadget.gadgetrender,
                          self.x+((self.xs-self.icon.gadget.width)/2), self.y+((self.ys-self.icon.gadget.height)/2))

            ENDIF

        ENDIF

        IF self.disabled THEN ghost(win, self.x, self.y, self.xs, self.ys)

    ENDIF

ENDPROC
-><

->> easygui standard procs
PROC min_size(ta:PTR TO textattr, fh) OF iconbox_plugin

    DEF width, height

    IF self.icon

        width:=self.icon.gadget.width + 16
        height:=self.icon.gadget.height + 12

    ELSE

        width:=48
        height:=32

    ENDIF

ENDPROC width, height

PROC will_resize() OF iconbox_plugin IS (RESIZEX OR RESIZEY)

PROC render(ta:PTR TO textattr, x, y, xs, ys, win:PTR TO window) OF iconbox_plugin

   self.draw(win)

ENDPROC

PROC appmessage(amsg:PTR TO appmessage, win:PTR TO window) OF iconbox_plugin

    DEF xok=FALSE, yok=FALSE

    xok:=(amsg.mousex>=(self.x)) AND (amsg.mousex<=(self.x+self.xs-1))
    yok:=(amsg.mousey>=(self.y)) AND (amsg.mousey<=(self.y+self.ys-1))

ENDPROC ((xok AND yok) AND (self.disabled=FALSE))

-><


