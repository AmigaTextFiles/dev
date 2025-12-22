#include "CreateInitCl.h"

#include "Global.h"
#include "Family.h"
#include "ClassDef.h"

#include <stdio.h>
#include <string.h>


short CreateInitCl::Create( void )
{

 FILE *fh;
 
 if( !ClassList.isEmpty() ) {
 
 	/* Sort */
 	
 	ClassDef *a, *b;
 	short nmax, n = 0;
 	
 	nmax = ClassList.Count();
 	
 	printf( "There are %hd classes\n", nmax );

 	nmax *= nmax;

	FScan( ClassDef, cd, &ClassList ) {
		if( cd->sw & SW_SELFCREATE ) {
 			cd = (ClassDef*)cd->Prev();
			cd->Next()->Remove();
		} else
 		if( cd->superpriv ) {
 			for( a = (ClassDef*)cd->Prev(); a->Prev(); a = (ClassDef*)a->Prev() ) {
 				if( !strcmp( cd->PSuper, a->Name ) ) goto OK;
 			}
 			
 			for( b = 0, a = (ClassDef*)cd->Next(); a->Next(); a = (ClassDef*)a->Next() ) {
 				if( !strcmp( cd->PSuper, a->Name ) ) {
 					b = a;
 					break;
 				}
 			}
 			
 			if( !b ) {
 				printf( "Error: Super class \"%s\" of \"%s\" not found\n", cd->PSuper, cd->Name );
 				return 0;
 			}
 			
 			cd->Swap( b );	
 			
 			n++;
 			
 			if( n > nmax ) {
 				printf( "Error: Infinite loop when sorting super classes\n" );
 				return 0;
 			}
 			
 			cd = (ClassDef*)b->Prev();
 		
 		}
 		OK:
 	}
 
 
	if( !(fh = fopen( "initcl.c", "w" )) ) {
 		printf( "Can not open ouput file\n" );
	 	return 0;
	}
	
	printf( "Creating \"initcl.c\" ...\n" );

	ins_every.Insert( fh );
	ins_initcl.Insert( fh );

	FScan( ClassDef, c1, &ClassList ) {
		switch( *c1->type ) {
			case 'B':
				fprintf( fh, "struct IClass *%s_Create( void );\n", c1->Name);
				break;
			default:
				fprintf( fh, "struct MUI_CustomClass *%s_Create( void );\n", c1->Name);
		}
	}

	fprintf( fh, "\n#include \"initcl.h\"\n\n" );


	FScan( ClassDef, c2, &ClassList ) {
		switch( *c2->type ) {
			case 'B':
				fprintf( fh, "struct IClass *cl_%s;\n", c2->Name);
				break;
			default:
				fprintf( fh, "struct MUI_CustomClass *cl_%s;\n", c2->Name);
		}
	}

	
	fprintf( fh, "\nshort _initclasses( void )\n{\n" );
	
	FScan( ClassDef, c3, &ClassList ) {
		fprintf( fh, "	if( !(cl_%s = %s_Create()) ) goto error;\n", c3->Name, c3->Name );
	}
	
	fprintf( fh, "\n	return 1;\n error:\n	_freeclasses();\n	return 0;\n}\n\n" );
	
	fprintf( fh, "void _freeclasses( void )\n{\n" );

	ClassDef *c4;
	for( c4 = (ClassDef*)ClassList.Last(); c4->Prev(); c4 = (ClassDef*)c4->Prev() ) {
		switch( *c4->type ) {
			case 'B':
				fprintf( fh, "	FreeClass( cl_%s );\n", c4->Name );
				break;
			default:
				fprintf( fh, "	MUI_DeleteCustomClass( cl_%s );\n", c4->Name );
		}
	}
	
	fprintf( fh, "}\n" );
		
	fclose( fh );


	if( !(fh = fopen( "initcl.h", "w" )) ) {
 		printf( "Can not open ouput file\n" );
	 	return 0;
	}

	printf( "Creating \"initcl.h\" ...\n" );
	 
	FScan( ClassDef, c5, &ClassList ) {
		switch( *c5->type ) {
			case 'B':
				fprintf( fh, "extern struct IClass *cl_%s;\n", c5->Name);
				break;
			default:
				fprintf( fh, "extern struct MUI_CustomClass *cl_%s;\n", c5->Name);
		}
	}
	
	fprintf( fh, "\nshort _initclasses( void );\nvoid _freeclasses( void );\n" );

 }
 
 if( ClassList.CheckDoubleTags() ) return 0;

 return 1;

}
