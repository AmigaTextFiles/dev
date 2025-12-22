/******************************************************************************\
**  $VER: inc/secallib.inc 1.0                                                **
**  Secal Release 1.0                                                         **
**  Secal.lib interface definitions                                           **
**  Copyright (c) 1996 Tibor Kulcsar & Jozsef Makrai (TDS Development)        **
\******************************************************************************/


import strlen;
import strcopy;
import strcopym;
import strdiff;
import strdiffi;
import strcat;
import strcatm;


#-------------------------------------------------------------------------------


pattern StrLen(_str) is					# D0.L=LENGTH, A0=STR END
a0:=_str;
call strlen;
endp;															# STRLEN



pattern StrCopy(_source,_dest) is				# A0=DEST END
safe a0:=_source; a1:=_dest;;
call strcopy;
endp;															# STRCOPY



pattern StrCopyM(_source,_dest,_max) is				# A0=DEST END
safe a0:=_source; a1:=_dest; d0.l:=_max;;
call strcopym;
endp;															# STRCOPYM



pattern StrDiff(_source,_dest) is				# D0=FIRST DIFF, OR 0
safe a0:=_source; a1:=_dest;;
call strdiff;
endp;															# STRDIFF



pattern StrDiffI(_source,_dest) is				# D0=FIRST DIFF, OR 0
safe a0:=_source; a1:=_dest;;
call strdiffi;
endp;															# STRDIFFI



pattern StrCat(_source,_dest) is				# A0=DEST END
safe a0:=_source; a1:=_dest;;
call strcat;
endp;															# STRCAT



pattern StrCatM(_source,_dest,_max) is				# A0=DEST END
safe a0:=_source; a1:=_dest; d0.l:=_max;;
call strcatm;
endp;															# STRCATM


#-------------------------------------------------------------------------------

