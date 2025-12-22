
/*

    $VER: popmisc_plugin 1.1 (25.2.98)

    Author:         Ali Graham ($01)
                    <agraham@hal9000.net.au>

    PLUGIN id:      $06

    Desc.:          Pop-up a listview containing various system entities.

    Tags:           PLA_PopMisc_ButtonText                      [ISG]
                    PLA_PopMisc_StringText                      [ISG]
                    PLA_PopMisc_CaseSensitive                   [ISG]
                    PLA_PopMisc_RemoveDuplicates                [ISG]
                    PLA_PopMisc_ListType                        [I..]
                    PLA_PopMisc_ListViewX                       [I..]
                    PLA_PopMisc_ListViewY                       [I..]
                    PLA_PopMisc_Disabled                        [ISG]

    Values:         PLV_PopMisc_TasksList
                    PLV_PopMisc_PortsList
                    PLV_PopMisc_LibrariesList
                    PLV_PopMisc_DevicesList
                    PLV_PopMisc_ResourcesList
                    PLV_PopMisc_MemNodesList

*/

OPT MODULE
OPT PREPROCESS, NOWARN

-> RST: Added conditional EASY_OS12 support
#define EASY_OS12

#ifdef EASY_OS12
  MODULE 'tools/easygui_os12', 'easyplugins/dclistview_os12','hybrid/tagdata','hybrid/strcmp'
  #define GetTagData getTagData
  #define Stricmp stricmp
  #define Strnicmp strnicmp
#endif
#ifndef EASY_OS12
  OPT OSVERSION=37
  MODULE 'tools/easygui', 'easyplugins/dclistview', 'utility'
#endif

->> popmisc_plugin: modules

MODULE 'intuition/intuition',
       'graphics/text', 'intuition/gadgetclass',
       'gadtools', 'libraries/gadtools',
       'utility/tagitem',
       'tools/textlen'

MODULE 'exec/nodes', 'exec/execbase', 'exec/lists',
       'exec/ports', 'exec/tasks', 'amigalib/lists'

-><

->> popmisc_plugin: definitions

CONST NAME_LENGTH=64

EXPORT OBJECT popmisc_plugin OF plugin PRIVATE

    but_contents:PTR TO CHAR
    str_contents[NAME_LENGTH]:ARRAY OF CHAR
    case_sensitive
    remove_duplicates
    list_type
    listview_x, listview_y
    disabled

    but_width

    gad_str:PTR TO gadget
    gad_but:PTR TO gadget

    font:PTR TO textattr

    iaddress

    list:PTR TO mlh

ENDOBJECT

OBJECT pm_node OF ln

    pm_name[NAME_LENGTH]:ARRAY OF CHAR

ENDOBJECT

-> PROGRAMMER_ID | MODULE_ID
->      $01      |   $06


EXPORT ENUM PLA_PopMisc_ButtonText=$81006001,   ->[ISG]
            PLA_PopMisc_StringText,             ->[ISG]
            PLA_PopMisc_CaseSensitive,          ->[ISG]
            PLA_PopMisc_RemoveDuplicates,       ->[ISG]
            PLA_PopMisc_ListType,               ->[I..]
            PLA_PopMisc_ListViewX,              ->[I..]
            PLA_PopMisc_ListViewY,              ->[I..]
            PLA_PopMisc_Disabled                ->[ISG]

EXPORT ENUM PLV_PopMisc_TasksList=0,
            PLV_PopMisc_PortsList,
            PLV_PopMisc_LibrariesList,
            PLV_PopMisc_DevicesList,
            PLV_PopMisc_ResourcesList,
            PLV_PopMisc_MemNodesList

-><

/* &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& */

->> popmisc_plugin: popmisc() & end()

PROC popmisc(tags=NIL:PTR TO tagitem) OF popmisc_plugin

    DEF name:PTR TO CHAR, type

#ifndef EASY_OS12
    IF utilitybase
#endif

        self.list_type      := GetTagData(PLA_PopMisc_ListType, PLV_PopMisc_TasksList, tags)

        type:=self.list_type

        SELECT type

            CASE PLV_PopMisc_TasksList;         name:='Task...'
            CASE PLV_PopMisc_PortsList;         name:='Port...'
            CASE PLV_PopMisc_LibrariesList;     name:='Library...'
            CASE PLV_PopMisc_DevicesList;       name:='Device...'
            CASE PLV_PopMisc_ResourcesList;     name:='Resource...'
            CASE PLV_PopMisc_MemNodesList;      name:='MemNode...'

            DEFAULT;                            Raise("baty")

        ENDSELECT

        self.but_contents   := GetTagData(PLA_PopMisc_ButtonText, name, tags)

        AstrCopy(self.str_contents, GetTagData(PLA_PopMisc_StringText, '', tags))

        self.case_sensitive     := GetTagData(PLA_PopMisc_CaseSensitive, FALSE, tags)
        self.remove_duplicates  := GetTagData(PLA_PopMisc_RemoveDuplicates, TRUE, tags)

        self.listview_x     := GetTagData(PLA_PopMisc_ListViewX, 15, tags)
        self.listview_y     := GetTagData(PLA_PopMisc_ListViewY, 6, tags)

        self.disabled       := GetTagData(PLA_PopMisc_Disabled, FALSE, tags)

