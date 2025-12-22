/* -- ----------------------------------------------------------------- -- *
 * -- Program.....: Class_Test.e                                        -- *
 * -- Author......: Daniel Kasmeroglu <raptor@cs.tu-berlin.de>          -- *
 * -- Description.: Demonstration of the Compressor.class               -- *
 * -- ----------------------------------------------------------------- -- *
 * -- History                                                           -- *
 * --                                                                   -- *
 * --   0.1 (31. August    1998) - Started with writing.                -- *
 * --   1.0 (17. September 1998) - Finished writing.                    -- *
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

MODULE 'intuition/classusr',
       'intuition/classes',
       'amigalib/boopsi',
       'libraries/iffparse',
       'libraries/xpk',
       'tools/inithook',
       'global/qstringf',
       'exec/memory',
       'graphics/text',
       'utility/tagitem',
       'utility/hooks',
       'prefs/prefhdr'

MODULE 'lib/iffparse'

MODULE 'classes/compressor',
       'lib/compressor'


/* -- ----------------------------------------------------------------- -- *
 * --                             Constants                             -- *
 * -- ----------------------------------------------------------------- -- */

CONST ERR_LIB       = "LIB " ,
      ERR_ARGS      = "ARGS" ,
      ERR_NOWB      = "NOWB" ,
      ERR_CLASS     = "CLAS"

CONST NUMFILES  = 4,  -> number of files to be generated
      NILLIST   = 11, -> NUMFILES + 1
      SIZESHIFT = 4   -> filesize = available mem / 2^SIZESHIFT


/* -- ----------------------------------------------------------------- -- *
 * --                           Declarations                            -- *
 * -- ----------------------------------------------------------------- -- */

DEF glo_clihook,glo_mempool


/* -- ----------------------------------------------------------------- -- *
 * --                           Hook-Routines                           -- *
 * -- ----------------------------------------------------------------- -- */

->»» PROC hoo_CLIProgress
PROC hoo_CLIProgress( cli_hook, cli_object, cli_msg : PTR TO xpkprogress )

  IF cli_msg.type = XPKPROG_START
    help_ClearCON()
    WriteF( '\n\tFile....: "\s"\n'    , cli_msg.filename )
    WriteF( '\tSize....: \d Bytes\n'  , cli_msg.ulen     )
    WriteF( '\c\tDone....: \r\d[3] %' , 13, cli_msg.done )
  ELSE
    WriteF( '\c\tDone....: \r\d[3] %' , 13, cli_msg.done )
  ENDIF

  -> user wants to abort ?
  IF CtrlC() <> FALSE
    WriteF( '\n\tCompression aborted !\n' )
    RETURN 1
  ENDIF

  IF cli_msg.type = XPKPROG_END
    WriteF( '\n\tEnd of (de)compression !\n' )
  ENDIF

ENDPROC 0
->»»>


/* -- ----------------------------------------------------------------- -- *
 * --                         Helping Routines                          -- *
 * -- ----------------------------------------------------------------- -- */

->»» PROC help_ShowXPKError
-> Simply prints out the name of the passed XPK-Error.
-> It's much more helpful then showing a negative value.
PROC help_ShowXPKError( sho_value )

  SELECT sho_value
  CASE XPKERR_NOFUNC       ; WriteF( 'XPKERR_NOFUNC\n'      )
  CASE XPKERR_NOFILES      ; WriteF( 'XPKERR_NOFILES\n'     )
  CASE XPKERR_IOERRIN      ; WriteF( 'XPKERR_IOERRIN\n'     )
  CASE XPKERR_IOERROUT     ; WriteF( 'XPKERR_IOERROUT\n'    )
  CASE XPKERR_CHECKSUM     ; WriteF( 'XPKERR_CHECKSUM\n'    )
  CASE XPKERR_VERSION      ; WriteF( 'XPKERR_VERSION\n'     )
  CASE XPKERR_NOMEM        ; WriteF( 'XPKERR_NOMEM\n'       )
  CASE XPKERR_LIBINUSE     ; WriteF( 'XPKERR_LIBINUSE\n'    )
  CASE XPKERR_WRONGFORM    ; WriteF( 'XPKERR_WRONGFORM\n'   )
  CASE XPKERR_SMALLBUF     ; WriteF( 'XPKERR_SMALLBUF\n'    )
  CASE XPKERR_LARGEBUF     ; WriteF( 'XPKERR_LARGEBUF\n'    )
  CASE XPKERR_WRONGMODE    ; WriteF( 'XPKERR_WRONGMODE\n'   )
  CASE XPKERR_NEEDPASSWD   ; WriteF( 'XPKERR_NEEDPASSWD\n'  )
  CASE XPKERR_CORRUPTPKD   ; WriteF( 'XPKERR_CORRUPTPKD\n'  )
  CASE XPKERR_MISSINGLIB   ; WriteF( 'XPKERR_MISSINGLIB\n'  )
  CASE XPKERR_BADPARAMS    ; WriteF( 'XPKERR_BADPARAMS\n'   )
  CASE XPKERR_EXPANSION    ; WriteF( 'XPKERR_EXPANSION\n'   )
  CASE XPKERR_NOMETHOD     ; WriteF( 'XPKERR_NOMETHOD\n'    )
  CASE XPKERR_ABORTED      ; WriteF( 'XPKERR_ABORTED\n'     )
  CASE XPKERR_TRUNCATED    ; WriteF( 'XPKERR_TRUNCATED\n'   )
  CASE XPKERR_WRONGCPU     ; WriteF( 'XPKERR_WRONGCPU\n'    )
  CASE XPKERR_PACKED       ; WriteF( 'XPKERR_PACKED\n'      )
  CASE XPKERR_NOTPACKED    ; WriteF( 'XPKERR_NOTPACKED\n'   )
  CASE XPKERR_FILEEXISTS   ; WriteF( 'XPKERR_FILEEXISTS\n'  )
  CASE XPKERR_OLDMASTLIB   ; WriteF( 'XPKERR_OLDMASTLIB\n'  )
  CASE XPKERR_OLDSUBLIB    ; WriteF( 'XPKERR_OLDSUBLIB\n'   )
  CASE XPKERR_NOCRYPT      ; WriteF( 'XPKERR_NOCRYPT\n'     )
  CASE XPKERR_NOINFO       ; WriteF( 'XPKERR_NOINFO\n'      )
  CASE XPKERR_LOSSY        ; WriteF( 'XPKERR_LOSSY\n'       )
  CASE XPKERR_NOHARDWARE   ; WriteF( 'XPKERR_NOHARDWARE\n'  )
  CASE XPKERR_BADHARDWARE  ; WriteF( 'XPKERR_BADHARDWARE\n' )
  CASE XPKERR_WRONGPW      ; WriteF( 'XPKERR_WRONGPW\n'     )
  DEFAULT                  ; WriteF( 'If you can read this, you should contact the author !\n' )
  ENDSELECT

