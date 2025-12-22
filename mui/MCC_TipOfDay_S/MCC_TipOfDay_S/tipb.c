
/*
** $Id: tipb.c,v 1.5 2000/06/29 22:41:48 carlos Exp $
**
** If your editor supports folding, set /// as  the
** opening and //| as closing phrases.
**
** Anyone who will fuck up the source indentation
** will die screaming!
**
** Carlos
*/

#include "tipb.h"

/// Data
struct Data
{
    Object *Board;
    ULONG  set_attr;

    char   filebase[256];
    ULONG  tips_file_initialized;

    ULONG  max_tips;
    ULONG  tipc_file_exists;

// saved to .tipc file

    LONG   current_tip;
    ULONG  show_on_startup;

// end


    char   tip[ TIP_LEN ];
};
//|

/// CLASS
#define CLASS       MUIC_Tipboard
#define SUPERCLASS  MUIC_Group

#define UserLibID VERSTAG " © 1999-2000 Marcin Orlowski <carlos@amiga.com.pl>"
#define MASTERVERSION 14

#define __NAME "Tipboard: "
#define  MCC_USES_IFFPARSE

#define VERSION TIPB_VERSION
#define REVISION TIPB_REVISION
#define VERSTAG TIPB_VERSTAG
#include "mccheader.c"
//|
/// TIP STOP CHUNKS
#define TIP_NUM_STOPS (sizeof(Tip_Stops) / (2 * sizeof(ULONG)))

STATIC LONG Tip_Stops[] =
{
        ID_TIPS, ID_MAX,
        ID_TIPS, ID_SHOW,
        ID_TIPS, ID_LAST,
        NULL, NULL,
};
//|

/// GetTipsName
char *GetTipsName( char *basename )
{
/*
** Looks for AmigaGuide on-line documentation
** The most correct location should be the last one,
** while the 1st should be default one (it will be
** returned even if file doesn't exists there).
*/

static char Tmp[ 128 ];
char Language[ 40 ];
char *result = NULL;
char *Locations[] = {
                      "PROGDIR:Tips/%s/%s",
                      "PROGDIR:Catalogs/%s/%s",
                      "LOCALE:Catalogs/%s/%s",
                      "LOCALE:Tips/%s/%s",
                      "LOCALE:%s_%s",
                      "PROGDIR:Tips/%s_%s",
                     };
int  Index        = (sizeof(Locations)/sizeof(char *)) - 1;


   sprintf(Tmp, Locations[0], "english", basename);

   if(GetVar("language", Language, sizeof(Language), NULL) > 0)
     {
     while(Index >= 0)
       {
       BPTR TipsLock;

       sprintf( Tmp, Locations[Index], Language, basename );

//       D(bug( __NAME "GetTipsName: %s\n", Tmp ));

       if( TipsLock = Lock( Tmp, ACCESS_READ ) )
          {
          UnLock( TipsLock );

          result = Tmp;
          break;
          }
       else
          Index--;
       }
     }


    if( !result )
       {
       char *Locations2[] = {
                      "PROGDIR:Tips/english/%s",
                      "PROGDIR:Tips/%s",
                      "PROGDIR:%s",
                     };
       int  Index2        = (sizeof(Locations2)/sizeof(char *)) - 1;


       while(Index2 >= 0)
           {
           BPTR TipsLock;

           sprintf( Tmp, Locations2[ Index2 ], basename );

//           D(bug(__NAME "GetTipsName: %s\n", Tmp ));

           if( TipsLock = Lock( Tmp, ACCESS_READ ) )
              {
              UnLock( TipsLock );

              result = Tmp;
              break;
              }
           else
              Index2--;
          }
       }

    return( result );

}
//|

/// _Open

/*
** frontend to dos' Open(). Searches proper path
** to the file
*/

BPTR _Open( char *name, LONG mode, char *suffix )
{
char   file[ 45 ];
char   *filename;

    _strcpy( file, name );
    _strcat( file, suffix );

    if( filename = GetTipsName( file ) )
       return( Open( filename, mode ) );
    else
       return( NULL );
}
//|

/// _ReadTip

/*
** Reads Tip #data->current_tip from tips file
** returns TRUE or FALSE if read failed.
*/

