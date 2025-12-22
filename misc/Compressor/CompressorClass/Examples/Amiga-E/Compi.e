/* -- ----------------------------------------------------------------- -- *
 * -- Program.....: Compi.e                                             -- *
 * -- Author......: Daniel Kasmeroglu <raptor@cs.tu-berlin.de>          -- *
 * -- Description.: Shows that you can ignore the XPK-Standard          -- *
 * -- ----------------------------------------------------------------- -- *
 * -- History                                                           -- *
 * --                                                                   -- *
 * --   0.1 (17. September 1998) - Started with writing.                -- *
 * --   1.0 (17. Sepeteber 1998) - Finished writing.                    -- *
 * --                                                                   -- *
 * -- ----------------------------------------------------------------- -- */

/* -- ----------------------------------------------------------------- -- *
 * --                              Options                              -- *
 * -- ----------------------------------------------------------------- -- */

OPT PREPROCESS       -> enable preprocessor
OPT REG = 5          -> register-optimisation


/* -- ----------------------------------------------------------------- -- *
 * --                              Modules                              -- *
 * -- ----------------------------------------------------------------- -- */

MODULE 'libraries/compressor',
       'libraries/iffparse',
       'libraries/xpk',
       'intuition/classes',
       'utility/tagitem',
       'tools/boopsi',
       'classes/compressor'   -> most users are using "emodules:libraries/" instead

MODULE 'lib/compressor'


/* -- ----------------------------------------------------------------- -- *
 * --                               Main                                -- *
 * -- ----------------------------------------------------------------- -- */

ENUM ARG_HELP,
     ARG_HIDE,
     ARG_LOAD,
     ARG_METHOD,
     ARG_MODE,
     ARG_PASSWORD,
     ARG_GUI,
     ARG_SAVE,
     ARG_DECOMPRESS,
     ARG_FILES


/* -- ----------------------------------------------------------------- -- *
 * --                             Routines                              -- *
 * -- ----------------------------------------------------------------- -- */

->»» PROC main
PROC main()
DEF ma_object      : PTR TO object
DEF ma_class       : PTR TO iclass
DEF ma_files2files : ccmFiles2Files
DEF ma_args        : PTR TO LONG
DEF ma_rdargs,ma_num

  ma_args   := [ FALSE, FALSE, NIL, 'HUFF', 50, 'Peter Lustig', FALSE, NIL, FALSE, NIL ]
  ma_rdargs := ReadArgs( {lab_Template}, ma_args, NIL )
  IF ma_rdargs <> NIL

    WriteF( '\s\n', {lab_Message} )
    IF ma_args[ ARG_HELP ] = FALSE

      compressorbase := OpenLibrary( 'compressor.class', 1 )
      IF compressorbase <> NIL

        ma_class := Cc_GetClassPtr()
        IF ma_class <> NIL

          ma_object := NewObjectA( ma_class, NIL, [ CCA_INTERNALPROGRESS, TRUE, TAG_END ] )
          IF ma_object <> NIL

            -> is there a file to load ?
            IF (ma_args[ ARG_LOAD ] <> NIL) AND (FileLength( ma_args[ ARG_LOAD ] ) > 0) THEN com_Load( ma_object, ma_args[ ARG_LOAD ] )

            -> The password should not be visible
            SetAttrsA( ma_object, [ CCA_HIDEPASSWORD , ma_args[ ARG_HIDE ] , TAG_END ] )

            -> set the method and the password
            IF ma_args[ ARG_METHOD   ] <> NIL THEN SetAttrsA( ma_object, [ CCA_METHOD       ,       ma_args[ ARG_METHOD   ]  , TAG_END ] )
            IF ma_args[ ARG_PASSWORD ] <> NIL THEN SetAttrsA( ma_object, [ CCA_PASSWORD     ,       ma_args[ ARG_PASSWORD ]  , TAG_END ] )

            -> the mode is not 50 (default) it was changed
            -> and a pointer has taken place. small values
            -> cannot be a pointer because such a small
            -> value is preserved for the system.
            IF ma_args[ ARG_MODE ] <> 50
              SetAttrsA( ma_object, [ CCA_MODE, Long( ma_args[ ARG_MODE ] ), TAG_END ] )
            ELSE
              SetAttrsA( ma_object, [ CCA_MODE, 50, TAG_END ] )
            ENDIF

            -> call the gui if the user wants that
            IF ma_args[ ARG_GUI ] <> FALSE THEN domethod( ma_object, [ CCM_PREFSGUI ] )

            -> save the preferences
            IF ma_args[ ARG_SAVE ] <> NIL THEN com_Save( ma_object, ma_args[ ARG_SAVE ] )

            -> if both are FALSE then we don't need to do anything
            IF ma_args[ ARG_FILES ] <> NIL

              ma_files2files.methodid         := CCM_FILES2FILES
              ma_files2files.com_Compressing  := IF ma_args[ ARG_DECOMPRESS ] <> FALSE THEN FALSE ELSE TRUE
              ma_files2files.com_Sources      := ma_args[ ARG_FILES ]
              ma_files2files.com_Destinations := NIL
              ma_files2files.com_Results      := NIL
              ma_files2files.com_Suffix       := 'xpk'

              ma_num := domethod( ma_object, ma_files2files )

              WriteF( '\d files were processed succesfully !\n', ma_num )

            ENDIF

          ELSE
            WriteF( 'Cannot create object !\n' )
          ENDIF

        ELSE
          WriteF( 'Class is not available !\n' )
        ENDIF

        CloseLibrary( compressorbase )
      ELSE
        WriteF( 'Cannot open "compressor.class" v1+ !\n' )
      ENDIF
    ELSE
      WriteF( '\s\n', {lab_CLIUsage} )
    ENDIF
    FreeArgs( ma_rdargs )

  ELSE
    WriteF( 'Cannot read args ! IoErr() = \d\n', IoErr() )
  ENDIF

