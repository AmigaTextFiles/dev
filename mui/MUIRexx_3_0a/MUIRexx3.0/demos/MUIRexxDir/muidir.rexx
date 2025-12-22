/*

Code:       muidir.rexx
Author:     Russell Leighton
Revision:   11 Jan 1996

Comments:  This is the main script for a simple directory utility that uses
MUIRexx.  This scripts only function is to create the GUI for the directory
utility.  Once setup the script exits.

*/

options results
arg portname

/* Method TAG ID definitions */

Application_OpenConfigWindow = 0x804299ba /*    { ULONG MethodID; ULONG flags; }; */

/* TAG ID definitions */

MUIA_AppMessage =                      0x80421955 /* V5  ..g struct AppMessage * */
MUIA_Dropable =                        0x8042fbce /* V11 isg BOOL              */
Draggable = '0x80420b6e'
Dirlist_RejectIcons = '0x80424808'
List_Format =                     0x80423c0a /* V4  isg STRPTR            */
Listview_DragType = '0x80425cd3'
Listview_MultiSelect = '0x80427e08'
Menuitem_Title = '0x804218be'
Weight = '0x80421d1f'
ShowMe = '0x80429ba8'

/* TAG variable definitions */

TRUE = 1
FALSE = 0
Listview_DragType_None = 0
Listview_DragType_Immediate = 1
Listview_MultiSelect_Shifted = 2
MUIV_EveryTime = 0x49893131

if ~show('l', "rexxsupport.library") then do
    call addlib('rexxsupport.library',0,-30,0)
end

if ~show('l', "datatypes.library") then do
    call addlib('datatypes.library',0,-30,0)
end

address command 'assign muidir: MUIRexx:demos/MUIRexxDir'

call pragma('Directory','muidir:')

if portname = '' then do
    portname = 'MUIDIR'
    closecom = '"quit"'
end
else closecom = '"window ID MDIR CLOSE"'

address VALUE portname
/*
request TITLE '"About MUIDir"' GADGETS '"OK"' FILE '"muidir:about.txt"'
*/
setvar screen '"Workbench"'

/* begin window definition.  A command to close the window will be issued
to the port MUIREXX if the user hits the close gadget */

