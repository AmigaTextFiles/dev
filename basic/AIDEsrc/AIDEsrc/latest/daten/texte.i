*   AIDE 2.13, an environment for ACE
*   Copyright (C) 1995/97 by Herbert Breuer
*		  1997/99 by Daniel Seifert
*
*                 contact me at: dseifert@gmx.net
*
*                                Daniel Seifert
*                                Elsenborner Weg 25
*                                12621 Berlin
*                                GERMANY
*
*   This program is free software; you can redistribute it and/or modify
*   it under the terms of the GNU General Public License as published by
*   the Free Software Foundation; either version 2 of the License, or
*   (at your option) any later version.
*
*   This program is distributed in the hope that it will be useful,
*   but WITHOUT ANY WARRANTY; without even the implied warranty of
*   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*   GNU General Public License for more details.
*
*   You should have received a copy of the GNU General Public License
*   along with this program; if not, write to the
*          Free Software Foundation, Inc., 59 Temple Place, 
*          Suite 330, Boston, MA  02111-1307  USA

* ATTENTION !!!
*
* Die Reihenfolge der Texte in dieser Datei stimmt mit den Kenncodes
* (beginnend bei 1) der Kataloge überein. Auf gar keinen Fall sollte
* ein Text dazwischen eingefügt werden. Immer nur ans Ende !!!!!!!!!
*


*--------------------------------------
* Texte
*--------------------------------------
        dc.b    "$VER: AIDE 2.13 (08/17/97)",0
        even
*--------------------------------------
about_gad_txt dc.b    "I like ACE",0
              even
text_about1   dc.b    "AIDE Version 2.13 © Herbert Breuer 1995/97, Daniel Seifert 1997.",0
              even
text_about2   dc.b    "Development Environment for A C E,",0
              even
text_about3   dc.b    "the very special Amiga BASIC Compiler.",0
              even
text_about4   dc.b    "Copyright © David Benn 1991/1997.",0
              even
*--------------------------------------
req_title     dc.b    "AIDE Request",0
              even
*--------------------------------------
error_req_title
              dc.b    "AIDE Error Request",0
              even
*--------------------------------------
alert_req_title
              dc.b    "AIDE Alert Request",0
              even
*--------------------------------------
text_okay     dc.b    "Okay",0
              even
*--------------------------------------
text_i_see    dc.b    "I see",0
              even
*--------------------------------------
text_yes      dc.b    "Yes",0
              even
*--------------------------------------
text_no       dc.b    "No",0
              even
*--------------------------------------
text_cancel   dc.b    "Cancel",0
              even
*--------------------------------------
text_wrong_system
              dc.b    "You need at least Workbench 2.0 V37.1",0
              even
*--------------------------------------
text_not_enough_start_mem1
              dc.b    "Not enough memory to run AIDE",0
              even
*--------------------------------------
text_not_enough_start_mem2
              dc.b    "Please free some and try again.",0
              even
*--------------------------------------
text_mrtlib
              dc.b    "Mrt.library not opened.",0
              even
*--------------------------------------
text_wblib    dc.b    "Workbench.library not opened.",0
              even
*--------------------------------------
text_asllib   dc.b    "Asl.library not opened.",0
              even
*--------------------------------------
text_diskfontlib
              dc.b    "Diskfont.library not opened.",0
              even
*--------------------------------------
text_gadtoolslib
              dc.b    "Gadtools.library not opened.",0
              even
*--------------------------------------
text_utillib  dc.b    "Utility.library not opened.",0
              even
*--------------------------------------
text_doslib   dc.b    "Dos.library not opened.",0
              even
*--------------------------------------
text_gfxlib   dc.b    "Graphics.library not opened.",0
              even
*--------------------------------------
text_iconlib  dc.b    "Icon.library not opened.",0
              even
*--------------------------------------
text_no_port  dc.b    "Message port not created.",0
              even
*--------------------------------------
text_window_not_opened
              dc.b    "Window not opened.",0
              even
*--------------------------------------
text_gt_gadgets_not_created
              dc.b    "Gadtools gadgets not created.",0
              even
*--------------------------------------
text_menu_not_created
              dc.b    "Menu not created.",0
              even
