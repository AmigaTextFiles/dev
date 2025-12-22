
TERM DEFUN(xx_Integer_X62_X61_0,(a,b)  ,TERM a AND TERM b)
                                          {return Integer_X62_X61_0(a,b);}
TERM DEFUN(xx_Integer_X62_0,(a,b)      ,TERM a AND TERM b)
                                          {return Integer_X62_0(a,b)    ;}
TERM DEFUN(xx_Integer_X60_X61_0,(a,b)  ,TERM a AND TERM b)
                                          {return Integer_X60_X61_0(a,b);}
TERM DEFUN(xx_Integer_X60_0,(a,b)      ,TERM a AND TERM b)
                                          {return Integer_X60_0(a,b)    ;}
TERM DEFUN(xx_Integermod_0,(a,b)       ,TERM a AND TERM b)
                                          {return Integermod_0(a,b)     ;}
TERM DEFUN(xx_Integerdiv_0,(a,b)       ,TERM a AND TERM b)
                                          {return Integerdiv_0(a,b)     ;}
TERM DEFUN(xx_Integer_X42_0,(a,b)      ,TERM a AND TERM b)
                                          {return Integer_X42_0(a,b)    ;}
TERM DEFUN(xx_Integer_X45_0,(a,b)      ,TERM a AND TERM b)
                                          {return Integer_X45_0(a,b)    ;}
TERM DEFUN(xx_Integer_X43_0,(a,b)      ,TERM a AND TERM b)
                                          {return Integer_X43_0(a,b)    ;}
TERM DEFUN(xx_Integernegate_0,(b)      ,TERM b)  
                                          {return Integernegate_0(b)    ;}
TERM DEFUN_VOID(xx_Integermaxint_0) { unsigned u=0; u--; return (TERM)(u>>1); }

XINITIALIZE(Integer_Xinitialize,__XINIT_Integer)
