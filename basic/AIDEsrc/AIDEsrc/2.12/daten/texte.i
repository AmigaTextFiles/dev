*   AIDE 2.12, an environment for ACE
*   Copyright (C) 1995/97 by Herbert Breuer
*		  1997/99 by Daniel Seifert
*
*                 contact me at: dseifert@berlin.sireco.net
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

*--------------------------------------
* Texte
*--------------------------------------
        dc.b    "$VER: AIDE 2.12 (05/19/97)",0
        even
*--------------------------------------
about_gad_txt
        dc.b    "I like ACE",0
        even
text_about1
        dc.b    "AIDE Version 2.12 © Herbert Breuer 1995/97, Daniel Seifert 1997.",0
        even
text_about2
        dc.b    "Development Environment for A C E,",0
        even
text_about3
        dc.b    "the very special Amiga BASIC Compiler.",0
        even
text_about4
        dc.b    "Copyright © David Benn 1991/1997.",0
        even
*--------------------------------------
req_title
        dc.b    "AIDE Request",0
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
text_okay
        dc.b    "Okay",0
        even
*--------------------------------------
text_i_see
        dc.b    "I see",0
        even
*--------------------------------------
text_yes
        dc.b    "Yes",0
        even
*--------------------------------------
text_no
        dc.b    "No",0
        even
*--------------------------------------
text_cancel
        dc.b    "Cancel",0
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
text_wblib
        dc.b    "Workbench.library not opened.",0
        even
*--------------------------------------
text_asllib
        dc.b    "Asl.library not opened.",0
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
text_utillib
        dc.b    "Utility.library not opened.",0
        even
*--------------------------------------
text_doslib
        dc.b    "Dos.library not opened.",0
        even
*--------------------------------------
text_gfxlib
        dc.b    "Graphics.library not opened.",0
        even
*--------------------------------------
text_iconlib
        dc.b    "Icon.library not opened.",0
        even
*--------------------------------------
text_no_port
        dc.b    "Message port not created.",0
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
text_font_not_loaded1
        ds.b    40

text_font_not_loaded2
        dc.b    " not installed.",0
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
text_souce_file_aktiv1
        dc.b    'Source file "',0
        ds.b    80
        even
text_souce_file_aktiv2
        dc.b    '" is correctly set.',0
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
text1_module_dir_error
        dc.b    'SUBMod directory "'
        ds.b    80
        even

text2_module_dir_error
        dc.b    '" does not exist.',0
        even

text3_module_dir_error
        dc.b    "Please correct the environment setup.",0
        even

text_no_module_dir
        dc.b    "No SUBMod directory specified.",0
        even

text1_temp_dir_error
        dc.b    'Temp directory "'
        ds.b    80
        even

text_too_many_modules
        dc.b    "Too many modules selected",0
        even
*--------------------------------------
* Fenster Texte
*--------------
Source_Titel_Text
        dc.b    " Source ",0
        even
*--------------------------------------
Program_Titel_Text
        dc.b    " Program ",0
        even
*--------------------------------------
Make_Titel_Text
        dc.b    " Make ",0
        even
*--------------------------------------
Preco_Titel_Text
        dc.b    " Precompiler ",0
        even
*--------------------------------------
AceOpt_Titel_Text
        dc.b    " ACE Options ",0
        even
*--------------------------------------
View_Titel_Text
        dc.b    " View ",0
        even
*--------------------------------------
SuperOpt_Titel_Text
        dc.b    " SuperOptimizer ",0
        even
*--------------------------------------
Ass_Titel_Text
        dc.b    " Assembler ",0
        even
*--------------------------------------
LinkLib_Titel_Text
        dc.b    " Linker Lib ",0
        even
*--------------------------------------
Linker_Titel_Text
        dc.b    " Linker ",0
        even
*--------------------------------------
Module_Titel_Text
        dc.b    " Module ",0
        even
*--------------------------------------
* GadToolGadgetTexte
*-------------------

* Source

GadText_0       dc.b    "Set",0
           even
GadText_1       dc.b    "Reset",0
           even
GadText_2       dc.b    "Edit",0
           even

* Program

GadText_3       dc.b    "Precompile",0
           even
GadText_4       dc.b    "Compile",0
           even
GadText_5       dc.b    "Assemble",0
           even
GadText_6       dc.b    "Link",0
           even
GadText_7       dc.b    "Run",0
           even
GadText_8       dc.b    "Run in Shell",0
           even
* Make

GadText_9       dc.b    "Executable",0
           even
GadText_10      dc.b    "Application",0
           even