ENDPROC
->»»>

->»» PROC help_WriteDummyFile
-> This little routines writes files of a given size.
-> The files are filled with shit but they may be
-> used for demonstrations.
PROC help_WriteDummyFile( gen_file, gen_size )
DEF gen_mem,gen_han

  -> allocate memory with the requested size
  gen_mem := AllocMem( gen_size, 0 )
  IF gen_mem <> NIL

    -> open the file
    gen_han := Open( gen_file, NEWFILE )
    IF gen_han <> NIL
      -> write the memory area into this file
      Write( gen_han, gen_mem, gen_size )
      Close( gen_han )
    ENDIF
    FreeMem( gen_mem, gen_size )

  ENDIF

  -> was writing successful
  IF FileLength( gen_file ) = gen_size
    RETURN TRUE
  ELSE
    DeleteFile( gen_file )
  ENDIF

ENDPROC FALSE
->»»>

->»» PROC help_WaitReturn
-> Stupid function which waits for a RETURN.
PROC help_WaitReturn()
DEF wai_buff[ 3 ] : STRING
  WriteF( '\n\n< PRESS RETURN TO CONTINUE > ' )
  ReadStr( stdin, wai_buff )
ENDPROC
->»»>

->»» PROC help_ClearCON
-> Simply clears the consolewindow.
PROC help_ClearCON() IS WriteF( '\e[0;0H\e[J' )
->»»>

->»» PROC help_LoadFile
PROC help_LoadFile( loa_path )
DEF loa_mem,loa_size,loa_han

  loa_size := FileLength( loa_path )
  loa_mem  := AllocMem( loa_size, MEMF_PUBLIC )
  IF loa_mem <> NIL

    loa_han := Open( loa_path, OLDFILE )
    IF loa_han <> NIL
      IF Read( loa_han, loa_mem, loa_size ) <> loa_size
        FreeMem( loa_mem, loa_size )
        loa_mem  := NIL
        loa_size := 0
      ENDIF
      Close( loa_han )
    ELSE
      FreeMem( loa_mem, loa_size )
      loa_mem  := NIL
      loa_size := 0
    ENDIF

  ENDIF

ENDPROC loa_mem,loa_size
->»»>


/* -- ----------------------------------------------------------------- -- *
 * --                          Demonstrations                           -- *
 * -- ----------------------------------------------------------------- -- */

->»» PROC dem_ShowConfiguration
PROC dem_ShowConfiguration( dem_object )
DEF dem_packerinfo : PTR TO xpkpackerinfo
DEF dem_packermode : PTR TO xpkmode
DEF dem_mode,dem_method

  -> This procedure simply gets some information from the given
  -> object and prints them out. It's very simpel as you can see.

  GetAttr ( CCA_METHOD , dem_object , {dem_method} )
  WriteF  ( '\n\n\tMethod..............: "\s"\n' , dem_method )

  GetAttr ( CCA_XPKPACKERINFO , dem_object , {dem_packerinfo} )
  WriteF  ( '\tLongName............: \s\n' , dem_packerinfo.longname )
  WriteF  ( '\tDescription.........: \s\n' , dem_packerinfo.description )

  GetAttr ( CCA_MODE, dem_object, {dem_mode} )
  WriteF  ( '\tMode................: \d\n', dem_mode )

  GetAttr ( CCA_XPKMODE, dem_object, {dem_packermode} )
  WriteF  ( '\tMode-Description....: \s\n', dem_packermode.description )

  WriteF  ( '\tEncryption..........: \s\n', IF (dem_packerinfo.flags AND XPKIF_ENCRYPTION) <> NIL THEN 'possible' ELSE 'not possible' )

  GetAttr( CCA_PASSWORD, dem_object, {dem_method} )
  WriteF( '\tPassword............: "\s"\n', dem_method )

  GetAttr( CCA_MEMPOOL, dem_object, {dem_method} )
  WriteF( '\tMemory pool.........: \s\n', IF dem_method <> NIL THEN 'installed' ELSE 'not installed' )
  GetAttr( CCA_PROGRESSHOOK, dem_object, {dem_method} )
  WriteF( '\tProgress-Hook.......: \s\n', IF dem_method <> NIL THEN 'installed' ELSE 'not installed' )

  GetAttr( CCA_HIDEPASSWORD, dem_object, {dem_method} )
  WriteF( '\tFlags...............: \s', IF dem_method <> FALSE THEN 'CCF_HIDEPASSWORD\n\t                      ' ELSE '' )

  GetAttr( CCA_INTERNALPROGRESS, dem_object, {dem_method} )
  WriteF( '\s', IF dem_method <> FALSE THEN 'CCF_INTERNALPROGRESS\n\t                      ' ELSE '' )

  GetAttr( CCA_SCREENLOCKED, dem_object, {dem_method} )
  WriteF( '\s', IF dem_method <> FALSE THEN 'CCF_SCREENLOCKED\n' ELSE '' )

  help_WaitReturn()

