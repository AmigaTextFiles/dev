OPT MODULE


->*****
->** External modules
->*****
MODULE 'libraries/mui'
MODULE 'tools/boopsi' , 'tools/installhook'
MODULE 'utility/tagitem' , 'utility/hooks'
MODULE 'icon' , 'workbench/workbench'
MODULE 'dos/dos' , 'dos/exall'

MODULE '*Locale'
MODULE '*Defs'
MODULE '*GUI_MUIB'
MODULE '*Errors'


->*****
->** Error handling
->*****
RAISE	"MEM"	IF	AllocDosObject()		=	NIL	,
		"MEM"	IF	ParsePatternNoCase()	=	-1


->*****
->** Constant definitions
->*****
CONST	EXALL_BUFFER_SIZE	=	1024

ENUM	SCAN_OK			=	1	,
		STOP_SCAN				,
		INCORRECT_DIR			,
		SCAN_ERROR


->*****
->** Global variables
->*****
EXPORT DEF deftII	:	PTR TO obj_app
EXPORT DEF cat		:	PTR TO catalog_DeftII
EXPORT DEF modified	:	LONG

DEF icon_pattern	:	PTR TO CHAR
DEF matchfunc_hook	:	PTR TO hook


/**********************************************************
** Initializes the icon_pattern to the '#?.info' pattern **
**********************************************************/
EXPORT PROC init_go()

	ParsePatternNoCase( '#?.info' , NEW icon_pattern[ 30 ] , 30 )
	installhook( NEW matchfunc_hook , {matchfunc} )

ENDPROC


/**************************************/
/* Like StrCmp() but case insensitive */
/**************************************/
EXPORT PROC str_cmp_no_case( string1 : PTR TO CHAR , string2 : PTR TO CHAR )

	DEF same = FALSE

->	DEF i =0 , same = TRUE , upper_char1 = 0 , upper_char2 = 0
->	WHILE same AND ( string1[ i ] <> 0 ) AND ( string2[ i ] <> 0 )
->		IF string1[ i ] <> string2[ i ]
->			upper_char1 := IF ( string1[ i ] >= "a" ) AND ( string1[ i ] <= "z" ) THEN string1[ i ] - 32 ELSE string1[ i ]
->			upper_char2 := IF ( string2[ i ] >= "a" ) AND ( string2[ i ] <= "z" ) THEN string2[ i ] - 32 ELSE string2[ i ]
->			IF upper_char1 <> upper_char2 THEN same := FALSE
->		ENDIF
->		INC i
->	ENDWHILE
->ENDPROC IF ( string1[ i ] = 0 ) AND ( string2[ i ] = 0 ) THEN TRUE ELSE FALSE

	MOVE.L	string1 , A1
	MOVE.L	string2 , A2
loop_while:
	MOVE.B	(A1)+ , D1
	MOVE.B	(A2)+ , D2
	TST.B	D1
	BNE.B	second_test
	TST.B	D2
	BNE.B	final_end
	MOVE.L	#-1 , same
	BRA.B	final_end
second_test:
	TST.B	D2
	BEQ.B	final_end
insidewhile:
		CMP.B	D1 , D2
		BEQ.B	loop_while
		CMP.B	#"a" , D1
		BCS.B	char1_ok
		CMP.B	#"z" , D1
		BHI.B	char1_ok
		SUB.B	#32 , D1
char1_ok:
		CMP.B	#"a" , D2
		BCS.B	char2_ok
		CMP.B	#"z" , D2
		BHI.B	char2_ok
		SUB.B	#32 , D2
char2_ok:
		CMP.B	D1 , D2
		BEQ.B	loop_while
final_end:

ENDPROC same


