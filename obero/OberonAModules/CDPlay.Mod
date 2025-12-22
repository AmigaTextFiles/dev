(*
Converted from the C-includes by Morten Bjergstrøm
Latest revision: 7/9/1997
CDPlay.MOD ©1997-99 Morten Bjergstrøm
EMail: mbjergstroem@hotmail.com
*)



<*STANDARD-*>
MODULE [2] CDPlay;

IMPORT
  e:=Exec, Kernel;

CONST
  CDPlayName   *="cdplay.library";
  CDPlayVersion*=37;




  devtypeDirectAcces*     =00H;
  devtypeSequentialAccess*=01H;
  devtypePrinter*         =02H;
  devtypeProcessor*       =03H;
  devtypeWriteOnce*       =04H;
  devtypeCDROM*           =05H;
  devtypeScanner*         =06H;
  devtypeOptical*         =07H;
  devtypeMediumChanger*   =08H;
  devtypeCommunications*  =09H;
  devtypeASCIT81*         =0AH;
  devtypeACSIT82*         =0BH;
  devtypeUnknown*         =-1;

  ansiNone* =00H;
  ansiSCSI1*=01H;
  ansiSCSI2*=02H;

  respSCSI1*=00H;
  respCCS*  =01H;
  respSCSI2*=02H;

  iflagRemovable* =1;
  iflagAENC*      =2;
  iflagRelAddress*=4;
  iflag16WideData*=8;
  iflag32WideData*=16;
  iflagSync*      =32;
  iflagLinked*    =64;
  iflagCMDQue*    =128;
  iflagSoftReset* =256;
  iflagTrmIop*    =512;


  tocSubChanNotAvail*       =00H;
  tocSubChanCurrentPos*     =01H;
  tocSubChanMediaCatalogNum*=02H;
  tocSubChanIsRc*           =03H;
  tocSubChanReserved*       =-1;


  iflagPreEmphasis*   =1;
  iflagCopyProhibited*=2;
  iflagAudioTrack*    =4;
  iflag2Chan*         =8;


  scsiStatNoDisk* =0;
  scsiStatPlaying*=1;
  scsiStatStopped*=2;
  scsiStatPauses* =3;


TYPE
  CDRequestPtr* =POINTER TO CDRequest;
  CDCapacityPtr*=POINTER TO CDCapacity;
  CDInquiryPtr* =POINTER TO CDInquiry;
  CDPTOCPtr*    =POINTER TO CDPTOC;
  CDTimePtr*    =POINTER TO CDTime;
  CDVolumePtr*  =POINTER TO CDVolume;



  CDTrack*=RECORD;
    trPosition*:e.ULONG;
    trFlags*   :e.ULONG;
    trSubChan* :e.UBYTE;
  END;


  CDInquiry*=RECORD
    cdiFlags*         :e.ULONG;
    cdiDeviceType*    :e.UBYTE;
    cdiANSIVersion*   :e.UBYTE;
    cdiResponseFormat*:e.UBYTE;
    cdiISOVersion*    :e.UBYTE;
    cdiECMAVersion*   :e.UBYTE;
    cdiVendorID*      :ARRAY 9 OF e.UBYTE;
    cdiProductID*     :ARRAY 17 OF e.UBYTE;
    cdiRevisionLevel* :ARRAY 5 OF e.UBYTE;
    cdiVendorSpecifik*:ARRAY 21 OF e.UBYTE;
    cdiReserved*      :ARRAY 36 OF e.UBYTE;
  END;


  CDCapacity*=RECORD
    cdcMaxSector* :e.ULONG;
    cdcSectorSize*:e.ULONG;
    cdcCapacity*  :e.ULONG;
  END;


  CDTime*=RECORD
    cdtTrackCurBase*     :e.ULONG;
    cdtTrackRemainBase*  :e.ULONG;
    cdtTrackCompleteBase*:e.ULONG;
    cdtAllCurBase*       :e.ULONG;
    cdtAllRemainBase*    :e.ULONG;
    cdtAllCompleteBase*  :e.ULONG;
  END;


  CDPTOC*=RECORD
    cdptocTOCSize*   :e.ULONG;
    cdptocFirstTrack*:e.UBYTE;
    cdptocLastTrack* :e.UBYTE;
  END;


  CDVolume*=RECORD
    cdvOutput*:ARRAY 4 OF e.UBYTE;
    cdvVolume*:ARRAY 4 OF e.UBYTE;
  END;


  CDRequest*=RECORD
    cdrRequest*       :e.IOStdReqPtr;
    cdrMsgPort*       :e.MsgPortPtr;
    cdrCapacity*      :CDCapacityPtr;
    cdrInquiry*       :CDInquiryPtr;
    cdrTOC*           :CDPTOCPtr;
    cdrTime*          :CDTimePtr;
    cdrVolume*        :CDVolumePtr;
    cdrID*            :ARRAY 20 OF e.UBYTE;
    cdrActive*        :e.UBYTE;
    cdrCurrentTrack*  :e.UBYTE;
    cdrCurrentAddress*:e.ULONG;
    cdrSCSISense*     :e.UBYTE;
    cdrSCSIData*      :e.UBYTE;
    cdrTOCBuf*        :e.UBYTE;
  END;


VAR
  base-:e.LibraryPtr;

PROCEDURE OpenDrive* [base,-30]
  (Device [8]:e.STRPTR;
   Unit   [0]:e.ULONG)
  :CDRequestPtr;

PROCEDURE CloseDrive* [base,-36]
  (CDReq [9]:CDRequestPtr)
  :BOOLEAN;

PROCEDURE Update* [base,-42]
  (CDReq [9]:CDRequestPtr)
  :e.ULONG;

PROCEDURE Inquiry* [base,-48]
  (VAR CDInq [8]:CDInquiryPtr;
   CDReq     [9]:CDRequestPtr)
  :e.ULONG;

PROCEDURE LockDrive* [base,-54]
  (State [0]:e.ULONG;
   CDReq [9]:CDRequestPtr)
  :e.ULONG;

PROCEDURE Open* [base,-60]
  (CDReq [9]:CDRequestPtr)
  :e.ULONG;

PROCEDURE Close* [base,-66]
  (CDReq [9]:CDRequestPtr)
  :e.ULONG;

PROCEDURE Play* [base,-72]
  (Start [0]:e.ULONG;
   CDReq [9]:CDRequestPtr)
  :e.ULONG;

PROCEDURE Pause* [base,-78]
  (State [0]:e.ULONG;
   CDReq [9]:CDRequestPtr)
  :e.ULONG;

PROCEDURE Stop* [base,-84]
  (CDReq [9]:CDRequestPtr)
  :e.ULONG;

PROCEDURE Jump* [base,-90]
  (Offset [0]:LONGINT;
   CDReq  [9]:CDRequestPtr)
  :e.ULONG;

PROCEDURE Next* [base,-96]
  (CDReq [9]:CDRequestPtr)
  :e.ULONG;

PROCEDURE Prev* [base,-102]
  (CDReq [9]:CDRequestPtr)
  :e.ULONG;



PROCEDURE* [0] CloseLib (VAR rc : LONGINT);

BEGIN (* CloseLib *)
  IF base # NIL THEN e.CloseLibrary (base) END
END CloseLib;


BEGIN

  base := e.OpenLibrary (CDPlayName, 0);

  IF base # NIL THEN Kernel.SetCleanup (CloseLib) END;
END CDPlay.
