#include "Global.h"
#include "TextItem.h"

GlobalDef ClassList;

InsertFile ins_every( ".bcc_every" );
InsertFile ins_header( ".bcc_header" );
InsertFile ins_code( ".bcc_code" );
InsertFile ins_initcl( ".bcc_initcl" );

Prf Prefs;

Prf::~Prf()
{

	SafeFScan( TextItem, ti, &textlist ) {
		ti->Remove();
		delete ti;
	}

}

Prf::Prf( void )
{
	deftype = "MUI";
	incdir = "ENV:bcc/";
	nosaveds = publicheader = forcetrans = verbose = noversion = 0;
	tagbase = 0;
	reallines = 0;
}

char *Prf::AddText( char *t, short len )
{
	TextItem *ti;

	ti = new TextItem( t, len );

	textlist.AddTail( (Family*)ti );

	return ti->Name;

}

