#include "ParseBC.h"
#include "ClassDef.h"
#include "MethodDef.h"
#include "VarDef.h"

#include "Global.h"

#include <string.h>

short ParseBC::Start( void )
{

	BCC_block_cnt = 0;

	ins_every.Insert( ofh );
	ins_code.Insert( ofh );

	UpdateLineNo();

	reppar.Clear();
	clref.Clear();
	cd = 0;
	
	switches = 0;
	
	while( 1 ) {
	
		GetToken();
		if( !TokLen ) break;
		
		if( BCC_block_cnt ) {
	
			short rcr;
			rcr = FullCheck();
			if( rcr == -1 ) return 0;
			
/*			rcr = NewDelCheck();
			if( rcr == -1 ) return 0;*/

			rcr = ClassPtrDefinition( BCC_block[BCC_block_cnt-1].rep );
			if( rcr == -1 ) return 0;
			
			if( chcmp( '}' ) && MBracket == BCC_block[BCC_block_cnt-1].brc ) {
				BCC_block_cnt--;
				delete BCC_block[BCC_block_cnt].rep;
				StopCopy();
				StartCopy();
			}
		
		}
		if( TokType == ALN ) {
			if( TokLen == 6 && !strncmp( "Method", Tok, 6 ) ) {
				if( !DoMA() ) {
					if( !ErrorBuf ) Error( 12 );
					return 0;
				}
				switches = 0;
			} else {
			if( TokLen == 7 && !strncmp( "include", Tok, 7 ) ) {
				if( !DoHeader() ) {
					return 0;
				}
				
			} else {
			if( TokLen == 9 && !strncmp( "Attribute", Tok, 9 ) ) {
				if( !DoMA( 1 ) ) {
					if( !ErrorBuf ) Error( 12 );
					return 0;
				}
				switches = 0;
			} else {
			if( TokLen == 6 && !strncmp( "nodata", Tok, 6 ) ) {
				switches |= SW_NODATA;
				StopCopy();
				StartCopy();
			} else {
			if( TokLen == 6 && !strncmp( "custom", Tok, 6 ) ) {
				switches |= SW_CUSTOM;
				StopCopy();
				StartCopy();
			} else {
			if( TokLen == 8 && !strncmp( "presuper", Tok, 8 ) ) {
				switches |= SW_PRESUPER;
				StopCopy();
				StartCopy();
			} else {
			if( TokLen == 9 && !strncmp( "postsuper", Tok, 9 ) ) {
				switches |= SW_POSTSUPER;
				StopCopy();
				StartCopy();
			} else {
			if( TokLen == 10 && !strncmp( "supercheck", Tok, 10 ) ) {
				switches |= SW_SUPERCHECK;
				StopCopy();
				StartCopy();
			} else {
			if( TokLen == 11 && !strncmp( "noearlydata", Tok, 11 ) ) {
				switches |= SW_NOEARLYDATA;
				StopCopy();
				StartCopy();
			} else {
			if( TokLen == 9 && !strncmp( "cleardata", Tok, 9 ) ) {
				switches |= SW_CLEARDATA;
				StopCopy();
				StartCopy();
			} else {
			if( TokLen == 5 && !strncmp( "super", Tok, 5 ) ) {
				switches |= SW_SUPER;
				StopCopy();
				StartCopy();
			} else {
			if( TokLen == 8 && !strncmp( "BCCBlock", Tok, 8 ) ) {
				StopCopy();
				
				if( BCC_block_cnt >= MAXBCCBLOCKS ) {
					Error( 24 );
					return 0;
				}
				
				BCC_block[BCC_block_cnt].brc = MBracket;

				GetToken();
				if( !TokLen ) return 0;
			
				if( !chcmp( '{' ) ) {
					Error( 2 );
					return 0;
				}

				BCC_block[BCC_block_cnt].rep = new Replace;
				
				BCC_block_cnt++;
				
				StartCopy();
			} else switches = 0;
			}
			}
			}
			}
			}
			}
			}
			}
			}
			}
			}
		}

		
	}
	
	if( BCC_block_cnt ) {
		short f;
		for( f = 0; f < BCC_block_cnt; f++ ) delete BCC_block[f].rep;
		Error( 25 );
		return 0;
	}
	
	FScan( ClassDef, c1, &ClassList ) {
		if( !stricmp( sfname, c1->Name ) ) {
			cd = c1;
			CreateDisp( ofh );
		}
	}
	
	return 1;

}

