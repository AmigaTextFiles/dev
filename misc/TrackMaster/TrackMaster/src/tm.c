//ญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญ
//
//  Soucecode:  TrackMaster
//
//  ฉ by BrainTrace Design    / Carsten Schlote, Egelseeweg 52,
//                              6302 Lich 1
//
//  Date          Author         Comment
//  =========     =========      ========================
//  26-Sep-91     Schlote        Offset & Directory Offset / Rev. Specialmdir
//  12-Sep-91     Schlote & MB   Relocator & Link feature
//  10-Aug-91     Schlote        Large-Size Dirtable
//  25-Jul-91     Schlote        Added lzh-coding of data
//  22-Jul-91     Schlote        Created this file!
//
//ญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญ

#include "tm.h"

#define BLKLENGTH( real )  ((real & 0xffffe00)+0x200)
#define COMPBLKLEN( real )  ( BLKLENGTH( real + ENCODEEXTRA( real ) ) )

#define  MAXENTRIES (4*64)                /* Maximale Anzahl von Files  */
#define  DIRBLOCK   (2*512)               /* Offset to DirBlock         */

//ญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญ
// The following stuff defines some code & data into glues.a

extern LONG __asm BBChkSum( register __a0 LONG * bootblock );
extern LONG __chip BootBlock[];
extern LONG __chip LoaderOffset, __chip LoaderLength;
extern LONG __chip NumFiles;

//ญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญ

OPAIR __chip dirfeld[MAXENTRIES];   // Dieses Feld enthไlt die Offsets/Lไngen für Trackdisk.device
                                    // Wird wไhrend des Schreibens erstellt.


TEXT  filefeld[MAXENTRIES][30];     /* Filename                         */
LONG  realfilelen[MAXENTRIES];      /* Die echte Filelไnge in Bytes !!  */
BOOL  compressfile[MAXENTRIES];     /* Dieses File comprimieren ?       */
BOOL  relocatefile[MAXENTRIES];     /* File relocieren und wohin        */
ULONG reloaddrfile[MAXENTRIES];
LONG  newoffset[MAXENTRIES];        /* Neuer BlockOffset o. -1          */

LONG  numfiles;                     /* Wieviele Files zu Zeit           */
LONG  curroffset;                   /* Actueller Blockoffset            */

TEXT *hunkfmt = "HunkWizard -a%lx -o%s %s\n";

//ญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญ

ULONG dospacket(struct MsgPort *aprt,LONG typ,
                LONG arg1,LONG arg2,LONG arg3,LONG arg4,LONG arg5,LONG arg6,LONG arg7)
{
struct StandardPacket *sp;
struct MsgPort* rp;
ULONG ret;

   if ( (rp = CreatePort(NULL,0))==NULL ) {
      return(-1);
   }else{
	   if ( (sp = AllocMem(sizeof(struct StandardPacket),MEMF_PUBLIC|MEMF_CLEAR))==0) {
		   DeletePort(rp);
		   return(-1);
      }else{
		   sp->sp_Msg.mn_Node.ln_Name = (char*)&(sp->sp_Pkt);
   		sp->sp_Pkt.dp_Link = &(sp->sp_Msg);
   		sp->sp_Pkt.dp_Port = rp;
	   	sp->sp_Pkt.dp_Type = typ;
   		sp->sp_Pkt.dp_Arg1 = arg1;
	   	sp->sp_Pkt.dp_Arg2 = arg2;
		   sp->sp_Pkt.dp_Arg3 = arg3;
		   sp->sp_Pkt.dp_Arg4 = arg4;
		   sp->sp_Pkt.dp_Arg5 = arg5;
		   sp->sp_Pkt.dp_Arg6 = arg6;
		   sp->sp_Pkt.dp_Arg7 = arg7;
   		PutMsg(aprt, &sp->sp_Msg); WaitPort(rp); GetMsg(rp);
		   ret = sp->sp_Pkt.dp_Res1;
		   FreeMem( sp, sizeof(struct StandardPacket));
   		DeletePort(rp);
      }
   }
   return(ret);
}

