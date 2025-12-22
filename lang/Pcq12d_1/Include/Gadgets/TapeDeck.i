   {   Definitions for the tapedeck BOOPSI class   }

{***************************************************************************}

{$I "Include:Utility/TagItem.i"}

{***************************************************************************}
const
    TDECK_Dummy            = (TAG_USER+$05000000);
    TDECK_Mode             = (TDECK_Dummy + 1);
    TDECK_Paused           = (TDECK_Dummy + 2);

    TDECK_Tape             = (TDECK_Dummy + 3);
        { (BOOL) Indicate whether tapedeck or animation controls.  Defaults
         * to FALSE. }

    TDECK_Frames           = (TDECK_Dummy + 11);
        { (LONG) Number of frames in animation.  Only valid when using
         * animation controls. }

    TDECK_CurrentFrame     = (TDECK_Dummy + 12);
        { (LONG) Current frame.  Only valid when using animation controls. }

{***************************************************************************}

{ Possible values for TDECK_Mode }
    BUT_REWIND     = 0;
    BUT_PLAY       = 1;
    BUT_FORWARD    = 2;
    BUT_STOP       = 3;
    BUT_PAUSE      = 4;
    BUT_BEGIN      = 5;
    BUT_FRAME      = 6;
    BUT_END        = 7;

{***************************************************************************}


