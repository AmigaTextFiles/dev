;
; DoInstallAgletM2PPC.s
;    24/4/2011
;
; CLI variables
;       mod2version        eg,  "(13.2.2011)"
;       agv3                     eg, "Work:Aglet/M2-v3/Compiler"
;       previous
;       suggest
;       basedir
;       temp
;       res

FAILAT 5
STACK 100000

SET res `REQUESTCHOICE "---AGLET M2 INSTALL---   init" "This script will install the AgletM2PPC Native Module-2 compiler*nDo you want to continue?" "Yes" "Cancel"`

IF $res EQ "0"
   ECHO "User cancel"
   QUIT 10
ENDIF

SET mod2version "(x.x.xxxx)"

;-------------------------------------------------
; Check for SDK with as version of 2.18
;-------------------------------------------------
IF NOT EXISTS SDK:gcc/bin/as NOREQ
   SET res `REQUESTCHOICE "---AGLET M2 INSTALL---   No SDK?" " You do not seem to have the AOS SDK installed.*n AgletM2PPC requires the SDK to create and link Elf files.*n Do you want to continue anyway?" "Yes" "Cancel"`
   IF $res EQ "0"
      ECHO "User cancel"
      QUIT 10
   ENDIF
ELSE
   sdk:gcc/bin/as --version > T:as$version.txt
   CUT string "`type T:as$version.txt`" word=5 > T:as$versionNum.txt
   IF NOT `type T:as$versionNum.txt` EQ 2.18
      SET res `REQUESTCHOICE "---AGLET M2 INSTALL---   Old SDK?" " I expected assembler, 'as', v2.18.*n Do you have an old version of the AOS SDK installed.*n AgletM2PPC requires the SDK 53.8*n Do you want to continue anyway?" "Yes" "Cancel"`
      IF $res EQ "0"
         ECHO "User cancel"
         QUIT 10
      ENDIF
   ENDIF
ENDIF

SET agv3 "XXX:"
SET suggest "XXX:"
SET previous "false"
;-----------------------------------------------------------------------------
; Get info on any existing installation from "agv3:" if possible, or "M2Lv3:"
;-----------------------------------------------------------------------------

IF EXISTS agv3: NOREQ 
   SET agv3 `which agv3:`                     ; no trailing slash, but may be trailing colon
;;;;   SET suggest `pathpart add "$agv3" ""`  ; adds trailing slash, unless it ends in colon
   SET suggest $agv3
   SET previous "true"
ELSE
IF EXISTS M2Lv3: NOREQ
   SET agv3 `which M2Lv3:`                    ; this will be one dir down (eg "a:v3/system"), but has no trailing slash
   SET agv3 `pathpart dir "$agv3"`            ; this will lop off the "/system" part, leaving a dir name w/o trailing slash (or disk with trailing colon)
;;;;   SET suggest `pathpart add "$agv3" ""`  ; adds trailing slash, unless it ends in colon   SET suggest $agv3
   SET suggest $agv3
   SET previous "true"
ELSE
IF EXISTS Work: NOREQ
   SET suggest Work:
ELSE
   SET suggest SYS:
ENDIF
ENDIF
ENDIF

IF $previous EQ "false"
   SKIP rflab
ENDIF

SET res `REQUESTCHOICE "---AGLET M2 INSTALL---   replace" "You seem to have an existing release in '$suggest'*nReplace existing release?*n*n(The existing Aglet directory will be renamed)" "Ok" "Cancel"`

IF $res EQ "0"
   ECHO "User cancel"
   QUIT 10
ENDIF

;IF $res EQ "1"               ; replace it

   ASSIGN agv3:                                            ; remove any assigns
   ASSIGN M2LV3:

   SET parentdir `pathpart dir $suggest`
   SET basedir "$suggest"

   SET temp `DATE LFORMAT=%H-%M-%S`
   SET temp "$suggest-"$temp
   RENAME "$suggest" TO "$temp"

   SKIP InstallItLab

;ENDIF

;--------
LAB rflab
;--------

REQUESTFILE drawersonly drawer "$suggest" Title "AgletM2PPC Install Location (dir AgletV3 will be created here)" > t:rq.txt
SET res $rc

type t:rq.txt

IF $res GE "5" VAL
   ECHO "User cancel"
   QUIT 10
ENDIF

SET parentdir `type t:rq.txt`
SET basedir `PathPart ADD "$parentdir" AgletV3`

IF EXISTS "$basedir"  NOREQ
   SET res `REQUESTCHOICE "---AGLET M2 INSTALL---   dir exists" "AgletV3 dir already exists*nYou should 'replace all' when asked" "Ok" "Different target dir" "Cancel"`
   IF $res EQ "0" VAL
      ECHO "User cancel"
      QUIT 10
   ENDIF
   IF $res EQ "2" VAL
      SET suggest "$parentdir"
      SKIP rflab BACK
   ENDIF
ENDIF

;---------------
LAB InstallItLab
;---------------