ENDPROC
->»»>

->»» PROC dem_SelectMethod
PROC dem_SelectMethod( dem_object )
DEF dem_buff[ 4 ] : STRING
DEF dem_list      : PTR TO LONG
DEF dem_count,dem_selected
DEF dem_choice,dem_run

  GetAttr( CCA_METHODLIST, dem_object, {dem_list}  )
  GetAttr( CCA_NUMPACKERS, dem_object, {dem_count} )

  dem_selected := FALSE
  WHILE dem_selected = FALSE

    help_ClearCON()

    WriteF( '\n\tSelect a method by entering the preceding number !\n\n' )

    -> print out the list of available packer
    WriteF( '\n\t' )
    FOR dem_run := 1 TO dem_count
      WriteF( ' \r\d[3]. \s   ', dem_run, dem_list[ dem_run - 1 ] )
      IF Mod( dem_run, 5 ) = 0 THEN WriteF( '\n\t' )
    ENDFOR

    WriteF( '\n\n\tYour choice => ' )
    ReadStr( stdin, dem_buff )
    dem_choice := Val( dem_buff )
    IF (dem_choice > 0) AND (dem_choice <= dem_count) THEN dem_selected := TRUE

  ENDWHILE

  -> we need the index (list starts from zero)
  dem_choice := dem_choice - 1


  -> both attributes are having the same effect, so you can use
  -> both calls. naturally you only need one of the following lines
  -> and you should prefer the attribute "CCA_METHODINDEX" because
  -> setting this is much faster than "CCA_METHOD". the reason is
  -> simple because my object have to search the method in the list
  -> and this results in some string-comparisons. if you are passing
  -> the name of a method which isn't available (or other shit) this
  -> will be ignored. all will be left unchanged.
  SetAttrsA( dem_object , [ CCA_METHODINDEX , dem_choice             , TAG_END ] )
  SetAttrsA( dem_object , [ CCA_METHOD      , dem_list[ dem_choice ] , TAG_END ] )

ENDPROC
->»»>

->»» PROC dem_SelectMode
PROC dem_SelectMode( dem_object )
DEF dem_buff [ 4 ] : STRING
DEF dem_mode

  WriteF( '\n\tEnter a value (1..100) => ' )
  ReadStr( stdin, dem_buff )
  dem_mode := Val( dem_buff )

  -> setting a value lower than 1 or higher than 100 will
  -> leave my object unchanged.
  SetAttrsA( dem_object, [ CCA_MODE, dem_mode, TAG_END ] )

ENDPROC
->»»>

->»» PROC dem_EnterPassword
PROC dem_EnterPassword( dem_object )
DEF dem_buffer[ 50 ] : STRING

  WriteF( '\n\tEnter a new password => ' )
  ReadStr( stdin, dem_buffer )

  -> the passed string will be copied to the internal buffer.
  SetAttrsA( dem_object, [ CCA_PASSWORD, dem_buffer, TAG_END ] )

ENDPROC
->»»>

->»» PROC dem_ToggleHook
PROC dem_ToggleHook( dem_object )
DEF dem_hook

  -> switch between progresshook on and progresshook off
  GetAttr( CCA_PROGRESSHOOK, dem_object, {dem_hook} )
  SetAttrsA( dem_object, [ CCA_PROGRESSHOOK, IF dem_hook <> NIL THEN NIL ELSE glo_clihook, TAG_END ] )

  IF dem_hook <> NIL
    WriteF( '\n\tCLI-Progress function has been removed !\n' )
  ELSE
    WriteF( '\n\tCLI-Progress function has been installed !\n' )
  ENDIF

  help_WaitReturn()

ENDPROC
->»»>

->»» PROC dem_PopupGUI
PROC dem_PopupGUI( dem_object )

  -> the simpliest way to do the configuration
  IF doMethodA( dem_object, [ CCM_PREFSGUI ] ) <> FALSE

    -> Damn, something went wrong
    WriteF( '\n\tCannot launch GUI !\n' )
    help_WaitReturn()

  ENDIF

ENDPROC
->»»>

