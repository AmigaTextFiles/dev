(VSprite (NextVSprite 0 VSprite . t) (PrevVSprite 4 VSprite . t) (DrawPath 
8 VSprite . t) (ClearPath 12 VSprite . t) (OldY 16 . 2) (OldX 18 . 2) (
Flags 20 . 2) (Y 22 . 2) (X 24 . 2) (Height 26 . 2) (Width 28 . 2) (Depth 
30 . 2) (MeMask 32 . 2) (HitMask 34 . 2) (ImageData 36 word . t) (
BorderLine 40 word . t) (CollMask 44 word . t) (SprColors 48 word . t) (
VSBob 52 Bob . t) (PlanePick 56 . 1) (PlaneOnOff 57 . 1) (VUserExt 58 . 2))

(Bob (Flags 0 . 2) (SaveBuffer 2 word . t) (ImageShadow 6 word . t) (Before
10 Bob . t) (After 14 Bob . t) (BobVSprite 18 VSprite . t) (BobComp 22 
AnimComp . t) (DBuffer 26 DBufPacket . t) (BUserExt 30 . 2))

(AnimComp (Flags 0 . 2) (Timer 2 . 2) (TimeSet 4 . 2) (NextComp 6 AnimComp 
. t) (PrevComp 10 AnimComp . t) (NextSeq 14 AnimComp . t) (PrevSeq 18 
AnimComp . t) (AnimCRoutine 22 (WORD) . t) (YTrans 26 . 2) (XTrans 28 . 2) 
(HeadOb 30 AnimOb . t) (AnimBob 34 Bob . t))

(AnimOb (NextOb 0 AnimOb . t) (PrevOb 4 AnimOb . t) (Clock 8 . 4) (AnOldY 
12 . 2) (AnOldX 14 . 2) (AnY 16 . 2) (AnX 18 . 2) (YVel 20 . 2) (XVel 22 . 
2) (YAccel 24 . 2) (XAccel 26 . 2) (RingYTrans 28 . 2) (RingXTrans 30 . 2) 
(AnimORoutine 32 (WORD) . t) (HeadComp 36 AnimComp . t) (AUserExt 40 . 2))

(DBufPacket (BufY 0 . 2) (BufX 2 . 2) (BufPath 4 VSprite . t) (BufBuffer 8 
word . t))

(collTable ((*collPtrs 0 16 . 4))