*--------------------------------------
text_config_changed
              dc.b    "AIDE configuration has been changed.",0
              even
*--------------------------------------
text_want_to_save
              dc.b    "Should I save it now?",0
              even
*--------------------------------------
text_prg_title
              dc.b    "AIDE © Herbert Breuer 1995/97, Daniel Seifert 1997",0
              even
*--------------------------------------
text_prg_end
              dc.b    "Really quit AIDE?",0
              even
*--------------------------------------
text_dirname_wrong
              dc.b    "Directory name is wrong.",0
              even
*--------------------------------------
text_correct_it
              dc.b    "Do you want to correct it?",0
              even
*--------------------------------------
text_filename_wrong
              dc.b    "File name is wrong.",0
              even
*--------------------------------------
text_filelength_null
              dc.b    "File length is NULL.",0
              even
*--------------------------------------
text_file_not_marked
              dc.b    "File is not marked as ACE source file.",0
              even
*--------------------------------------
text_no_source_file_selected1
              dc.b    "No source file selected.",0
              even
text_no_source_file_selected2
              dc.b    "Do you want to select one?",0
              even
*--------------------------------------
text_kill_source
              dc.b    "Do you want to erase the current settings?",0
              even
*--------------------------------------
text_no_data_file
              dc.b    "File is not an AIDE config file.",0
              even
text_default_settings
              dc.b    "Using default settings.",0
              even
text_current_settings
              dc.b    "Current settings will not be changed.",0
              even
*--------------------------------------
text_no_config_loaded
              dc.b    "No AIDE config file loaded.",0
              even
*--------------------------------------
text_new_config_not_saved1
              dc.b    "Your new AIDE config file has not been saved.",0
              even
text_new_config_not_saved2
              dc.b    "Please check your environment setup.",0
              even
*--------------------------------------
text_no_other_preco_eingetragen
              dc.b    "No name for another precompiler defined.",0
              even

text_no_other_assembler_eingetragen
              dc.b    "No name for another assembler defined.",0
              even

text_no_other_linker_eingetragen
              dc.b    "No name for another linker defined.",0
              even

text_no_other_linkerlib_eingetragen
              dc.b    "No name for another linker lib defined.",0
              even

text_compiler_run_abort
              dc.b    "Compiler run will be aborted.",0
              even
*--------------------------------------
text_config_not_saved
              dc.b    "Your AIDE config file has not been saved.",0
              even
*--------------------------------------
text_error_env1
              dc.b    "ACE environment not found or not correct installed.",0
              even
text_error_env2
              dc.b    "Please install ACE (© David Benn 1992/96) first.",0
              even
text_error_env3
              dc.b    "AIDE will not start without ACE installed.",0
              even
*--------------------------------------
text_not_loaded_complete
              dc.b    "File not completely loaded from disk.",0
              even
*--------------------------------------
text_file_exists
              dc.b    "File already exists.",0
              even
*--------------------------------------
text_configfile_exists
              dc.b    "AIDE config file already exists.",0
              even
*--------------------------------------
text_overwrite_it
              dc.b    "Overwrite it?",0
              even
*--------------------------------------
text_rename_it
              dc.b    "Rename it?",0
              even
*--------------------------------------
text_file_error
              dc.b    "File not completely written to disk.",0
              even
*--------------------------------------
text_delete_it
              dc.b    "Should I delete it now?",0
              even
*--------------------------------------
text_no_module_dir
              dc.b    "No SUBMod directory specified.",0
              even

text_too_many_modules
              dc.b    "Too many modules selected",0
              even
*--------------------------------------
* Fenster Texte
*--------------
Source_Titel_Text
              dc.b    "Source",0
              even
*--------------------------------------
Program_Titel_Text
              dc.b    "Program",0
              even
*--------------------------------------
Make_Titel_Text
              dc.b    "Make",0
              even
*--------------------------------------
Preco_Titel_Text
              dc.b    "Precompiler",0
              even
*--------------------------------------
AceOpt_Titel_Text
              dc.b    "ACE Options",0
              even
*--------------------------------------
View_Titel_Text
              dc.b    "View",0
              even
*--------------------------------------
SuperOpt_Titel_Text
              dc.b    "SuperOptimizer",0
              even