->»» PROC dem_HiddenPassword
PROC dem_HiddenPassword( dem_object )
DEF dem_hidden

  GetAttr( CCA_HIDEPASSWORD, dem_object, {dem_hidden} )
  SetAttrsA( dem_object, [ CCA_HIDEPASSWORD, Not( dem_hidden ), TAG_END ] )

  IF dem_hidden <> FALSE
    WriteF( '\n\tThe password in the GUI is now visible !\n' )
  ELSE
    WriteF( '\n\tThe password in the GUI is now invisible !\n' )
  ENDIF

  help_WaitReturn()

ENDPROC
->»»>

->»» PROC dem_LoadPrefs
-> Both procedures are using the "iffparse.library" to write
-> the IFF-File. You could use your own code instead to write
-> such an IFF-File but I hope you won't write the chunk as
-> raw data in your prefsfile. However, this is a little example
-> that has minimal functionality but it shows how it works.
PROC dem_LoadPrefs( dem_object )
DEF dem_path [ 200 ] : STRING
DEF dem_prhd         : PTR TO storedproperty
DEF dem_cccp         : PTR TO storedproperty
DEF dem_iff          : PTR TO iffhandle
DEF dem_res

  WriteF( '\n\tEnter path of the prefsfile => ' )
  ReadStr( stdin, dem_path )

  IF FileLength( dem_path ) <= 0
    WriteF( '\n\tFile "\s" does not exist !\n', dem_path )
    help_WaitReturn()
    RETURN
  ENDIF

  dem_iff := AllocIFF()
  IF dem_iff <> NIL

    dem_iff.stream := Open( dem_path, OLDFILE )
    IF dem_iff.stream <> NIL

      InitIFFasDOS( dem_iff )
      IF OpenIFF( dem_iff, IFFF_READ ) = 0

        StopOnExit( dem_iff, ID_PREF, ID_FORM )
        PropChunk( dem_iff, ID_PREF, ID_PRHD )
        PropChunk( dem_iff, ID_PREF, ID_CCCP )

        -> search the selected chunks
        dem_res  := ParseIFF( dem_iff, IFFPARSE_SCAN )
        dem_prhd := FindProp( dem_iff, ID_PREF, ID_PRHD )
        dem_cccp := FindProp( dem_iff, ID_PREF, ID_CCCP )

        -> valid chunks ?
        IF ((dem_res = IFFERR_EOF) OR (dem_res = IFFERR_EOC)) AND (dem_prhd <> NIL) AND (dem_cccp <> NIL)

          WriteF( '\n\tVersion of the prefsfile : \d\n', dem_prhd.data::prefheader.version )

          -> here ! this is a simple way of setting the prefs.
          SetAttrsA( dem_object, [ CCA_PREFSCHUNK, dem_cccp, TAG_END ] )
          WriteF( '\tLoaded prefs are setted !\n' )
          help_WaitReturn()

        ENDIF

        CloseIFF( dem_iff )

      ENDIF
      Close( dem_iff.stream )

    ELSE
      WriteF( '\n\tCannot open file "\s" !\n', dem_path )
      help_WaitReturn()
    ENDIF

    FreeIFF( dem_iff )

  ELSE
    WriteF( '\n\tCan\at get an IFF-Handle !\n' )
    help_WaitReturn()
  ENDIF

ENDPROC
->»»>

->»» PROC dem_SavePrefs
PROC dem_SavePrefs( dem_object )
DEF dem_path [ 200 ] : STRING
DEF dem_cccp         : PTR TO storedproperty
DEF dem_iff          : PTR TO iffhandle
DEF dem_data

  WriteF( '\n\tEnter path of the prefsfile => ' )
  ReadStr( stdin, dem_path )

  dem_iff := AllocIFF()
  IF dem_iff <> NIL

    dem_iff.stream := Open( dem_path, NEWFILE )
    IF dem_iff.stream <> NIL

      InitIFFasDOS( dem_iff )
      IF OpenIFF( dem_iff, IFFF_WRITE ) = 0

        PushChunk( dem_iff, ID_PREF, ID_FORM, IFFSIZE_UNKNOWN )

        dem_data := [ 1, 0, 0 ]:prefheader
        PushChunk( dem_iff, ID_PREF, ID_PRHD, SIZEOF prefheader )
        WriteChunkBytes( dem_iff, dem_data, SIZEOF prefheader )
        PopChunk( dem_iff )

        -> this chunk must be saved
        GetAttr( CCA_PREFSCHUNK, dem_object, {dem_cccp} )

        -> here we are storing our chunk
        PushChunk( dem_iff, ID_PREF, ID_CCCP, dem_cccp.size )
        WriteChunkBytes( dem_iff, dem_cccp.data, dem_cccp.size )
        PopChunk( dem_iff )

        PopChunk( dem_iff )

        CloseIFF( dem_iff )

        WriteF( '\n\tWriting the prefs was successful !\n' )
        help_WaitReturn()

      ENDIF
      Close( dem_iff.stream )

    ELSE
      WriteF( '\n\tCannot open file "\s" !\n', dem_path )
      help_WaitReturn()
    ENDIF

    FreeIFF( dem_iff )

  ELSE
    WriteF( '\n\tCan\at get an IFF-Handle !\n' )
    help_WaitReturn()
  ENDIF

ENDPROC
->»»>

