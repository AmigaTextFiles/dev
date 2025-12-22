   {   Definitions for the gradientslider BOOPSI class }

{ ***************************************************************************}

{$I "Include:Utility/TagItem.i"}

{ ***************************************************************************}

Const
    GRAD_Dummy       = (TAG_USER+$05000000);
    GRAD_MaxVal      = (GRAD_Dummy+1);     {  max value of slider         }
    GRAD_CurVal      = (GRAD_Dummy+2);     {  current value of slider     }
    GRAD_SkipVal     = (GRAD_Dummy+3);     {  "body click" move amount    }
    GRAD_KnobPixels  = (GRAD_Dummy+4);     {  size of knob in pixels      }
    GRAD_PenArray    = (GRAD_Dummy+5);     {  pen colors                  }


{ ***************************************************************************}