*--------------------------------------
Ass_Titel_Text
              dc.b    "Assembler",0
              even
*--------------------------------------
LinkLib_Titel_Text
              dc.b    "Linker Lib",0
              even
*--------------------------------------
Linker_Titel_Text
              dc.b    "Linker",0
              even
*--------------------------------------
Module_Titel_Text
              dc.b    "Module",0
              even
*--------------------------------------
* GadToolGadgetTexte
*-------------------

* Source

GadText_0     dc.b    "Set",0
              even
GadText_1     dc.b    "Reset",0
              even
GadText_2     dc.b    "Edit",0
              even

* Program

GadText_3     dc.b    "Precompile",0
              even
GadText_4     dc.b    "Compile",0
              even
GadText_5     dc.b    "Assemble",0
              even
GadText_6     dc.b    "Link",0
              even
GadText_7     dc.b    "Run",0
              even
GadText_8     dc.b    "Run in Shell",0
              even
* Make

GadText_9     dc.b    "Executable",0
              even
GadText_10    dc.b    "Application",0
              even
GadText_11    dc.b    "Module",0
              even

* Precompiler

GadText_12    dc.b    "NAP",0
              even
GadText_13    dc.b    "ACPP",0
              even
GadText_14    dc.b    "other",0
              even

* ACE Options

GadText_15    dc.b    "Break Trapping",0
              even
GadText_16    dc.b    "Assem. Comment",0
              even
GadText_17    dc.b    "Create Icon",0
              even
GadText_18    dc.b    "Optimize",0
              even
GadText_19    dc.b    "Window Trapping",0
              even
GadText_20    dc.b    "other",0
              even

* SuperOptimizer

GadText_21    dc.b    "active",0
              even
GadText_22    dc.b    "Set Level",0
              even

* View

GadText_23    dc.b    "Precompiled Source",0
              even
GadText_24    dc.b    "Assembled Source",0
              even
GadText_25    dc.b    "ACE Compiler Errors",0
              even

* Assembler

GadText_26    dc.b    "A68K",0
              even
GadText_27    dc.b    "PhxAss",0
              even
GadText_28    dc.b    "other",0
              even
GadText_29    dc.b    "Small Code",0
              even
GadText_30    dc.b    "Small Data",0
              even
GadText_31    dc.b    "Debug Info",0
              even
GadText_32    dc.b    "Set Options",0
              even

* Linker Lib

GadText_33    dc.b    "Ami.lib",0
              even
GadText_34    dc.b    "Amiga.lib",0
              even
GadText_35    dc.b    "other",0
              even

* Linker

GadText_36    dc.b    "BLink",0
              even
GadText_37    dc.b    "PhxLnk",0
              even
GadText_38    dc.b    "other",0
              even
GadText_39    dc.b    "Small Code",0
              even
GadText_40    dc.b    "Small Data",0
              even
GadText_41    dc.b    "No Debug Info",0
              even
GadText_42    dc.b    "Set Options",0
              even
GadText_43    dc.b    "Remove all Modules",0
              even
*---------------------------------------------
acpp_txt      dc.b    "Precompiling with ACPP...",0
              even
nap_txt       dc.b    "Precompiling with NAP...",0
              even
removeline_txt
              dc.b    "Processing RemoveLine...",0
              even
ace_txt       dc.b    "Compiling with ACE...",0
              even
superopt_txt  dc.b    "SuperOptimizing...",0
              even
a68k_txt      dc.b    "Assembling with A68K...",0
              even
phxass_txt    dc.b    "Assembling with PhxAss...",0
              even
blink_txt     dc.b    "Linking with BLink...",0
              even
phxlnk_txt    dc.b    "Linking with PhxLnk...",0
              even
*--------------------------------------
application_built_txt
              dc.b    "Application successful built.",0
              even
*--------------------------------------
compile_erfolgreich_txt
              dc.b    "Compiler run successful.",0
              even
*--------------------------------------
comp_error_text2
              dc.b    "See > AIDE Output Window < for details.",0
              even
*--------------------------------------
error_acpp_txt
              dc.b    "Error while precompiling with ACPP.",0
              even
error_nap_txt dc.b    "Error while precompiling with NAP.",0
              even
