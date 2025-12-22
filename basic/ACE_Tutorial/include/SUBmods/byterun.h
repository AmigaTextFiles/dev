/*
** SubMod declarations for ACE Basic
**
** Note: © by Oliver Gantert
**       <LucyG@t-online.de>
**
**       Don't forget to link with <byterun.o>
**       
** Date: 19-08-99
**
*/

DECLARE SUB LONGINT Cmp_BR(ADDRESS source_mem, ADDRESS target_mem, LONGINT source_len) EXTERNAL

/*  Cmp_BR returns size of crunched data, 0 if something went wrong  /*


DECLARE SUB DCmp_BR(ADDRESS source_mem, ADDRESS target_mem, LONGINT target_len) EXTERNAL

/*
**  You MUST know the size of decrunched data, so store it somewhere
**  before compression!
*/
