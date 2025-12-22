static TERM
DEFUN(my_mark,(A),TERM A) { return copy_StreamIO_inStream(A); }

static void
DEFUN(my_drop,(A),TERM A) { free_StreamIO_inStream(A); }

static TERM
DEFUN(my_topos,(A,B),TERM A AND TERM B)
    { free_StreamIO_inStream(B); return A; }

void
DEFUN(xx__StreamRWread_0,(ARG0,ARG1,RES1,RES2,RES3,IR),
 TERM  ARG0 AND
 TERM  ARG1 AND
 TERM *RES1 AND
 TERM *RES2 AND
 TERM *RES3 AND
 INSTREC IR)
 { INtoUSER_MODE(xx_StreamIOchar_0,my_mark,my_drop,my_topos,ARG1);
   _RUNTIME_READ(_SStreamRW_term,ARG0,(TERM)0,RES1,RES2,RES3);
   *RES3=INreturnMODE();
 }

void
DEFUN(xx__StreamRWwrite_0,(ARG0,ARG1,RES1,RES2,IR),
      TERM  ARG0 AND
      TERM  ARG1 AND
      TERM *RES1 AND
      TERM *RES2 AND
      INSTREC IR)
 { OUTtoUSER_MODE(StreamIO_X43_2,ARG1);
   _RUNTIME_WRITE(_SStreamRW_term,ARG0,(TERM)0,RES1,RES2);
   *RES2=OUTreturnMODE();
 }

void
DEFUN(xx__StreamRWwrite_1,(ARG0,ARG1,RES1,RES2,IR),
      TERM  ARG0 AND
      TERM  ARG1 AND
      TERM *RES1 AND
      TERM *RES2 AND
      INSTREC IR)
 { OUTtoUSER_MODE(StreamIO_X43_0,ARG1);
   _RUNTIME_WRITE(_SStreamRW_term,ARG0,(TERM)0,RES1,RES2);
   *RES2=OUTreturnMODE();
 }

XINITIALIZE(StreamRW_Xinitialize,__XINIT_StreamRW)

