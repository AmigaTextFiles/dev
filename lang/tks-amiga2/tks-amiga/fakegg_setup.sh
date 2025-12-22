assign gg: gg
assign ade: gg:
setenv TERM amiga-f
setenv PS1=$PWD>
if EXISTS ram:GG-datestamp
  skip END
else
  date >ram:GG-datestamp
endif
assign LOCAL: exists >NIL:
if WARN
  assign LOCAL: gg:
endif

; Make assigns for Geek Gadgets things, like general binaries,
; manual pages, info files, etc.  We try to keep these to an
; absolute minimum!

assign BIN: GG:bin
assign SBIN: GG:sbin
;assign USR: GG:usr
assign USR: GG:
assign VAR:  GG:var
assign HOME: gg:home
assign ETC: GG:etc
assign INFO:   GG:info
assign MAN: GG:man
assign TMP: t:
assign SHARE: gg:share
;assign X11R6.3: gg:usr/x11r6.3
path BIN: ADD
path SBIN: ADD
assign include: gg:include
assign libexec: gg:libexec
assign lib: gg:lib
;assign libx11: gg:usr/x11r6.3/lib/x11
assign etc: gg:etc
assign inet: gg:inet


; Add various directories under GG: that supplement the normal
; system logical defines, like "LIBS:", "L:", "DEV:", etc.
; We have to have C: in here if we want the Workbench to notice
; anything in BIN:, or have them available from any CLIs already
; running.

assign C:   GG:bin      ADD
;assign DEVS:   GG:Sys/Devs ADD
;assign LIBS:   GG:Sys/Libs ADD
;assign L:   GG:Sys/L ADD
;assign S:   GG:Sys/S ADD

; Assign GNU: to GG: for backwards compatibility.  This will be
; removed at some point in the future.

assign GNU:   GG:   

; Mount the ixpipe: device

; mount IXPIPE: from DEVS:MountList.IXPIPE

; Install GNU Emacs version 18.59
;   Assign GNUEmacs: so emacs can find it's files.
;   Cancel any system supplied alias for emacs.
;   Use the emacs specific shell since bin:sh (PD ksh) causes a crash
;     when you try to use it under emacs.

;if EXISTS GG:lib/emacs/18.59
;  assign GNUemacs: GG:lib/emacs/18.59
;  unalias emacs
;  setenv ESHELL GNUemacs:etc/sh
;endif

; Install Matt Dillon's fifo library, for emacs and others.
; Note that it must be able to find LIBS:fifo.library when run.

;run <nil: >nil: L:fifo-handler

LAB END
