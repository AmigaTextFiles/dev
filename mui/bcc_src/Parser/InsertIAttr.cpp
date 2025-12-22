
#include "ParseBC.H"
#include "ClassDef.h"
#include "VarDef.h"

void ParseBC::InsertIAttrPre( FILE *fh, unsigned short test )
{
		cont = 0;
		FScan( VarDef, vds, &(cd->Var) ) cont += (vds->switches & test) ? 1 : 0;
		if( cont ) fprintf( fh, " struct TagItem *tags, *tag;\n" );

}

void ParseBC::InsertIAttr( FILE *fh, unsigned short test )
{
		
		if( cont ) {
		
			fprintf( fh, " for( tags = msg->ops_AttrList; tag = NextTagItem(&tags); ) {\n		switch( tag->ti_Tag ) {\n", cd->Name );
			FScan( VarDef, vd, &(cd->Var) ) {
				if( (vd->switches & test) && !(switches & SW_VIRTUAL) ) {
					fprintf( fh, "			case %s:", vd->FullName() );
					if( vd->switches & SW_SIMPLE ) fprintf( fh, " *((unsigned long*)&data->%s) = tag->ti_Data; break;\n", vd->Name );
					else fprintf( fh, " a%s%s%s( cl, obj, (void*)tag%s ); break;\n", cd->Name, vd->Name, vd->SGIName( test ), vd->passmsg & test ? ", msg" : "" );
				}
			}

			fprintf( fh, "		}\n	}\n" );
		}

}
