/* -- ----------------------------------------------------------------- -- *
 * -- Program.....: Class_Test.c                                        -- *
 * -- Author......: Daniel Kasmeroglu <raptor@cs.tu-berlin.de>          -- *
 * -- Description.: Demonstration of the Compressor.class               -- *
 * -- ----------------------------------------------------------------- -- *
 * -- History                                                           -- *
 * --                                                                   -- *
 * --   0.1 (31. August    1998) - Started with writing.                -- *
 * --   1.0 (17. September 1998) - Finished writing of E-Version.       -- *
 * --   1.0 (17. September 1998) - Finished C version.                  -- *
 * --                                                                   -- *
 * -- ----------------------------------------------------------------- -- */

/* -- ----------------------------------------------------------------- -- *
 * --                              Includes                             -- *
 * -- ----------------------------------------------------------------- -- */

#include <stdio.h>
#include <string.h>

#include <libraries/compressor.h>
#include <libraries/iffparse.h>
#include <libraries/xpk.h>

#include <utility/tagitem.h>
#include <utility/hooks.h>

#include <dos/dosextens.h>
#include <dos/rdargs.h>
#include <dos/dos.h>

#include <intuition/classusr.h>
#include <intuition/classes.h>

#include <prefs/prefhdr.h>

#include <exec/memory.h>

#include <pragma/compressor_lib.h>
#include <pragma/intuition_lib.h>
#include <pragma/iffparse_lib.h>
#include <pragma/exec_lib.h>

#include <clib/compressor_protos.h>
#include <clib/iffparse_protos.h>
#include <clib/alib_protos.h>
#include <clib/dos_protos.h>


/* -- ----------------------------------------------------------------- -- *
 * --                            Structures                             -- *
 * -- ----------------------------------------------------------------- -- */

struct Msg {
  ULONG MethodID;
};


/* -- ----------------------------------------------------------------- -- *
 * --                             Constants                             -- *
 * -- ----------------------------------------------------------------- -- */

#define help_ClearCON  printf( "%c[0;0H%c[J", 27, 27 );


/* -- ----------------------------------------------------------------- -- *
 * --                           Hook-Routines                           -- *
 * -- ----------------------------------------------------------------- -- */

/// hoo_CLIProgress
LONG __saveds hoo_CLIProgress( register __a1 struct XpkProgress *cli_msg ) {

  if (cli_msg->xp_Type == XPKPROG_START)
    {
      help_ClearCON
      printf( "\n    File....: '%s'\n"    , cli_msg->xp_FileName );
      printf( "    Size....: %lu Bytes\n" , cli_msg->xp_ULen     );
      printf( "\r    Done....: %-3u %%"   , cli_msg->xp_Done     );
      fflush( stdout );
    }
  else {
    printf( "\r    Done....: %-3u %%" , cli_msg->xp_Done );
    fflush( stdout );
  };

  if (cli_msg->xp_Type == XPKPROG_END) printf( "\n    End of (de)compression !\n" );

  return SetSignal(0L,SIGBREAKF_CTRL_C)&SIGBREAKF_CTRL_C;

};
///


/* -- ----------------------------------------------------------------- -- *
 * --                           Declarations                            -- *
 * -- ----------------------------------------------------------------- -- */

struct Hook glo_clihook  = {{0L},(HOOKFUNC)hoo_CLIProgress};
APTR        glo_mempool  = NULL;
APTR        glo_filemem  = 0;
ULONG       glo_filesize = NULL;

struct Library *iffparsebase;
struct Library *compressorbase;
struct Library *intuitionbase;
struct Library *dosbase;
struct Library *gfxbase;


/* -- ----------------------------------------------------------------- -- *
 * --                         Helping Routines                          -- *
 * -- ----------------------------------------------------------------- -- */

/// help_WaitReturn
void help_WaitReturn() {
struct RDArgs   *wai_rdargs;
ULONG           wai_var;
  printf( "\n\n< PRESS RETURN TO CONTINUE >\n" );
  wai_rdargs = ReadArgs( "ARG", (LONG *)&wai_var, NULL );
  if (wai_rdargs != NULL) FreeArgs( wai_rdargs );
};
///