error_removeline_txt
              dc.b    "Error while processing RemoveLine.",0
              even
error_ace_txt dc.b    "Error while compiling with ACE.",0
              even

error_superopt_txt
              dc.b    "Error while SuperOptimizing.",0
              even

error_a68k_txt
              dc.b    "Error while assembling with A68K.",0
              even

error_phxass_txt
              dc.b    "Error while assembling with PhxAss.",0
              even


error_blink_txt
              dc.b    "Error while linking with BLink.",0
              even
error_phxlnk_txt
              dc.b    "Error while linking with PhxLnk.",0
              even

*--------------------------------------
Cmd_Line_Text dc.b    "Enter command line arguments",0
              even
*--------------------------------------
Ace_Options_Text
              dc.b    "Enter additional ACE options",0
              even
Asm_Options_Text
              dc.b    "Enter additional assembler options",0
              even
Lnk_Options_Text
              dc.b    "Enter additional linker options",0
              even
*--------------------------------------
Preco_Other_Text
              dc.b    "Enter precompiler name",0
              even
Asm_Other_Text
              dc.b    "Enter assembler name",0
              even
Lib_Other_Text
              dc.b    "Enter library name",0
              even
Lnk_Other_Text
              dc.b    "Enter linker name",0
              even
*--------------------------------------
laden_Text    dc.b    "Select a file to open.",0
              even
*-------------------------------------
view_Text     dc.b    "Select a file to view.",0
              even
*-------------------------------------
rename_Text1  dc.b    "Select a file to rename.",0
              even
*--------------------------------------
rename_Text2  dc.b    "Select a new file name.",0
              even
*--------------------------------------
copy_Text1    dc.b    "Select a file to copy.",0
              even
*--------------------------------------
copy_Text2    dc.b    "Where to copy to?",0
              even
*--------------------------------------
delete_Text   dc.b    "Select a file to delete.",0
              even
*-------------------------------------
print_Text    dc.b    "Select a file to print.",0
              even
*--------------------------------------
config_laden_Text
              dc.b    "Load AIDE config file.",0
              even
*-------------------------------------
set_source_Text
              dc.b    "Set source.",0
              even
*-------------------------------------
config_sichern_Text
              dc.b    "Save AIDE config file as...",0
              even
*--------------------------------------
dirname_Text  dc.b    "Please select a directory.",0
              even
*--------------------------------------
filename_Text dc.b    "Please select a filename.",0
              even
*--------------------------------------
bmaps_Text    dc.b    "Please select bmap file(s).",0
              even
*--------------------------------------
ab2ascii_Text1
              dc.b    "Select AmigaBASIC file(s).",0
              even
*--------------------------------------
ab2ascii_Text2
              dc.b    "Select destination directory.",0
              even
*--------------------------------------

*--------------------------------------
Exec_Prg_Text dc.b    "Please enter command string:",0
              even
text_printer_error1
              dc.b    "Printer trouble.",0
              even
text_printer_error2
              dc.b    "Please check printer and cable.",0
              even
text_printer_error3
              dc.b    "Continue printing?",0
              even
*--------------------------------------
text_printer_openerror1
              dc.b    "Printer device not opened.",0
              even
text_printer_openerror2
              dc.b    "Please check your system setup.",0
              even


*------------------
* Texte für das SuperOptimizer-Options-Einstell-Window
*------------------

SOptTitle     dc.b    "Please choose the optimizations!",0
              even
_SOptGad00    dc.b    "(L) ... logical operations",0
              even
_SOptGad01    dc.b    "(F) ... floating point operations",0
              even
_SOptGad02    dc.b    "(m) ... math instructions",0
              even
_SOptGad03    dc.b    "(s) ... struct base moves",0
              even
_SOptGad04    dc.b    "(M) ... ???",0
              even
_SOptGad05    dc.b    "(P) ... stack pushing and popping",0
              even
_SOptGad06    dc.b    "(E) ... ext.l operations",0
              even
_SOptGad07    dc.b    "(c) Concatenate immediate or's [L]",0
              even
_SOptGad08    dc.b    "(S) ... struct base moves (second pass)",0
              even
_SOptGad09    dc.b    "(r) ... memory to register instructions",0
              even
