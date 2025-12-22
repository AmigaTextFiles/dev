MODULE  CyberQTGlobals;

(* $IFNOT DEBUG *)
  (* $StackChk- $OvflChk- $RangeChk- $CaseChk- $ReturnChk- $NilChk- $TypeChk- $OddChk- $ClearVars- *)
(* $END *)

(* /// ------------------------------- "IMPORT" -------------------------------- *)
IMPORT  cgfx:=CyberGraphics,
        d:=Dos,
        e:=Exec,
        es:=ExecSupport,
        fp:=FixedPoint,
        gfx:=Graphics,
        io:=AsyncIOSupport2;
(* \\\ ------------------------------------------------------------------------- *)

(* /// -------------------------------- "TYPE" --------------------------------- *)
TYPE    Matrix * =ARRAY 3,3 OF fp.FixedPoint32;

        AtomHeader * =STRUCT
            size * : LONGINT;
            id * : LONGINT;
        END;

        HeaderDummy * =STRUCT
            version * : LONGINT;
            creation * : LONGINT;
            modification * : LONGINT;
        END;

        MovieHeader * =STRUCT(head * : HeaderDummy)
            timeScale * : LONGINT;
            duration * : LONGINT;
            rate * : fp.FixedPoint32;
            volume * : fp.FixedPoint16;
            reserved: ARRAY 10 OF CHAR;
            matrix * : Matrix;
            previewTime * : LONGINT;
            previewDuration * : LONGINT;
            posterTime * : LONGINT;
            selectTime * : LONGINT;
            selectDuration * : LONGINT;
            currentTime * : LONGINT;
            nextTrackID * : LONGINT;
        END;

        ColorTable * =STRUCT
            tableSeed * : LONGINT;
            flags * : SET;
            size * : INTEGER;
        END;

        TrackHeader * =STRUCT(head * : HeaderDummy)
            trackID * : LONGINT;
            reserved0: LONGINT;
            duration * : LONGINT;
            reserved1: LONGINT;
            reserved2: LONGINT;
            layer * : INTEGER;
            altGroup * : INTEGER;
            volume * : fp.FixedPoint16;
            reserved3: INTEGER;
            matrix * : Matrix;
            width * : fp.FixedPoint32;
            height * : fp.FixedPoint32;
        END;

        MediaHeader * =STRUCT(head * : HeaderDummy)
            timeScale * : LONGINT;
            duration * : LONGINT;
            language * : INTEGER;
            quality * : INTEGER;
        END;

        HandlerReference * =STRUCT
            version * : LONGINT;
            type * : LONGINT;
            subType * : LONGINT;
            manufacturer * : LONGINT;
            flags * : LONGINT;
            flagMask * : LONGINT;
            name * : e.STRING;
        END;

        VideoMediaHeader * =STRUCT
            version * : LONGINT;
            graphicsMode * : INTEGER;
            opColor * : ARRAY 3 OF INTEGER;
        END;

        SoundMediaHeader * =STRUCT
            version * : LONGINT;
            balance * : INTEGER;
            reserved: INTEGER;
        END;

        DescriptionHeadPtr * =UNTRACED POINTER TO DescriptionHead;
        DescriptionHead * =STRUCT
            size * : LONGINT;
            dataFormat * : LONGINT;
            reserved: ARRAY 6 OF CHAR;
            index * : INTEGER;
        END;

        DummyDescriptionPtr * =UNTRACED POINTER TO DummyDescription;
        DummyDescription * =STRUCT(head * : DescriptionHead);
            data * : LONGINT;
        END;

        VideoDescriptionPtr * =UNTRACED POINTER TO VideoDescription;
        VideoDescription * =STRUCT(head * : DescriptionHead)
            version * : INTEGER;
            revision * : INTEGER;
            vendor * : LONGINT;
            tempQuality * : LONGINT;
            spatQuality * : LONGINT;
            width * : INTEGER;
            height * : INTEGER;
            horizRes * : fp.FixedPoint32;
            vertRes * : fp.FixedPoint32;
            dataSize * : LONGINT;
            frameCount * : INTEGER;
            compression * : ARRAY 32 OF CHAR;
            depth * : INTEGER;
            colorTableID * : INTEGER;
            start * : LONGINT;
            cFlag *  : SET;
            end * : INTEGER;
            colorTable * : LONGINT;
        END;

        SoundDescriptionPtr * =UNTRACED POINTER TO SoundDescription;
        SoundDescription * =STRUCT(head * : DescriptionHead)
            version * : INTEGER;
            revision * : INTEGER;
            vendor * : LONGINT;
            channels * : INTEGER;
            sampleSize * : INTEGER;
            compression * : INTEGER;
            packetSize * : INTEGER;
            sampleRate * : fp.FixedPoint32;
        END;

        DescriptionIndex * =UNTRACED POINTER TO ARRAY MAX(INTEGER) OF DummyDescriptionPtr;

        TimeToSample * =STRUCT
            count * : LONGINT;
            duration * : LONGINT;
        END;
        TimeToSampleIndex * =UNTRACED POINTER TO ARRAY MAX(INTEGER) OF TimeToSample;

        SyncSampleIndex * =UNTRACED POINTER TO ARRAY MAX(INTEGER) OF LONGINT;

        SampleToChunk * =STRUCT
            firstChunk * : LONGINT;
            samplesPerChunk * : LONGINT;
            descriptionID * : LONGINT;
        END;
        SampleToChunkIndex * =UNTRACED POINTER TO ARRAY MAX(INTEGER) OF SampleToChunk;

        SampleSizeIndex * =UNTRACED POINTER TO ARRAY MAX(INTEGER) OF LONGINT;

        ChunkOffsetIndex * =UNTRACED POINTER TO ARRAY MAX(INTEGER) OF LONGINT;

        EditList * =STRUCT
            duration * : LONGINT;
            mediaTime * : LONGINT;
            mediaRate * : fp.FixedPoint32;
        END;
        EditListIndex * =UNTRACED POINTER TO ARRAY MAX(INTEGER) OF EditList;

        TrackPtr * =UNTRACED POINTER TO Track;
        Track * =STRUCT (node * : e.Node)
            head * : TrackHeader;
            mediaHead * : MediaHeader;
            initDuration * : LONGINT;
            startOffset * : LONGINT;
            descriptions * : DescriptionIndex;
            descriptionEntries * : LONGINT;
            times * : TimeToSampleIndex;
            timeEntries * : LONGINT;
            syncs * : SyncSampleIndex;
            syncEntries *  : LONGINT;
            samples * : SampleToChunkIndex;
            sampleEntries * : LONGINT;
            sizes * : SampleSizeIndex;
            sizeEntries * : LONGINT;
            offsets * : ChunkOffsetIndex;
            offsetEntries * : LONGINT;
            edits * : EditListIndex;
            editEntries * : LONGINT;
        END;

        Atom * =STRUCT
            size * : LONGINT;
            id * : LONGINT;
        END;

        AnimInfoPtr * =UNTRACED POINTER TO AnimInfo;
        AnimInfo * =STRUCT
            mvhd * : MovieHeader;
            videoTracks * : e.List;
            audioTracks * : e.List;
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
        qtFile * : io.ASFile;
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
    d.PrintF("CyberQT needs either AGA chipset or CyberGraphX installed\n");
    HALT(0);
  END;
END CheckGfxAbility;
(* \\\ ------------------------------------------------------------------------- *)

BEGIN
  CheckGfxAbility();
  NEW(animInfo);
  es.NewList(animInfo.videoTracks);
  es.NewList(animInfo.audioTracks);
CLOSE
  io.Close(qtFile);
END CyberQTGlobals.