void inhibitdrive(WORD drnum, BOOL state)
{
TEXT*tp;
struct MsgPort *mp;
   switch( drnum ) {
   case  0 : tp = "df0:"; break;
   case  1 : tp = "df1:"; break;
   case  2 : tp = "df2:"; break;
   case  3 : tp = "df3:"; break;
   }
   mp = DeviceProc( tp );
   if ( mp ) {
		dospacket( mp, ACTION_INHIBIT,state,0,0,0,0,0,0);
   }
}

//ญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญ

LONG calcrating( struct LhBuffer *lh )
{
LONG ret;
   ret =  ( (lh->lh_SrcSize - lh->lh_DstSize) * 100 ) / lh->lh_SrcSize;
   return( ret );
}

//ญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญ

BOOL CheckDisk( struct IOStdReq* ior)
{
BOOL err = FALSE;
	ior->io_Command = TD_CHANGESTATE;
	DoIO( ior );
	if ( ior->io_Actual != FALSE ) {
		printf("Insert a blank,formatted disk in drive before !\n");
      err = TRUE;
	} else {
	   ior->io_Command = TD_PROTSTATUS;
	   err = DoIO( ior );
	   if ( ior->io_Actual != FALSE ) {
   		printf("Disk in selected drive is write-protected !\n");
         err = TRUE;
	   }
   }
	return( err );
}

//ญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญ

struct Library *LhBase;
struct LhBuffer *lhbuffer;

void openlibs(void) {
   if ( !(LhBase = OpenLibrary( LH_NAME, LH_VERSION ) )) {
      printf("\nI can't find the %s\nCompression disabled.\n",LH_NAME);
   }else{
      if ( !(lhbuffer = CreateBuffer(FALSE))) {
         printf("Unable to allocate auxilary buffers for compression.\n"
                "Terminating.\n");
         exit( RETURN_FAIL );
      }
   }
}
void closelibs(void) {
   if ( lhbuffer ) { DeleteBuffer(lhbuffer); lhbuffer = NULL; }
   if ( LhBase ) { CloseLibrary( LhBase ); LhBase = NULL; }
}

//ญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญ

void Usage(TEXT*pn) {
  printf(
   "Usage: %s scriptfile <0..3>\n\n"
   "This tool was designed to copy some workfiles to a non-dos disk\n"
   "using trackdisk.device.\n"
   "'scriptfile' is a file, which contains the names of the file to\n"
   "store. See TrackMaster Docfile for more information\n\n",pn);
}

//ญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญ

