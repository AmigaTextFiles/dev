/************************************************************************************
** Action: Free()
** Object: ObjectFile
*/

LIBFUNC void OBJ_Free(mreg(__a0) struct ObjectFile *ObjectFile)
{
   if (ObjectFile->Config) Free(ObjectFile->Config);
   Public->OpenCount--;
}

/************************************************************************************
** Action: Get()
** Object: ObjectFile
*/

LIBFUNC struct ObjectFile * OBJ_Get(mreg(__a0) struct ObjectFile *ObjectFile)
{
  Public->OpenCount++;
  return(ObjectFile);
}

/************************************************************************************
** Action: Load(ID_OBJECTFILE, FileName)
** Object: ObjectFile
*/

LIBFUNC struct ObjectFile * OBJ_Load(mreg(__a0) struct File *File)
{
  struct ObjectFile *ObjFile;

  if (ObjFile = Get(ID_OBJECTFILE)) {
     ObjFile->Source = (struct Source *)File->Source;
     if (Init(ObjFile,NULL)) {
        ObjFile->Source = NULL;
        return(ObjFile);
     }
     else ErrCode(ERR_INIT);
  }
  else ErrCode(ERR_GET);

  return(NULL);
}

/************************************************************************************
** Action: Init()
** Object: ObjectFile
*/

LIBFUNC LONG OBJ_Init(mreg(__a0) struct ObjectFile *ObjectFile)
{
  if (ObjectFile) {
     if (ObjectFile->Source IS NULL) {
        DPrintF("!Init:","Failed to define ObjectFile->Source.");
        return(ERR_FAILED);
     }

     if (ObjectFile->Config = Get(ID_CONFIG)) {
        ObjectFile->Config->Source = ObjectFile->Source;

        if (Init(ObjectFile->Config, ObjectFile)) {
           return(ERR_OK);
        }
     }
  }
  else return(ErrCode(ERR_ARGS));

  return(ERR_FAILED);
}