short ParseBC::DoMA( short attr )
{
 short BLevel;
 short mdspec = 0, passmsg;
 MethodDef *md;

	reppar.Clear();
	clref.Clear();

	StopCopy();

	GetToken();
	if( !TokLen ) return 0;

	if( TokLen == 3 && !strncmp( "Set", Tok, 3 ) ) switches |= SW_SET;
	else if( TokLen == 3 && !strncmp( "Get", Tok, 3 ) ) switches |= SW_GET;
	else if( TokLen == 4 && !strncmp( "Init", Tok, 4 ) ) switches |= SW_INIT;

	if( switches & (SW_SET|SW_GET|SW_INIT) ) {
		GetToken();
		if( !TokLen ) return 0;
	}

	cd = (ClassDef*)(ClassList.FindItem( Tok, TokLen ));
	
	if( !cd ) {
		Error( 6 );
		return 0;
	}

	if( !IsReferenced( "data", &cd->rep ) ) switches |= SW_NODATA;
	if( attr ) passmsg = IsReferenced( "msg" );

	GetToken();
	if( !TokLen ) return 0;
	
	if( TokLen != 2 || strncmp( Tok, "::", 2 ) ) {
		Error( 7 );
		return 0;
	}

	GetToken();
	if( !TokLen ) return 0;

	BLevel = MBracket;

	switches |= stricmp( sfname, cd->Name ) ? 0 : SW_LOCAL;

	if( !attr ) {
	/* Method */

	if( TokLen == strlen( cd->Name ) && !strncmp( cd->Name, Tok, TokLen ) ) {
		md = new MethodDef( "OM_NEW", 6, 0, switches );
		cd->AddTail( (Family*)md );
		mdspec = 1;
	} else {

	if( TokLen == strlen( cd->Name )+1 && *Tok == '~' && !strncmp( cd->Name, Tok+1, TokLen-1 ) ) {
		md = new MethodDef( "OM_DISPOSE", 10, 0, switches );
		cd->AddTail( (Family*)md );
		mdspec = 2;
	} else {

	if( switches & SW_SUPER ) {
		md = new MethodDef( Tok, TokLen, 0, switches );
		cd->AddTail( (Family*)md );
	} else {
		md = (MethodDef*)(cd->FindItem( Tok, TokLen ));
		md->switches |= switches;
	}
	
	}
	
	}
	
	if( !md ) {
		Error( 8 );
		return 0;
	}
	
	if( md->switches & SW_VIRTUAL ) {
		Error( 17 );
		return 0;
	}
	
	switches |= md->switches;

/*
	if( mdspec == 1 ) {
		FScan( VarDef, vd, &(cd->Var) ) {
			if( (vd->switches & SW_INIT) && !(vd->switches & (SW_VIRTUAL|SW_SIMPLE)) ) {
				fprintf( ofh, "a%s%s%s( IClass*, Object*, void* );\n", cd->Name, vd->Name, vd->SGIName( SW_INIT ) );
			}
		}
	}
*/

	/* Parameters */

	if( switches & SW_LOCAL ) fprintf( ofh, "static " );
	fprintf( ofh, "unsigned long m%s%s( struct IClass *cl, Object *obj, ", cd->Name, md->Name );
	
	short ret;
	ret = Params();
	if( ret == -1 ) return 0;
	if( !ret ) fprintf( ofh, "%s msg", md->msgtype );
	else md->msgtype = "void*";
	
	fprintf( ofh, " )\n{\n" );

	if( EarlyCode() == -1 ) return 0;

	
	if( !(switches & SW_CUSTOM) ) {
	
		if( mdspec == 1 ) fprintf( ofh, " unsigned long _ret;\n" );
		else fprintf( ofh, " unsigned long _ret = 1;\n" );
	
	/* OM_NEW */
	if( mdspec == 1 ) {

		if( !IsReferenced( "data", &cd->rep, 1 ) ) switches |= SW_NOEARLYDATA;

		InsertIAttrPre( ofh );
	
		if( chcmp( ':' ) ) {

			if( !(switches & SW_NODATA) ) {
				if( switches & SW_NOEARLYDATA ) {
					fprintf( ofh, " %sData *data;\n", cd->Name );
				} else {
					fprintf( ofh, " %sData *data, _tdata;\n data = &_tdata;\n", cd->Name );
					InitData();
				}
			}

			fprintf( ofh, " obj = (Object*)BCC_DoSuperNew( cl, obj,\n" );

			UpdateLineNo();

			StartCopy();
		
			while( 1 ) {
			
				GetToken();
				if( !TokLen ) return 0;

				short rcr;
				rcr = FullCheck( );
				if( rcr == -1 ) return 0;

				if( chcmp( '{' ) ) break;

			}
			
			StopCopy();
			
			fprintf( ofh, ",\n TAG_MORE, (unsigned long)msg->ops_AttrList,\n TAG_DONE );\n" );
			
			fprintf( ofh, " _ret = (unsigned long)obj;\n if( !obj ) return 0;\n" );
			if( !(switches & SW_NODATA ) ) {
				if( switches & SW_NOEARLYDATA ) {
					fprintf( ofh, " data = INST_DATA( cl, obj );\n", cd->Name );
					InitData();
				} else fprintf( ofh, " data = INST_DATA( cl, obj );\n memcpy( data, &_tdata, sizeof( %sData ) );\n", cd->Name );
			}
			InsertIAttr( ofh );

		} else {
			pDataDef();
			fprintf( ofh, " obj = (Object*)DoSuperMethodA( cl, obj, (Msg)msg );\n" );
			fprintf( ofh, " _ret = (unsigned long)obj;\n if( !obj ) return 0;\n" );
			if( !(switches & SW_NODATA ) ) {
				fprintf( ofh, " data = INST_DATA( cl, obj );\n" );
				InitData();
			}
			InsertIAttr( ofh );
		}
	/* Other methods */
	} else {
		pDataDefAssign();
		if( switches & SW_PRESUPER ) {
			fprintf( ofh, " _ret = DoSuperMethodA( cl, obj, (Msg)msg );\n" );
			if( switches & SW_SUPERCHECK ) fprintf( ofh, " if( !_ret ) return 0;\n" );
		}
	}
	
	}
	
	} else {
	/* Attribute mode */
	
		VarDef *vd;

		if( switches & SW_SUPER ) {
			vd = new VarDef( Tok, TokLen, switches );
			cd->Var.AddTail( (Family*)vd );
		} else 
		if( !(vd = (VarDef*)((TextItem*)&cd->Var)->FindItem( Tok, TokLen )) ) {
			Error( 11 );
			return 0;
		}
		
		vd->switches |= switches;

		if( vd->switches & SW_SIMPLE ) {
			Error( 14 );
			return 0;
		}
		
		if( vd->switches & SW_VIRTUAL ) {
			Error( 17 );
			return 0;
		}

		short CLevel = CBracket;
		
		GetToken();
		if( !TokLen ) return 0;
		
		short ret;
		unsigned short sw = switches;
		ret = GetSGI( &sw );
		if( ret == -1 ) return 0;
		
		if( !((sw & (SW_SET|SW_INIT)) ^ (SW_SET|SW_INIT)) ) sw |= SW_SAMESI;
		
		if( ( sw & (SW_SET|SW_INIT) ) && ( sw & SW_GET ) ) {
			Error( 23 );
			return 0;
		}
		
		vd->switches |= sw;

		if( !(vd->switches & (SW_SET|SW_GET|SW_INIT)) ) {
			Error( 10 );
			return 0;
		}

		if( passmsg ) vd->passmsg |= sw & (SW_SET|SW_GET|SW_INIT);
		else vd->passmsg &= 0xffff - (sw & (SW_SET|SW_GET|SW_INIT));


		fprintf( ofh, "void a%s%s", cd->Name, vd->Name );
		if( sw & SW_SAMESI ) fprintf( ofh, "SI" );
		else if( sw & SW_GET ) fprintf( ofh, "Get" );
		else if( sw & SW_SET ) fprintf( ofh, "Set" );
		else fprintf( ofh, "Init" );
		fprintf( ofh, "( struct IClass *cl, Object *obj, struct { unsigned long ti_Tag;  " );
		
		if( chcmp( '(' ) ) {
		
			StartCopy();
		
			short c_line;
			
			c_line = LineN;
		
			short loop = 0;
			while( 1 ) {
	
				GetToken();
				if( !TokLen ) return 0;
				
				if( c_line != LineN ) {
					Error( 21 );
					return 0;
				}
				
				short ret;
				ret = ClassPtrDefinition( &clref, 1, 1 );
				if( ret == -1 ) return 0;

				if( chcmp( ')' ) && CBracket == CLevel ) {
					if( !loop ) { Error( 27 ); return 0; } 
					break;
				}
				
				loop = 1;

			}
			
			StopCopy();

			String Buf( "(tag->" );
			Buf += PrevTok;
			Buf += ")";
			reppar.Add( PrevTok, 0, (char*)Buf, 0 );
			
			GetToken();
			if( !TokLen ) return 0;
			
		} else {
			if( sw & SW_GET ) {
				fprintf( ofh, " unsigned long *store" );
				reppar.Add( "store", 0, "(tag->store)", 0 );
			}
			else {
				fprintf( ofh, " unsigned long value" );
				reppar.Add( "value", 0, "(tag->value)", 0 );
			}
		}
		
		char *pmsg = "";
		if( vd->passmsg & sw ) {
			if( sw & (SW_SET|SW_INIT) ) pmsg = ", struct opSet* msg";
			if( sw & (SW_GET) ) pmsg = ", struct opGet* msg";
		}
		
		fprintf( ofh, " ; } *tag%s )\n{\n", pmsg );
 
		pDataDefAssign();

	}

	if( !chcmp( '{' ) ) {
		Error( 2 );
		return 0;
	}

	fprintf( ofh, "{\n /* UC Beg */\n" );
	
	UpdateLineNo();

	StartCopy();
	
	short wasmret = 0;
	
	String objrefbuf( cd->type );
	objrefbuf += cd->Name;
	clref.Add( "obj", 3, (char*)objrefbuf, 0 );

	InitClassPtrDef();

	/* Inside code */		
	while( 1 ) {
	
		again:

		GetToken();
		if( !TokLen ) break;
		
		short rcr;

		rcr = FullCheck( );
		if( rcr == -1 ) return 0;
		if( rcr ) goto again;

		if( chcmp( '}' ) && MBracket == BLevel ) break;

		rcr = ClassPtrDefinition( &clref );
		if( rcr == -1 ) return 0;
		if( rcr ) goto again;

		if( TokLen == 7 && !strncmp( Tok, "mreturn", 7 ) ) {
			StopCopy();
			fprintf( ofh, "{ _ret = " );
			StartCopy();
			
			while( 1 ) {
				GetToken();
				if( !TokLen ) return 0;
				
				if( chcmp( ';' ) ) break;
			}
			
			StopCopy();
			StartCopy();
			
			fprintf( ofh, "; goto %s_exit; } ", md->Name );
			wasmret = 1;
		}
	
	}

	fprintf( ofh, "\n}\n /* UC End */\n" );
	
	if( !(switches & SW_CUSTOM) && !attr ) {
	
		fprintf( ofh, "%s_exit:\n", md->Name );

		if( mdspec == 1 ) {
			if( wasmret ) fprintf( ofh, " if( !_ret ) CoerceMethod( cl, obj, OM_DISPOSE );\n" );
		} else
		if( switches & SW_POSTSUPER ) {
			if( switches & SW_SUPERCHECK ) fprintf( ofh, " if( !_ret ) return 0;\n" );
			fprintf( ofh, " _ret = DoSuperMethodA( cl, obj, (Msg)msg );\n" );
		}
		
		fprintf( ofh, "return _ret;\n" );
	
	}


	UpdateLineNo();
	
	cd = 0;
	reppar.Clear();
	clref.Clear();

	return 1;

}

void ParseBC::InitData( void )
{
	char *var, *val;
	
	if( switches & SW_CLEARDATA ) fprintf( ofh, " memset( data, 0, sizeof( %sData ) );\n", cd->Name );

	cd->rep.InitGetExtra();
	
	while( var = cd->rep.GetExtra( &val) ) {
	
		fprintf( ofh, " %s = %s;\n", var, val );
	
	}

}