int main(int argc,char *argv[])
{
struct   MsgPort *myport;           /* Mein MessagePort           */
struct   IOStdReq *myio;            /* Mein Standard IO Block     */
LONG     unitnum;                   /* Nummer des Disklaufwerkes  */


struct   FileInfoBlock *fib;        /* Für Filelไngen etc         */
BPTR     lock;

FILE     *fp;
TEXT     buffer[256];               /* Eingabepuffer für Zeile    */
BYTE     *filebuff;                 /* DateiPuffer                */
BYTE     *compbuff;                 /* Compress Dest-Buffer       */

LONG     i,j;                       /* Laufvariable               */
BOOL     breakloop = FALSE;         /* Falls ein Fehler auftritt  */
BOOL     firstline = FALSE;         /* schon erste Zeile bearbeit.*/
BOOL     compresson = FALSE;        /* Default is aus !!!         */
BOOL     relocateon = FALSE;        /*       "                    */
ULONG    relocateaddr;
BOOL     specialon = FALSE;         /* Special command            */
TEXT     specialcom[80];
BOOL     patchdir = FALSE;          /* Skip some leading files on */
LONG     patchfrom;                 /* disk, yet.                 */


   printf("\nTrackMaster V1.7   Freeware ฉ1990 Carsten Schlote\n"
			 "                                    BrainTrace Design Software\n\n");

   //ญญญญญญญ Startup-Stuff for lhlib ญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญ

   onexit( closelibs );
   openlibs();

   //ญญญญญญญ Argumente auswerten ญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญ

   if ( argc != 3 ) {
      Usage(argv[0]); exit(RETURN_ERROR);
   }else{
      if ( sscanf( argv[2],"%ld\n", &unitnum )!=1 ) {
         printf("The drive number is invalid !\n\n"); breakloop = TRUE;
      }else{
         if ( (fp = fopen( argv[1],"r" ))==NULL ) {
            printf("Can't open scriptfile\n\n"); breakloop = TRUE;
         }else{
            if ( !(fib = AllocMem( sizeof(*fib),MEMF_PUBLIC ))) {
               printf("Can't allocate FIB.\n\n"); breakloop = TRUE;
            }else{
               numfiles = 0;

               //ญญญญScriptzeile lesen und auswertenญญญญญญญญญญญญญญญญญญญญญญญญญญญ

               while ( !breakloop && (fgets( buffer,256,fp ) != NULL) ) {

                  if ( buffer[0]=='\n' ) continue;    /* Commentar            */

                  if (newoffset[numfiles]<=0)
                     newoffset[ numfiles ] = -1;      /* No new offset, yet   */

                  //ญญญญCommandosequence auswertenญญญญญญญญญญญญญญญญญญญญญญญญญญญญญ

                  if ( buffer[0]=='#' ) {
                     if ( buffer[1]=='\n' ) continue;    /* Commentar         */

                     switch ( toupper( buffer[1] ) ) {
                     case '@' : if ( patchdir || firstline ) {
                                   printf("*** #@ may be used only once and the beginning of the script.\n");
                                   breakloop = TRUE;
                                }else{
                                   if ( sscanf( &buffer[3],"%ld",&patchfrom ) != 1 ) {
                                      printf("*** Dir Entry Number wrong or non-decimal.\n");
                                      breakloop = TRUE;
                                   }
                                   patchdir = TRUE;
                                   numfiles = patchfrom;
                                }
                                break;
                     case 'O' : if ( sscanf( &buffer[3],"%ld",&newoffset[numfiles] ) != 1 ) {
                                   printf("*** Offset Number wrong or non-decimal.\n");
                                   breakloop = TRUE;
                                }
                                break;
                     case 'C' : if ( LhBase ) compresson = ( buffer[2]=='1' )?TRUE:FALSE; break;
                     case 'R' : relocateon = (buffer[2]== '1')?TRUE:FALSE;
                                if ( buffer[2] == '1' ) {
                                   if ( sscanf( &buffer[3],"%lx", &relocateaddr ) != 1 ) {
                                       printf("*** Hexaddr for relocate is wrong\n");
                                       breakloop = TRUE;
                                   }
                                } break;
                     case 'S' : specialon = (buffer[2]== '1')?TRUE:FALSE;
                                strcpy( specialcom ,&buffer[3] );
                                break;
                     case 'L' : {
                                TEXT tempfname[30];
                                TEXT linkfiles[30*30] = "\0";
                                TEXT doscom[256];
                                   if ( sscanf( &buffer[2],"%d %s",&i,tempfname ) != 2 ) {
                                      printf("*** Link parameters wrong or missing.\n");
                                      breakloop = TRUE;
                                   }
                                   if ( i <= 30 && i > 1 ) {
                                      while ( i > 0 ) {
                                         if ( fgets( buffer,256,fp ) != NULL ) {
                                            if ( buffer[0] == '\n' ) continue;
                                            strcat( linkfiles, buffer );
                                            linkfiles[ strlen(linkfiles)-1 ] = ' ';
                                         }
                                         --i;
                                      }
                                      sprintf(doscom,"Join %s to %s", linkfiles, tempfname );
                                      if ( Execute( doscom, NULL,NULL ) == FALSE ) {
                                         printf("*** Linkage failed.\n"); breakloop=TRUE; continue;
                                      }
                                      strcpy(buffer, tempfname );
                                      goto getlinkfilename;
                                   }else{
                                      printf("*** Too many/less files for link option.\n");
                                      breakloop = TRUE;
                                   }
                                }
                                break;
                     }
                     continue;
                  }
                  buffer[ strlen( buffer ) -1 ] = 0;
getlinkfilename:
                  //ญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญ

                  if ( relocateon & specialon ) {
                     printf("Script options conflict\n");
                     breakloop = TRUE; continue;
                  }

                  //ญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญ

                  if ( specialon ) {
                  TEXT tempfname[30], doscom[256], *p;
                  TEXT speccom[160];
                     strcpy( speccom, specialcom );
                     strcpy( tempfname, buffer ); strcat( tempfname, ".rel" );
                     while ( p = strchr( speccom, '@' ) ) {
                        p[0] = '%';
                        switch ( p[1] ) {
                        case 's' : sprintf( doscom, speccom, buffer ); strcpy( speccom, doscom ); break;
                        case 'd' : p[1] = 's'; sprintf( doscom, speccom, tempfname); strcpy( speccom, doscom ); break;
                        }
                     }
                     strcpy( doscom, speccom );
                     printf("%s",doscom );
                     if ( Execute( doscom, NULL,NULL ) == FALSE ) {
                        printf("Can't start requested command or prg failed.\n");
                        breakloop = TRUE; continue;
                     }
                     strcpy( buffer, tempfname );
                  }

                  //ญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญ

                  if ( relocateon ) {
                  TEXT tempfname[30];
                  TEXT doscom[256];
                     strcpy( tempfname, buffer );
                     strcat( tempfname, ".rel" );
                     sprintf( doscom, hunkfmt, relocateaddr, tempfname,buffer );
                     if ( Execute( doscom, NULL,NULL ) == FALSE ) {
                        printf("Can't start hunkwizard or prg failed.\n");
                        breakloop = TRUE; continue;
                     }
                     strcpy( buffer, tempfname );
                  }

                  //ญญญญFile locken und auswertenญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญ

                  if ( sscanf( buffer,"%30s\n",filefeld[numfiles]) != 1 ) {
                     printf("Error in scriptfile.\n"); breakloop = TRUE;
                  } else {
                     if ( (lock=Lock(filefeld[numfiles],ACCESS_READ))==0 ) {
                        printf("Can't find file %s.\n\n",filefeld[numfiles]);
                        breakloop = TRUE;
                     }else{
                        if ( Examine( lock, fib ) == FALSE ) {
                           printf("Can't examine file %s.\n\n",filefeld[numfiles]);
                           breakloop = TRUE;
                        }else{
                           realfilelen[numfiles]=fib->fib_Size;
                           compressfile[numfiles] = (numfiles==0)?FALSE:compresson;
                           relocatefile[numfiles] = relocateon;
                           reloaddrfile[numfiles] = relocateaddr;
                        }
                        UnLock(lock);
                     }
                  }
                  if ( ++numfiles >= MAXENTRIES-1 ) { // Wegen filenamesfile => - 1 !
                     printf("Table overflow. Too many files in script !\n");
                     breakloop=TRUE;
                  }
                  firstline = TRUE;
               }
               FreeMem(fib,sizeof(fib));
            }
            fclose(fp);             /* scriptfile schlie฿en */
         }
      }
   }
   if ( breakloop ) exit( RETURN_FAIL );

   //ญญญญ Filenamen abspeichern ญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญ

   {
   LONG fnamelen = numfiles * 30;
   BPTR fh;
      if ( fh = Open( "tm.dir", MODE_NEWFILE ) ) {
         if ( Write( fh, filefeld, fnamelen ) != fnamelen ) exit(RETURN_FAIL);
         Close(fh);
      } else {
         exit( RETURN_FAIL );
      }
      strcpy( filefeld[numfiles], "tm.dir" );
      realfilelen[numfiles]= fnamelen;
      compressfile[numfiles] = TRUE;
      relocatefile[numfiles] = FALSE;
      reloaddrfile[numfiles] = NULL;
      newoffset[numfiles] = -1;
      ++numfiles;
   }

   //ญญญญญญญ Daten lesen und schreiben ญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญ

#define TDCOM( com, data, offset, len ) { myio->io_Command = com; myio->io_Data = data; myio->io_Offset = offset; myio->io_Length = len; DoIO(myio); }
#define TDCOMX( com, data, offset, len ) { TDCOM( com,data, offset,len); if (myio->io_Error) { printf("*** IO-Error %ld. Terminating.\n",myio->io_Error); goto error; } }

   if(numfiles==0) {
      printf("Nothing to write !?\n\n"); exit(RETURN_WARN);
   }
   if ( (myport = CreatePort( NULL,0 ))==NULL ) {
      printf("Can't create port.\n\n"); exit(RETURN_ERROR);
   }else{
      if ( (myio = CreateStdIO( myport ))==NULL ) {
         printf("Can't create std io.\n\n"); exit(RETURN_ERROR);
      }else{
         if ( OpenDevice( TD_NAME, unitnum, myio, 0 )!=0 ) {
            printf("Can't open %s unit %ld.\n\n",TD_NAME,unitnum); exit(RETURN_ERROR);
         }else{
            inhibitdrive( unitnum, TRUE );
            printf("Please insert disk in Drive df%ld: and hit return.",unitnum);
            Read( Input(), buffer, sizeof(buffer) );

            if ( (i = CheckDisk( myio )) ) {
               printf("*** IO-Error %ld. Terminating.\n",i);
               goto nodisk;
            }

            //ญญญญFiles lesen, bearbeiten und schreiben ญญญญญญญญญญญญญญญญญญญญญญญ

            curroffset = DIRBLOCK + BLKLENGTH( (numfiles*8) );

            printf("---------------------------------------------------------------------\n");
            for ( i= (patchdir)?patchfrom:0 ; i<numfiles ; ++i )
            {
            static OPAIR olddirfeld[MAXENTRIES];
            static TEXT oldfilefeld[MAXENTRIES][30];
            static TEXT packedfiles[MAXENTRIES][30];
            static LONG * lp = (LONG*)packedfiles;

               if ( patchdir && (i==patchfrom) ) {
                  printf("patching old entries...\r");
                  TDCOMX( CMD_READ, olddirfeld, DIRBLOCK, BLKLENGTH( (numfiles*8) ) );
                  for ( j=0; j<patchfrom; ++j ) dirfeld[j] = olddirfeld[j];

                  for ( j = MAXENTRIES-1; j > 0 && !olddirfeld[j].offset && !olddirfeld[j].length ; --j )
                     ;
                  TDCOMX( CMD_READ, packedfiles, olddirfeld[j].offset, olddirfeld[j].length );
                  if ( lp[0] == 'PACK' ) {
                     lhbuffer->lh_Src = &lp[3]; lhbuffer->lh_SrcSize = lp[1];
                     lhbuffer->lh_Dst = oldfilefeld; lhbuffer->lh_DstSize = lp[2];
                     LhDecode( lhbuffer );
                  }else
                     memcpy( oldfilefeld, packedfiles, sizeof(packedfiles) );
               }

               if ( newoffset[i] != -1 ) {
                  if ( newoffset[i]*512 < curroffset ) {
                     printf("*** Warning : Seeking to lower disk offset.\n");
                  }
                  curroffset = newoffset[i] * 512;
                  printf("Seek to Diskblock %ld and continue writing.\n",newoffset[i] );
               }

               if ( curroffset < (DIRBLOCK + BLKLENGTH( (numfiles*8) )) ||
                    curroffset > ( 160*11*512 ) ) {
                  printf("*** Seek offset invalid.\n\n");
                  break;
               }

               if( !(filebuff = AllocMem( BLKLENGTH(realfilelen[i]), MEMF_CHIP|MEMF_PUBLIC|MEMF_CLEAR ))) {
                  printf("*** Can't allocate buffer for file %s.\n\n",filefeld[i]);
                  breakloop = TRUE;
               }else{
                  if( !(lock = Open( filefeld[i], MODE_OLDFILE ))) {
                     printf("*** Can't open file %s.\n\n",filefeld[i]);
                     breakloop = TRUE;
                  } else {
                     if ( Read(lock, filebuff, realfilelen[i]) != realfilelen[i] ) {
                        printf("*** Can't open file %s.\n\n",filefeld[i]);
                        breakloop = TRUE;
                     }else{
                        if ( compressfile[i] ) {
                           if ( !(compbuff = AllocMem( COMPBLKLEN( realfilelen[i] ), MEMF_CHIP|MEMF_CLEAR|MEMF_PUBLIC ))) {
                              printf("*** Can't allocate compression buffer.\nTerminate.\n");
                              breakloop = TRUE;
                           }else{

                              if ( i == numfiles-1 && patchdir ) {
                                 for ( j=0; j<patchfrom; ++j ) {
                                    memcpy( filebuff+(j*30),&oldfilefeld[j], 30 );
                                 }
                              }

                              lhbuffer->lh_Src = filebuff; lhbuffer->lh_SrcSize = realfilelen[i];
                              lhbuffer->lh_Dst = compbuff + ( 3*4 );
                              printf(" Compress data - stand by.");
                              if ( LhEncode( lhbuffer )==0 ) {
                                 printf("\r*** Compression failed.\nTerminating.\n");
                                 breakloop = TRUE;
                              }else{
                                 if ( lhbuffer->lh_DstSize >= lhbuffer->lh_SrcSize ) {
                                    printf("\r*** uncompressable data. Check file %s\nTerminate.\n",filefeld[i] );
                                    breakloop = TRUE;
                                 }else{
                                    {
                                    LONG * tp;
                                       tp = (LONG*)(compbuff);
                                       tp[0] = 'PACK' ;
                                       tp[1] = lhbuffer->lh_SrcSize;
                                       tp[2] = lhbuffer->lh_DstSize;
                                    }
                                    dirfeld[i].offset = curroffset;
                                    dirfeld[i].length = BLKLENGTH( lhbuffer->lh_DstSize );
                                    printf("\r%3ld. Offset: %6ld(%4ld)  Length: %6ld(%4ld) Rate:%ld%% File: %s\n",
                                            i,
                                            dirfeld[i].offset,dirfeld[i].offset/512,
                                            dirfeld[i].length,dirfeld[i].length/512,calcrating( lhbuffer ),filefeld[i] );
                                    TDCOMX( CMD_WRITE, compbuff, dirfeld[i].offset, dirfeld[i].length);
                                    curroffset += dirfeld[i].length;
                                 }
                              }
                              FreeMem( compbuff, COMPBLKLEN(realfilelen[i]) );
                           }
                        }else{
                           dirfeld[i].offset = curroffset;
                           dirfeld[i].length = BLKLENGTH( realfilelen[i] );
                           printf("%3ld. Offset: %6ld(%4ld)  Length: %6ld(%4ld) File: %s\n",
                                   i,
                                   dirfeld[i].offset,dirfeld[i].offset/512,
                                   dirfeld[i].length,dirfeld[i].length/512,filefeld[i] );
                           TDCOMX( CMD_WRITE, filebuff, dirfeld[i].offset, dirfeld[i].length);
                           curroffset += dirfeld[i].length;
                        }
                        Close(lock);
                     }
                  }
                  FreeMem(filebuff, BLKLENGTH( realfilelen[i] ) );
               }
               if ( breakloop ) break;
            }
            printf("---------------------------------------------------------------------\n");
            printf("Writing %ld direntrie(s) to offset %ld(%ld).\n",numfiles,DIRBLOCK,DIRBLOCK/512);
            TDCOMX( CMD_WRITE, dirfeld, DIRBLOCK, BLKLENGTH( (numfiles*8) ) );

            printf("---------------------------------------------------------------------\n");
            printf("Writing BootLoader for first, unpacked & pc-relative program !\n");
            LoaderOffset = dirfeld[0].offset;
            LoaderLength = dirfeld[0].length;
            NumFiles = numfiles;
            BBChkSum( BootBlock );
            TDCOMX( CMD_WRITE, BootBlock, 0, 1024 );

error:      printf("---------------------------------------------------------------------\n");
            TDCOM( CMD_UPDATE, 0,0,0 );
            TDCOM( TD_MOTOR, 0,0,0 );       // Motor aus
            printf("Please remove disk from Drive df%ld: and hit return.",unitnum);
            Read( Input(), buffer, sizeof(buffer) );
nodisk:     inhibitdrive( unitnum, FALSE );
            printf("%s",(breakloop==FALSE)?"All done.\n":"Operation failed !\n");
            CloseDevice( myio );
         }
         DeleteStdIO( myio );
      }
      DeletePort( myport );
   }

   //ญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญ

   closelibs();

   //ญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญ

   return( breakloop?RETURN_FAIL:RETURN_OK );
}