ENDPROC
->»»>

->»» PROC com_Load
PROC com_Load( loa_object, loa_file )
DEF loa_sp         : PTR TO storedproperty
DEF loa_buff [ 4 ] : STRING
DEF loa_handle,loa_length

  -> stupid function to read the IFF-File
  loa_sp     := [ NIL, 0 ]:storedproperty
  loa_handle := Open( loa_file, OLDFILE )
  IF loa_handle <> NIL
    Read( loa_handle, loa_buff, 4 )
    IF StrCmp( loa_buff, 'FORM', 4 ) <> FALSE
      Read( loa_handle, loa_buff, 4 )
      Read( loa_handle, loa_buff, 4 )
      IF StrCmp( loa_buff, 'CCCP', 4 ) <> FALSE
        Read( loa_handle, {loa_length}, 4 )
        loa_sp.size := loa_length
        loa_sp.data := New( loa_length )
        IF loa_sp.data <> NIL
          IF Read( loa_handle, loa_sp.data, loa_length ) = loa_length
            SetAttrsA( loa_object, [ CCA_PREFSCHUNK, loa_sp, TAG_END ] )
          ENDIF
        ENDIF
      ENDIF
    ENDIF
    Close( loa_handle )
  ELSE
    WriteF( 'Cannot open file "\s" !\n', loa_file )
  ENDIF

ENDPROC
->»»>

->»» PROC com_Save
PROC com_Save( sav_object, sav_file )
DEF sav_sp : PTR TO storedproperty
DEF sav_handle,sav_err,sav_source

  -> very simple routine to write a stupid
  -> IFF-file.

  GetAttr( CCA_PREFSCHUNK, sav_object, {sav_sp} )
  sav_err    := FALSE
  sav_handle := Open( sav_file, NEWFILE )
  IF sav_handle <> NIL
    sav_source := ID_FORM
    IF Write( sav_handle, {sav_source}, 4 ) = 4
      sav_source := sav_sp.size + 8
      IF Write( sav_handle, {sav_source}, 4 ) = 4
        sav_source := ID_CCCP
        IF Write( sav_handle, {sav_source}, 4 ) = 4
          sav_source := sav_sp.size
          IF Write( sav_handle, {sav_source}, 4 ) = 4
            IF Write( sav_handle, sav_sp.data, sav_sp.size ) <> sav_sp.size
              sav_err := TRUE
            ENDIF
          ELSE
            sav_err := TRUE
          ENDIF
        ELSE
          sav_err := TRUE
        ENDIF
      ELSE
        sav_err := TRUE
      ENDIF
    ELSE
      sav_err := TRUE
    ENDIF
    Close( sav_handle )
  ENDIF

  IF sav_err <> FALSE THEN DeleteFile( sav_file )

ENDPROC
->»»>


/* -- ----------------------------------------------------------------- -- *
 * --                               Data                                -- *
 * -- ----------------------------------------------------------------- -- */

lab_Template:
CHAR '?/S,H=HIDEPASSWORD/S,L=LOAD/K,M=METHOD/K,O=MODE/K/N,P=PASSWORD/K,GUI/S,S=SAVE/K,D=DECOMPRESS/S,FILES/M',0

lab_Message:
CHAR '\e[1;1mCompi 1.0 (c) \a98 \e[2mDaniel Kasmeroglu\e[0m',0

lab_CLIUsage:
CHAR '\n    \e[2;2mCLI-Parameter        Description\e[0;0m\n\n',
     '     ?            /S   : This description\n',
     ' H = HIDEPASSWORD /S   : The password in the gui will be replaced by wildcards\n',
     ' L = LOAD         /K   : Specify the path of the prefsfile to load\n',
     ' M = METHOD       /K   : The method you want to use (compression only)\n',
     ' O = MODE         /K/N : The mode you want to use (compression only)\n',
     ' P = PASSWORD     /K   : The password you want to use\n',
     '     GUI          /S   : Pops up the gui before saving or (de)compressing\n',
     ' S = SAVE         /K   : Specify the path of the prefsfile to save\n',
     ' D = DECOMPRESS   /S   : Decompress the listed files (default is compression)\n',
     '     FILES        /M   : List with the files that should be processed !\n',0

lab_Version:
CHAR '$VER: Compi 1.0 (17-Sep-98) [ Daniel Kasmeroglu ]',0