/// help_ShowXPKError
// Simply prints out the name of the passed XPK-Error.
// It's much more helpful then showing a negative value.
void help_ShowXPKError( LONG sho_value ) {

  switch(sho_value) {
  case XPKERR_NOFUNC       : printf( "XPKERR_NOFUNC\n"      ) ; break ;
  case XPKERR_NOFILES      : printf( "XPKERR_NOFILES\n"     ) ; break ;
  case XPKERR_IOERRIN      : printf( "XPKERR_IOERRIN\n"     ) ; break ;
  case XPKERR_IOERROUT     : printf( "XPKERR_IOERROUT\n"    ) ; break ;
  case XPKERR_CHECKSUM     : printf( "XPKERR_CHECKSUM\n"    ) ; break ;
  case XPKERR_VERSION      : printf( "XPKERR_VERSION\n"     ) ; break ;
  case XPKERR_NOMEM        : printf( "XPKERR_NOMEM\n"       ) ; break ;
  case XPKERR_LIBINUSE     : printf( "XPKERR_LIBINUSE\n"    ) ; break ;
  case XPKERR_WRONGFORM    : printf( "XPKERR_WRONGFORM\n"   ) ; break ;
  case XPKERR_SMALLBUF     : printf( "XPKERR_SMALLBUF\n"    ) ; break ;
  case XPKERR_LARGEBUF     : printf( "XPKERR_LARGEBUF\n"    ) ; break ;
  case XPKERR_WRONGMODE    : printf( "XPKERR_WRONGMODE\n"   ) ; break ;
  case XPKERR_NEEDPASSWD   : printf( "XPKERR_NEEDPASSWD\n"  ) ; break ;
  case XPKERR_CORRUPTPKD   : printf( "XPKERR_CORRUPTPKD\n"  ) ; break ;
  case XPKERR_MISSINGLIB   : printf( "XPKERR_MISSINGLIB\n"  ) ; break ;
  case XPKERR_BADPARAMS    : printf( "XPKERR_BADPARAMS\n"   ) ; break ;
  case XPKERR_EXPANSION    : printf( "XPKERR_EXPANSION\n"   ) ; break ;
  case XPKERR_NOMETHOD     : printf( "XPKERR_NOMETHOD\n"    ) ; break ;
  case XPKERR_ABORTED      : printf( "XPKERR_ABORTED\n"     ) ; break ;
  case XPKERR_TRUNCATED    : printf( "XPKERR_TRUNCATED\n"   ) ; break ;
  case XPKERR_WRONGCPU     : printf( "XPKERR_WRONGCPU\n"    ) ; break ;
  case XPKERR_PACKED       : printf( "XPKERR_PACKED\n"      ) ; break ;
  case XPKERR_NOTPACKED    : printf( "XPKERR_NOTPACKED\n"   ) ; break ;
  case XPKERR_FILEEXISTS   : printf( "XPKERR_FILEEXISTS\n"  ) ; break ;
  case XPKERR_OLDMASTLIB   : printf( "XPKERR_OLDMASTLIB\n"  ) ; break ;
  case XPKERR_OLDSUBLIB    : printf( "XPKERR_OLDSUBLIB\n"   ) ; break ;
  case XPKERR_NOCRYPT      : printf( "XPKERR_NOCRYPT\n"     ) ; break ;
  case XPKERR_NOINFO       : printf( "XPKERR_NOINFO\n"      ) ; break ;
  case XPKERR_LOSSY        : printf( "XPKERR_LOSSY\n"       ) ; break ;
  case XPKERR_NOHARDWARE   : printf( "XPKERR_NOHARDWARE\n"  ) ; break ;
  case XPKERR_BADHARDWARE  : printf( "XPKERR_BADHARDWARE\n" ) ; break ;
  case XPKERR_WRONGPW      : printf( "XPKERR_WRONGPW\n"     ) ; break ;
  };

};
///

/// help_ReadValue
LONG help_ReadValue() {
struct RDArgs    *rea_rdargs;
ULONG            rea_value;
  rea_rdargs = ReadArgs( "VALUE/N", (LONG *)&rea_value, NULL );
  rea_value  = rea_value ? *(ULONG *)rea_value : 0;
  if (rea_rdargs != NULL) FreeArgs( rea_rdargs );
  return (LONG)rea_value;
};
///

/// help_SetAttrsA
void help_SetAttrsA( APTR set_object, ULONG set_attrid, ULONG set_data ) {
struct TagItem   set_tags[2];
  set_tags[0].ti_Tag   = set_attrid;
  set_tags[0].ti_Data  = set_data;
  set_tags[1].ti_Tag   = TAG_END;
  SetAttrsA( set_object, &set_tags[0] );
};
///

/// help_ReadString
void help_ReadString( STRPTR rea_buffer ) {
struct RDArgs   *rea_rdargs;
ULONG           rea_adr;
  rea_adr    = NULL;
  rea_rdargs = ReadArgs( "STRING", (LONG *)&rea_adr, NULL );
  if (rea_rdargs != NULL) {
    if (rea_adr != NULL)
      strcpy( rea_buffer, (STRPTR)rea_adr );
    else
      strcpy( rea_buffer, "" );
    FreeArgs( rea_rdargs );
  };
  else {
    strcpy( rea_buffer, "" );
  };
};
///

/// help_FileLength
ULONG help_FileLength( STRPTR fil_path ) {
struct FileInfoBlock   fil_fib;
ULONG                  fil_length;
BPTR                   fil_lock;

  fil_length = -1;
  fil_lock   = Lock( fil_path, SHARED_LOCK );
  if (fil_lock != NULL) {
    if (Examine( fil_lock, &fil_fib ) != NULL)
      fil_length =  fil_fib.fib_Size;
    UnLock( fil_lock );
  };

  return fil_length;

};
///

