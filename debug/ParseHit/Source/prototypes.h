
/* PH_main.c */
/*      15 */ UBYTE *AddAString ( UBYTE *string );
/*      40 */ void FreeStringBuffer ( void );
/*      52 */ UWORD FillSourceNameLineNumber ( struct InfoHit *newhit );
/*     129 */ UWORD AddToHit ( struct InfoHit *newhit );
/*     164 */ void FreeHitList ( void );
/*     178 */ UBYTE *PutAnEnd ( UBYTE *EnfHitBuffer , UBYTE character );
/*     192 */ void ParseEnfHitBuffer ( UBYTE *EnfHitBuffer );
/*     245 */ void PutMessageinSCMSG ( void );
/*     280 */ void main ( int argc , UBYTE *argv []);
/*     305 */ UBYTE *LoadFileInMemory ( UBYTE *FileName );