ULONG _ReadTip(struct IClass *cl, Object *obj, Msg msg)
{
struct Data *data = INST_DATA(cl,obj);

#define _NUM_STOPS (sizeof(_Stops) / (2 * sizeof(ULONG)))
LONG _Stops[] =
{
    ID_TIPS, ID_MAX,
    NULL, NULL,
};

ULONG  result = FALSE;

   if( data->filebase[0] != 0 )
     {
     struct IFFHandle *iff;
     struct ContextNode *cn;
     long   Error = 0;
//     char   ValidFile = FALSE;
     ULONG  Current = '0000';


     if(iff = AllocIFF())
       {
       char _id[5];

       sprintf( _id, "%04lx", data->current_tip );
       _strtolower( _id, _id );
       _Stops[1] = MAKE_ID( _id[0], _id[1], _id[2], _id[3] );
       Current = _Stops[1];

       D(bug(__NAME "ReadTip ('%s'): ID: %s  %lx  Current: %lx\n", data->filebase, _id, _Stops[1], data->current_tip ));


       if(iff->iff_Stream = _Open( data->filebase, MODE_OLDFILE, ".tips" ))
           {
           InitIFFasDOS(iff);

           StopChunks(iff, _Stops, _NUM_STOPS);

           if(!OpenIFF(iff, IFFF_READ))
               {
               while(TRUE)
                  {
                  Error = ParseIFF(iff, IFFPARSE_SCAN);

                  if(!((Error >= 0) || (Error == IFFERR_EOC)))
                     break;

                  if(cn = CurrentChunk(iff))
                     {
                     LONG ID = cn->cn_ID;

/*
                     if(!ValidFile)
                        {
                        if((ID == ID_CAT) && (cn->cn_Type == ID_TIPS))
                           {
                           ValidFile = TRUE;
                           continue;
                           }

                        break;
                        }
*/
///                       Current tip

//                   D(bug(__NAME "ID: %lx vs %lx\n", ID, Current ));

                     if(ID == Current)
                        {
                        ULONG len = cn->cn_Size;

                        if( len > TIP_LEN )
                           len = TIP_LEN;

                        ReadChunkBytes( iff, data->tip, len );
                        data->tip[ len ] = 0;

                        result = TRUE;
                        break;
                        }
//|

                     }
                  }

               CloseIFF(iff);
               }

            Close(iff->iff_Stream);
            }

       if(Error == IFFERR_EOF) Error = 0;

//       if(((Error!=0 || ValidFile!=TRUE) && (msg->Quiet==FALSE)))
//             MUI_Request((Object *)xget(obj, MUIA_ApplicationObject), (Object *)xget(obj, MUIA_WindowObject), 0, TITLE, MSG_OK, MSG_EDIT_AUTHOR_READ_ERROR);

       FreeIFF(iff);
       }
    else
       {
       D(bug(__NAME "ReadTip: AllocIFF() failed\n"));
       }
    }

    return( result );
}
//|
/// _InitTipsFile

/*
** Scans given Tip file and fill the max_tips and related
** variables according to the data stored in the file
*/