/**************************************************************/
/* The function which runs the icon default tool replacements */
/**************************************************************/
EXPORT PROC go( error_messages )

	DEF wrong_path_met = FALSE
	DEF path_str : PTR TO CHAR
	DEF result , i = 0
	DEF return = 0
	DEF old_priority

	old_priority := SetTaskPri( FindTask( NIL ) , -5 )
	
	set( deftII.lv_paths , MUIA_List_Quiet , MUI_TRUE )

	REPEAT

		domethod( deftII.lv_paths , [ MUIM_List_GetEntry , i++ , {path_str} ] )
		IF path_str <> NIL

			result := scan_dir( path_str , path_str , error_messages )

			IF result = INCORRECT_DIR

				domethod( deftII.lv_paths , [ MUIM_List_Remove , i-- ] )
				wrong_path_met := TRUE

			ENDIF

		ENDIF

	UNTIL ( path_str = NIL ) OR ( result = STOP_SCAN ) OR ( result = SCAN_ERROR )

	IF wrong_path_met

		IF error_messages THEN deftII_error( get_string( cat.msg_Wrong_Path_Met ) )
		modified := TRUE

	ENDIF

	set( deftII.lv_paths , MUIA_List_Quiet , FALSE )

	set( deftII.tx_info , MUIA_Text_Contents , get_string( cat.msg_TX_info ) )

	set( deftII.gr_paths , MUIA_Disabled , FALSE )
	set( deftII.gr_default_tools , MUIA_Disabled , FALSE )
	set( deftII.bt_go , MUIA_Disabled , FALSE )
	set( deftII.bt_save_prefs , MUIA_Disabled , FALSE )
	set( deftII.bt_about , MUIA_Disabled , FALSE )
	set( deftII.bt_quit , MUIA_Disabled , FALSE )

	SetTaskPri( FindTask( NIL ) , old_priority )

	IF wrong_path_met THEN return := 10
	IF result = STOP_SCAN THEN return := return + 5
	IF result = SCAN_ERROR THEN return := return + 100

ENDPROC return