->»» PROC dem_ToggleMemPool
PROC dem_ToggleMemPool( dem_object )
DEF dem_pool

  GetAttr( CCA_MEMPOOL, dem_object, {dem_pool} )
  IF dem_pool <> NIL
    SetAttrsA( dem_object, [ CCA_MEMPOOL, NIL, TAG_END ] )
    WriteF( '\n\tMemory pool has been removed !\n' )
  ELSE
    SetAttrsA( dem_object, [ CCA_MEMPOOL, glo_mempool, TAG_END ] )
    WriteF( '\n\tMemory pool has been installed !\n' )
  ENDIF
  help_WaitReturn()

ENDPROC
->»»>

->»» PROC dem_ToggleProgress
PROC dem_ToggleProgress( dem_object )
DEF dem_flag
  GetAttr( CCA_INTERNALPROGRESS, dem_object, {dem_flag} )
  SetAttrsA( dem_object, [ CCA_INTERNALPROGRESS, Not( dem_flag ), TAG_END ] )
  IF dem_flag = FALSE
    Vprintf( 'Internal Progress-Hook installed !\n', NIL )
  ELSE
    Vprintf( 'Internal Progress-Hook removed !\n', NIL )
  ENDIF
  help_WaitReturn()
ENDPROC
->»»>

->»» PROC dem_File2File
PROC dem_File2File( dem_object, dem_compressing )
DEF dem_infile  [ 200 ] : STRING
DEF dem_outfile [ 200 ] : STRING
DEF dem_msg             : ccmFile2File
DEF dem_xerr

  WriteF( '\n\tPath of the file to ' )
  IF dem_compressing = FALSE THEN WriteF( 'de' )
  WriteF( 'compress => ' )
  ReadStr( stdin, dem_infile )

  IF FileLength( dem_infile ) > 0

    WriteF( '\tPath of the destination-file => ' )
    ReadStr( stdin, dem_outfile )

    WriteF( '\n' )

    -> here a file will be compressed
    dem_msg.methodid        := CCM_FILE2FILE
    dem_msg.com_Source      := dem_infile
    dem_msg.com_Destination := dem_outfile
    dem_msg.com_Compressing := dem_compressing

    dem_xerr := doMethodA( dem_object, dem_msg )
    IF dem_xerr = FALSE
      WriteF( '\n\tFile "\s" was ', dem_infile )
      IF dem_compressing = FALSE THEN WriteF( 'de' )
      WriteF( 'compressed from \d to \d Bytes\n', FileLength( dem_infile ), FileLength( dem_outfile ) )
    ELSE
      WriteF( '\n\tDamn, an error occured ! XPK-Error = ' )
      help_ShowXPKError( dem_xerr )
    ENDIF

  ELSE
    WriteF( 'The file "\s" doesn\at exist !\n', dem_infile )
  ENDIF

  help_WaitReturn()

ENDPROC
->»»>

->»» PROC dem_CompressFiles2Files
PROC dem_CompressFiles2Files( dem_object )
DEF dem_basename [  30 ]     : STRING
DEF dem_buffer   [ 200 ]     : STRING
DEF dem_strings  [ NILLIST ] : ARRAY OF LONG
DEF dem_results  [ NILLIST ] : ARRAY OF LONG
DEF dem_files2files          : ccmFiles2Files
DEF dem_size,dem_number
DEF dem_err,dem_len

  -> make sure the array are NIL-terminated
  dem_strings[ NUMFILES ] := NIL
  dem_results[ NUMFILES ] := NIL

  -> As you can see I prefer to use a suffix instead
  -> of a list with destination-names.
  dem_files2files.methodid         := CCM_FILES2FILES
  dem_files2files.com_Compressing  := TRUE
  dem_files2files.com_Sources      := dem_strings
  dem_files2files.com_Destinations := NIL
  dem_files2files.com_Results      := dem_results
  dem_files2files.com_Suffix       := 'lurf'

  dem_size   := Div( Shr( AvailMem(0), SIZESHIFT ), NUMFILES )

  WriteF( '\n\tEnter a basename for the files => ' )
  ReadStr( stdin, dem_basename )

  -> allocate memory for the strings
  dem_len := StrLen( dem_basename ) + 8
  dem_err := FALSE
  FOR dem_number := 0 TO NUMFILES - 1
    dem_strings[ dem_number ] := String( dem_len )
    IF dem_strings[ dem_number ] = NIL THEN dem_err := TRUE
  ENDFOR

  -> Damn, something went wrong
  IF dem_err <> FALSE
    WriteF( '\n\tNot enough memory available !\n' )
    help_WaitReturn()
    RETURN
  ENDIF

  -> generate the files
  Vprintf( '\n\tGenerating \d files with the size %lu Bytes:\n\n', [ dem_number, dem_size ] )
  FOR dem_number := 0 TO NUMFILES - 1
    stringf( dem_strings[ dem_number ], 'Ram:\s.\d', [ dem_basename, dem_number ] )
    help_WriteDummyFile( dem_strings[ dem_number ], dem_size )
    WriteF( '\n\tGenerated "\s"', dem_strings[ dem_number ] )
  ENDFOR

  -> here we are running the method
  dem_err    := doMethodA( dem_object, dem_files2files )
  WriteF( '\n\t\d files were processed successfully !\n', dem_err )

  FOR dem_number := 0 TO NUMFILES - 1
    IF dem_results[ dem_number ] <> XPKERR_OK
      WriteF( '\tFile "\s" failed ! XPK-Error: ', dem_strings[ dem_number ] )
      help_ShowXPKError( dem_results[ dem_number ] )
    ELSE
      stringf( dem_buffer, '\s.lurf', [ dem_strings[ dem_number ] ] )
      WriteF( '\tCompressed "\s" to "\s" (\d Bytes)\n', dem_strings[ dem_number ], dem_buffer, FileLength( dem_buffer ) )
    ENDIF
  ENDFOR

  help_WaitReturn()

