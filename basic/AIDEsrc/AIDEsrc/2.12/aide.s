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
* AIDE.s
*--------------------------------------
* begonnen              : 18. 12. 1995
* beendet               : Version 2.01 am 16.05.1996 veroeffentlicht.
* Programmierer         : Herbert Breuer
* Programmiersprache    : Assembler
* Assembliert mit dem PhxAss V4.32ß von Frank Wille
*--------------------------------------
* begonnen              : 17. 04. 1997
* Programmierer         : Daniel Seifert <dseifert@hell1og.be.schule.de>
*--------------------------------------
        Incdir  ASM_INC:

        Include exec/exec.i
        Include exec/exec_lib.i

        Include dos/datetime.i
        Include dos/dos.i
        Include dos/dosasl.i
        Include dos/dosextens.i
        Include dos/dostags.i
        Include dos/exall.i
        Include dos/dos_lib.i

        Include graphics/graphics_lib.i

        Include intuition/gadgetclass.i
        Include intuition/intuition.i
        Include intuition/intuition_lib.i

        Include libraries/asl.i
        Include libraries/asl_lib.i

        Include libraries/gadtools.i
        Include libraries/gadtools_lib.i

        Include libraries/mrt_lib.i

        Include utility/utility.i
        Include utility/utility_lib.i
        Include utility/tagitem.i

        Include diskfont/diskfont_lib.i

        Include workbench/icon_lib.i
        Include workbench/startup.i
        Include workbench/workbench.i
        Include workbench/wb_lib.i
*--------------------------------------
        Incdir ASM_MAC:

        Include AideMacros.mac
*--------------------------------------
        Include ASM_INC:workbench/easystart.i

        Incdir  asm:aide/main/

        Include start.i
        Include ende.i
        Include layout.i
        Include create_gadgets.i
        Include steuerung.i
        Include sperr_frei.i
        Include menu.i
        Include msg_win.i
        Include requester.i
        Include setup_win.i
        INCLUDE iconify.i
*--------------------------------------
        Incdir  asm:aide/inc/

        Include compile.i
        Include module_list.i
        Include general.i
        Include wbargs.i
        Include gadget.i
        Include gadget_rout.i
        Include source.i
        Include program.i
*--------------------------------------
        Incdir  asm:aide/sys/

        Include sys_asl.i
        Include sys_dos.i
        Include sys_exec.i
        Include sys_gadtools.i
        Include sys_gfx.i
        Include sys_intuition.i
        Include sys_mrt.i
        Include sys_utility.i
*--------------------------------------
        Incdir  asm:aide/disk/

        Include asl_req_laden.i
        Include asl_req_sichern.i
        Include datei_laden.i
        Include datei_sichern.i
        Include dateiname.i
        Include fileinfo.i
        Include fi_block.i
        Include io_error.i
        Include new_buffer.i
        Include pruefe_datei.i
        Include config_file.i
*--------------------------------------
        Incdir  asm:aide/daten/

        Include intui_str.i
        Include menu_str.i
        Include texte.i
        Include daten.i
*--------------------------------------
END
