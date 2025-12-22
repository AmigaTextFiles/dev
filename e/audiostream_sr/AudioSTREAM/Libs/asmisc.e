
/*

      AudioSTREAM Professional
      (c) 1997-98 Immortal SYSTEMS

      Source codes for version 1.0
      
      =================================================

      Source:     asmisc.e
      Description:    asmisc.library source
      Contains:   memorypool handling routines for asguisetup
                  interface to image objects for asguisetup
      Version:    1.0
 --------------------------------------------------------------------
*/


LIBRARY 'asmisc.library',1,1,'asmisc.library v1.0 (1.2.3345)' IS strginit,strgflush,gs,aboutImg

MODULE '*adst:aboutimage','exec','exec/memory','*adst:global'



PROC strginit()
ENDPROC

/* called on all strings, dummy now */

PROC gs(s:PTR TO CHAR) IS s

/* returns about image object */

PROC aboutImg(muibase)
ENDPROC imgAboutObject(muibase)

/* allocates taglist in memory pool */


PROC strgflush()
ENDPROC


PROC main()
ENDPROC
