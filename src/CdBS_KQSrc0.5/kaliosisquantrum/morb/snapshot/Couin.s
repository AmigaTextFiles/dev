*
* CdBSian Obviously Universal & Interactive Nonsense (COUIN)
* (Absurdité CdBSienne Manifestement Universelle et Interactive)
* ©1997-1998, CdBS Software (MORB)
* Main source
* $Id: Couin.s 0.22 1998/02/13 13:16:53 MORB Exp MORB $
*

;fs "Includes"
	 machine   68020
	 incdir    "IncludeIII:"
	 include   "exec/exec_lib.i"
	 include   "exec/memory.i"
	 include   "exec/lists.i"
	 include   "exec/nodes.i"
	 include   "dos/dos_lib.i"
	 include   "dos/dos.i"
	 include   "dos/dosextens.i"
	 include   "dos/exall.i"
	 include   "utility/tagitem.i"
	 include   "intuition/intuition_lib.i"
	 include   "intuition/intuitionbase.i"
	 include   "intuition/intuition.i"
	 include   "intuition/screens.i"
	 include   "graphics/graphics_lib.i"
	 include   "graphics/gfxbase.i"
	 include   "libraries/lowlevel_lib.i"
	 include   "libraries/lowlevel.i"
	 include   "libraries/keymap_lib.i"
	 include   "hardware/custom.i"
	 include   "hardware/dmabits.i"
	 include   "asm:debug.i"
;fe
;fs "Macros"
CALL     macro
	 jsr       _LVO\1(a6)
	 endm

TRUE     = -1
FALSE    = 0

gdwarfpt = sprpt

AbsExecBase        = 4
CustomBase         = $dff000
BlitQueueSize      = 100
;fe
	 include   "KaliosisQuantrum_rev.i"
;fs "Chaîne de version"
	 bra.s     _Init

	 dc.b      0,"$VER: "
	 VERS
	 dc.b      " ("
	 DATE
	 dc.b      ") ©1997-1998, CdBS Software",0
	 even
;fe

DISABLEGUIGFX      SET       0

	 include   "Support.i"
	 include   "Playfield.i"
	 include   "Copper.i"
	 include   "CopIns.i"
	 include   "OO.i"
	 include   "GuiSupport.i"
	 include   "Gui.i"
	 include   "Editor.i"
	 include   "Init.s"
	 include   "Iconify.s"
	 include   "ScreenSwitch.s"
	 include   "Main.s"
	 include   "Keyboard.s"
	 include   "Support.s"
	 include   "Playfield.s"
	 include   "Copper.s"
	 include   "Scrolls.s"
	 include   "Ripolin.s"
	 include   "MapEditor.s"
	 include   "AutoCrop.s"
	 include   "OO.s"
	 include   "GuiSupport.s"
	 include   "Gui.s"
	 include   "Editor.s"
	 include   "Test.s"
	 include   "ChipDats.s"
	 include   "BSS.s"

	 END