GadText_11      dc.b    "Module",0
           even

* Precompiler

GadText_12      dc.b    "APP",0
           even
GadText_13      dc.b    "ACPP",0
           even
GadText_14      dc.b    "other",0
           even

* ACE Options

GadText_15      dc.b    "Break Trapping",0
           even
GadText_16      dc.b    "Assem. Comment",0
           even
GadText_17      dc.b    "Create Icon",0
           even
GadText_18      dc.b    "Optimize",0
           even
GadText_19      dc.b    "Window Trapping",0
           even
GadText_20      dc.b    "other",0
           even

* SuperOptimizer

GadText_21      dc.b    "active",0
           even
GadText_22      dc.b    "Set Level",0
           even

* View

GadText_23      dc.b    "Precompiled Source",0
           even
GadText_24      dc.b    "Assembled Source",0
           even
GadText_25      dc.b    "ACE Compiler Errors",0
           even

* Assembler

GadText_26      dc.b    "A68K",0
           even
GadText_27      dc.b    "PhxAss",0
           even
GadText_28      dc.b    "other",0
           even
GadText_29      dc.b    "Small Code",0
           even
GadText_30      dc.b    "Small Data",0
           even
GadText_31      dc.b    "Debug Info",0
           even
GadText_32      dc.b    "Set Options",0
           even

* Linker Lib

GadText_33      dc.b    "Ami.lib",0
           even
GadText_34      dc.b    "Amiga.lib",0
           even
GadText_35      dc.b    "other",0
           even
* Linker

GadText_36      dc.b    "BLink",0
           even
GadText_37      dc.b    "PhxLnk",0
           even
GadText_38      dc.b    "other",0
           even
GadText_39      dc.b    "Small Code",0
           even
GadText_40      dc.b    "Small Data",0
           even
GadText_41      dc.b    "No Debug Info",0
           even
GadText_42      dc.b    "Set Options",0
           even
GadText_43      dc.b    "Remove all Modules",0
           even
*---------------------------------------------
acpp_txt
                dc.b    " Precompiling with ACPP... ",0
                even
app_txt
                dc.b    " Precompiling with APP... ",0
                even

preco_other_txt
                dc.b    " Precompiling with "
                ds.b    32
                even

removeline_txt
                dc.b    " Processing RemoveLine... ",0
                even

ace_txt
                dc.b    " Compiling with ACE... ",0
                even

superopt_txt
                dc.b    " SuperOptimizing... ",0
                even

a68k_txt
                dc.b    " Assembling with A68K... ",0
                even

phxass_txt
                dc.b    " Assembling with PhxAss... ",0
                even
ass_other_txt
                dc.b    " Assembling with "
                ds.b    32
                even

blink_txt
                dc.b    " Linking with BLink... ",0
                even
phxlnk_txt
                dc.b    " Linking with PhxLnk... ",0
                even
lnk_other_txt
                dc.b    " Linking with "
                ds.b    32
                even
*--------------------------------------
dos_cmd_acpp
        dc.b    "ACE:bin/acpp",0
        even
*--------------------------------------
dos_cmd_app
        dc.b    "ACE:bin/app",0
        even
*--------------------------------------
dos_cmd_preco_other
        dc.b    "ACE:bin/"
        ds.b    32
        even
*--------------------------------------
dos_cmd_removeline
        dc.b    "ACE:bin/removeline",0
        even
*--------------------------------------
dos_cmd_ace
        dc.b    "ACE:bin/ACE -E",0
        even
*--------------------------------------
dos_cmd_superopt
        dc.b    "ACE:bin/SuperOptimizer",0
        even
*--------------------------------------
dos_cmd_a68k
        dc.b    "ACE:bin/a68k",0
        even
*--------------------------------------
dos_cmd_phxass
        dc.b    "ACE:bin/phxass FROM",0
        even
*--------------------------------------
dos_cmd_ass_other
        dc.b    "ACE:bin/"
        ds.b    32
        even
*--------------------------------------
dos_cmd_blink
        dc.b    "ACE:bin/blink",0
        even
*--------------------------------------
dos_cmd_phxlnk
        dc.b    "ACE:bin/phxlnk",0
        even
*--------------------------------------
dos_cmd_lnk_other
        dc.b    "ACE:bin/"
        ds.b    32
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
error_app_txt
                dc.b    "Error while precompiling with APP.",0
                even

error_preco_other_txt
                dc.b    "Error while precompiling with "
                ds.b    32
                even

error_removeline_txt
                dc.b    "Error while processing RemoveLine.",0
                even