/// help_WriteDummyFile
// This little routines writes files of a given size.
// The files are filled with shit but they may be
// used for demonstrations.
ULONG help_WriteDummyFile( STRPTR wri_file, ULONG wri_size ) {
BPTR wri_han;
APTR wri_mem;

  // allocate memory with the requested size
  wri_mem = AllocMem( wri_size, 0 );
  if (wri_mem != NULL) {

    // open the file
    wri_han = Open( wri_file, MODE_NEWFILE );
    if (wri_han != NULL) {
      // write the memory area into this file
      Write( wri_han, wri_mem, wri_size );
      Close( wri_han );
    };
    FreeMem( wri_mem, wri_size );

  };

  // was writing successful
  if (help_FileLength( wri_file ) == wri_size)
    return TRUE;
  else
    DeleteFile( wri_file );

  return FALSE;
};
///

/// help_LoadFile
void help_LoadFile( STRPTR loa_path ) {
BPTR loa_han;

  if (glo_filemem != NULL) FreeMem( glo_filemem, glo_filesize );

  glo_filesize = help_FileLength( loa_path );
  glo_filemem  = AllocMem( glo_filesize, MEMF_PUBLIC );
  if (glo_filemem != NULL) {

    loa_han = Open( loa_path, MODE_OLDFILE );
    if (loa_han != NULL) {

      if (Read( loa_han, glo_filemem, glo_filesize ) != glo_filesize) {
        FreeMem( glo_filemem, glo_filesize );
        glo_filemem  = NULL;
        glo_filesize = 0;
      };

      Close( loa_han );
    };
    else {
      FreeMem( glo_filemem, glo_filesize );
      glo_filemem  = NULL;
      glo_filesize = 0;
    };
  };
};
///


/* -- ----------------------------------------------------------------- -- *
 * --                          Demonstrations                           -- *
 * -- ----------------------------------------------------------------- -- */

/// dem_ShowConfiguration
void dem_ShowConfiguration( APTR dem_object ) {
struct XpkPackerInfo  *dem_packerinfo;
struct XpkMode        *dem_packermode;
ULONG                 dem_method;
ULONG                 dem_mode;

  // This procedure simply gets some information from the given
  // object and prints them out. It's very simpel as you can see.
  GetAttr( CCA_METHOD, dem_object, &dem_method );
  printf( "\n\nMethod..............: '%s'\n", dem_method );

  GetAttr( CCA_XPKPACKERINFO , dem_object, (ULONG *)&dem_packerinfo );
  printf( "LongName............: '%s'\n", dem_packerinfo->xpi_LongName );
  printf( "Description.........: '%s'\n", dem_packerinfo->xpi_Description );

  GetAttr( CCA_MODE, dem_object, &dem_mode );
  printf( "Mode................: %d\n", dem_mode );

  GetAttr( CCA_XPKMODE, dem_object, (ULONG *)&dem_packermode );
  printf( "Mode-Description....: '%s'\n", dem_packermode->xm_Description );
  printf( "Encryption..........: '%s'\n", (dem_packerinfo->xpi_Flags & XPKIF_ENCRYPTION) ? "possible" : "not possible" );

  GetAttr( CCA_PASSWORD, dem_object, (ULONG *)&dem_method );
  printf( "Password............: '%s'\n", dem_method );

  GetAttr( CCA_MEMPOOL, dem_object, (ULONG *)&dem_method );
  printf( "Memory pool.........: %s\n", dem_method ? "installed" : "not installed" );

  GetAttr( CCA_PROGRESSHOOK, dem_object, (ULONG *)&dem_method );
  printf( "Progress-Hook.......: %s\n", dem_method ? "installed" : "not installed" );

  GetAttr( CCA_HIDEPASSWORD, dem_object, (ULONG *)&dem_method );
  printf( "Flags...............: %s", dem_method ? "CCF_HIDEPASSWORD\n                      " : "" );

  GetAttr( CCA_INTERNALPROGRESS, dem_object, (ULONG *)&dem_method );
  printf( "%s", dem_method ? "CCF_INTERNALPROGRESS\n                      " : "" );

  GetAttr( CCA_SCREENLOCKED, dem_object, (ULONG *)&dem_method );
  printf( "%s", dem_method ? "CCF_SCREENLOCKED\n" : "" );

  help_WaitReturn();

};
///

