#include "ParseBH.h"
#include "MethodDef.h"
#include "ClassDef.h"
#include "Global.h"

#include "VarDef.h"

#include <string.h>

short ParseBH::Start( void )
{

	IfDefBeg();
	
	ins_every.Insert( ofh );
	ins_header.Insert( ofh );

	UpdateLineNo();

	switches = 0;

	while( 1 ) {
	
		GetToken();
		if( !TokLen ) break;

		SetCType();
		
		if( TokLen == 5 && !strncmp( "Class", Tok, 5 ) ) {
			if( !DoClass() ) {
				if( !ErrorBuf ) Error( 12 );
				return 0;
			}
		} else
		if( TokLen == 7 && !strncmp( "include", Tok, 7 ) ) {
			if( !DoHeader() ) {
				if( !ErrorBuf ) Error( 12 );
				return 0;
			}
		} else
		if( TokLen == 10 && !strncmp( "selfcreate", Tok, 10 ) ) {
			switches |= SW_SELFCREATE;
			StopCopy();
			StartCopy();
		} else switches = 0;

	}

	IfDefEnd();

	return 1;

}

short ParseBH::DoClass( void )
{
 short BLevel;

	StopCopy();

	GetToken();
	if( !TokLen ) return 0;
		
	if( strlen( (char*)sfname ) != TokLen || strncmp( (char*)sfname, Tok, strlen( (char*)sfname ) )  ) {
		Error( 1 );
		return 0;
	}

	ClassDef *cd;
	
	cd = new ClassDef( Tok, TokLen );

	if( !cd ) { printf( "Memory failture\n" ); exit( 10 ); }

	cd->sw = switches;
	ClassList.AddTail( (Family*)cd );

	classdef = cd;
	cd->type = ctype;

	BLevel = MBracket;

	GetToken();
	if( !TokLen ) return 0;

	/* Super class */
	if( chcmp( ':' ) ) {

		GetToken();
		if( !TokLen ) return 0;

		if( TokLen == 7 && !strncmp( "private", Tok, 7 ) ) {

			cd->superpriv = 1;

			GetToken();
			if( !TokLen ) return 0;

		}

		memcpy( cd->PSuper, Tok, min( TokLen, 30 ) );
		cd->PSuper[ min( TokLen, 30 ) ] = 0;

		GetToken();
		if( !TokLen ) return 0;

	} else {
		switch( *cd->type ) {
			case 'B':
				strcpy( cd->PSuper, "\"rootclass\"" );
				break;
			default:
				strcpy( cd->PSuper, "MUIC_Notify" );
		}
	}

	if( !chcmp( '{' ) ) {
		Error( 2 );
		return 0;
	}
	
	fprintf( ofh, "typedef struct {\n" ); 

	StartCopy();

	short nods = 0;
	short swtch = 0;

	InitClassPtrDef();

	UpdateLineNo();

	while( 1 ) {
	
		next:	
		GetToken();
		if( !TokLen ) return 0;

		if( chcmp( '}' ) && MBracket == BLevel ) break;



		/* shortcuts to data variables */
		if( ( ( chcmp( ',' ) || chcmp( ';' ) || chcmp( ':' ) || chcmp( '[') ) || chcmp( '=' ) ) && PrevTok[0] && (PrevType == ALN) ) {
			String opbuf( "(data->" );
			opbuf += PrevTok;
			opbuf += ")";

			String AttrName( PrevTok );

			/* Simple Set Get Init variables */
			if( chcmp( ':' ) ) {

				StopCopy();

				GetToken();
				if( !TokLen ) return 0;

				if( TokType != ALN || TokLen > 3 ) {
					Error( 9 );
					return 0;
				}

				VarDef *vd = new VarDef( (char*)AttrName, Tok, TokLen, cd, swtch|SW_SIMPLE );
				cd->Var.AddTail( (Family*)vd );

				StartCopy();

				GetToken();
				if( !TokLen ) return 0;

			}

			String defval;

			/* default values */
			if( chcmp( '=' ) ) {


				StopCopy();

				GetToken();
				if( !TokLen ) return 0;

				StartCopy();

				defval.Copy( Tok, TokLen );

				GetToken();
				if( !TokLen ) return 0;

			}

			cd->rep.Add( (char*)AttrName, 0, (char*)opbuf, 0, (char*)defval );


		}


		/* Class Ptr definition */
		short ret;
		ret = ClassPtrDefinition( &cd->clref );
		if( ret < 0 ) return 0;
		if( ret ) goto next;

		/* Method definition */
		if( TokLen == 6 && !strncmp( Tok, "Method", 6 ) ) {
			StopCopy();

			GetToken();
			if( !TokLen ) return 0;

			if( TokType != ALN ) {
				Error( 4 );
				return 0;
			}			

			MethodDef *md;
			md = new MethodDef( Tok, TokLen, cd, swtch );

			short CLevel = CBracket;
			
			GetToken();
			if( !TokLen ) return 0;
			
			if( !chcmp( '(' ) ) {
				Error( 5 );
				return 0;
			}
			
			while( 1 ) {

				GetToken();
				if( !TokLen ) return 0;
				
				if( chcmp( ')' ) && CBracket == CLevel ) break;
		
			}

			GetToken();
			if( !TokLen ) return 0;
			
			if( !chcmp( ';' ) ) {
				Error( 3 );
				return 0;
			}
			
			cd->AddTail( (Family*)md );
			
			StartCopy();
		} else {
		/* Attribute definition */
		if( TokLen == 9 && !strncmp( "Attribute", Tok, 9 ) ) {
			StopCopy();

			GetToken();
			if( !TokLen ) return 0;

			if( TokType != ALN ) {
				Error( 4 );
				return 0;
			}			

			GetToken();
			if( !TokLen ) return 0;

			VarDef *vd1;

			if( chcmp( ':' ) ) {

				String AttrName( PrevTok );

				GetToken();
				if( !TokLen ) return 0;

				if( TokType != ALN || TokLen > 3 ) {
					Error( 9 );
					return 0;
				}

				vd1 = new VarDef( (char*)AttrName, Tok, TokLen, cd, swtch );

				GetToken();
				if( !TokLen ) return 0;

			} else {
				vd1 = new VarDef( PrevTok, "S", 1, cd, swtch );
			}

			cd->Var.AddTail( (Family*)vd1 );
			
			if( !chcmp( ';' ) ) {
				Error( 3 );
				return 0;
			}
			
			StartCopy();

		}
		}

		/* Virtual methods/attributes */
		if( TokLen == 7 && !strncmp( "virtual", Tok, 7 ) ) {
			StopCopy();
			StartCopy();
			swtch |= SW_VIRTUAL;
			goto next;
		} else swtch = 0;

	}

	StopCopy();

	GetToken();
	if( !TokLen ) return 0;
		
	if( TokLen != 1 || *Tok != ';' ) {	
		Error( 3 );
		return 0;
	}
	
	fprintf( ofh, "} %sData;\n\n/* Method Tags */\n", cd->Name );
	
	FScan( MethodDef, child, cd ) {
		fprintf( ofh, "#define %s 0x%lx\n", child->FullName(), child->GetTagVal() );
	}

	fprintf( ofh, "\n" );

	FScan( VarDef, child1, &(cd->Var) ) {
		fprintf( ofh, "#define %s 0x%lx\n", child1->FullName(), child1->GetTagVal() );
	}

	switch( *cd->type ) {
		case 'B':
			fprintf( ofh, "\nextern struct IClass *cl_%s;\n", cd->Name );
			if( cd->sw & SW_SELFCREATE ) {
				fprintf( ofh, "Object *%s_New( unsigned long pad, unsigned long tags, ... );\n", cd->Name );
				fprintf( ofh, "#define %sObject %s_New( 0\n", cd->Name, cd->Name );
			} else {
				fprintf( ofh, "#define %sObject NewObject( cl_%s, NULL\n", cd->Name, cd->Name );
				fprintf( ofh, "struct IClass *%s_Create( void );\n", cd->Name );
			}
			break;
		default:
			fprintf( ofh, "\nextern struct MUI_CustomClass *cl_%s;\n", cd->Name );
			if( cd->sw & SW_SELFCREATE ) {
				fprintf( ofh, "Object *%s_New( unsigned long pad, unsigned long tags, ... );\n", cd->Name );
				fprintf( ofh, "#define %sObject %s_New( 0\n", cd->Name, cd->Name );
			} else {
				fprintf( ofh, "#define %sObject NewObject( cl_%s->mcc_Class, NULL\n", cd->Name, cd->Name );
				fprintf( ofh, "struct MUI_CustomClass *%s_Create( void );\n", cd->Name );
			}

	}

	StartCopy();

	if( cd->CheckDoubleTags() ) return 0;

	UpdateLineNo();
		
  	return 1;
	
}
