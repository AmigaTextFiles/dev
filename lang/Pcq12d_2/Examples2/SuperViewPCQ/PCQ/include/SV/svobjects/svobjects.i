{  svobjects/svobjects.h            }
{  Version    : 4.1                 }
{  Date       : 15.05.1994          }
{  Written by : Andreas R. Kleinert }
{  PCQ-Konvertierung by Andreas Neumann }

{  SVObject-Version V2.x+ }

TYPE
    SVO_ObjectNode  =   RECORD

        svo_Node    :   Node;       { chaining Node
                                      (svo_Node->ln_Name is NULL
                                      by default !)                     }

        svo_Version :   INTEGER;    { Library-Version of svobject       }

        svo_ObjectType : INTEGER;   { see below (SVO_OBJECTTYPE_...)    }

        svo_FileName :  ARRAY [1..108] OF CHAR; { use 30, as in struct FileInfoBlock    }

        svo_TypeID  :   ARRAY [1..32] OF CHAR;  { e.g. "GIF"                            }
        svo_TypeCode :  INTEGER;    { ... and its appropriate Code,  ,
                                      assigned by superview.library LATER.  }

        svo_SubTypeNum : INTEGER;   { actually available SubTypes
                                      (maximum 16) of the svobject.

                                      0xFFFFFFFF means, that it is an
                                      INDEPENDENT entry, which is an
                                      unimplemented feature yet and
                                      means that the SubTypeID and
                                      SubTypeCode fields should be skipped. }

        svo_SubTypeID : ARRAY [1..16] OF ARRAY [1..16] OF CHAR; { e.g. "87a" or "89a"                   }
        svo_SubTypeCode : ARRAY [1..16] OF INTEGER;     { ... and their appropriate Codes,
                                                          assigned by superview.library LATER.  }

 { version 2 extensions : }

        svo_Flags   :   INTEGER;    { SVO_FLAG_... (see below)          }

 { size may grow with bigger svo_Version, see below }

                        END;
    SVO_ObjectNodePtr = ^SVO_ObjectNode;

CONST
    SVO_VERSION     =   2;      { If this Version, which depends on the
                                  svobject's Library-Version, is set,
                                  it is guaranteed, that at least the
                                  above information is available.       }

    SVO_FILENAME    =   "INTERNAL";     { for internal svobjects only.          }

    SVO_OBJECTTYPE_NONE :   INTEGER = 0;
    SVO_OBJECTTYPE_UNKNOWN = SVO_OBJECTTYPE_NONE;
    SVO_OBJECTTYPE_ILLEGAL : INTEGER = $FFFFFFFF;

    SVO_OBJECTTYPE_INTERNAL : INTEGER = 1; { internal                   }
    SVO_OBJECTTYPE_INDEPENDENT : INTEGER = 2; { UNIMPLEMENTED
                                                Handle them like EXTERNAL,
                                                but ignore some entries.    }
    SVO_OBJECTTYPE_EXTERNAL : INTEGER = 3;  { external svobject         }


  {  The following flags have been introduced with the V2 SVObjects
     (depending on svo_Version : do not check them with V1 SVObjects).
     They should help any applications deciding, whether a specific
     SVObject may fulfil an action or not.
     Note : Some SVObjects may not have the correct flags set and might
            return SVERR_ACTION_NOT_SUPPORTED nevertheless
  }


    SVO_FLAG_READS_TO_BUFFER    =   (1 shl 0); { allows reading to SV_GfxBuffer }
    SVO_FLAG_READS_TO_SCREEN    =   (1 shl 1); { allows displaying on Screen    }

    SVO_FLAG_WRITES_FROM_BUFFER =   (1 shl 2); { writes SV_GfxBuffer to file    }
    SVO_FLAG_WRITES_FROM_SCREEN =   (1 shl 3); { writes Screen to file          }

    SVO_FLAG_SUPPORTS_SVDRIVER  =   (1 shl 4); { uses default SVDriver,
                                                 if available                   }
    SVO_FLAG_NEEDS_SVDRIVER     =   (1 shl 5); { needs valid default SVDriver
                                                 for working. Developers :
                                                 Set SVO_FLAG_SVDRIVER instead  }

    SVO_FLAG_SVDRIVER = (SVO_FLAG_SUPPORTS_SVDRIVER + SVO_FLAG_NEEDS_SVDRIVER);


 {  This structure has to be passed to SVObject's SVO_CheckFileType()
    function, if media other than AKO_MEDIUM_DISK are used for reading.
    This is supported since superview.library V4 and may be ignored by
    SVObjects for compatibility reasons. To prevent older SVO_CheckFileType()
    functions from crashing, superview.library will create a dummy-file and
    pass it's handle also ...
    ("You wanna something to check ? - Here you get it !")

     In the V3-SVObject specification this structure will HAVE TO be
     examined, then. In the current V2-specification this is not the case.
 }

TYPE
    SVOCheckFile    =   RECORD

        svc_Medium  :   INTEGER;    { AKO_MEDIUM_... }

        svc_Future  :   INTEGER;    { as usual       }

                        END;
    SVOCheckFilePtr =   ^SVOCheckFile;