ULONG _InitTipsFile(struct IClass *cl, Object *obj, Msg msg)
{
struct Data *data = INST_DATA(cl,obj);

ULONG  result = FALSE;

struct IFFHandle *iff;
struct ContextNode *cn;
long   Error = 0;
//char   ValidFile = FALSE;


   // no File Base, let's try to find out one...
   if( data->filebase[0] == 0 )
     if( !DoMethod( obj, MUIM_Tipb_GetDefFileBase ) )
       return( NULL );


     if( iff = AllocIFF() )
       {
//       D(bug(__NAME "InitTipFile: %s\n", file ));

       if(iff->iff_Stream = _Open( data->filebase, MODE_OLDFILE, ".tips" ))
           {
           InitIFFasDOS(iff);

           StopChunks(iff, Tip_Stops, TIP_NUM_STOPS);

           if(!OpenIFF(iff, IFFF_READ))
               {
               while(TRUE)
                  {
                  Error = ParseIFF(iff, IFFPARSE_SCAN);

                  if(!((Error >= 0) || (Error == IFFERR_EOC)))
                     break;

                  if(cn = CurrentChunk(iff))
                     {
                     LONG ID = cn->cn_ID;

/*
                     if(!ValidFile)
                        {
                        if((ID == ID_CAT) && (cn->cn_Type == ID_TIPS))
                           {
                           ValidFile = TRUE;
                           continue;
                           }

                        break;
                        }
*/
/*
///                       ID_VERS
                     if(ID == ID_VERS)
                        {
                        struct BaseVersion version = {0};

                        if(ReadChunkBytes(iff, &version, cn->cn_Size) == cn->cn_Size)
                           {
                           D(bug("TIP: %ld.%ld\n", version.Version, version.Revision));
                           if((version.Version != 0) && (version.Revision != 53))
                               {
                               D(bug("To nie jest magazyn v0.53!\n");
                               break;
                               }

                           }
                        else
                           {
                           printf("?!\n");
                           Error = IoErr();
                           break;
                           }

                        continue;
                        }
//|
*/
///                       ID_MAX

                     // tipcount
                     if(ID == ID_MAX )
                        {
                        if(ReadChunkBytes(iff, &data->max_tips, cn->cn_Size) != sizeof(ULONG))
                           {
                           data->max_tips = 0;
                           }

                        data->tips_file_initialized = TRUE;
                        result = TRUE;

                        break;
                        }
//|

                     }
                  }

               CloseIFF(iff);
               }
            else
               {
               D(bug(__NAME "Can't OpenIFF() for '%s.tips'\n", data->filebase ));
               }

            Close(iff->iff_Stream);
            }
         else
            {
            D(bug(__NAME "Can't Open() for '%s.tips'\n", data->filebase ));
            }

       if(Error == IFFERR_EOF) Error = 0;

//       if(((Error!=0 || ValidFile!=TRUE) && (msg->Quiet==FALSE)))
//             MUI_Request((Object *)xget(obj, MUIA_ApplicationObject), (Object *)xget(obj, MUIA_WindowObject), 0, TITLE, MSG_OK, MSG_EDIT_AUTHOR_READ_ERROR);

       FreeIFF(iff);
       }

    return( result );
}

//|
/// _LoadTipcData

/*
** Restores numer of last shown tip (if count file exists)
*/

ULONG _LoadTipcData(struct IClass *cl, Object *obj, Msg msg)
{
struct Data *data = INST_DATA(cl,obj);

ULONG  result = FALSE;
char   file[256];

   if( data->filebase[0] != 0 )
     {
     struct IFFHandle *iff;
     struct ContextNode *cn;
     long   Error = 0;
//     char   ValidFile = FALSE;


     if(iff = AllocIFF())
       {
       _strcpy( file, data->filebase );
       _strcat( file, ".tipc" );

       if(iff->iff_Stream = Open( file, MODE_OLDFILE))
           {
           InitIFFasDOS(iff);

           StopChunks(iff, Tip_Stops, TIP_NUM_STOPS);

           if(!OpenIFF(iff, IFFF_READ))
               {
               D(bug(__NAME "_LoadTipcData(): '%s'\n", file));

               while(TRUE)
                  {
                  Error = ParseIFF(iff, IFFPARSE_SCAN);

                  if(!((Error >= 0) || (Error == IFFERR_EOC)))
                     break;


                  if(cn = CurrentChunk(iff))
                     {
                     LONG ID = cn->cn_ID;

/*
                     if(!ValidFile)
                        {
                        if((ID == ID_CAT) && (cn->cn_Type == ID_TIPS))
                           {
                           ValidFile = TRUE;
                           continue;
                           }

                        break;
                        }
*/
///                       ID_LAST

                     // last shown tip
                     if(ID == ID_LAST)
                        {
                        if(ReadChunkBytes(iff, &data->current_tip, cn->cn_Size) != sizeof(ULONG))
                           data->current_tip = 0;

                        D(bug(__NAME "ID_LAST: %ld\n",data->current_tip));
                        continue;
                        }
//|
///                       ID_SHOW

                     // show on startup state
                     if(ID == ID_SHOW)
                        {
                        if(ReadChunkBytes(iff, &data->show_on_startup, cn->cn_Size) != sizeof(ULONG))
                           data->show_on_startup = TRUE;

                        D(bug(__NAME "ID_SHOW: %ld\n",data->show_on_startup));
                        continue;
                        }
//|

                     }
                  }

               CloseIFF(iff);

               data->tipc_file_exists = TRUE;
               }

            D(bug(__NAME "_LoadTipcData(): done\n" ));

            Close(iff->iff_Stream);
            }

       if(Error == IFFERR_EOF) Error = 0;

//       if(((Error!=0 || ValidFile!=TRUE) && (msg->Quiet==FALSE)))
//             MUI_Request((Object *)xget(obj, MUIA_ApplicationObject), (Object *)xget(obj, MUIA_WindowObject), 0, TITLE, MSG_OK, MSG_EDIT_AUTHOR_READ_ERROR);

       FreeIFF(iff);
       }
     }
    else
     {
     D(bug(__NAME "LoadTipcData: filebase is NULL!\n" ));
     }

    return( result );
}