/// dem_SelectMethod
void dem_SelectMethod( APTR dem_object ) {
ULONG *dem_list;
ULONG dem_count;
ULONG dem_end;
ULONG dem_run;
LONG  dem_choice;

  GetAttr( CCA_METHODLIST, dem_object, (ULONG *)&dem_list );
  GetAttr( CCA_NUMPACKERS, dem_object, &dem_count );

  dem_end = 0;

  for(;;) {

    help_ClearCON

    printf( "\nSelect a method by entering the preceding number !\n\n" );

    // print out the list of available packer
    printf( "\n" );
    for ( dem_run = 1; dem_run<=dem_count; dem_run++ ) {
      printf( " %3d. %s   ", dem_run, dem_list[ dem_run - 1 ] );
      if (dem_run % 5 == 0) printf( "\n" );
    };

    printf( "\n\nYour choice => " );
    fflush( stdout );
    dem_choice = help_ReadValue();

    if ((dem_choice > 0) && (dem_choice <= dem_count)) dem_end = 1;

    if (dem_end != 0) break;

  };

  dem_choice = dem_choice - 1;

  // both attributes are having the same effect, so you can use
  // both calls. naturally you only need one of the following lines
  // and you should prefer the attribute "CCA_METHODINDEX" because
  // setting this is much faster than "CCA_METHOD". the reason is
  // simple because my object have to search the method in the list
  // and this results in some string-comparisons. if you are passing
  // the name of a method which isn't available (or other shit) this
  // will be ignored. all will be left unchanged.
  help_SetAttrsA( dem_object, CCA_METHODINDEX, (ULONG)dem_choice );
  help_SetAttrsA( dem_object, CCA_METHOD, (ULONG)dem_list[ dem_choice ] );

};
///

/// dem_SelectMode
void dem_SelectMode( APTR dem_object ) {
LONG dem_mode;

  printf( "\nEnter a value (1..100) => " );
  fflush( stdout );
  dem_mode = help_ReadValue();

  // setting a value lower than 1 or higher than 100 will
  // leave my object unchanged.
  help_SetAttrsA( dem_object, CCA_MODE, (ULONG)dem_mode );

};
///

/// dem_EnterPassword
void dem_EnterPassword( APTR dem_object ) {
TEXT dem_buffer[50];

  printf( "\nEnter a new password => " );
  fflush( stdout );
  help_ReadString( dem_buffer );

  // the passed string will be copied to the internal buffer.
  help_SetAttrsA( dem_object, CCA_PASSWORD, (ULONG)dem_buffer );

};
///

/// dem_ToggleHook
void dem_ToggleHook( APTR dem_object ) {
ULONG dem_hook;

  // switch between progresshook on and progresshook off
  GetAttr( CCA_PROGRESSHOOK, dem_object, &dem_hook );
  help_SetAttrsA( dem_object, CCA_PROGRESSHOOK, dem_hook ? NULL : (ULONG)&glo_clihook );

  if (dem_hook != NULL)
    printf( "\nCLI-Progress function has been removed !\n" );
  else
    printf( "\nCLI-Progress function has been installed !\n" );

  help_WaitReturn();

};
///

/// dem_PopupGUI
void dem_PopupGUI( APTR dem_object ) {
struct Msg pop_msg;

  pop_msg.MethodID = CCM_PREFSGUI;

  // the simpliest way to do the configuration
  if (DoMethodA( dem_object, (Msg)&pop_msg ) != NULL) {

    // Damn, something went wrong
    printf( "\nCannot launch GUI !\n" );
    help_WaitReturn();

  };

};
///

/// dem_HiddenPassword
void dem_HiddenPassword( APTR dem_object ) {
ULONG dem_hidden;

  GetAttr( CCA_HIDEPASSWORD, dem_object, &dem_hidden );
  help_SetAttrsA( dem_object, CCA_HIDEPASSWORD, !dem_hidden );

  if (dem_hidden != NULL)
    printf( "\nThe password in the GUI is now visible !\n" );
  else
    printf( "\nThe password in the GUI is now invisible !\n" );

  help_WaitReturn();

};
///

/// dem_ToggleProgress
void dem_ToggleProgress( APTR dem_object ) {
ULONG dem_flags;

  GetAttr( CCA_INTERNALPROGRESS, dem_object, &dem_flags );
  if (dem_flags != FALSE) {
    help_SetAttrsA( dem_object, CCA_INTERNALPROGRESS, FALSE );
    printf( "\nInternal Progress-Report removed !\n" );
  } else {
    help_SetAttrsA( dem_object, CCA_INTERNALPROGRESS, TRUE );
    printf( "\nInternal Progress-Report installed !\n" );
  };

  help_WaitReturn();

};
///

