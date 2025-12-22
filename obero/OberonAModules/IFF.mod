(*IFF.library 23.2 Module Translated from C and Modula2 Includes/Modules
  By Morten Bjergstrøm
  EMail: mbjergstroem@hotmail.com
  $VER: 23.2 (3.9.97)
*)

<*STANDARD-*>
MODULE IFF;


IMPORT
  e:=Exec,Kernel,g:=Graphics;

CONST
  IFFName*="iff.library";


  (* Error codes (returned by IFFL_IFFError()) *)

  badTask* = -1;            (* IFFError() called by wrong task *)
  cantOpenFile* = 16;       (* File not found *)
  readError* = 17;          (* Error reading file *)
  noMem* = 18;              (* Not enough memory *)
  notIFF* = 19;             (* File is not an IFF file *)
  writeError* = 20;         (* Error writing file *)
  noILBM* = 24;             (* IFF file is not of type ILBM *)
  noBMHD* = 25;             (* BMHD chunk not found *)
  noBODY* = 26;             (* BODY chunk not found *)
  tooManyPlanes* = 27;      (* Obsolete since V18.6 *)
  unknownCompression* = 28; (* Unknown compression type *)
  noANHD* = 29;             (* ANHD chunk not found *)
  noDLTA* = 30;             (* DLTA chunk not found *)

  (*Generic IFF IDs*)
  idFORM *   = 0464F524DH;  (* MakeID('F','O','R','M') *)
  idPROP *   = 050524F50H;  (* MakeID('P','R','O','P') *)
  idLIST *   = 04C495354H;  (* MakeID('L','I','S','T') *)
  idCAT *    = 043415420H;  (* MakeID('C','A','T',' ') *)

  (*Specific IFF IDs*)
  idANIM*    = 041787377H;
  idANHD*    = 041784844H;
  idILBM*    = 0494C424DH;
  idBMHD*    = 0424D4844H;
  idBODY*    = 0424F4459H;
  idCAMG*    = 043414D47H;
  idCLUT*    = 0434C5554H;
  idCMAP*    = 0434D4150H;
  idCRNG*    = 043524E47H;
  idDLTA*    = 0444C5441H;
  idSHAM*    = 05348414DH;

  id8SVX*    = 038535658H;
  idATAK*    = 04154414BH;
  idNAME*    = 04E414D45H;
  idRLSE*    = 0524C5345H;
  idVHDR*    = 056484452H;


  (* Modes for IFFL_OpenIFF() *)
  modeRead*  = 0;
  modeWrite* = 1;

  (* Modes for IFFL_CompressBlock() and IFFL_DecompressBlock() *)
  comprNone*     = 00000H; (*generic*)
  comprByteRun1* = 00001H; (*ILBM*)
  comprFibDelta* = 00101H; (*8SVX*)


TYPE

  Chunk=RECORD
    ckID*  :LONGINT;
    ckSize*:LONGINT;
(*    ckData*:ARRAY ckSize OF UByte; Hvorfor?*)
  END;
  ChunkPtr=POINTER TO Chunk;


  BitMapHeader*=RECORD
    w*               :e.UWORD;
    h*               :e.UWORD;
    x*               :INTEGER;
    y*               :INTEGER;
    nPlanes*         :e.UBYTE;
    masking*         :e.UBYTE;
    compression*     :e.UBYTE;
    pad1*            :e.UBYTE;
    transparentColor*:e.UWORD;
    xAspect*         :e.UBYTE;
    yAspect*         :e.UBYTE;
    pageWidh*        :INTEGER;
    pageHeight*      :INTEGER;
  END;
  BitMapHeaderPtr*=POINTER TO BitMapHeader;


  AnimHeader*=RECORD
    operation* :e.UBYTE;
    mask*      :e.UBYTE;
    w*         :e.UWORD;
    h*         :e.UWORD;
    x*         :INTEGER;
    y*         :INTEGER;
    absTime*   :e.ULONG;
    relTime*   :e.ULONG;
    interleave*:e.UBYTE;
    pad0*      :e.UBYTE;
    bits*      :e.ULONG;
    pad*       :ARRAY 16 OF e.UBYTE;
  END;
  AnimHeaderPtr*=POINTER TO AnimHeader;



VAR
  base-: e.LibraryPtr;



PROCEDURE OpenIFF* [base,-30]
  (filename[8]:e.APTR)
  :e.APTR;

PROCEDURE CloseIFF* [base,-36]
  (ifffile[9]:e.APTR);

PROCEDURE FindChunk* [base,-42]
  (ifffile  [9]:e.APTR;
   chunkname[0]:LONGINT)
  :e.APTR;

PROCEDURE GetBMHD* [base,-48]
  (ifffile[9]:e.APTR)
  :BitMapHeaderPtr;

PROCEDURE GetColorTab* [base,-54]
  (ifffile[9]  :e.APTR;
  colortable[8]:e.APTR)
  :LONGINT;

PROCEDURE DecodePic* [base,-60]
  (ifffile[9]:e.APTR;
   bitmap [8]:g.BitMapPtr)
  :BOOLEAN;

PROCEDURE SaveBitMap* [base,-66]
  (filename   [8]:e.APTR;
   bitmap     [9]:g.BitMapPtr;
   colortable[10]:e.APTR;
   flags      [0]:LONGINT)
  :BOOLEAN;

PROCEDURE SaveClip* [base,-72]
  (filename [8]:e.APTR;
   bitmap   [9]:g.BitMapPtr;
   coltab  [10]:e.APTR;
   flags    [0]:LONGINT;
   xoff     [1]:LONGINT;
   yoff     [2]:LONGINT;
   width    [3]:LONGINT;
   height   [4]:LONGINT)
  :BOOLEAN;

PROCEDURE IFFError* [base,-78]
  ()
  :LONGINT;

PROCEDURE GetViewModes* [base,-84]
  (ifffile[9]:e.APTR)
  :e.ULONG;

PROCEDURE NewOpenIFF* [base,-90]
  (filename[8]:e.APTR;
   type    [0]:LONGINT)
  :e.APTR;

PROCEDURE ModifyFrame* [base,-96]
  (modForm[9]:e.APTR;
   bm     [8]:g.BitMapPtr)
  :BOOLEAN;




PROCEDURE* [0] CloseLib (VAR rc : LONGINT);

BEGIN (* CloseLib *)
  IF base # NIL THEN e.CloseLibrary (base) END
END CloseLib;


BEGIN

  base := e.OpenLibrary (IFFName, 0);

  IF base # NIL THEN Kernel.SetCleanup (CloseLib) END;

END IFF.