_SOptGad10    dc.b    "(C) ... compare operations",0
              even
_SOptGad11    dc.b    "(T) ... tst operations",0
              even
_SOptGad12    dc.b    "(I) Inline functions [P]",0
              even
_SOptGad13    dc.b    "(A) ... absolute moves",0
              even
_SOptGad14    dc.b    "(X) ... external calls",0
              even
_SOptGad15    dc.b    "(B) ... library base moves",0
              even
_SOptGad16    dc.b    "(Z) ... zero moves",0
              even
_SOptGad17    dc.b    "Ok",0
              even
_SOptButton1  dc.b    "None",0
              even
_SOptButton2  dc.b    "Less",0
              even
_SOptButton3  dc.b    "Standard",0
              even
_SOptButton4  dc.b    "Full",0
              even
no_monitor_text
              dc.b    "Named monitor spec not available.",0
              even
newer_custom_chips_text
              dc.b    "You need newer custom chips for this screen mode.",0
              even
not_enough_mem_text
              dc.b    "Not enough memory to open the screen.",0
              even
not_enough_chip_mem_text
              dc.b    "Not enough chip memory to open the screen.",0
              even
aide_already_active_text
              dc.b    "PublicScreen AIDE is already in use.",0
              even
unknown_display_mode_text
              dc.b    "Don't recognize mode asked for.",0
              even
screen_to_deep_text
              dc.b    "Screen deeper than HW supports.",0
              even
failed_to_attach_screen_text
              dc.b    "Failed to attach screen.",0
              even
mode_not_available_text
              dc.b    "Screen mode not available.",0
              even
m1t           dc.b "Project",0
              even
m1p1t         dc.b "Open ...",0
              even
m1p2t         dc.b "View ...",0
              even
m1p3t         dc.b "Rename ...",0
              even
m1p4t         dc.b "Copy ...",0
              even
m1p5t         dc.b "Delete ...",0
              even
m1p6t         dc.b "Print ...",0
              even
m1p7t         dc.b "Execute ...",0
              even
m1p8t         dc.b "Spawn Shell",0
              even
m1p9t         dc.b "AIDE setup ...",0
              even
m1p10t        dc.b "Load Config File",0
              even
default_text  dc.b "default",0
              even
other_text    dc.b "other ...",0
              even
m1p11t        dc.b "Save Config File",0
              even
m1p12t        dc.b "About ...",0
              even
m1p13t        dc.b "Iconify",0
              even
m1p14t        dc.b "Quit AIDE",0
              even
m2t           dc.b "Utilities",0
              even
m2p1t         dc.b "Calculator",0
              even
m2p2t         dc.b "ReqEd",0
              even
m2p3t         dc.b "Create BMAP file(s)",0
              even
m2p4t         dc.b "AmigaBASIC -> ASCII",0
              even
m2p5t         dc.b "UppercACEr",0
              even
m2p6t         dc.b "Utility 0",0
              even
m2p7t         dc.b "Utility 1",0
              even
m2p8t         dc.b "Utility 2",0
              even
m2p9t         dc.b "Utility 3",0
              even
m3t           dc.b "Help",0
              even
*--------------------------------------
DirSetup_Titel_Text
              dc.b    "Directory Setup",0
              even
NewSrcDir_Titel_Text
              dc.b    "Source Dir",0
              even
NewTmpDir_Titel_Text
              dc.b    "Temp Dir",0
              even
NewBltDir_Titel_Text
              dc.b    "Built Dir",0
              even
NewDocDir_Titel_Text
              dc.b    "Doc Dir",0
              even
NewModDir_Titel_Text
              dc.b    "SUBMod Dir",0
              even
NewFDDir_Titel_Text
              dc.b    "FD Dir",0
              even
NewEditor_Titel_Text
              dc.b    "Editor",0
              even
NewViewer_Titel_Text
              dc.b    "Viewer",0
              even
NewAGD_Titel_Text
              dc.b    "Amigaguide",0
              even
NewFD2BMAP_Titel_Text
              dc.b    "FD -> BMAP",0
              even
NewAB2ASCII_Titel_Text
              dc.b    "AmigaBASIC -> ASCII",0
              even