ENDPROC
->»»>

->»» PROC dem_DecompressFiles2Files
PROC dem_DecompressFiles2Files( dem_object )
DEF dem_basename [  30 ]     : STRING
DEF dem_buffer   [ 200 ]     : STRING
DEF dem_strings  [ NILLIST ] : ARRAY OF LONG
DEF dem_results  [ NILLIST ] : ARRAY OF LONG
DEF dem_files2files          : ccmFiles2Files
DEF dem_number,dem_err,dem_len

  -> make sure the array are NIL-terminated
  dem_strings[ NUMFILES ] := NIL
  dem_results[ NUMFILES ] := NIL

  -> As you can see I prefer to use a suffix instead
  -> of a list with destination-names.
  dem_files2files.methodid         := CCM_FILES2FILES
  dem_files2files.com_Compressing  := FALSE
  dem_files2files.com_Sources      := dem_strings
  dem_files2files.com_Destinations := NIL
  dem_files2files.com_Results      := dem_results
  dem_files2files.com_Suffix       := 'lurf'

  WriteF( '\n\tEnter a basename for the files => ' )
  ReadStr( stdin, dem_basename )

  -> allocate memory for the strings
  dem_len := StrLen( dem_basename ) + 13
  dem_err := FALSE
  FOR dem_number := 0 TO NUMFILES - 1
    dem_strings[ dem_number ] := String( dem_len )
    IF dem_strings[ dem_number ] = NIL
      dem_err := TRUE
    ELSE
      stringf( dem_strings[ dem_number ], 'ram:\s.\d.lurf', [ dem_basename, dem_number ] )
    ENDIF
  ENDFOR

  -> Damn, something went wrong
  IF dem_err <> FALSE
    WriteF( '\n\tNot enough memory available !\n' )
    help_WaitReturn()
    RETURN
  ENDIF

  -> here we are running the method
  dem_err    := doMethodA( dem_object, dem_files2files )
  WriteF( '\n\t\d files were processed successfully !\n', dem_err )

  FOR dem_number := 0 TO NUMFILES - 1
    IF dem_results[ dem_number ] <> XPKERR_OK
      WriteF( '\tFile "\s" failed ! XPK-Error: ', dem_strings[ dem_number ] )
      help_ShowXPKError( dem_results[ dem_number ] )
    ELSE
      AstrCopy( dem_buffer, dem_strings[ dem_number ], StrLen( dem_strings[ dem_number ] ) - 4 )
      WriteF( '\tDecompressed "\s" to "\s" (\d Bytes)\n', dem_strings[ dem_number ], dem_buffer, FileLength( dem_buffer ) )
    ENDIF
  ENDFOR

  help_WaitReturn()

ENDPROC
->»»>

->»» PROC dem_File2Mem
PROC dem_File2Mem( dem_object, dem_compressing )
DEF dem_infile [ 200 ] : STRING
DEF dem_file2mem       : ccmFile2Mem
DEF dem_pool,dem_length,dem_endlen
DEF dem_mem,dem_xerr

  WriteF( '\n\tPath of the file to ' )
  IF dem_compressing = FALSE THEN WriteF( 'de' )
  WriteF( 'compress => ' )
  ReadStr( stdin, dem_infile )

  IF FileLength( dem_infile ) <= 0
    WriteF( '\n\tFile "\s" doesn\at exist !\n', dem_infile )
    help_WaitReturn()
    RETURN
  ENDIF

  GetAttr( CCA_MEMPOOL, dem_object, {dem_pool} )
  IF dem_pool <> NIL

    -> a memory pool is installed, so we are
    -> using this pool
    dem_file2mem.com_Memory := {dem_mem}
    dem_file2mem.com_Length := 0          -> this is needed to use the pool

  ELSE

    -> we must allocate the memory by ourself

    -> find out the needed length
    IF dem_compressing <> FALSE
      dem_length := PACKSIZE( FileLength( dem_infile ) )
    ELSE
      doMethodA( dem_object, [ CCM_EXAMINE, dem_infile, NIL, 0, {dem_length} ]:ccmExamine )
      dem_length := UNPACKSIZE( dem_length )
    ENDIF

    dem_mem := AllocMem( dem_length, MEMF_PUBLIC )
    IF dem_mem = NIL
      WriteF( '\n\tCannot allocate enough memory !\n' )
      help_WaitReturn()
      RETURN
    ENDIF

    dem_file2mem.com_Memory := dem_mem
    dem_file2mem.com_Length := dem_length

  ENDIF

  dem_file2mem.methodid        := CCM_FILE2MEM
  dem_file2mem.com_Compressing := dem_compressing
  dem_file2mem.com_Source      := dem_infile
  dem_file2mem.com_OutLen      := {dem_endlen}

  -> call the method
  dem_xerr := doMethodA( dem_object, dem_file2mem )
  IF dem_xerr = FALSE
    WriteF( '\n\tCompression was successful !\n' )
    IF dem_pool <> NIL
      dem_length := MEMSIZE( dem_mem )
      WriteF( '\tMemory pool was used !\n' )
    ENDIF
    WriteF( '\tMemory area at $\h ( \d Bytes )\n', dem_mem, dem_length )
    WriteF( '\tCompressed data \d Bytes\n', dem_endlen )
  ELSE
    WriteF( '\n\tAn error occured ! XPK-Error: ' )
    help_ShowXPKError( dem_xerr )
  ENDIF
  help_WaitReturn()

  IF dem_mem <> NIL
    IF dem_pool <> NIL
      FreePooled( glo_mempool, dem_mem - 4, dem_length )
    ELSE
      FreeMem( dem_mem, dem_length )
    ENDIF
  ENDIF