window ID MDIR CLOSE
window ID MDIR TITLE '"Directory Utility"' COMMAND closecom PORT portname
    menu LABEL "Project"
        item COMMAND '"request TITLE About GADGETS OK FILE muidir:about.txt"' PORT portname LABEL "About"
        menu LABEL "Settings"
            item COMMAND '"method 'Application_OpenConfigWindow'"' PORT portname LABEL "MUI..."
        endmenu
        item ATTRS Menuitem_Title '-1'
        item COMMAND '"window ID MDIR CLOSE"' PORT portname LABEL "Close"
    endmenu

    /* begin a vertical group */

    group

        /* begin a register group */

        group ID REG REGISTER LABELS "Directory,Buffers,Volumes,Mirror"

            /* begin a vertical group */

            group
                group ID DIR REGISTER LABELS "1,2"

                    /* begin a vertical group */

                    group

                        /* create a text gadget which if hit will issue
                           the command "muidir:comm DIR [/]" to REXX
                           (i.e. execute a REXX macro). This command changes
                           the current directory to the parent directory */

                        text ID TXT1 COMMAND '"muidir:comm 'portname' DIR [/]"' NODE '"TXT"' LABEL 'No Directory'
                        group HORIZ

                            /* create a dirlist with 5 fields, no .info
                               display, and which will issue a command if an
                               entry is selected (by double clicking on it) */

                            dirlist ID DIR1 COMMAND '"muidir:comm 'portname' DIR [%s]"' NODE '"DIR"' ATTRS Listview_DragType Listview_DragType_Immediate Listview_MultiSelect Listview_MultiSelect_Shifted Dirlist_RejectIcons TRUE List_Format '",,,,"'
                            group ID G1 ATTRS Weight 0 ShowMe FALSE
                                space
                                group ID GRP1
                                    space HORIZ 20
                                    button ID IMG1 NODE '"IMG"' ATTRS Draggable TRUE
                                endgroup
                                space
                            endgroup
                        endgroup
                        group HORIZ

                            /* create a check gadget with weight 0 (it will
                               never get sized even if the window is resized)
                               and which will issue a command to port MUIREXX.
                               If the check is unselected then the "%s" will be
                               replaced by "1" else it will be "0".  This
                               will set the attribute Dirlist_RejectIcons
                               (id 0x80424808) to either true or false. */

                            check ID ICN1 ATTRS Weight 0 COMMAND '"dirlist ID DIR1 REREAD ATTRS 'Dirlist_RejectIcons' %s"' PORT portname NODE '"ICN"' LABELS "1,0"

                            /* create a string gadget which will issue a
                               command if a string is entered (i.e. the user
                               hits the return) */

                            string ID SRC1 COMMAND '"muidir:comm 'portname' DIR [%s]"' NODE '"SRC"'

                            check ATTRS Weight 0 COMMAND '"group ID G1 ATTRS 'ShowMe' %s"' PORT portname NODE '"CHK"'
                        endgroup
                    endgroup
                    group   /* begin a vertical group */

                        /* create a text gadget which if hit will issue
                           the command "muidir:comm DIR [/]" to REXX
                           (i.e. execute a REXX macro). This command changes
                           the current directory to the parent directory */

                        text ID TXT2 COMMAND '"muidir:comm 'portname' DIR [/]"' NODE '"TXT"' LABEL 'No Directory'
                        group HORIZ

                            /* create a dirlist with 5 fields, no .info
                               display, and which will issue a command if an
                               entry is selected (by double clicking on it) */

                            dirlist ID DIR2 COMMAND '"muidir:comm 'portname' DIR [%s]"' NODE '"DIR"' ATTRS Listview_DragType Listview_DragType_Immediate Listview_MultiSelect Listview_MultiSelect_Shifted Dirlist_RejectIcons TRUE List_Format '",,,,"'
                            group ID G2 ATTRS Weight 0 ShowMe FALSE
                                space
                                group ID GRP2
                                    space HORIZ 20
                                    button ID IMG2 NODE '"IMG"' ATTRS Draggable TRUE
                                endgroup
                                space
                            endgroup
                        endgroup
                        group HORIZ

                            /* create a check gadget with weight 0 (it will
                               never get sized even if the window is resized)
                               and which will issue a command to port MUIREXX.
                               If the check is unselected then the "%s" will be
                               replaced by "1" else it will be "0".  This
                               will set the attribute Dirlist_RejectIcons
                               (id 0x80424808) to either true or false. */

                            check ID ICN2 ATTRS Weight 0 COMMAND '"dirlist ID DIR2 REREAD ATTRS 'Dirlist_RejectIcons' %s"' PORT portname NODE '"ICN"' LABELS "1,0"

                            /* create a string gadget which will issue a
                               command if a string is entered (i.e. the user
                               hits the return) */

                            string ID SRC2 COMMAND '"muidir:comm 'portname' DIR [%s]"' NODE '"SRC"'

                            check ATTRS Weight 0 COMMAND '"group ID G2 ATTRS 'ShowMe' %s"' PORT portname NODE '"CHK"'
                        endgroup
                    endgroup
                endgroup
                group FRAME
                    group HORIZ

                        /* create a series of buttons (arranged
                           horizontally) which if hit will issue commands
                           to REXX (i.e. execute REXX macros) */

                        button COMMAND '"muidir:comm 'portname' COPY"' NODE '"COPY"' LABEL 'Copy'
                        button COMMAND '"muidir:comm 'portname' MOVE"' NODE '"MOVE"' LABEL 'Move'
                        button COMMAND '"muidir:renfile 'portname'"' NODE '"RENAME"' LABEL 'Rename'
                        button COMMAND '"muidir:comm 'portname' DELETE"' NODE '"DELETE"' LABEL 'Delete'
                        button COMMAND '"muidir:protfile 'portname'"' NODE '"PROTECT"' LABEL 'Protect'
                    endgroup
                endgroup
            endgroup
            group
                group REGISTER LABELS "Path,Command"

                    /* create a list to hold the directory history
                       buffer. If an entry in this list is selected
                       then the command to change the directory will be
                       issued */

                    list ID LST COMMAND '"muidir:comm 'portname' DIR [%s]"' NODE '"LST"'
                    group

                        /* create a list to hold the command history
                           buffer. */

                        list ID HST NODE '"HST"'
                        group HORIZ
                            button COMMAND '"muidir:comm 'portname' HCLEAR"' NODE '"HCLEAR"' LABEL 'Clear'
                            button COMMAND '"list ID HST TOGGLE"' PORT portname NODE '"TOGGLE"' LABEL 'Toggle'
                            button COMMAND '"muidir:comm 'portname' HEXE"' NODE '"HEXE"' LABEL 'Execute'
                        endgroup
                    endgroup
                endgroup
            endgroup
            group

                /* create a volumelist.  If an entry in this list
                   is selected then the command to change the
                   directory will be issued */

                volumelist COMMAND '"muidir:comm 'portname' DIR [%s]"' NODE '"VOL"'
            endgroup
            group ID MIRR REGISTER LABELS "Copy,Delete"
                group

                    /* create a list to display files to be copied. */

                    list ID CLST NODE '"CLST"' ATTRS Listview_MultiSelect Listview_MultiSelect_Shifted 
                    group HORIZ

                        /* create a series of buttons (arranged
                           horizontally) which if hit will issue commands
                           to REXX (i.e. execute REXX macros) */

                        button COMMAND '"muidir:comm 'portname' CCOPY"' NODE '"CCOPY"' LABEL 'Compile'
                        button COMMAND '"list ID CLST TOGGLE"' PORT portname NODE '"TOGGLE"' LABEL 'Toggle'
                        button COMMAND '"muidir:comm 'portname' MCOPY"' NODE '"MCOPY"' LABEL 'Copy'
                    endgroup
                endgroup
                group

                    /* create a list to display files to be deleted. */

                    list ID DLST NODE '"DLST"' ATTRS Listview_MultiSelect Listview_MultiSelect_Shifted 
                    group HORIZ

                        /* create a series of buttons (arranged
                           horizontally) which if hit will issue commands
                           to REXX (i.e. execute REXX macros) */

                        button COMMAND '"muidir:comm 'portname' CDEL"' NODE '"CDEL"' LABEL 'Compile'
                        button COMMAND '"list ID DLST TOGGLE"' PORT portname NODE '"TOGGLE"' LABEL 'Toggle'
                        button COMMAND '"muidir:comm 'portname' MDEL"' NODE '"MDEL"' LABEL 'Delete'
                    endgroup
                endgroup
            endgroup
        endgroup
    endgroup
endwindow

callhook ID DIR1 APP COMMAND '"muidir:comm 'portname' DIR [%s]"'
callhook ID DIR2 APP COMMAND '"muidir:comm 'portname' DIR [%s]"'
callhook ID G1 DROP COMMAND '"muidir:comm 'portname' ICON [%s]"'
callhook ID G2 DROP COMMAND '"muidir:comm 'portname' ICON [%s]"'
group ID GRP1 ATTRS MUIA_Dropable FALSE
group ID GRP2 ATTRS MUIA_Dropable FALSE
call 'muidir:comm' portname 'DIR [home:]'

/* all finished */

exit