error_ace_txt
                dc.b    "Error while compiling with ACE.",0
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
error_ass_other_txt
                dc.b    "Error while assembling with "
                ds.b    32
                even

error_blink_txt
                dc.b    "Error while linking with BLink.",0
                even
error_phxlnk_txt
                dc.b    "Error while linking with PhxLnk.",0
                even
error_lnk_other_txt
                dc.b    "Error while linking with "
                ds.b    32
                even
*--------------------------------------
default_aide_name       dc.b    "AIDE",0
                        even
*--------------------------------------
default_ace_dir         dc.b    "ACE:",0
                        even
*--------------------------------------
default_aide_path       dc.b    "ACE:AIDE/AIDE",0
                        even
*--------------------------------------
default_aide_dir        dc.b    "ACE:AIDE",0
                        even
*--------------------------------------
default_bin_dir         dc.b    "ACE:bin",0
                        even
*--------------------------------------
default_bmap_dir        dc.b    "ACEbmaps:",0
                        even
*--------------------------------------
default_doc_dir         dc.b    "ACE:docs",0
                        even
*--------------------------------------
default_fd_dir          dc.b    "ACE:fd",0
                        even
*--------------------------------------
default_icon_dir        dc.b    "ACE:icons",0
                        even
*--------------------------------------
default_inc_dir         dc.b    "ACEinclude:",0
                        even
*--------------------------------------
default_lib_dir         dc.b    "ACElib:",0
                        even
*--------------------------------------
default_mod_dir         dc.b    "ACE:mods",0
                        even
*--------------------------------------
default_src_dir         dc.b    "ACE:prgs",0
                        even
*--------------------------------------
default_blt_dir         dc.b    "ACE:run",0
                        even
*--------------------------------------
default_tmp_dir         dc.b    "ACE:temp",0
                        even
*--------------------------------------
default_ab2ascii        dc.b    "ACE:Utils/ab2ascii/ab2ascii",0
                        even
*--------------------------------------
default_uppercacer      dc.b    "ACE:Utils/UppercACEr/UppercACEr",0
                        even
*--------------------------------------
default_fd2bmap         dc.b    "ACE:Utils/FD2BMAP/FD2BMAP",0
                        even
*--------------------------------------
default_calc            dc.b    "ACE:Utils/ACEcalc/ACEcalc",0
                        even
*--------------------------------------
default_reqed           dc.b    "ACE:Utils/ReqEd/ReqEd",0
                        even
*--------------------------------------
default_editor          dc.b    "C:Ed",0
                        even
*--------------------------------------
default_viewer          dc.b    "ACE:bin/MuchMore",0
                        even
*--------------------------------------
default_agdtool         dc.b    "Sys:Utilities/AmigaGuide",0
                        even
*--------------------------------------
default_mltvtool        dc.b    "Sys:Utilities/Multiview",0
                        even
*--------------------------------------
old_editor_def          dc.b    "EDITOR",0
                        even
old_viewer_def          dc.b    "VIEWER",0
                        even
old_calc_def            dc.b    "CALCTOOL",0
                        even
old_agd_def             dc.b    "AGDTOOL",0
                        even
old_tmpdir_def          dc.b    "TMPDIR",0
                        even
old_srcdir_def          dc.b    "SRCDIR",0
                        even
old_bltdir_def          dc.b    "BLTDIR",0
                        even
old_docdir_def          dc.b    "DOCDIR",0
                        even
old_moddir_def          dc.b    "MODDIR",0
                        even
*--------------------------------------
ram_disk_string         dc.b    "Ram Disk:",0
                        even
*--------------------------------------
exe_icon_name           dc.b    "exe.info",0
                        even
text_b_ext              dc.b    "b",0
                        even
text_bas_ext            dc.b    "bas",0
                        even
*--------------------------------------
dcpp_name               dc.b    "dcpp",0
                        even
ami_lib_name            dc.b    "ami.lib",0
                        even
amiga_lib_name          dc.b    "amiga.lib",0
                        even
*--------------------------------------
startup_lib_name        dc.b    "startup.lib",0
                        even
db_lib_name             dc.b    "db.lib",0
                        even
*--------------------------------------
small_code_string       dc.b    "SMALLCODE",0
                        even
small_data_string       dc.b    "SMALLDATA",0
                        even
no_debug_string         dc.b    "NODEBUG",0
                        even
*--------------------------------------
ace_error_string        dc.b    "ace.err",0
                        even
*--------------------------------------
Cmd_Line_Text           dc.b    "Enter command line arguments",0
                        even
*--------------------------------------
Ace_Options_Text        dc.b    "Enter additional ACE options",0
                        even