/// dem_LoadPrefs
// Both procedures are using the "iffparse.library" to write
// the IFF-File. You could use your own code instead to write
// such an IFF-File but I hope you won't write the chunk as
// raw data in your prefsfile. However, this is a little example
// that has minimal functionality but it shows how it works.
void dem_LoadPrefs( APTR dem_object ) {
TEXT                      dem_path[200];
struct StoredProperty     *dem_prhd;
struct StoredProperty     *dem_cccp;
struct IFFHandle          *dem_iff;
struct PrefHeader         *dem_prefhd;
ULONG                     dem_res;

  printf( "\nEnter path of the prefsfile => " );
  fflush( stdout );
  help_ReadString( dem_path );

  dem_iff = AllocIFF();
  if (dem_iff != NULL) {

    dem_iff->iff_Stream = Open( dem_path, MODE_OLDFILE );
    if (dem_iff->iff_Stream != NULL) {

      InitIFFasDOS( dem_iff );
      if (OpenIFF( dem_iff, IFFF_READ ) == 0) {

        StopOnExit( dem_iff, ID_PREF, ID_FORM );
        PropChunk( dem_iff, ID_PREF, ID_PRHD );
        PropChunk( dem_iff, ID_PREF, ID_CCCP );

        // search the selected chunks
        dem_res  = ParseIFF( dem_iff, IFFPARSE_SCAN );
        dem_prhd = FindProp( dem_iff, ID_PREF, ID_PRHD );
        dem_cccp = FindProp( dem_iff, ID_PREF, ID_CCCP );

        // valid chunks ?
        if (((dem_res == IFFERR_EOF) || (dem_res == IFFERR_EOC)) && (dem_prhd != NULL) && (dem_cccp != NULL)) {

          dem_prefhd = (PrefHeader *)dem_prhd->sp_Data;
          printf( "\nVersion of the prefsfile : %ld\n", dem_prefhd->ph_Version );

          // here ! this is a simple way of setting the prefs.
          help_SetAttrsA( dem_object, CCA_PREFSCHUNK, (ULONG)dem_cccp );
          printf( "Loaded prefs are setted !\n" );
          help_WaitReturn();

        };

        CloseIFF( dem_iff );

      };
      Close( dem_iff->iff_Stream );

    };
    else {
      printf( "\nCannot open file '\s' !\n", dem_path );
      help_WaitReturn();
    };

    FreeIFF( dem_iff );

  };
  else {
    printf( "\nCan't get an IFF-Handle !\n" );
    help_WaitReturn();
  };

};
///

/// dem_SavePrefs
void dem_SavePrefs( APTR dem_object ) {
TEXT                     dem_path[200];
struct StoredProperty    *dem_cccp;
struct IFFHandle         *dem_iff;
struct PrefHeader        dem_prefhd;

  printf( "\nEnter path of the prefsfile => " );
  fflush( stdout );
  help_ReadString( dem_path );

  dem_iff = AllocIFF();
  if (dem_iff != NULL) {

    dem_iff->iff_Stream = Open( dem_path, MODE_NEWFILE );
    if (dem_iff->iff_Stream != NULL) {

      InitIFFasDOS( dem_iff );
      if (OpenIFF( dem_iff, IFFF_WRITE ) == 0 ) {

        PushChunk( dem_iff, ID_PREF, ID_FORM, IFFSIZE_UNKNOWN );

        dem_prefhd.ph_Version = 1;
        dem_prefhd.ph_Type    = 0;
        dem_prefhd.ph_Flags   = 0;

        PushChunk( dem_iff, ID_PREF, ID_PRHD, 6 );
        WriteChunkBytes( dem_iff, &dem_prefhd, 6 );
        PopChunk( dem_iff );

        // this chunk must be saved
        GetAttr( CCA_PREFSCHUNK, dem_object, (ULONG *)&dem_cccp );

        // here we are storing our chunk
        PushChunk( dem_iff, ID_PREF, ID_CCCP, dem_cccp->sp_Size );
        WriteChunkBytes( dem_iff, dem_cccp->sp_Data, dem_cccp->sp_Size );
        PopChunk( dem_iff );

        PopChunk( dem_iff );

        CloseIFF( dem_iff );

        printf( "\nWriting the prefs was successful !\n" );
        help_WaitReturn();

      };
      Close( dem_iff->iff_Stream );

    };
    else {
      printf( "\nCannot open file '\s' !\n", dem_path );
      help_WaitReturn();
    };

    FreeIFF( dem_iff );

  };
  else {
    printf( "\nCan't get an IFF-Handle !\n" );
    help_WaitReturn();
  };

};
///

/// dem_ToggleMemPool
void dem_ToggleMemPool( APTR dem_object ) {
ULONG dem_pool;

  GetAttr( CCA_MEMPOOL, dem_object, &dem_pool );
  help_SetAttrsA( dem_object, CCA_MEMPOOL, dem_pool ? NULL : (ULONG)glo_mempool );

  if (dem_pool != NULL)
    printf( "\nMemory pool has been removed !\n" );
  else
    printf( "\nMemory pool has been installed !\n" );

  help_WaitReturn();

};
///