//|
/// _SaveTipcData

ULONG _SaveTipcData(struct IClass *cl, Object *obj, Msg msg)
{
struct Data *data = INST_DATA(cl,obj);

char   file[256];
struct IFFHandle *MyIFFHandle;
//int i;

    if(MyIFFHandle = AllocIFF())
        {
        BPTR  FileHandle;

        _strncpy( file, data->filebase, sizeof(file) );
        _strcat( file, ".tipc" );

        if(FileHandle = Open( file, MODE_NEWFILE))
           {
           MyIFFHandle->iff_Stream = FileHandle;
           InitIFFasDOS(MyIFFHandle);

           if(OpenIFF(MyIFFHandle, IFFF_WRITE) == 0)
               {
               struct BaseVersion version;

               PushChunk(MyIFFHandle, ID_TIPS, ID_CAT, IFFSIZE_UNKNOWN);

               PushChunk(MyIFFHandle, ID_TIPS, ID_FORM, IFFSIZE_UNKNOWN);
                   PushChunk(MyIFFHandle, ID_TIPS, ID_VERS, IFFSIZE_UNKNOWN);
                   version.Version = VERSION;
                   version.Revision = REVISION;
                   WriteChunkBytes(MyIFFHandle, &version, sizeof(version));
                   PopChunk(MyIFFHandle);
               PopChunk(MyIFFHandle);


               PushChunk(MyIFFHandle, ID_TIPS, ID_FORM, IFFSIZE_UNKNOWN);

               PushChunk(MyIFFHandle, ID_TIPS, ID_LAST, IFFSIZE_UNKNOWN);
               WriteChunkBytes(MyIFFHandle, &data->current_tip, sizeof(ULONG));
               PopChunk(MyIFFHandle);

               PushChunk(MyIFFHandle, ID_TIPS, ID_SHOW, IFFSIZE_UNKNOWN);
               WriteChunkBytes(MyIFFHandle, &data->show_on_startup, sizeof(ULONG));
               PopChunk(MyIFFHandle);

               PopChunk(MyIFFHandle);

               PopChunk(MyIFFHandle);
               CloseIFF(MyIFFHandle);
               }
           else
               {
               DisplayBeep(0);
               D(bug(__NAME "*** _SaveTipCount: OpenIFF() failed\n"));
               }

           Close(FileHandle);
           }
        else
           {
//           MUI_Request(app, (Object *)xget(obj, MUIA_WindowObject), 0, TITLE, MSG_OK, MSG_WRITE_ERROR);
           D(bug(__NAME "*** Can't open for write \"%s\"\n", file));
           }

        FreeIFF(MyIFFHandle);
        }
     else
        {
        D(bug(__NAME "*** SaveTipCount: Can't AllocIFF()\n"));
        }

    return(0);
}

//|
/// _GetDefFileBase

/*
** Tries to resolve proper file base for the current
** application if no FileBase is given by user. Strips
** trailing .1, .2 etc suffixes for multiple instances
** to get real core name
**
** returns TRUE if file base exists or was properly
** resolved. Otherwise returns FALSE
**
** new name is set() to make sure all related
** initializations will take place! We rely on this!
*/