Asm_Options_Text        dc.b    "Enter additional assembler options",0
                        even
Lnk_Options_Text        dc.b    "Enter additional linker options",0
                        even
*--------------------------------------
Preco_Other_Text        dc.b    "Enter precompiler name",0
                        even
Asm_Other_Text          dc.b    "Enter assembler name",0
                        even
Lib_Other_Text          dc.b    "Enter library name",0
                        even
Lnk_Other_Text          dc.b    "Enter linker name",0
                        even
*--------------------------------------
laden_Text              dc.b    "Select a file to open.",0
                        even
*-------------------------------------
view_Text               dc.b    "Select a file to view.",0
                        even
*-------------------------------------
rename_Text1            dc.b    "Select a file to rename.",0
                        even
*--------------------------------------
rename_Text2            dc.b    "Select a new file name.",0
                        even
*--------------------------------------
copy_Text1              dc.b    "Select a file to copy.",0
                        even
*--------------------------------------
copy_Text2              dc.b    "Where to copy to?",0
                        even
*--------------------------------------
delete_Text             dc.b    "Select a file to delete.",0
                        even
*-------------------------------------
print_Text              dc.b    "Select a file to print.",0
                        even
*--------------------------------------
config_laden_Text       dc.b    "Load AIDE config file.",0
                        even
*-------------------------------------
set_source_Text         dc.b    "Set source.",0
                        even
*-------------------------------------
config_sichern_Text     dc.b    "Save AIDE config file as...",0
                        even
*--------------------------------------
dirname_Text            dc.b    "Please select a directory.",0
                        even
*--------------------------------------
filename_Text           dc.b    "Please select a filename.",0
                        even
*--------------------------------------
bmaps_Text              dc.b    "Please select bmap file(s).",0
                        even
*--------------------------------------
ab2ascii_Text1          dc.b    "Select AmigaBASIC file(s).",0
                        even
*--------------------------------------
ab2ascii_Text2          dc.b    "Select destination directory.",0
                        even
*--------------------------------------

* Default Directory- und Filenamen
*---------------------------------

ConfigDirname           dc.b    "ACE:AIDE/",0
                        even
ConfigFilename          dc.b    "AIDE2.config",0
                        even
ConfigFilenameLength    equ     *-ConfigFilename

oldConfigFilename       dc.b    "AIDE.config",0
                        even
oldOptionsFilename      dc.b    "AIDE.options",0
                        even
*--------------------------------------
Exec_Prg_Text           dc.b    "Please enter command string:",0
                        even
*--------------------------------------
spawn_shell_string      dc.b    "newshell",0
                        even
*--------------------------------------
aide_doc_name           dc.b    "aide.doc",0
                        even
aide_guide_name         dc.b    "aide.guide",0
                        even
*--------------------------------------
ace_doc_name            dc.b    "ace.doc",0
                        even
ace_guide_name          dc.b    "ace.guide",0
                        even
*--------------------------------------
superopt_guide_name     dc.b    "superoptimizer.guide",0
                        even
*--------------------------------------
a68k_doc_name           dc.b    "a68k.doc",0
                        even
*--------------------------------------
phxass_guide_name       dc.b    "phxass.guide",0
                        even
*--------------------------------------
phxlnk_guide_name       dc.b    "phxlnk.guide",0
                        even
*--------------------------------------
blink_doc_name          dc.b    "blink.doc",0
                        even
*--------------------------------------
ace_ref_name            dc.b    "ref.guide",0
                        even
*--------------------------------------
ace_words_name          dc.b    "ace-rwords",0
                        even
*--------------------------------------
example_guide_name      dc.b    "example.guide",0
                        even
*--------------------------------------
ace_history_name        dc.b    "history",0
                        even
*--------------------------------------
acecalc_doc_name        dc.b    "acecalc.doc",0
                        even
acecalc_guide_name      dc.b    "acecalc.guide",0
                        even
*--------------------------------------
reqed_doc_name          dc.b    "reqed.doc",0
                        even
reqed_guide_name        dc.b    "reqed.guide",0
                        even
*--------------------------------------
printer_name            dc.b    "PRT:",0
                        even
text_printer_error1     dc.b    "Printer trouble.",0
                        even
text_printer_error2     dc.b    "Please check printer and cable.",0
                        even
text_printer_error3     dc.b    "Continue printing?",0
                        even
*--------------------------------------
text_printer_openerror1 dc.b    "Printer device not opened.",0
                        even
text_printer_openerror2 dc.b    "Please check your system setup.",0
                        even
*--------------------------------------