/// dem_File2File
void dem_File2File( APTR dem_object, ULONG dem_compressing ) {
struct ccmFile2File     dem_msg;
TEXT                    dem_infile[200];
TEXT                    dem_outfile[200];
LONG                    dem_xerr;

  printf( "\nPath of the file to " );
  if (dem_compressing == FALSE) printf( "de" );
  printf( "compress => " );
  fflush( stdout );
  help_ReadString( dem_infile );

  printf( "Path of the destination-file => " );
  fflush( stdout );
  help_ReadString( dem_outfile );

  printf( "\n" );

  // here a file will be compressed
  dem_msg.methodid        = CCM_FILE2FILE;
  dem_msg.com_Source      = dem_infile;
  dem_msg.com_Destination = dem_outfile;
  dem_msg.com_Compressing = dem_compressing;

  dem_xerr = DoMethodA( dem_object, (Msg)&dem_msg );
  if (dem_xerr == FALSE) {
    printf( "\nFile '%s' was ", dem_infile );
    if (dem_compressing == FALSE) printf( "de" );
    printf( "compressed from %lu to %lu Bytes\n", help_FileLength( dem_infile ), help_FileLength( dem_outfile ) );
  };
  else {
    printf( "\nDamn, an error occured ! XPK-Error = " );
    help_ShowXPKError( dem_xerr );
  };

  help_WaitReturn();

};
///

/// dem_File2Mem
void dem_File2Mem( APTR dem_object, ULONG dem_compressing ) {
TEXT                  dem_infile[200];
struct ccmFile2Mem    dem_file2mem;
APTR                  dem_pool;
ULONG                 dem_mem;
ULONG                 dem_length;
ULONG                 dem_endlen;
LONG                  dem_xerr;

  printf( "\nPath of the file to " );
  if (dem_compressing == FALSE) printf( "de" );
  printf( "compress => " );
  fflush( stdout );
  help_ReadString( dem_infile );

  if (help_FileLength( dem_infile ) <= 0) {
    printf( "\nFile '%s' doesn't exist !\n", dem_infile );
    help_WaitReturn();
    return;
  };

  GetAttr( CCA_MEMPOOL, dem_object, (ULONG *)&dem_pool );
  if (dem_pool != NULL) {

    // a memory pool is installed, so we are
    // using this pool
    dem_file2mem.com_Memory = &dem_mem;
    dem_file2mem.com_Length = 0;          // this is needed to use the pool

  };
  else {

    // we must allocate the memory by ourself, so first
    // we need to find out the length
    if (dem_compressing != FALSE)
      dem_length = PACKSIZE( help_FileLength( dem_infile ) );
    else {

      struct ccmExamine   dem_examine;

      dem_examine.methodid      = CCM_EXAMINE;
      dem_examine.com_Source    = dem_infile;
      dem_examine.com_Memory    = NULL;
      dem_examine.com_MemoryLen = 0;
      dem_examine.com_SizeAddr  = &dem_length;

      DoMethodA( dem_object, (Msg)&dem_examine );
      dem_length = UNPACKSIZE( dem_length );

    };

    // now do the allocation
    dem_mem = (ULONG)AllocMem( dem_length, MEMF_PUBLIC );
    if (dem_mem == NULL) {
      printf( "\nCannot allocate enough memory !\n" );
      help_WaitReturn();
      return;
    };

    dem_file2mem.com_Memory = (APTR)dem_mem;
    dem_file2mem.com_Length = dem_length;

  };

  dem_file2mem.methodid        = CCM_FILE2MEM;
  dem_file2mem.com_Compressing = dem_compressing;
  dem_file2mem.com_Source      = dem_infile;
  dem_file2mem.com_OutLen      = &dem_endlen;

  // call the method
  dem_xerr = DoMethodA( dem_object, (Msg)&dem_file2mem );
  if (dem_xerr == FALSE) {

    printf( "\nCompression was successful !\n" );
    if (dem_pool != NULL) {
      dem_length = MEMSIZE( dem_mem );
      printf( "Memory pool was used !\n" );
    };
    printf( "Memory area at $%08lx ( %lu Bytes )\n", dem_mem, dem_length );
    printf( "Compressed data %lu Bytes\n", dem_endlen );

  }; else {
    printf( "\nAn error occured ! XPK-Error: " );
    help_ShowXPKError( dem_xerr );
  };

  if (dem_pool != NULL) {
    if (dem_xerr == FALSE) {
      dem_mem = dem_mem - 4;
      FreePooled( glo_mempool, (APTR)dem_mem, dem_length );
    };
  }; else
    FreeMem( (APTR)dem_mem, dem_length );

  help_WaitReturn();

};
///

