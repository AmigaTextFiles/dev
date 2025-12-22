{
**      $Filename: xpk.h $
**      $Release: 0.9 $
**
**
**
**      (C; Copyright 1991 U. Dominik Mueller, Bryan Ford, Christian Schneider
**          All Rights Reserved
}

{$I "Include:Exec/Nodes.i"}
{$I "Include:Utility/TagItem.i"}
{$I "Include:Utility/Hooks.i"}

const
  XPKNAME = "xpkmaster.library";

VAR
  XpkMasterBase : Address;

{****************************************************************************
 *
 *
 *      The packing/unpacking tags
 *
 }

const
  XPK_TagBase   =  (TAG_USER + 88*256 + 80);

{ Caller must supply ONE of these to tell Xpk#?ackFile where to get data from }
  XPK_InName    =    XPK_TagBase+$01;    { Process an entire named file }
  XPK_InFH      =    XPK_TagBase+$02;    { File handle - start from current position }
                                        { If packing partial file, must also supply InLen }
  XPK_InBuf     =    XPK_TagBase+$03;    { Single unblocked memory buffer }
                                        { Must also supply InLen }
  XPK_InHook    =    XPK_TagBase+$04;    { Call custom Hook to read data }
                                        { If packing, must also supply InLen }
                                        { If unpacking, InLen required only for PPDecrunch }

{ Caller must supply ONE of these to tell Xpk#?ackFile where to send data to }
  XPK_OutName      = XPK_TagBase+$10;    { Write (or overwrite; this data file }
  XPK_OutFH        = XPK_TagBase+$11;    { File handle - write from current position on }
  XPK_OutBuf       = XPK_TagBase+$12;    { Unblocked buffer - must also supply OutBufLen }
  XPK_GetOutBuf    = XPK_TagBase+$13;    { Master allocates OutBuf - ti_Data points to buf ptr }
  XPK_OutHook      = XPK_TagBase+$14;    { Callback Hook to get output buffers }

{ Other tags for Pack/Unpack }
  XPK_InLen        = XPK_TagBase+$20;    { Length of data in input buffer  }
  XPK_OutBufLen    = XPK_TagBase+$21;    { Length of output buffer         }
  XPK_GetOutLen    = XPK_TagBase+$22;    { ti_Data points to long to receive OutLen    }
  XPK_GetOutBufLen = XPK_TagBase+$23;    { ti_Data points to long to receive OutBufLen }
  XPK_Password     = XPK_TagBase+$24;    { Password for de/encoding        }
  XPK_GetError     = XPK_TagBase+$25;    { ti_Data points to buffer for error message  }
  XPK_OutMemType   = XPK_TagBase+$26;    { Memory type for output buffer   }
  XPK_PassThru     = XPK_TagBase+$27;    { Bool: Pass through unrecognized formats on unpack }
  XPK_StepDown     = XPK_TagBase+$28;    { Bool: Step down pack method if necessary    }
  XPK_ChunkHook    = XPK_TagBase+$29;    { Call this Hook between chunks   }
  XPK_PackMethod   = XPK_TagBase+$2a;    { Do a FindMethod before packing  }
  XPK_ChunkSize    = XPK_TagBase+$2b;    { Chunk size to try to pack with  }
  XPK_PackMode     = XPK_TagBase+$2c;    { Packing mode for sublib to use  }
  XPK_NoClobber    = XPK_TagBase+$2d;    { Don't overwrite existing files  }
  XPK_Ignore       = XPK_TagBase+$2e;    { Skip this tag                   }
  XPK_TaskPri      = XPK_TagBase+$2f;    { Change priority for (un;packing }
  XPK_FileName     = XPK_TagBase+$30;    { File name for progress report   }
  XPK_ShortError   = XPK_TagBase+$31;    { Output short error messages     }
  XPK_PackersQuery = XPK_TagBase+$32;    { Query available packers         }
  XPK_PackerQuery  = XPK_TagBase+$33;    { Query properties of a packer    }
  XPK_ModeQuery    = XPK_TagBase+$34;    { Query properties of packmode    }
  XPK_LossyOK      = XPK_TagBase+$35;    { Lossy packing permitted? def.=no}


  XPK_FindMethod   = XPK_PackMethod;   { Compatibility }

  XPK_MARGIN       = 256;     { Safety margin for output buffer      }




{****************************************************************************
 *
 *
 *     The hook function interface
 *
 }

type
{ Message passed to InHook and OutHook as the ParamPacket }
    XpkIOMsg = Record
        xpk_Type : Integer;  { Read/Write/Alloc/Free/Abort        }
        Ptr  : Address;      { The mem area to read from/write to }
        Size,                { The size of the read/write         }
        IOError,             { The IoErr(; that occurred          }
        Reserved,            { Reserved for future use            }
        Private1,            { Hook specific, will be set to 0 by }
        Private2,            { master library before first use    }
        Private3,
        Private4 : Integer;
    end;
    XpkIOMsgPtr = ^XpkIOMsg;

const
{ The values for XpkIoMsg->Type }
  XIO_READ   = 1;
  XIO_WRITE  = 2;
  XIO_FREE   = 3;
  XIO_ABORT  = 4;
  XIO_GETBUF = 5;
  XIO_SEEK   = 6;
  XIO_TOTSIZE= 7;





{****************************************************************************
 *
 *
 *      The progress report interface
 *
 }

type
{ Passed to ChunkHook as the ParamPacket }
      XpkProgress = Record
        xpk_Type : Integer;       { Type of report: start/cont/end/abort       }
        PackerName,               { Brief name of packer being used            }
        PackerLongName,           { Descriptive name of packer being used      }
        Activity,                 { Packing/unpacking message                  }
        FileName : String;        { Name of file being processed, if available }
        CCur,             { Amount of packed data already processed    }
        UCur,             { Amount of unpacked data already processed  }
        ULen,             { Amount of unpacked data in file            }
        CF,               { Compression factor so far                  }
        Done,             { Percentage done already                    }
        Speed : Integer;  { Bytes per second, from beginning of stream }
        Reserved : Array[0..7] of Integer; { For future use            }
      end;
      XpkProgressPtr = ^XpkProgress;

const
  XPKPROG_START  = 1;
  XPKPROG_MID    = 2;
  XPKPROG_END    = 3;





{****************************************************************************
 *
 *
 *       The file info block
 *
 }

type
      XpkFib = Record
        xpk_Type,         { Unpacked, packed, archive?   }
        ULen,             { Uncompressed length          }
        CLen,             { Compressed length            }
        NLen,             { Next chunk len               }
        UCur,             { Uncompressed bytes so far    }
        CCur,             { Compressed bytes so far      }
        ID : Integer;     { 4 letter ID of packer        }
        Packer : Array[0..5] of Byte;   { 4 letter name of packer      }
        SubVersion,       { Required sublib version      }
        MasVersion : WORD;{ Required masterlib version   }
        Flags : Integer;              { Password?                    }
        Head : Array[0..15] of Byte;  { First 16 bytes of orig. file }
        Ratio : Integer;              { Compression ratio            }
        Reserved : Array[0..7] of Integer; { For future use               }
      end;
      XpkFibPtr = ^XpkFib;

const
  XPKTYPE_UNPACKED = 0;        { Not packed                   }
  XPKTYPE_PACKED   = 1;        { Packed file                  }
  XPKTYPE_ARCHIVE  = 2;        { Archive                      }

  XPKFLAGS_PASSWORD = 1;       { Password needed              }
  XPKFLAGS_NOSEEK   = 2;       { Chunks are dependent         }
  XPKFLAGS_NONSTD   = 4;       { Nonstandard file format      }





{****************************************************************************
 *
 *
 *       The error messages
 *
 }

  XPKERR_OK         =  0 ;
  XPKERR_NOFUNC     = -1 ;  { This function not implemented        }
  XPKERR_NOFILES    = -2 ;  { No files allowed for this function   }
  XPKERR_IOERRIN    = -3 ;  { Input error happened, look at Result2}
  XPKERR_IOERROUT   = -4 ;  { Output error happened,look at Result2}
  XPKERR_CHECKSUM   = -5 ;  { Check sum test failed                }
  XPKERR_VERSION    = -6 ;  { Packed file's version newer than lib }
  XPKERR_NOMEM      = -7 ;  { Out of memory                        }
  XPKERR_LIBINUSE   = -8 ;  { For not-reentrant libraries          }
  XPKERR_WRONGFORM  = -9 ;  { Was not packed with this library     }
  XPKERR_SMALLBUF   = -10;  { Output buffer too small              }
  XPKERR_LARGEBUF   = -11;  { Input buffer too large               }
  XPKERR_WRONGMODE  = -12;  { This packing mode not supported      }
  XPKERR_NEEDPASSWD = -13;  { Password needed for decoding         }
  XPKERR_CORRUPTPKD = -14;  { Packed file is corrupt               }
  XPKERR_MISSINGLIB = -15;  { Required library is missing          }
  XPKERR_BADPARAMS  = -16;  { Caller's TagList was screwed up      }
  XPKERR_EXPANSION  = -17;  { Would have caused data expansion     }
  XPKERR_NOMETHOD   = -18;  { Can't find requested method          }
  XPKERR_ABORTED    = -19;  { Operation aborted by user            }
  XPKERR_TRUNCATED  = -20;  { Input file is truncated              }
  XPKERR_WRONGCPU   = -21;  { Better CPU required for this library }
  XPKERR_PACKED     = -22;  { Data are already XPacked             }
  XPKERR_NOTPACKED  = -23;  { Data not packed                      }
  XPKERR_FILEEXISTS = -24;  { File already exists                  }
  XPKERR_OLDMASTLIB = -25;  { Master library too old               }
  XPKERR_OLDSUBLIB  = -26;  { Sub library too old                  }
  XPKERR_NOCRYPT    = -27;  { Cannot encrypt                       }
  XPKERR_NOINFO     = -28;  { Can't get info on that packer        }
  XPKERR_LOSSY      = -29;  { This compression method is lossy     }
  XPKERR_NOHARDWARE = -30;  { Compression hardware required        }
  XPKERR_BADHARDWARE= -31;  { Compression hardware failed          }
  XPKERR_WRONGPW    = -32;  { Password was wrong                   }

  XPKERRMSGSIZE     = 80;   { Maximum size of an error message     }





{****************************************************************************
 *
 *
 *     The XpkQuery(; call
 *
 }

type
     XpkPackerInfo = Record
        Name : Array[0..23] of Byte;        { Brief name of the packer          }
        LongName : Array[0..31] of Byte;    { Full name of the packer           }
        Description : Array[0..79] of Byte; { One line description of packer    }
        Flags,                              { Defined below                     }
        MaxChunk,                           { Max input chunk size for packing  }
        DefChunk : Integer;                 { Default packing chunk size        }
        DefMode  : WORD;                    { Default mode on 0..100 scale      }
     end;
     XpkPackInfoPtr = ^XpkPackerInfo;

const
{ Defines for Flags }
  XPKIF_PK_CHUNK   = $00000001; { Library supplies chunk packing       }
  XPKIF_PK_STREAM  = $00000002; { Library supplies stream packing      }
  XPKIF_PK_ARCHIVE = $00000004; { Library supplies archive packing     }
  XPKIF_UP_CHUNK   = $00000008; { Library supplies chunk unpacking     }
  XPKIF_UP_STREAM  = $00000010; { Library supplies stream unpacking    }
  XPKIF_UP_ARCHIVE = $00000020; { Library supplies archive unpacking   }
  XPKIF_HOOKIO     = $00000080; { Uses full Hook I/O                   }
  XPKIF_CHECKING   = $00000400; { Does its own data checking           }
  XPKIF_PREREADHDR = $00000800; { Unpacker pre-reads the next chunkhdr }
  XPKIF_ENCRYPTION = $00002000; { Sub library supports encryption      }
  XPKIF_NEEDPASSWD = $00004000; { Sub library requires encryption      }
  XPKIF_MODES      = $00008000; { Sub library has different modes      }
  XPKIF_LOSSY      = $00010000; { Sub library does lossy compression   }


type
    XpkMode = Record
        Next : ^XpkMode; { Chain to next descriptor for ModeDesc list}
        Upto,            { Maximum efficiency handled by this mode   }
        Flags,           { Defined below                             }
        PackMemory,      { Extra memory required during packing      }
        UnpackMemory,    { Extra memory during unpacking             }
        PackSpeed,       { Approx packing speed in K per second      }
        UnpackSpeed : Integer; { Approx unpacking speed in K per second    }
        Ratio,           { CF in 0.1% for AmigaVision executable     }
        ChunkSize : WORD;{ Desired chunk size in K (!!) for this mode}
        Description : Array[0..9] of Byte; { 7 character mode description              }
    end;
    XpkModePtr = ^XpkMode;

const
{ Defines for XpkMode.Flags }
  XPKMF_A3000SPEED =$00000001;     { Timings on A3000/25               }
  XPKMF_PK_NOCPU   =$00000002;     { Packing not heavily CPU dependent }
  XPKMF_UP_NOCPU   =$00000004;     { Unpacking... (i.e. hardware modes)}

  MAXPACKERS = 100;

type
    XpkPackerList = Record
        NumPackers : Integer;
        Packer : Array[0..MAXPACKERS-1] of Array[0..5] of Byte;
    end;
    XpkPackerListPtr = ^XpkPackerList;



{****************************************************************************
 *
 *
 *     The XpkOpen() type calls
 *
 }

const
  XPKLEN_ONECHUNK =  $7fffffff;

type
  XpkFH = XpkFib;
  XpkFHPtr = ^XpkFH;
  XFH = XpkFib;
  XFHPtr = ^XFH;


{****************************************************************************
 *
 *
 *      The library vectors
 *
 }

FUNCTION XpkExamine      ( fib : XpkFIBPtr; tags : Address) : Integer;            External;
FUNCTION XpkPack         ( tags : Address) : Integer;                             External;
FUNCTION XpkUnpack       ( tags : Address) : Integer;                             External;
FUNCTION XpkOpen         ( fh : ^xfhPtr; tags : Address) : Integer;               External;
FUNCTION XpkRead         ( fh : xfhPtr; buf : Address; len : Integer) : Integer;  External;
FUNCTION XpkWrite        ( fh : xfhPtr; buf : Address; len : Integer) : Integer;  External;
FUNCTION XpkSeek         ( fh : xfhPtr; dist, mode : Integer) : Integer;          External;
FUNCTION XpkClose        ( fh : xfhPtr) : Integer;                                External;
FUNCTION XpkQuery        ( tags : Address) : Integer;                             External;

