
/*

Algo: Cercare pezzi di files uguali, in qualsiasi punto, grandi almeno 20 bytes.

*/

struct chunk
{
 ULONG 		size;
 UBYTE 		flags;
 UBYTE 		hole00;
 struct chunk 	*friend;
 UBYTE		*data;
};



