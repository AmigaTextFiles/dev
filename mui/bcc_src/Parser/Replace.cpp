#include "Replace.h"
#include <string.h>

Replace::Replace()
{
	n = 0;
}

void Replace::Clear( void )
{
 short f;
 
 for( f = 0; f < n; f++ ) delete dat[f];
 
 n = 0;
}

Replace::~Replace()
{
 Clear(); 
}

void Replace::Add( char *old, short olds, char *_new, short news, char *extra )
{
  repdat *rd = new repdat( old, olds, _new, news );
  
  short i;
  for( i = 0; i < n; i++ ) if( dat[i]->o[0] <= rd->o[0] ) break;
  
  short f;
  for( f = n; f > i; f-- ) dat[f] = dat[f-1];
  
  if( extra ) rd->extra = extra;
  
  dat[i] = rd;
  n++;

}

repdat::repdat( char *old, short olds, char *_new, short news )
{

 if( !olds ) olds = strlen( old );
 o = new char[olds+1];
 memcpy( o, old, olds );
 o[olds] = 0;
 os = olds;

 if( !news ) news = strlen( _new );
 n = new char[news+1];
 memcpy( n, _new, news );
 n[news] = 0;
 ns = news;

}

repdat::~repdat()
{
	if( o ) delete o;
	if( n ) delete n;
}

char *Replace::Check( char *s, short sl )
{

	if( !sl ) sl = strlen( s );
	
	short f;
	for( f = 0; f < n; f++ )
		if( sl == dat[f]->os && !strncmp( s, dat[f]->o, sl ) ) return dat[f]->n;
		
	return 0;

}



char *Replace::GetExtra( char **ex )
{

	while( gec < n && !((char*)dat[gec]->extra) ) gec++;
	
	if( gec >= n ) return 0;
	
	
	*ex = (char*)dat[gec]->extra;
	return dat[gec++]->n;


}