/**************************************************************/
/* Recursively scan a directory to replace icon default tools */
/**************************************************************/
PROC scan_dir( dir_name : PTR TO CHAR , previous_path : PTR TO CHAR , error_messages ) HANDLE

	DEF eac : PTR TO exallcontrol
	DEF fib : PTR TO fileinfoblock
	DEF entry : PTR TO exalldata
	DEF current_dir = NIL , parent_dir = NIL
	DEF more = FALSE , i , j , found
	DEF icon_name[ 32 ] : STRING , icon : PTR TO diskobject
	DEF def_tool : PTR TO default_tool
    DEF error_buf[ 81 ] : ARRAY OF CHAR , error_num
	DEF complete_path[ 512 ] : STRING
	DEF buffer : PTR TO CHAR
	DEF scan_result , signals

	NEW buffer[ EXALL_BUFFER_SIZE ]
	eac := ( eac := NIL ) BUT AllocDosObject( DOS_EXALLCONTROL , NIL )
	fib := ( fib := NIL ) BUT AllocDosObject( DOS_FIB , NIL )

	IF ( current_dir := Lock( dir_name , SHARED_LOCK ) ) = NIL

		FreeDosObject( DOS_FIB , fib )
		FreeDosObject( DOS_EXALLCONTROL , eac )
		RETURN INCORRECT_DIR

	ENDIF

	IF Examine( current_dir , fib ) = FALSE

		UnLock( current_dir )
		FreeDosObject( DOS_FIB , fib )
		FreeDosObject( DOS_EXALLCONTROL , eac )
		RETURN INCORRECT_DIR

	ENDIF

	IF fib.direntrytype < 0

		UnLock( current_dir )
		FreeDosObject( DOS_FIB , fib )
		FreeDosObject( DOS_EXALLCONTROL , eac )
		RETURN INCORRECT_DIR

	ENDIF

	FreeDosObject( DOS_FIB , fib )	;	fib := NIL
	parent_dir := CurrentDir( current_dir )

	eac.lastkey := 0
	eac.matchstring := NIL
	eac.matchfunc := matchfunc_hook

	REPEAT

		more := ExAll( current_dir , buffer , EXALL_BUFFER_SIZE , ED_TYPE , eac )
		error_num := IoErr()

		IF domethod( deftII.app , [ MUIM_Application_Input , {signals} ] ) = ID_BT_STOP

			IF more THEN ExAllEnd( current_dir , buffer , EXALL_BUFFER_SIZE , ED_TYPE , eac )
			CurrentDir( parent_dir )
			UnLock( current_dir )
			FreeDosObject( DOS_EXALLCONTROL , eac )
			RETURN STOP_SCAN

		ENDIF

		entry := buffer

		FOR i := 1 TO eac.entries

			IF entry.type >= 0

				StrCopy( complete_path , previous_path , ALL )
				AddPart( complete_path , entry.name , 512 )
				SetStr( complete_path , StrLen( complete_path ) )

				IF ( scan_result := scan_dir( entry.name , complete_path , error_messages ) ) <> SCAN_OK

					ExAllEnd( current_dir , buffer , EXALL_BUFFER_SIZE , ED_TYPE , eac )
					CurrentDir( parent_dir )
					UnLock( current_dir )
					FreeDosObject( DOS_EXALLCONTROL , eac )
					RETURN scan_result

				ENDIF

			ELSE

				IF ( icon := GetDiskObject( StrCopy ( icon_name , entry.name , StrLen( entry.name ) - 5 ) ) ) <> NIL

					IF icon.type = WBPROJECT

						j := 0
						found := FALSE

						REPEAT

							domethod( deftII.lv_default_tools , [ MUIM_List_GetEntry , j++ , {def_tool} ] )

							IF def_tool <> NIL

								IF def_tool.pattern

									found := MatchPatternNoCase( def_tool.pattern , icon.defaulttool )

								ELSE

									found := str_cmp_no_case( icon.defaulttool , def_tool.old )

								ENDIF

							ENDIF

						UNTIL ( def_tool = NIL ) OR found

						IF found AND ( str_cmp_no_case( icon.defaulttool , def_tool.new ) = FALSE )

							icon.defaulttool :=  def_tool.new
							PutDiskObject( icon_name , icon )
						
							StrCopy( complete_path , previous_path , ALL )
							AddPart( complete_path , entry.name , 512 )
							SetStr( complete_path , StrLen( complete_path ) )
							set( deftII.tx_info , MUIA_Text_Contents , complete_path )

						ENDIF

					ENDIF

					FreeDiskObject( icon )

				ENDIF

			ENDIF

			entry := entry.next

		ENDFOR

	UNTIL more = FALSE

	IF error_num <> ERROR_NO_MORE_ENTRIES

		CurrentDir( parent_dir )
		UnLock( current_dir )
		FreeDosObject( DOS_EXALLCONTROL , eac )

	    Fault( error_num , NIL , error_buf , 80 )
    	IF error_messages THEN deftII_error( error_buf )

		RETURN SCAN_ERROR

	ENDIF

	CurrentDir( parent_dir )
	UnLock( current_dir )
	FreeDosObject( DOS_EXALLCONTROL , eac )
	END buffer[ EXALL_BUFFER_SIZE ]

EXCEPT

	IF more THEN ExAllEnd( current_dir , buffer , EXALL_BUFFER_SIZE , ED_TYPE , eac )
	IF parent_dir THEN CurrentDir( parent_dir )
	IF current_dir THEN UnLock( current_dir )
	IF fib THEN FreeDosObject( DOS_FIB , fib )
	IF eac THEN FreeDosObject( DOS_EXALLCONTROL , eac )

	ReThrow()

ENDPROC SCAN_OK


/**********************************************************************
** Hook function called by ExAll() to see if an entry is a directory **
**********************************************************************/
PROC matchfunc( hook , ptype : PTR TO LONG , ed : PTR TO exalldata ) RETURN ( ed.type >= 0 ) OR ( MatchPatternNoCase( icon_pattern , ed.name ) )