#ifndef EASY_OS12
    ELSE

        Raise("util")

    ENDIF
#endif

    NEW self.list

    newList(self.list)

ENDPROC

PROC end() OF popmisc_plugin

    popmisc_private_clear(self)

    END self.list

ENDPROC
-><

->> popmisc_plugin: set() & get()

PROC set(attr, value) OF popmisc_plugin

    SELECT attr

        CASE PLA_PopMisc_ButtonText

            IF self.but_contents<>value

                self.but_contents:=value

                IF self.gad_but AND self.gh.wnd

                    Gt_SetGadgetAttrsA(self.gad_but, self.gh.wnd, NIL, [GA_TEXT, self.but_contents, TAG_DONE])

                ENDIF

            ENDIF

        CASE PLA_PopMisc_StringText

            IF self.str_contents<>value

                AstrCopy(self.str_contents, value)

                IF self.gad_str AND self.gh.wnd

                    Gt_SetGadgetAttrsA(self.gad_str, self.gh.wnd, NIL, [GTST_STRING, self.str_contents, TAG_DONE])

                ENDIF

            ENDIF

        CASE PLA_PopMisc_CaseSensitive

            IF self.case_sensitive<>value THEN self.case_sensitive:=value

        CASE PLA_PopMisc_RemoveDuplicates

            IF self.remove_duplicates<>value THEN self.remove_duplicates:=value

        CASE PLA_PopMisc_Disabled

            IF self.disabled<>value

                self.disabled:=value

                IF ((self.gad_str AND self.gad_but) AND self.gh.wnd)

                    Gt_SetGadgetAttrsA(self.gad_but, self.gh.wnd, NIL, [GA_DISABLED, self.disabled, TAG_DONE])
                    Gt_SetGadgetAttrsA(self.gad_str, self.gh.wnd, NIL, [GA_DISABLED, self.disabled, TAG_DONE])

                ENDIF

            ENDIF

    ENDSELECT

ENDPROC

PROC get(attr) OF popmisc_plugin

    SELECT attr

        CASE PLA_PopMisc_ButtonText;       RETURN self.but_contents, TRUE
        CASE PLA_PopMisc_StringText;       RETURN self.str_contents, TRUE
        CASE PLA_PopMisc_CaseSensitive;    RETURN self.case_sensitive, TRUE
        CASE PLA_PopMisc_RemoveDuplicates; RETURN self.remove_duplicates, TRUE
        CASE PLA_PopMisc_Disabled;         RETURN self.disabled, TRUE

    ENDSELECT

ENDPROC -1, FALSE
-><

/* &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& */

->> popmisc_plugin: min_size() & will_resize()
PROC min_size(ta:PTR TO textattr, fh) OF popmisc_plugin

   self.but_width:=textlen(self.but_contents,ta)+8

ENDPROC (self.but_width+(fh*8)),(fh+6)

PROC will_resize() OF popmisc_plugin IS RESIZEX
-><

->> popmisc_plugin: gtrender() & clear_render()
PROC gtrender(gl, vis, ta:PTR TO textattr, x, y, xs, ys, win:PTR TO window) OF popmisc_plugin

    self.font:=ta

    self.gad_but:=CreateGadgetA(BUTTON_KIND, gl,
                                [x, y, self.but_width, ys, self.but_contents, ta, 1, 0, vis, 0]:newgadget,
                                [GA_DISABLED, self.disabled, TAG_DONE])

    self.gad_str:=CreateGadgetA(STRING_KIND, self.gad_but,
                                [x+self.but_width+1, y, xs-self.but_width, ys, NIL, ta, 2, 0, vis, 0]:newgadget,
                                [GA_DISABLED, self.disabled,
                                 GTST_MAXCHARS, NAME_LENGTH,
                                 GTST_STRING, self.str_contents,
                                 TAG_DONE])

ENDPROC self.gad_str

PROC clear_render(win:PTR TO window) OF popmisc_plugin

    IF self.gad_str THEN AstrCopy(self.str_contents, self.gad_str.specialinfo::stringinfo.buffer)

ENDPROC

-><

->> popmisc_plugin: message_test() & message_action()
PROC message_test(imsg:PTR TO intuimessage, win:PTR TO window) OF popmisc_plugin

    IF imsg.class=IDCMP_GADGETUP

        self.iaddress:=imsg.iaddress

        RETURN (imsg.iaddress=self.gad_but) OR (imsg.iaddress=self.gad_str)

    ENDIF

ENDPROC FALSE