/// dem_Mem2Mem
void dem_Mem2Mem( APTR dem_object, ULONG dem_compressing ) {
TEXT                  dem_infile[200];
struct ccmMem2Mem     dem_mem2mem;
APTR                  dem_pool;
ULONG                 dem_mem;
ULONG                 dem_length;
ULONG                 dem_endlen;
LONG                  dem_xerr;

  printf( "\nPath of the file to " );
  if (dem_compressing == FALSE) printf( "de" );
  printf( "compress => " );
  fflush( stdout );
  help_ReadString( dem_infile );

  help_LoadFile( dem_infile );
  if (glo_filemem == NULL) {
    printf( "\nFile '%s' doesn't exist !\n", dem_infile );
    help_WaitReturn();
    return;
  };

  GetAttr( CCA_MEMPOOL, dem_object, (ULONG *)&dem_pool );
  if (dem_pool != NULL) {

    // a memory pool is installed, so we are
    // using this pool
    dem_mem2mem.com_Destination    = &dem_mem;
    dem_mem2mem.com_DestinationLen = 0;          // this is needed to use the pool

  };
  else {

    // we must allocate the memory by ourself, so first
    // we need to find out the length
    if (dem_compressing != FALSE)
      dem_length = PACKSIZE( glo_filesize );
    else {

      struct ccmExamine   dem_examine;

      dem_examine.methodid      = CCM_EXAMINE;
      dem_examine.com_Source    = NULL;
      dem_examine.com_Memory    = glo_filemem;
      dem_examine.com_MemoryLen = glo_filesize;
      dem_examine.com_SizeAddr  = &dem_length;

      DoMethodA( dem_object, (Msg)&dem_examine );
      dem_length = UNPACKSIZE( dem_length );

    };

    // now do the allocation
    dem_mem = (ULONG)AllocMem( dem_length, MEMF_PUBLIC );
    if (dem_mem == NULL) {
      printf( "\nCannot allocate enough memory !\n" );
      help_WaitReturn();
      return;
    };

    dem_mem2mem.com_Destination    = (APTR)dem_mem;
    dem_mem2mem.com_DestinationLen = dem_length;

  };

  dem_mem2mem.methodid        = CCM_MEM2MEM;
  dem_mem2mem.com_Compressing = dem_compressing;
  dem_mem2mem.com_Source      = glo_filemem;
  dem_mem2mem.com_SourceLen   = glo_filesize;
  dem_mem2mem.com_OutLen      = &dem_endlen;

  // call the method
  dem_xerr = DoMethodA( dem_object, (Msg)&dem_mem2mem );
  if (dem_xerr == FALSE) {

    printf( "\nCompression was successful !\n" );
    if (dem_pool != NULL) {
      dem_length = MEMSIZE( dem_mem );
      printf( "Memory pool was used !\n" );
    };
    printf( "Memory area $%08lx ( %lu Bytes ) to $%08lx ( %lu Bytes )\n", glo_filemem, glo_filesize, dem_mem, dem_length );

  }; else {
    printf( "\nAn error occured ! XPK-Error: " );
    help_ShowXPKError( dem_xerr );
  };

  if (dem_pool != NULL) {
    if (dem_xerr == FALSE) {
      dem_mem = dem_mem - 4;
      FreePooled( glo_mempool, (APTR)dem_mem, dem_length );
    };
  }; else
    FreeMem( (APTR)dem_mem, dem_length );

  help_WaitReturn();

};
///

/// dem_Menu
void dem_Menu( APTR dem_object ) {
ULONG dem_selected;
UBYTE dem_end;

  dem_end = 0;

  for(;;) {

    help_ClearCON
    printf( "          +-------------------------------------+\n" );
    printf( "          |             %c[1;1mCONFIGURATION%c[0m           |\n", 27, 27 );
    printf( "          +-------------------------------------+\n" );
    printf( "          | 01. Show configuration              |\n" );
    printf( "          | 02. Select a method                 |\n" );
    printf( "          | 03. Select the mode                 |\n" );
    printf( "          | 04. Enter a password                |\n" );
    printf( "          | 05. Toggle hook installation        |\n" );
    printf( "          | 06. Use GUI for configuration       |\n" );
    printf( "          | 07. Toggle hidden password          |\n" );

    if (iffparsebase != NULL) {
      printf( "          | 08. Load configuration from file    |\n" );
      printf( "          | 09. Save configuration to file      |\n" );
    };

    printf( "          | 10. Toggle memory pool installation |\n" );
    printf( "          | 19. Toggle internal progress report |\n" );
    printf( "          +-------------------------------------+\n\n" );
    printf( "+---------------------------+ +---------------------------+\n" );
    printf( "|         %c[1;1mCOMPRESSION%c[0m       | |        %c[1;1mDECOMPRESSION%c[0m      |\n", 27, 27, 27, 27 );
    printf( "+---------------------------+ +---------------------------+\n" );
    printf( "| 11. From file to file     | | 14. From file to file     |\n" );
    printf( "| 12. From file to memory   | | 15. From file to memory   |\n" );
    printf( "| 13. From memory to memory | | 16. From memory to memory |\n" );
    printf( "+-------------+-------------+-+----------+----------------+\n" );
    printf( "              |  %c[2;1m20. Leave this program%c[0m  |\n", 27, 27 );
    printf( "              +--------------------------+\n\n" );
    printf( "  Your choice => " );
    fflush( stdout );

    dem_selected = help_ReadValue();

    help_ClearCON
    switch( dem_selected ) {
    case  1  : dem_ShowConfiguration ( dem_object ); break;
    case  2  : dem_SelectMethod      ( dem_object ); break;
    case  3  : dem_SelectMode        ( dem_object ); break;
    case  4  : dem_EnterPassword     ( dem_object ); break;
    case  5  : dem_ToggleHook        ( dem_object ); break;
    case  6  : dem_PopupGUI          ( dem_object ); break;
    case  7  : dem_HiddenPassword    ( dem_object ); break;
    case 10  : dem_ToggleMemPool     ( dem_object ); break;
    case  8  : if (iffparsebase != NULL) dem_LoadPrefs( dem_object ); break;
    case  9  : if (iffparsebase != NULL) dem_SavePrefs( dem_object ); break;
    case 11  : dem_File2File ( dem_object, TRUE  ); break;
    case 14  : dem_File2File ( dem_object, FALSE ); break;
    case 12  : dem_File2Mem  ( dem_object, TRUE  ); break;
    case 15  : dem_File2Mem  ( dem_object, FALSE ); break;
    case 13  : dem_Mem2Mem   ( dem_object, TRUE  ); break;
    case 16  : dem_Mem2Mem   ( dem_object, FALSE ); break;
    case 19  : dem_ToggleProgress( dem_object ); break;
    case 20  : dem_end = 1 ; break ;
    default  : break ;
    };

    if (dem_end != 0) break;

  };

};
///


