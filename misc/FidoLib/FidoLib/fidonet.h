/* fidonet.h */

extern ULONG stoa(u_char *,struct NetAddr *);
extern u_char *atos(struct NetAddr *);
extern BPTR MakePkt(u_char *,u_char *,u_char *,u_char *);
extern void MakeMsg(BPTR,u_char *,UWORD),ClosePkt(BPTR);

/* This C include file defines some of the structures used in the FidoNet
   technology. This file was compiled from the FidoNet documentation by
   Sami Klemola. */

struct Packet { /* Type-2 Packet Format */
    UWORD OrigNode;         /* Origination node address   0-65535       */
    UWORD DestNode;         /* Destination node address   1-65535       */
    UWORD Year;             /* Year packet generated      19??-2???     */
    UWORD Month;            /* Month  "        "          0-11 (0=Jan)  */
    UWORD Day;              /* Day    "        "          1-31          */
    UWORD Hour;             /* Hour   "        "          0-23          */
    UWORD Min;              /* Minute "        "          0-59          */
    UWORD Sec;              /* Second "        "          0-59          */
    UWORD Baud;             /* Baud Rate (not in use)     ????          */
    UWORD PktVer;           /* Packet Version             Always 2      */
    UWORD OrigNet;          /* Origination net address    1-65535       */
    UWORD DestNet;          /* Destination net address    1-65535       */
    UBYTE PrdCodL;          /* FTSC Product Code     (lo) 1-255         */
    UBYTE PVMajor;          /* FTSC Product Rev   (major) 1-255         */
    u_char Password[8];     /* Packet password            A-Z,0-9       */
    UWORD QOrgZone;         /* Orig Zone (ZMailQ,QMail)   1-65535       */
    UWORD QDstZone;         /* Dest Zone (ZMailQ,QMail)   1-65535       */
    UWORD Filler;           /* Spare Change               ?             */
    UWORD CapValid;         /* CW Byte-Swapped Valid Copy BitField      */
    UBYTE PrdCodH;          /* FTSC Product Code     (hi) 1-255         */
    UBYTE PVMinor;          /* FTSC Product Rev   (minor) 1-255         */
    UWORD CapWord;          /* Capability Word            BitField      */
    UWORD OrigZone;         /* Origination Zone           1-65535       */
    UWORD DestZone;         /* Destination Zone           1-65535       */
    UWORD OrigPoint;        /* Origination Point          1-65535       */
    UWORD DestPoint;        /* Destination Point          1-65535       */
    ULONG ProdData;         /* Product-specific data      Whatever      */
/*  UWORD PktTerm; */       /* Packet terminator          0000          */
}; /* 0x3a */

struct PkdMsg { /* A packed message */
    UWORD   Type;
    UWORD   OrigNode;
    UWORD   DestNode;
    UWORD   OrigNet;
    UWORD   DestNet;
    UWORD   Attribute;
    UWORD   Cost;
    u_char  DateTime[20];
    void    Data;           /* To [36], From [36], Subject [72], Text */
};

/* Attribute word */

#define MSGF_PRIVATE        1
#define MSGF_CRASH          2
#define MSGF_RECEIVED       4
#define MSGF_SENT           8
#define MSGF_FILEATTACH     16
#define MSGF_INTRANSIT      32
#define MSGF_ORPHAN         64
#define MSGF_KILLSENT       128
#define MSGF_LOCAL          256
#define MSGF_HOLD           512
#define MSGF_FILEREQUEST    2048
#define MSGF_RETURNRECREQ   4096
#define MSGF_ISRETREQ       8192
#define MSGF_AUDITREQ       16384
#define MSGF_FILEUPDREQ     32768

/* This structure holds a fidonet address. */

struct NetAddr {
    UWORD   Zone;
    UWORD   Net;
    UWORD   Node;
    UWORD   Point;
};