PROC message_action(class, qual, code, win:PTR TO window) OF popmisc_plugin

    DEF exec:PTR TO execbase, dclv:PTR TO dclistview, type,
        fnode:PTR TO pm_node, node:PTR TO pm_node, sel, a,
        found=FALSE

    IF self.iaddress=self.gad_but

        exec:=execbase; type:=self.list_type

        Disable()

        SELECT type

            CASE PLV_PopMisc_TasksList

                popmisc_private_snapshot(self, exec.taskwait.head)
                popmisc_private_snapshot(self, exec.taskready.head)

            CASE PLV_PopMisc_PortsList

                popmisc_private_snapshot(self, exec.portlist.head)

            CASE PLV_PopMisc_LibrariesList

                popmisc_private_snapshot(self, exec.liblist.head)

            CASE PLV_PopMisc_DevicesList

                popmisc_private_snapshot(self, exec.devicelist.head)

            CASE PLV_PopMisc_ResourcesList

                popmisc_private_snapshot(self, exec.resourcelist.head)

            CASE PLV_PopMisc_MemNodesList

                popmisc_private_snapshot(self, exec.memlist.head)

        ENDSELECT

        Enable()

        blockwin(self.gh)

        IF fnode:=FindName(self.list, self.str_contents)

            node:=self.list.head; a:=0

            WHILE (node<>NIL) AND (found=FALSE)

                IF fnode=node;  found:=TRUE
                ELSE;           node:=node.succ; a:=a+1
                ENDIF

            ENDWHILE

        ENDIF

        NEW dclv.dclistview([DCLV_RELX,    self.listview_x,
                            DCLV_RELY,     self.listview_y,
                            DCLV_LIST,     self.list,
                            DCLV_CURRENT,  (IF fnode THEN a ELSE -1),
                            DCLV_TOP,      (IF fnode THEN a ELSE 0),
                            TAG_DONE])

        easyguiA(NIL, [DCLIST, {popmisc_private_listclick}, dclv, TRUE],
                      [EG_WTYPE,  WTYPE_NOBORDER,
                       EG_SCRN,   win.wscreen,
                       EG_FONT,   self.font,
                       EG_LEFT,   (win.leftedge + self.x),
                       EG_TOP,    (win.topedge + self.y + self.ys),
                       TAG_DONE])

        sel:=dclv.get(DCLV_CURRENT)

        END dclv

        node:=self.list.head; a:=0

        WHILE node AND (a<sel)

            node:=node.succ; a:=a+1

        ENDWHILE

        IF node THEN self.set(PLA_PopMisc_StringText, node.pm_name)

        popmisc_private_clear(self)

        unblockwin(self.gh)

    ELSEIF self.iaddress=self.gad_str

        AstrCopy(self.str_contents, self.gad_str.specialinfo::stringinfo.buffer)

    ENDIF

    self.iaddress:=NIL

ENDPROC TRUE
-><

/* &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& */

->> PRIVATE: clear(), snapshot() & compare()
PROC popmisc_private_clear(pt:PTR TO popmisc_plugin)

    DEF node:PTR TO pm_node, tnode:PTR TO pm_node

    node:=pt.list.head

    WHILE tnode:=node.succ

        END node; node:=tnode

    ENDWHILE

    newList(pt.list)

ENDPROC

PROC popmisc_private_snapshot(pt:PTR TO popmisc_plugin, src_node:PTR TO ln)

  DEF tnode:PTR TO pm_node, node:PTR TO pm_node,
      inserting, result

    WHILE src_node.succ

        NEW tnode

        AstrCopy(tnode.pm_name, src_node.name, NAME_LENGTH)
        tnode.name:=tnode.pm_name

        node:=pt.list.head

        IF (popmisc_private_compare(pt, node.pm_name, tnode.pm_name)>0)

            AddHead(pt.list, tnode)

        ELSE

            inserting:=TRUE

            WHILE node.succ AND inserting

                node:=node.succ

                result:=popmisc_private_compare(pt, node.pm_name, tnode.pm_name)

                IF (result=0) AND pt.remove_duplicates

                    inserting:=FALSE

                ELSEIF (result>0)

                    Insert(pt.list, tnode, node.pred)

                    inserting:=FALSE

                ENDIF

            ENDWHILE

            IF inserting=TRUE THEN AddTail(pt.list, tnode)

        ENDIF

        src_node:=src_node.succ

    ENDWHILE

ENDPROC

PROC popmisc_private_compare(pt:PTR TO popmisc_plugin, s:PTR TO CHAR, t:PTR TO CHAR)

ENDPROC (IF pt.case_sensitive THEN Stricmp(s, t) ELSE Strnicmp(s, t, NAME_LENGTH))
-><

/* &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& */

->> PRIVATE: listclick()

PROC popmisc_private_listclick(gh:PTR TO guihandle, dclv:PTR TO dclistview)

    DEF bool=FALSE, valid=FALSE

    bool, valid:=dclv.get(DCLV_CLICK)

    IF bool AND valid THEN quitgui()

ENDPROC

-><

/* &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& */