ENDPROC
->»»>

->»» PROC dem_Mem2Mem
PROC dem_Mem2Mem( dem_object, dem_compressing )
DEF dem_infile [ 200 ] : STRING
DEF dem_mem2mem        : ccmMem2Mem
DEF dem_sourcemem,dem_sourcelen
DEF dem_destmem,dem_destlen
DEF dem_pool,dem_endlen,dem_xerr

  WriteF( '\n\tEnter path of the file to load into memory => ' )
  ReadStr( stdin, dem_infile )

  dem_sourcemem,dem_sourcelen := help_LoadFile( dem_infile )
  IF dem_sourcemem = NIL
    WriteF( '\n\tCannot load file "\s" !\n', dem_infile )
    help_WaitReturn()
    RETURN
  ENDIF

  GetAttr( CCA_MEMPOOL, dem_object, {dem_pool} )

  IF dem_pool <> NIL
    dem_mem2mem.com_Destination    := {dem_destmem}
    dem_mem2mem.com_DestinationLen := 0
  ELSE

    IF dem_compressing <> FALSE
      dem_destlen := PACKSIZE( dem_sourcelen )
    ELSE
      doMethodA( dem_object, [ CCM_EXAMINE, NIL, dem_sourcemem, dem_sourcelen, {dem_destlen} ]:ccmExamine )
      dem_destlen := UNPACKSIZE( dem_destlen )
    ENDIF

    dem_destmem := AllocMem( dem_destlen, MEMF_PUBLIC )
    IF dem_destmem = NIL
      WriteF( '\n\tCannot allocate enough memory !\n' )
      FreeMem( dem_sourcemem, dem_sourcelen )
      help_WaitReturn()
      RETURN
    ENDIF

    dem_mem2mem.com_Destination    := dem_destmem
    dem_mem2mem.com_DestinationLen := dem_destlen

  ENDIF

  dem_mem2mem.methodid        := CCM_MEM2MEM
  dem_mem2mem.com_Compressing := dem_compressing
  dem_mem2mem.com_Source      := dem_sourcemem
  dem_mem2mem.com_SourceLen   := dem_sourcelen
  dem_mem2mem.com_OutLen      := {dem_endlen}

  dem_xerr := doMethodA( dem_object, dem_mem2mem )
  IF dem_xerr = FALSE
    WriteF( '\n\tOperation was successful !\n' )
    IF dem_pool <> NIL
      WriteF( '\tMemory pool was used !\n' )
      dem_destlen := MEMSIZE( dem_destmem )
    ENDIF
    IF dem_compressing <> FALSE
      WriteF( '\tCompressed ' )
    ELSE
      WriteF( '\tDecompressed ' )
    ENDIF
    WriteF( 'memory area $\h ( \d Bytes ) to $\h ( \d Bytes )\n', dem_sourcemem, dem_sourcelen, dem_destmem, dem_endlen )
  ELSE
    WriteF( '\n\tOperation failed ! XPK-Error: ' )
    help_ShowXPKError( dem_xerr )
  ENDIF
  help_WaitReturn()

  IF dem_destmem <> NIL
    IF dem_pool <> NIL
      FreePooled( glo_mempool, dem_destmem - 4, dem_destlen )
    ELSE
      FreeMem( dem_destmem, dem_destlen )
    ENDIF
  ENDIF

  FreeMem( dem_sourcemem, dem_sourcelen )

ENDPROC
->»»>


->»» PROC dem_Menu
PROC dem_Menu( men_object )
DEF men_buffer[ 20 ] : STRING
DEF men_end,men_choice

  -> Wow, what a modern style (Hehe) 

  men_end := FALSE

  WHILE men_end = FALSE

    help_ClearCON()

    Vprintf( {lab_ConfigMenu}, NIL )
    IF iffparsebase <> NIL THEN Vprintf( {lab_IFFMenu}, NIL )
    Vprintf( {lab_EndMenu}, NIL )
    Flush( stdout )
    ReadStr( stdin, men_buffer )

    men_choice := Val( men_buffer )

    help_ClearCON()
    SELECT men_choice 
    CASE  1  ; dem_ShowConfiguration ( men_object )
    CASE  2  ; dem_SelectMethod      ( men_object )
    CASE  3  ; dem_SelectMode        ( men_object )
    CASE  4  ; dem_EnterPassword     ( men_object )
    CASE  5  ; dem_ToggleHook        ( men_object )
    CASE  6  ; dem_PopupGUI          ( men_object )
    CASE  7  ; dem_HiddenPassword    ( men_object )
    CASE 10  ; dem_ToggleMemPool     ( men_object )
    CASE 19  ; dem_ToggleProgress    ( men_object )
    CASE  8  ; IF iffparsebase <> NIL THEN dem_LoadPrefs( men_object )
    CASE  9  ; IF iffparsebase <> NIL THEN dem_SavePrefs( men_object )
    CASE 11  ; dem_File2File  ( men_object, TRUE  )
    CASE 15  ; dem_File2File  ( men_object, FALSE )
    CASE 14  ; dem_Mem2Mem    ( men_object, TRUE  )
    CASE 18  ; dem_Mem2Mem    ( men_object, FALSE )
    CASE 13  ; dem_File2Mem   ( men_object, TRUE  )
    CASE 17  ; dem_File2Mem   ( men_object, FALSE )
    CASE 12  ; dem_CompressFiles2Files   ( men_object )
    CASE 16  ; dem_DecompressFiles2Files ( men_object )
    CASE 20  ; men_end := TRUE
    ENDSELECT

  ENDWHILE
 
