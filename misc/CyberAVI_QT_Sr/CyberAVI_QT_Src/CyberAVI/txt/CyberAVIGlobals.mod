MODULE  CyberAVIGlobals;

(* $IFNOT DEBUG *)
  (* $StackChk- $OvflChk- $RangeChk- $CaseChk- $ReturnChk- $NilChk- $TypeChk- $OddChk- $ClearVars- *)
(* $END *)

(* /// ------------------------------- "IMPORT" -------------------------------- *)
IMPORT  cgfx:=CyberGraphics,
        d:=Dos,
        gfx:=Graphics;
(* \\\ ------------------------------------------------------------------------- *)

(* /// -------------------------------- "TYPE" --------------------------------- *)
TYPE    AVIHeader * =STRUCT
            microsPerFrame * : LONGINT;
            maxBytesPerSec * : LONGINT;
            reserved * : LONGINT;
            flags * : LONGSET;
            totalFrames * : LONGINT;
            initialFrames * : LONGINT;
            streams * : LONGINT;
            suggestedBufferSize * : LONGINT;
            width * : LONGINT;
            height * : LONGINT;
            scale * : LONGINT;
            rate * : LONGINT;
            start * : LONGINT;
            length * : LONGINT;
        END;

        AVIStreamHeader * =STRUCT
            fccType * : LONGINT;
            fccHandler * : LONGINT;
            flags * : LONGSET;
            priority * : LONGINT;
            initialFrames * : LONGINT;
            scale * : LONGINT;
            rate * : LONGINT;
            start * : LONGINT;
            length * : LONGINT;
            suggestedBufferSize * : LONGINT;
            quality * : LONGINT;
            sampleSize * : LONGINT;
            reserved * : ARRAY 4 OF LONGINT;
        END;

        VIDS * =STRUCT
            size * : LONGINT;
            width * : LONGINT;
            height * : LONGINT;
            planes * : INTEGER;
            bitCnt * : INTEGER;
            compression * : LONGINT;
            imageSize * : LONGINT;
            xPelsPerMeter * : LONGINT;
            yPelsPerMeter * : LONGINT;
            clrUsed * : LONGINT;
            clrImportant * : LONGINT;
        END;

        VIDSHeader * =STRUCT
            strh * : AVIStreamHeader;
            strf * : VIDS;
        END;

        AUDS * =STRUCT
            format * : INTEGER;
            channels * : INTEGER;
            samplesPerSec * : LONGINT;
            avgBytesPerSec * : LONGINT;
            blockAlign * : INTEGER;
            bitsPerSample * : INTEGER;
            extSize * : INTEGER;
        END;

        AUDSHeader * =STRUCT
            strh * : AVIStreamHeader;
            strf * : AUDS;
        END;

        AnimInfoPtr * =UNTRACED POINTER TO AnimInfo;
        AnimInfo * =STRUCT
            avih * : AVIHeader;
            vids * : VIDSHeader;
            auds * : AUDSHeader;
        END;
(* \\\ ------------------------------------------------------------------------- *)

(* /// -------------------------------- "CONST" -------------------------------- *)
CONST   pauseAnim * =-2;
        skipAnim * =-1 ;
        noError * =0;
        unknownError * =1;
        readError * =2;
(* \\\ ------------------------------------------------------------------------- *)

(* /// --------------------------------- "VAR" --------------------------------- *)
VAR     agaOnly - : BOOLEAN;
        cgfxOnly - : BOOLEAN;
        gfxBoth - : BOOLEAN;
        animInfo * : AnimInfoPtr;
(* \\\ ------------------------------------------------------------------------- *)

(* /// --------------------- "PROCEDURE CheckGfxAbility()" --------------------- *)
PROCEDURE CheckGfxAbility();

VAR     aga: BOOLEAN;
        cyber: BOOLEAN;

BEGIN
  aga:=(gfx.hrAgnus IN gfx.base.chipRevBits0) & (gfx.hrDenise IN gfx.base.chipRevBits0) & (gfx.aaAlice IN gfx.base.chipRevBits0) & (gfx.aaLisa IN gfx.base.chipRevBits0);
  cyber:=(cgfx.cgfx#NIL);
  agaOnly:=aga & ~cyber;
  cgfxOnly:=~aga & cyber;
  gfxBoth:=aga & cyber;
  IF ~aga & ~cyber THEN
    d.PrintF("CyberAVI needs either AGA chipset or CyberGraphX installed\n");
    HALT(0);
  END;
END CheckGfxAbility;
(* \\\ ------------------------------------------------------------------------- *)

BEGIN
  CheckGfxAbility();
  NEW(animInfo);
END CyberAVIGlobals.