NewUppercACEr_Titel_Text
              dc.b    "UppercACEr",0
              even
NewCalc_Titel_Text
              dc.b    "Calculator",0
              even
NewReqEd_Titel_Text
              dc.b    "ReqEd",0
              even
NewUtil0_Titel_Text
              dc.b    "Utility 0",0
              even
NewUtil1_Titel_Text
              dc.b    "Utility 1",0
              even
NewUtil2_Titel_Text
              dc.b    "Utility 2",0
              even
NewUtil3_Titel_Text
              dc.b    "Utility 3",0
              even
*--------------------------------------
Other_Text    dc.b    "Other",0
              even
PubScreen_Text1
              dc.b    "Public",0
              even
PubScreen_Text2
              dc.b    "Screen",0
              even
*--------------------------------------
ReqSet_Text   dc.b    "Requester",0
              even
All_Text      dc.b    "All",0
              even
Error_Text    dc.b    "Error",0
              even
Min_Text      dc.b    "Min",0
              even
Cleanup_Text  dc.b    "Clean up",0
              even
soptversion_Text
              dc.b    "SuperOpt",0
              even
Old_Text      dc.b    "1.x",0
              even
New_Text      dc.b    "2.x",0
              even
*--------------------------------------
text_no_doc_dir1
              dc.b    "No doc dir specified!",0
              even
text_no_doc_dir2
              dc.b    "Please correct your AIDE setup.",0
              even
text_doc_file dc.b    "Doc file(s):",0
              even
text_not_found
              dc.b    "not found!",0
              even
*--------------------------------------
errCA         dc.b    "Object in use.",0
              even
errCC         dc.b    "Directory not found.",0
              even
errCD         dc.b    "Directory name is wrong.",0
              even
errD2         dc.b    "File name is invalid.",0
              even
errD5         dc.b    "Disk is not validated.",0
              even
errD6         dc.b    "Disk is write protected.",0
              even
errDA         dc.b    "Device not mounted.",0
              even
errDD         dc.b    "Disk is full.",0
              even
errDE         dc.b    "File is protected from deletion.",0
              even
errDF         dc.b    "File is write protected.",0
              even
errE0         dc.b    "File is read protected.",0
              even
errE1         dc.b    "No AmigaDOS disk.",0
              even
errE2         dc.b    "No disk in drive.",0
              even
_err_text     dc.b    "DOS error no.",0
              even
err_retry     dc.b    "Retry",0
              even
err_cancel    dc.b    "Cancel",0
              even
err_2text     dc.b    "Try again?",0
              even
err_3text     dc.b    "Oh no!",0
              even
io_error_titel
              dc.b    "AIDE IO Error Request",0
              even
text_font_not_loaded2
              dc.b    "not installed.",0
              even
_text_souce_file_aktiv1
              dc.b    'Source file "',0
              even
text_souce_file_aktiv2
              dc.b    '" is correctly set.',0
              even
_text1_module_dir_error
              dc.b    'SUBMod directory "',0
              even
text2_module_dir_error
              dc.b    '" does not exist.',0
              even
text3_module_dir_error
              dc.b    "Please correct the environment setup.",0
              even
_text1_temp_dir_error
              dc.b    'Temp directory "',0
              even
_error_preco_other_txt
              dc.b    "Error while precompiling with",0
              even
_error_ass_other_txt
              dc.b    "Error while assembling with",0
              even
_error_lnk_other_txt
              dc.b    "Error while linking with",0
              even
_preco_other_txt
              dc.b    "Precompiling with",0
              even
_ass_other_txt
              dc.b    "Assembling with",0
              even
_lnk_other_txt
              dc.b    "Linking with",0
              even
CompileGadText
              dc.b    "Stop",0
              even
_MainWinTitle dc.b    "AIDE Main Window",0
              even
_MsgWinTitle  dc.b    "AIDE Message Window",0
              even
_InputWinTitle
              dc.b    "AIDE Input Window",0
              even
_SetupWinTitle
              dc.b    "AIDE Setup Window",0
              even
_SOptWinTitle dc.b    "SuperOptimizer Options Window",0
              even
_ScreenTitle  dc.b    "AIDE Screen",0
              even
*************************************************************

