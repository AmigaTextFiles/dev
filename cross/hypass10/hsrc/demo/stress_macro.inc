  * stress macro include file

    MACRO stressmacro1
      FCB NARG
      beq \@rst+1
\@rst FDB $12
      FDB \@rst
    ENDM

    MACRO stressmacro2
      FCB NARG
      beq \@rst+2
\@rst FDB $12
      FDB \@rst
    ENDM

    MACRO stressmacro3
      FCB NARG
      beq \@rst+3
\@rst FDB $12
      FDB \@rst
    ENDM


  .END ; end of stress macro file
  this doesn't get assembled any more.