ENDPROC
->»»>


/* -- ----------------------------------------------------------------- -- *
 * --                               Main                                -- *
 * -- ----------------------------------------------------------------- -- */

->»» PROC main
PROC main() HANDLE
DEF ma_object   : PTR TO object
DEF ma_class    : PTR TO iclass
DEF ma_clihook  : hook

  -> initialisation is necessary for proper exception-handling
  ma_object := NIL

  -> make sure to be started from CLI
  IF wbmessage <> NIL THEN Raise( ERR_NOWB )

  -> this library is needed for out configuration file
  iffparsebase   := OpenLibrary( 'iffparse.library', 37 )

  -> open the class itself
  compressorbase := OpenLibrary( 'compressor.class', 1 )
  IF compressorbase = NIL THEN Raise( ERR_LIB )

  -> Never forget to get the class-pointer
  ma_class := Cc_GetClassPtr()
  IF ma_class = NIL THEN Raise( ERR_CLASS )

  -> install the progresshook
  inithook( ma_clihook, {hoo_CLIProgress} )
  glo_clihook := ma_clihook

  -> allocate a memory pool for demonstration reasons
  glo_mempool := CreatePool( MEMF_PUBLIC, 500000, 25000 )

  -> create an object with initial tags
  ma_object   := NewObjectA( ma_class , NIL ,
  [ CCA_METHOD       , 'HUFF'               ,
    CCA_MODE         , 100                  ,
    CCA_PASSWORD     , 'Peter Lustig'       ,
    CCA_PROGRESSHOOK , ma_clihook           ,
    TAG_END ] )

  -> begin with the demonstration
  IF ma_object <> NIL THEN dem_Menu( ma_object )

EXCEPT DO

  SELECT exception
  CASE ERR_LIB   ; WriteF( 'Wasn\at able to open the class.\n' )
  CASE ERR_ARGS  ; WriteF( 'Bad Args !\n' )
  CASE ERR_CLASS ; WriteF( 'No class available !\n' )
  CASE ERR_NOWB  ; WriteF( 'You must run this proggy from a shell !\n' )
  ENDSELECT

  IF ma_object      <> NIL THEN DisposeObject( ma_object )
  IF glo_mempool    <> NIL THEN DeletePool( glo_mempool )
  IF iffparsebase   <> NIL THEN CloseLibrary( iffparsebase   )
  IF compressorbase <> NIL THEN CloseLibrary( compressorbase )

ENDPROC
->»»>


/* -- ----------------------------------------------------------------- -- *
 * --                               Data                                -- *
 * -- ----------------------------------------------------------------- -- */

lab_ConfigMenu:
CHAR '          +-------------------------------------+\n',
     '          |             \e[1;1mCONFIGURATION\e[0m           |\n',
     '          +-------------------------------------+\n',
     '          | 01. Show configuration              |\n',
     '          | 02. Select a method                 |\n',
     '          | 03. Select the mode                 |\n',
     '          | 04. Enter a password                |\n',
     '          | 05. Toggle hook installation        |\n',
     '          | 06. Use GUI for configuration       |\n',
     '          | 07. Toggle hidden password          |\n',0

lab_IFFMenu:
CHAR '          | 08. Load configuration from file    |\n',
     '          | 09. Save configuration to file      |\n',0

lab_EndMenu:
CHAR '          | 10. Toggle memory pool installation |\n',
     '          | 19. Toggle internal progresshook    |\n',
     '+---------+-----------------+-+-----------------+---------+\n',
     '|         \e[1;1mCOMPRESSION\e[0m       | |        \e[1;1mDECOMPRESSION\e[0m      |\n',
     '+---------------------------+ +---------------------------+\n',
     '| 11. From file to file     | | 15. From file to file     |\n',
     '| 12. From files to files   | | 16. From files to files   |\n',
     '| 13. From file to memory   | | 17. From file to memory   |\n',
     '| 14. From memory to memory | | 18. From memory to memory |\n',
     '+-------------+-------------+-+----------+----------------+\n',
     '              |  \e[2;1m20. Leave this program\e[0m  |\n',
     '              +--------------------------+\n\n',
     '  Your choice => ',0


CHAR '$VER: com_TestClass.e 1.0 (17-Sep-98) [ Daniel Kasmeroglu ]',0
