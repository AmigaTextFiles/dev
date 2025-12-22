PROC main() HANDLE
DEF d=0

d:=Val(arg) /* Let's get the alue from the shell args */

IF d<1 /* No point in going futher as 1 bit IS lowest bit possible :-D */
   WriteF('Invalid value: Value to low!\n')
   Raise(10)
ENDIF
   IF d>32 /* We can't go higher due to 32bit math, higher need 64bit math */
   WriteF('Invalid value: Value to high!\n')
   Raise(10)
ENDIF

WriteF('Depth \d: ',d)
IF d<31
   WriteF('\d',Shl(1,d)) /* This is the magic, just shift the depth value, */
ELSE                     /* 1 bit to the left and wher'e done :-) */
   SELECT d              /* Not true really 31 and 32 make trouble, */
     CASE 31             /* due to 32bit math/routines 31/32 value get signed */
          WriteF('2147483648') /* So I have prepared two values for us here */
     CASE 32                   /* don't you just love these cooking shows? :-D */
          WriteF('4294967296') /* with 64bit rutines and <digit to string> print,*/
   ENDSELECT                   /* there should be no problems like this */
ENDIF                          /* well except 63 and 64 bit though :-) */
WriteF(' Colors!')
SELECT d /* now for the text */
  CASE 1; WriteF(' ;Black and white is sooo cute! (it is)')
  CASE 2; WriteF(' ;Default WB, wow lot''s of colors! (yeah right)')
  CASE 3; WriteF(' ;Getting better, not THAT bad WB though.')
  CASE 4; WriteF(' ;Cartoons? PS! Max color on Hires ECS')
  CASE 5; WriteF(' ;Cartoons? PS! Max color on Lores ECS (EHB = 64)')
  CASE 6; WriteF(' ;This is more like it. (HAM6 = 4096)')
  CASE 7; WriteF(' ;Getting better!')
  CASE 8; WriteF(' ;AGA here we come, wow a rainbow! (HAM8 = 262144)')
  CASE 9; WriteF(' ;Never seen one of those yet!')
  CASE 10; WriteF(' ;Hmm, unusual.')
  CASE 11; WriteF(' ;Very rare.')
  CASE 12; WriteF(' ;Ah, popular among cheaper digtizers.')
  CASE 13; WriteF(' ;Hmm, what?!!')
  CASE 14; WriteF(' ;Yeah I know lots of weird colors!')
  CASE 15; WriteF(' ;Not really that much used you know!')
  CASE 16; WriteF(' ;NOW! Where really starting to talk colors!')
  CASE 17; WriteF(' ;Might have seen these once in a while!')
  CASE 18; WriteF(' ;Moving on up!')
  CASE 19; WriteF(' ;Upwards I say, upwards!')
  CASE 20; WriteF(' ;Getting high in here!')
  CASE 21; WriteF(' ;Woa this is really getting high!')
  CASE 22; WriteF(' ;Don''t look down but...')
  CASE 23; WriteF(' ;Eeek I think I''m gonna fall!!!')
  CASE 24; WriteF(' ;Amazing isn''t it? Shangri La (or GFX cards :-)')
  CASE 25; WriteF(' ;Don''t ask me!')
  CASE 26; WriteF(' ;Hey stop asking me!')
  CASE 27; WriteF(' ;Who knows!')
  CASE 28; WriteF(' ;I don''t care!')
  CASE 29; WriteF(' ;I''m getting sick!')
  CASE 30; WriteF(' ;Cool, this isn''t so bad!')
  CASE 31; WriteF(' ;Aw shit, I think I just hit the moon up here!')
  CASE 32; WriteF(' ;WOA! WHAT A TRIP! Almost like... real, man!')
ENDSELECT
WriteF('\n')
EXCEPT
ENDPROC exception

/* YES! I KNOW I could have put the color values with the text,
   but where's the fun in doing that?
   (other than playing with the calculator)
   Nah I like my rutine it's simple,
   and it works (except for 31/32 depth due to limitations in 32math)
   And I discovered/thought of it after playing with depth calculation.
   If anyone wish to make a better one that goes to 64bits in depth,
   or gosh perhaps convert back from colors to depth then feel free
   to do so this program is Freely Distributable Public domain.

   Roger Hågensen <emsai@online.no>
*/

CHAR '$VER: dephcol 1.0 (6.1.1999) #PROGRAM © Msi Software',0