/* -- ----------------------------------------------------------------- -- *
 * --                               Main                                -- *
 * -- ----------------------------------------------------------------- -- */

/// main
ULONG main( void ) {
struct IClass     *ma_class;
struct Process    *ma_myproc;
struct TagItem    ma_tags[5];
ULONG             ma_retcode;
APTR              ma_object;

  // this is useful for later, except C initialises
  // global variables by default to NULL but I don't know if so 8-(
  ma_retcode   = 0;

  // check whether we are being started from CLI or not
  ma_myproc = (struct Process *)FindTask( NULL );
  if (ma_myproc->pr_CLI == NULL)
    {
      printf( "Start me from the CLI !\n" );
      return 20UL;
    };

  // try to open the "iffparse.library". It does no matter
  // if this opening fails.
  iffparsebase = OpenLibrary( "iffparse.library", 37 );

  gfxbase = OpenLibrary( "graphics.library", 37 );
  if (gfxbase != NULL) {

    dosbase = OpenLibrary( "dos.library", 37 );
    if (dosbase != NULL) {

      intuitionbase = OpenLibrary( "intuition.library", 33 );
      if (intuitionbase != NULL) {

        compressorbase = OpenLibrary( "compressor.class", 1 );
        if (compressorbase != NULL) {

          ma_class = Cc_GetClassPtr();
          if (ma_class != NULL) {

            // create a memory pool
            glo_mempool = CreatePool( MEMF_PUBLIC, 500000, 25000 );

            ma_tags[0].ti_Tag  = CCA_METHOD;
            ma_tags[1].ti_Tag  = CCA_MODE;
            ma_tags[2].ti_Tag  = CCA_PASSWORD;
            ma_tags[3].ti_Tag  = CCA_PROGRESSHOOK;
            ma_tags[4].ti_Tag  = TAG_END;
            ma_tags[0].ti_Data = (ULONG)"HUFF";
            ma_tags[1].ti_Data = 80;
            ma_tags[2].ti_Data = (ULONG)"Peter Lustig";
            ma_tags[3].ti_Data = (ULONG)&glo_clihook;
            ma_tags[4].ti_Data = NULL;

            ma_object = NewObjectA( ma_class, NULL, &ma_tags[0] );
            if (ma_object != NULL) dem_Menu( ma_object );

            DisposeObject( ma_object );

            // free the last mem allocated for "help_LoadFile()"
            if (glo_filemem != NULL) FreeMem( glo_filemem, glo_filesize );

            // free all memory associated with this pool
            if (glo_mempool != NULL) DeletePool( glo_mempool );

          };
          else
            printf( "Class is not available !\n" );

          CloseLibrary( compressorbase );
        };
        else
          printf( "Cannot open the 'compressor.class' v1.0 or higher !\n" );

        CloseLibrary( intuitionbase );
      };
      else
        ma_retcode = 20;

      CloseLibrary( dosbase );
    };
    else
      ma_retcode = 20;

    CloseLibrary( gfxbase );
  };
  else
    ma_retcode = 20;

  // close the "iffparse.library" if open
  if (iffparsebase != NULL) CloseLibrary( iffparsebase );

  exit( ma_retcode );

};
///


/* -- ----------------------------------------------------------------- -- *
 * --                               Data                                -- *
 * -- ----------------------------------------------------------------- -- */

TEXT glo_versionstr[] = "$VER: com_TestClass.e 1.0 (17-Sep-98) [ Daniel Kasmeroglu ]";

