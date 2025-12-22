#include "ClassDef.h"
#include "MethodDef.h"

#include "VarDef.h"
#include "ParseBC.h"
#include "Global.h"

#include <stdio.h>
#include <string.h>

void ParseBC::CreateDisp( FILE *fh )
{

		fprintf( fh, "\n/* %s - %s class dispatcher */\n\n", cd->type, cd->Name );

		if( cd->sw & SW_SELFCREATE )
			switch( *cd->type ) {
				case 'B':
					fprintf( fh, "struct IClass *cl_%s;\n", cd->Name);
					break;
				default:
					fprintf( fh, "struct MUI_CustomClass *cl_%s;\n", cd->Name);
			}
		
		FScan( MethodDef, md1, cd ) {
			if( !(md1->switches & (SW_VIRTUAL|SW_LOCAL)) ) fprintf( fh, "unsigned long m%s%s( struct IClass *cl, Object *obj, %s msg );\n", cd->Name, md1->Name, md1->msgtype );
		}

		short Sc = 0, Gc = 0, Sg = 0, Ss = 0;
		FScan( VarDef, vds, &(cd->Var) ) {
			if( !(vds->switches & SW_VIRTUAL) ) {
				Sc |= vds->switches & SW_SET;
				Gc |= vds->switches & SW_GET;
				if( vds->switches & SW_SET ) Ss |= vds->switches & SW_SIMPLE;
				if( vds->switches & SW_GET ) Sg |= vds->switches & SW_SIMPLE;
			}
		}
		
		if( Sc ) {

			if( cd->FindItem( "OM_SET" ) ) {
				Error( 26 );
				return;
			}

			MethodDef *md1;
			md1 = new MethodDef( "OM_SET", 6, 0, 0 );
			cd->AddTail( (Family*)md1 );
		
			fprintf( fh, "\nstatic unsigned long m%sOM_SET( struct IClass *cl, Object *obj, struct opSet *msg )\n{\n", cd->Name );
			if( Ss ) fprintf( fh, " %sData *data = INST_DATA(cl, obj);\n", cd->Name );

			InsertIAttrPre( ofh, SW_SET );
			InsertIAttr( ofh, SW_SET );
			
			fprintf( fh, "	 return DoSuperMethodA( cl, obj, (Msg)msg );\n}\n" );
		}
		
		if( Gc ) {

			if( cd->FindItem( "OM_GET" ) ) {
				Error( 26 );
				return;
			}

			MethodDef *md2;
			md2 = new MethodDef( "OM_GET", 6, 0, 0 );
			cd->AddTail( (Family*)md2 );

			fprintf( fh, "\nstatic unsigned long m%sOM_GET( struct IClass *cl, Object *obj, struct opGet *msg )\n{\n", cd->Name );
			if( Sg ) fprintf( fh, " %sData *data = INST_DATA(cl, obj);\n", cd->Name );
			fprintf( fh, "	switch( msg->opg_AttrID ) {\n" );

			FScan( VarDef, vd, &(cd->Var) ) {
				if( (vd->switches & SW_GET) && !(vd->switches & SW_VIRTUAL) ) {
					fprintf( fh, "			case %s:", vd->FullName() );
					if( vd->switches & SW_SIMPLE ) fprintf( fh, " *msg->opg_Storage = (unsigned long)data->%s; break;\n", vd->Name );
					else fprintf( fh, " a%s%sGet( cl, obj, (void*)&msg->opg_AttrID%s ); break;\n", cd->Name, vd->Name, (vd->passmsg & SW_GET) ? ", msg" : "" );
				}
			}

			fprintf( fh, "			default: return DoSuperMethodA( cl, obj, (Msg)msg );\n" );
			fprintf( fh, "	}\n return 1;\n}\n" );

		}

		
		fprintf( fh, "\nstatic unsigned long" );
		if( !Prefs.nosaveds ) fprintf( fh, " SAVEDS" );
		fprintf( fh, " ASM %s_Dispatcher( REG(a0) struct IClass *cl, REG(a2) Object *obj, REG(a1) Msg msg )\n{\n", cd->Name );
		fprintf( fh, "	switch( msg->MethodID ) {\n" );
		
		FScan( MethodDef, md, cd ) {

			if( !(md->switches & SW_VIRTUAL) ) 
				fprintf( fh, "		case %s: return m%s%s( cl, obj, (%s)msg );\n", md->FullName(), cd->Name, md->Name, md->msgtype );
		
		}
		
		fprintf( fh, "	}\n	return( DoSuperMethodA( cl, obj, msg ) );\n}\n\n" );
		
		if( cd->sw & SW_SELFCREATE ) fprintf( fh, "static " );
		switch( *cd->type ) {
			case 'B':
				fprintf( fh, "struct IClass *%s_Create( void )\n{\nstruct IClass *cl;\n", cd->Name );
				if( cd->superpriv ) fprintf( fh, "	if( cl = MakeClass( NULL, NULL, cl_%s, sizeof( %sData ), 0 ) ) {\n", cd->PSuper, cd->Name );
				else fprintf( fh, "	if( cl = MakeClass( NULL, %s, NULL, sizeof( %sData ), 0 ) ) {\n", cd->PSuper, cd->Name );
				fprintf( fh, "		cl->cl_Dispatcher.h_Entry = (ULONG (*)())%s_Dispatcher;\n		cl->cl_Dispatcher.h_SubEntry = NULL;\n", cd->Name );
				fprintf( fh, "		return cl;\n	}\n	return 0;\n}\n" );
				break;
		
			default:
				fprintf( fh, "struct MUI_CustomClass *%s_Create( void )\n{\n", cd->Name );
				if( cd->superpriv ) fprintf( fh, "	return MUI_CreateCustomClass( NULL, NULL, cl_%s, sizeof( %sData ), %s_Dispatcher );\n", cd->PSuper, cd->Name, cd->Name, cd->Name );
				else fprintf( fh, "	return MUI_CreateCustomClass( NULL, %s, NULL, sizeof( %sData ), %s_Dispatcher );\n", cd->PSuper, cd->Name, cd->Name, cd->Name );
				fprintf( fh, "}\n" );
		}
		
		if( cd->sw & SW_SELFCREATE ) {
		
			fprintf( fh, "Object *%s_New( unsigned long pad, unsigned long tags, ... )\n{\n", cd->Name );
			fprintf( fh, " if( !cl_%s ) cl_%s = %s_Create();\n", cd->Name, cd->Name, cd->Name );
			switch( *cd->type ) {
				case 'B':
					fprintf( fh, " return NewObjectA( cl_%s, NULL, (struct TagItem*)tags );\n", cd->Name );
					break;
		
				default:
					fprintf( fh, " return NewObjectA( cl_%s->mcc_Class, NULL, (struct TagItem*)tags );\n", cd->Name );
			}

			fprintf( fh, "}\n" );
			
		}
		
}

