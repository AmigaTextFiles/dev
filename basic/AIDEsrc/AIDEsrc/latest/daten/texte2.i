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

err_text               ds.b 50
text_font_not_loaded1  ds.b 50
ass_other_txt          ds.b 100
lnk_other_txt          ds.b 100
preco_other_txt        ds.b 100
error_ass_other_txt    ds.b 100
error_lnk_other_txt    ds.b 100
error_preco_other_txt  ds.b 100
text1_module_dir_error ds.b 120
text1_temp_dir_error   ds.b 120
text_souce_file_aktiv1 ds.b 100


*--------------------------------------
dos_cmd_preco_other
        dc.b    "ACE:bin/"
        ds.b    32
        even

dos_cmd_preco_other_offset equ 8

dos_cmd_lnk_other
        dc.b    "ACE:bin/"
        ds.b    32
        even

dos_cmd_lnk_other_offset equ 8
*--------------------------------------
dos_cmd_ass_other
        dc.b    "ACE:bin/"
        ds.b    32
        even

dos_cmd_ass_other_offset equ 8
*--------------------------------------
dos_cmd_acpp  dc.b    "ACE:bin/acpp",0
              even
*--------------------------------------
dos_cmd_nap   dc.b    "ACE:bin/NAP",0
              even
*--------------------------------------
dos_cmd_removeline
              dc.b    "ACE:bin/removeline",0
              even
*--------------------------------------
dos_cmd_ace   dc.b    "ACE:bin/ACE -E",0
              even
*--------------------------------------
dos_cmd_superopt
              dc.b    "ACE:bin/SuperOptimizer",0
              even
*--------------------------------------
dos_cmd_a68k  dc.b    "ACE:bin/a68k",0
              even
*--------------------------------------
dos_cmd_phxass
              dc.b    "ACE:bin/phxass FROM",0
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

*--------------------------------------
R_Text        dc.b    "R",0
              even

m3p1t   dc.b "AIDE",0
        even
m3p2t   dc.b "ACE",0
        even
m3p3t   dc.b "SuperOptimizer",0
        even
m3p4t   dc.b "A68K",0
        even
m3p5t   dc.b "PhxAss",0
        even
m3p6t   dc.b "BLink",0
        even
m3p7t   dc.b "PhxLnk",0
        even
m3p8t   dc.b "ACE Reference",0
        even
m3p9t   dc.b "ACE Reserved Words",0
        even
m3p10t  dc.b "ACE Examples",0
        even
m3p11t  dc.b "ACE History",0
        even
m3p12t  dc.b "ACEcalc",0
        even
m3p13t  dc.b "ReqEd",0
        even


ARexxPortName dc.b "AIDE",0
              dc.b 7
              even
RXFF_Result   dc.l 0