ULONG _GetDefFileBase( struct IClass *cl, Object *obj, Msg msg )
{
struct Data *data = INST_DATA(cl,obj);
ULONG result = FALSE;

    if( data->filebase[0] == 0 )
       {
       // let's find out application base name

       Object *app = (Object *)xget( obj, MUIA_ApplicationObject );

       D(bug(__NAME "Application object: %lx\n", app ));
       if( app )
           {
           char name_buf[ 40 ];
           char *name;

           if( (name = (char *)xget( app, MUIA_Application_Base )) == NULL )
               name = (char *)xget( app, MUIA_Application_Title );

           D(bug(__NAME "OurBaseName: '%s'\n", name ));
           if( name )
               {
               char *dot;

               _strncpy( name_buf, name, sizeof( name_buf ) );


               // let's strip some ".1", ".2" taks suffixes (if any)
               dot = _strnchrrev( name_buf, '.', 4 );
               if( dot )
                  dot[0] = 0;

               set( obj, MUIA_Tipb_FileBase, name_buf );
               result = TRUE;
               }
           }
       }
    else
       {
       // FileBase exists
       result = TRUE;
       }

    D(bug(__NAME " DefFileBase: result: %ld base: '%s'\n", result, data->filebase ));
    return( result );
}
//|

/// _ShowTip
ULONG _ShowTip(struct IClass *cl, Object *obj, struct MUIP_Tipb_Show *msg)
{
struct Data *data = INST_DATA(cl,obj);


    if( data->tips_file_initialized == FALSE )
       {
       if( !DoMethod( obj, MUIM_Tipb_InitTipsFile ) )
           {
           D(bug(__NAME "InitTipsFile failed\n"));

           DisplayBeep(NULL);
           return( FALSE );
           }

       // tipc file shall be already read (on filebase set/detect)
       if( data->tipc_file_exists )
          {
          if( data->current_tip > data->max_tips )
               {
               data->current_tip = 0;
               }
          }
       else
          {
          // if there's no tipc file we need to
          // show the very first tip

          goto show_tip;
          }
       }


    // let's update counters...
    switch( msg->Flags )
       {
       case MUIV_Tipb_Show_Random:
           {
           struct DateStamp ds;
           LONG   next_tip;

           DateStamp( &ds );

           next_tip = ds.ds_Tick % data->max_tips;

           if( next_tip == data->current_tip )
               data->current_tip = (data->current_tip+1) % data->max_tips;
           else
               data->current_tip = next_tip;
           }
           break;

       case MUIV_Tipb_Show_Prev:
           {
           data->current_tip--;
           if(data->current_tip < 0)
               data->current_tip = data->max_tips - 1;
           }
           break;

       default:
           {
           data->current_tip = (data->current_tip+1) % data->max_tips;
           }
           break;
       }


show_tip:
    if( DoMethod( obj, MUIM_Tipb_ReadTip ) )
       {
       set( data->Board, data->set_attr, data->tip );
       }
    else
       {
       DisplayBeep( 0 );
       D(bug(__NAME " Can't read tip #%ld!\n", data->current_tip ));
       }

    return( 0 );
}
//|

/// OM_NEW


ULONG ASM _New( REG(a0) struct IClass *cl,
                REG(a2) Object *obj,
                REG(a1) Msg msg )
{
struct Data *data;
Object *Board;
ULONG  set_attr = MUIA_Floattext_Text;


    D(bug(__NAME ": OM_NEW\n"));


/*    // is TI present?

    if( (Board = TextinputObject,
                   TextFrame, TextBack,
                   MUIA_Textinput_NoInput     , TRUE,
                   MUIA_Textinput_Multiline   , TRUE,
                   MUIA_Textinput_DefaultPopup, TRUE,
                   MUIA_Textinput_WordWrap    , 30,
                 End ) )
       {
       set_attr = MUIA_Textinput_Contents;
       }
    else
*/
       {
       Board = FloattextObject, TextFrame, TextBack, End;
       }



    if( !obj )
       {
       D(bug(__NAME "No TI/TF classes available!\n"));
       return( NULL);
       }



    // let's create the board
    obj = (Object *)DoSuperNew(cl, obj,
                       Child, Board,
                  TAG_DONE );


    if( obj )
        {
        /*** init data ***/

        data = INST_DATA(cl, obj);

        data->Board    = Board;
        data->set_attr = set_attr;

        data->filebase[0]    = 0;
        data->tips_file_initialized = FALSE;
        data->max_tips      = 0;
        data->current_tip   = 0;
        data->tipc_file_exists  = FALSE;
        data->show_on_startup     = TRUE;


        /*** trick to set arguments ***/
        msg->MethodID = OM_SET;
        DoMethodA(obj, (Msg)msg);
        msg->MethodID = OM_NEW;
        }



    return((ULONG)obj);

}
//|
/// OM_DISPOSE
ULONG _Dispose(struct IClass *cl, Object *obj, struct opSet *msg)
{
struct Data *data = INST_DATA(cl,obj);


    D(bug(__NAME "OM_DISPOSE\n"));


    if( data->tips_file_initialized )
        DoMethod( obj, MUIM_Tipb_SaveTipcData );


    DoSuperMethodA(cl, obj, msg);

    return( 0 );
}
//|
/// OM_SET

