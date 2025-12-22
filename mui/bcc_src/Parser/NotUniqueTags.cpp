#include "Global.h"
#include "ClassDef.h"
#include "MethodDef.h"
#include "VarDef.h"

#define N 100

struct ct {
	unsigned long tag;
	TextItem *ti;
};

short ClassDef::CheckDoubleTags( void )
{
	short ret = 0, cnt;
	ct *c;
	
	c = new ct[N];
	
	cnt = 0;
	
	FScan( MethodDef, md, this ) {
		c[cnt].tag = md->GetTagVal();
		c[cnt].ti = (TextItem*)md;
		cnt++;
		if( cnt >= N ) break;
	}

	FScan( VarDef, vd, &(Var) ) {
		c[cnt].tag = vd->GetTagVal();
		c[cnt].ti = (TextItem*)vd;
		cnt++;
		if( cnt >= N ) break;
	}

	short f, g;
	for( f = 0; f < cnt; f++ ) 
		for( g = f+1; g < cnt; g++ ) 
			if( c[f].tag == c[g].tag ) {
				printf( "Warning!! Tags: \"%s\" and \"%s\" have the same tag value.\n  Change name of one of them immediately!!\n", c[f].ti->Name, c[f].ti->Name );
				ret = 1;
			}
	

	delete c;
	
	return ret;

}

short GlobalDef::CheckDoubleTags( void )
{
	short ret = 0, cnt;
	ct *c;
	
	c = new ct[N];
	
	cnt = 0;
	FScan( ClassDef, cd1, &ClassList ) {
		c[cnt].tag = cd1->GetTagVal();
		c[cnt].ti = (TextItem*)cd1;
		cnt++;
		if( cnt >= N ) break;
	}

	short f, g;
	for( f = 0; f < cnt; f++ ) 
		for( g = f+1; g < cnt; g++ ) 
			if( c[f].tag == c[g].tag ) {
				printf( "Warning!! Classes: \"%s\" and \"%s\" produce the same root of tag value.\n  Change name of one of them immediately!!\n", c[f].ti->Name, c[f].ti->Name );
				ret = 1;
			}
	
	
	delete c;
	
	return ret;

}