SET res `REQUESTCHOICE "---AGLET M2 INSTALL---   Install AgletM2PPC?" "About to install into '$basedir' *n (26 MB)" "Ok" "Different target dir" "Cancel"`

IF $res EQ "0"
   ECHO "User cancel"
   QUIT 10
ENDIF

IF $res EQ "2"
   SET suggest "$parentdir"
   SKIP rflab BACK
ENDIF

FAILAT 20
; not necessary MAKEDIR "$basedir"
PROTECT "$basedir/#?" +rwd ALL QUIET
FAILAT 5

REQUESTCHOICE "AgletM2PPC" "Unpacking will start shortly..." TIMEOUTSECS 3 "->" > NIL:

;--------------
; Unpacking Bin
;--------------

sys:utilities/unarc from AgletM2PPCBin.lha to "$parentdir" Auto

SET temp `PathPart ADD "$basedir" m2-assigns.s`

ECHO ";" > "$temp"
ECHO ";  m2-assigns.s" >> "$temp"
ECHO ";" >> "$temp"
ECHO ";" >> "$temp"
ECHO ASSIGN agv3: "*"$basedir*"" >> "$temp"
ECHO ";" >> "$temp"
ECHO "ASSIGN m2lv3: agv3:system agv3:amiga agv3:iso agv3:reaction agv3:sysmod agv3:experimental" >> "$temp"
ECHO ";" >> "$temp"
ECHO "PATH agv3: ADD" >> "$temp"
ECHO "LOADWB NEWPATH  ; <remove this line if the script is run in user-startup>" >> "$temp"

PROTECT "$temp" +s

REQUESTCHOICE "---AGLET M2 INSTALL---   Assigns and Path" "About to display M2-Assigns.s, and execute it after you close the display." "OK" > NIL:
Multiview "$temp"
EXECUTE "$temp"

REQUESTCHOICE "---AGLET M2 INSTALL---   M2 Assigns" "Script m2-Assigns.s was created and run. *n*n 'M2Lv3:' is necessary for the package to work,*n and the execute Path must be correct. *n*n You may want to call m2-Assigns.s from user-startup" "OK" > NIL:

SET res `REQUESTCHOICE "---AGLET M2 INSTALL---   Implementation sources?" "About to copy the support module implementation source files." "Ok" "Skip"`

;--------------
; Unpacking Src
;--------------
IF NOT $res EQ "0"
   sys:utilities/unarc from AgletM2PPCModSrc.lha to "$parentdir" Auto
ENDIF

;-------
LAB EXAM
;-------

PATH "$basedir" ADD

; These I can't make work if there is a space in basedir !!
rx "ADDRESS WORKBENCH; OPTIONS FAILAT 20; OPTIONS RESULTS; WINDOW '$basedir' OPEN"
rx "ADDRESS WORKBENCH; OPTIONS FAILAT 20; OPTIONS RESULTS; MENU WINDOW '$basedir' INVOKE WINDOW.UPDATE"
rx "ADDRESS WORKBENCH; OPTIONS FAILAT 20; OPTIONS RESULTS; MENU WINDOW '$basedir' INVOKE WINDOW.CLEANUPBY.TYPE"
rx "ADDRESS WORKBENCH; OPTIONS FAILAT 20; OPTIONS RESULTS; MENU WINDOW '$basedir' INVOKE WINDOW.SNAPSHOT.ALL"

;-------
LAB TEST
;-------

SET temp `PathPart ADD "$basedir" Examples`
CD "$temp"

REQUESTCHOICE "---AGLET M2 INSTALL---   Compile Test" "About to compile Examples/HelloWorld.mod" "OK" > NIL:

mod2 HelloWorld.mod
IF NOT $rc EQ "0"
   ECHO "Compile Error on HelloWorld.mod"
   QUIT 10
ENDIF

REQUESTCHOICE "---AGLET M2 INSTALL---   Link Test" "About to link Examples/HelloWorld" "OK"

mod2lnk HelloWorld

REQUESTCHOICE "---AGLET M2 INSTALL---   Run Test" "About to run HelloWorld" "OK" > NIL:

HelloWorld > CON:100/100/300/200/Hello/WAIT/CLOSE

REQUESTCHOICE "---AGLET M2 INSTALL---   Example Programs" " For verification of the install,*n you may want to compile and link some of the programs *n in `PathPart $basedir Examples`" "OK" > NIL:

REQUESTCHOICE "---AGLET M2 INSTALL---   Post install" "Things you may want to do post install:*n*n     - call m2-assigns.s from user-startup*n*n     - choose your editor as described in the docs*n*n     - set default icons from the samples here*n*n" "OK" > NIL:

SET temp `PathPart ADD "$basedir" Docs`
REQUESTCHOICE "---AGLET M2 INSTALL---   AgletM2PPC Guide" "Docs are in $temp" "OK" > NIL:

SET temp `PathPart ADD "$basedir" Docs/AgletM2PPC.guide`
Multiview "$temp"