ULONG ASM _Set(REG(a0) struct IClass *cl, REG(a2) Object *obj, REG(a1) Msg msg)
{
struct Data *data = INST_DATA(cl,obj);
struct TagItem *tags,*tag;

    for(tags=((struct opSet *)msg)->ops_AttrList; tag=NextTagItem(&tags); )
       {
       switch(tag->ti_Tag)
          {
          case MUIA_Tipb_FileBase:
               data->tips_file_initialized = FALSE;
               _strncpy( data->filebase, (char *)tag->ti_Data, 256);
               DoMethod( obj, MUIM_Tipb_LoadTipcData );
               D(bug(__NAME "TipBase: '%s'\n", data->filebase ));
               break;

          case MUIA_Tipb_ShowOnStartup:
               {
               data->show_on_startup = tag->ti_Data;
               if( _GetDefFileBase( cl, obj, msg ) )
                   DoMethod( obj, MUIM_Tipb_SaveTipcData );
               }
               break;

          }
       }

    return( DoSuperMethodA(cl, obj, msg) );
}

//|
/// OM_GET
static ULONG ASM _Get(REG(a0) struct IClass *cl, REG(a2) Object *obj, REG(a1) Msg msg)
{
struct Data *data = INST_DATA(cl,obj);
ULONG  *store = ((struct opGet *)msg)->opg_Storage;

//    D(bug(__NAME "GET\n"));

    switch(((struct opGet *)msg)->opg_AttrID)
       {
       case MUIA_Tipb_ShowOnStartup:
            D(bug( __NAME "********\n" ));

            if( _GetDefFileBase( cl, obj, msg ) )
                _LoadTipcData (cl, obj, msg);

            D(bug( __NAME "********\n" ));

//            D(bug( __NAME "OM_NEW: finishing: showonstartup: %ld\n", data->show_on_startup ));
            *store = data->show_on_startup;
            break;
       }

    return(DoSuperMethodA(cl, obj, msg));
}
//|

/// Dispatcher
ULONG ASM SAVEDS _Dispatcher(REG(a0) struct IClass *cl, REG(a2) Object *obj, REG(a1) Msg msg)
{

    switch (msg->MethodID)
       {
       case OM_NEW    : return(_New     (cl, obj, (APTR)msg));
       case OM_DISPOSE: return(_Dispose (cl, obj, (APTR)msg));
       case OM_SET    : return(_Set     (cl, obj, (APTR)msg));
       case OM_GET    : return(_Get     (cl, obj, (APTR)msg));

       case MUIM_Tipb_GetDefFileBase : return(_GetDefFileBase (cl, obj, (APTR)msg));
       case MUIM_Tipb_InitTipsFile   : return(_InitTipsFile   (cl, obj, (APTR)msg));
       case MUIM_Tipb_LoadTipcData   : return(_LoadTipcData   (cl, obj, (APTR)msg));
       case MUIM_Tipb_SaveTipcData   : return(_SaveTipcData   (cl, obj, (APTR)msg));
       case MUIM_Tipb_ReadTip        : return(_ReadTip        (cl, obj, (APTR)msg));
       case MUIM_Tipb_Show           : return(_ShowTip        (cl, obj, (APTR)msg));
       }

    return((ULONG)DoSuperMethodA(cl, obj, msg));

}
//|

