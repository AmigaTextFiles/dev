
OPT MODULE

/* This is the main module structure */
EXPORT OBJECT mmd0      /* Also for MMD1 and MMD2 */
    id:LONG                             /* "MMD0" or "MMD1" */
    modlen:LONG                         /* module length (in bytes) */
    song:PTR TO mmd0song                /* pointer to MMD0song */
    psecnum:INT                         /* (MMD2) - used by the player */
    pseq:INT                            /* (MMD2) - used by the player */
    blockarr:PTR TO LONG                /* pointer to pointers of blocks */
    reserved1:LONG
    smplarr:PTR TO LONG                 /* pointer to pointers of samples */
    reserved2:LONG
    expdata:PTR TO mmd0exp              /* pointer to expansion data */
    reserved3:LONG
/* The following values are used by the play routine */
    pstate:INT                          /* the state of the player */
    pblock:INT                          /* current block */
    pline:INT                           /* current line */
    pseqnum:INT                         /* current # of playseqlist */
    actplayline:INT                     /* OBSOLETE!! SET TO 0xFFFF! */
    counter:CHAR                        /* delay between notes */
    extra_songs:CHAR                    /* number of additional songs, see */
ENDOBJECT                               /* expdata.nextmod */

/* These are the structures for future expansions */

EXPORT OBJECT instrext  /* This struct only for data required for playing */
/* NOTE: THIS STRUCTURE MAY GROW IN THE FUTURE, TO GET THE CORRECT SIZE,
   EXAMINE mmd0.expdata.s_ext_entrsz */
/* ALSO NOTE: THIS STRUCTURE MAY BE SHORTER THAN DESCRIBED HERE,
   EXAMINE mmd0.expdata.s_ext_entrsz */
        hold:CHAR
        decay:CHAR
        suppress_midi_off:CHAR        /* 1 = suppress, 0 = don't */
        finetune:CHAR
        default_pitch:CHAR      /* (V5) */
        instr_flags:CHAR        /* (V5) */
        long_midi_preset:INT    /* (V5), overrides the preset in the
                song structure, if this exists, MMD0sample/midipreset
                should not be used. */
        output_device:CHAR      /* (V5.02, V6) */
        reserved:CHAR           /* currently unused */
ENDOBJECT

/* Bits for instr_flags */
EXPORT SET SSFLG_LOOP,SSFLG_EXTPSET,SSFLG_DISABLED

/* Currently defined output_device values */
EXPORT ENUM OUTPUT_STD=0,OUTPUT_MD16,OUTPUT_TOCC

EXPORT OBJECT mmdinstrinfo
        name[40]:ARRAY OF CHAR
        pad0:CHAR
        pad1:CHAR
ENDOBJECT

EXPORT OBJECT mmd0exp
        nextmod:PTR TO mmd0             /* for multi-modules */
        exp_smp:PTR TO instrext         /* pointer to an array of InstrExts */
        s_ext_entries:INT               /* # of InstrExts in the array */
        s_ext_entrsz:INT                /* size of an InstrExt structure */
        annotxt:PTR TO CHAR             /* 0-terminated message string */
        annolen:LONG                    /* length (including the 0-byte) */
/* MED V3.20 data below... */
        iinfo:PTR TO mmdinstrinfo       /* "secondary" InstrExt for info
                                           that does not affect output */
        i_ext_entries:INT               /* # of MMDInstrInfos */
        i_ext_entrsz:INT                /* size of one */
        jumpmask:LONG                   /* OBSOLETE in current OctaMEDs */
        rgbtable:PTR TO INT             /* pointer to 8 UWORD values,
                                           ignored by OctaMED V5 and later */
        channelsplit[4]:ARRAY OF CHAR   /* for OctaMED only (non-zero = NOT splitted) */
        n_info:PTR TO notationinfo      /* OctaMED notation editor info data */
        songname:PTR TO CHAR            /* song name */
        songnamelen:LONG                /* length (including terminating zero) */
        dumps:PTR TO mmddumpdata        /* MIDI message dump data */
        mmdinfo:PTR TO mmdinfo          /* (V6) annotation information */
/* These are still left, they must be 0 at the moment. */
        reserved2[6]:ARRAY OF LONG
ENDOBJECT

/* Info for each instrument (mmd0.song.sample[xx]) */

EXPORT OBJECT mmd0sample
        rep:INT
        replen:INT              /* repeat/repeat length */
        midich:CHAR             /* midi channel for curr. instrument */
        midipreset:CHAR         /* midi preset (1 - 128), 0 = no preset */
        svol:CHAR               /* default volume */
        strans:CHAR             /* sample transpose */
ENDOBJECT

/* The song structure (mmd0.song) */

EXPORT OBJECT mmd0song
        sample[63]:ARRAY OF mmd0sample  /* info for each instrument */
        numblocks:INT                   /* number of blocks in this song */
        songlen:INT                     /* number of playseq entries */
        playseq[256]:ARRAY OF CHAR      /* the playseq list */
        deftempo:INT                    /* default tempo */
        playtransp:CHAR                 /* play transpose */
        flags:CHAR                      /* flags (see below) */
        reserved:CHAR                   /* for future expansion */
        tempo2:CHAR                     /* 2ndary tempo (delay betw. notes) */
        trkvol[16]:ARRAY OF CHAR        /* track volume */
        mastervol:CHAR                  /* master volume */
        numsamples:CHAR                 /* number of instruments */
ENDOBJECT /* length = 788 bytes */

/* The new PlaySeq structure of MMD2 */

EXPORT OBJECT playseq
        name[32]:ARRAY OF CHAR      /* (0)  31 chars + \0 */
        reserved[2]:ARRAY OF LONG   /* (32) for possible extensions */
        length:INT                  /* (40) # of entries */
/* Commented out, not all compilers may like it... */
/*      UWORD   seq[0]; */          /* (42) block numbers.. */
/* Note: seq[] values above 0x7FFF are reserved for future expansion! */
ENDOBJECT

/* This structure is used in MMD2s, instead of the above one. */

EXPORT OBJECT mmd2song
        sample[63]:ARRAY OF mmd0sample
        numblocks:INT
        songlen:INT             /* NOTE: number of sections in MMD2 */
        playseqtable:PTR TO LONG
        sectiontable:INT        /* UWORD section numbers */
        trackvols:PTR TO CHAR   /* UBYTE track volumes */
        numtracks:INT           /* max. number of tracks in the song
                                   (also the number of entries in
                                    'trackvols' table) */
        numpseqs:INT            /* number of PlaySeqs in 'playseqtable' */
        pad0[240]:ARRAY OF CHAR /* reserved for future expansion */
/* Below fields are MMD0/MMD1-compatible (except pad1[]) */
        deftempo:INT
        playtransp:CHAR
        flags:CHAR
        flags2:CHAR
        tempo2:CHAR
        pad1[16]:ARRAY OF CHAR  /* used to be trackvols, in MMD2 reserved */
        mastervol:CHAR
        numsamples:CHAR
ENDOBJECT

 /* FLAGS of the above structure */
EXPORT SET FLAG_FILTERON,    /* hardware low-pass filter */
           FLAG_JUMPINGON,   /* OBSOLETE now, but retained for compatibility */
           FLAG_JUMP8TH,     /* also OBSOLETE */
           FLAG_INSTRSATT,   /* instruments are attached (sng+samples)
                                used only in saved MED-songs */
           FLAG_VOLHEX,      /* volumes are represented as hex */
           FLAG_STSLIDE,     /* no effects on 1st timing pulse (STS) */
           FLAG_8CHANNEL,    /* OctaMED 8 channel song, examine this bit
                                to find out which routine to use */
           FLAG_SLOWHQ       /* HQ slows playing speed (V2-V4 compatibility) */
/* flags2 */
EXPORT CONST FLAG2_BMASK=$1F,FLAG2_BPM=$20

EXPORT OBJECT mmddump
        length:LONG             /* dump data length */
        data:PTR TO CHAR        /* data pointer */
        ext_len:INT             /* bytes remaining in this struct */
/* ext_len >= 20: */
        name[20]:ARRAY OF CHAR  /* message name (null-terminated) */
ENDOBJECT

EXPORT OBJECT mmddumpdata
        numdumps:INT             /* number of message dumps */
        reserved[3]:ARRAY OF INT /* not currently used */
ENDOBJECT   /* Followed by <numdumps> pointers to struct MMDDump */

/* Designed so that several info items can exist (in V6 only one supported),
   you must also check the data type before using it, currently only text is
   supported, but more types can be added in the future.

   Text is stored in plain Amiga ASCII, lines separated by \n characters.
   The last byte is \0.
*/
EXPORT OBJECT mmdinfo
        next:PTR TO mmdinfo     /* next info (currently not supported) */
        reserved:INT            /* 0 */
        type:INT                /* 1 = text, ignore ALL other types */
        length:LONG             /* length of the following data */
/*      UBYTE   data[0]; */     /* Comments may be removed in SAS/C V6 */
ENDOBJECT

/* flags in struct NotationInfo */
EXPORT SET NFLG_FLAT,NFLG_3_4

EXPORT OBJECT notationinfo
        n_of_sharps:CHAR        /* number of #'s (or b's) */
        flags:CHAR              /* flags (see above) */
        trksel[5]:ARRAY OF INT  /* selected track for each preset (-1 = none) */
        trkshow[16]:ARRAY OF CHAR /* which tracks to show (bit 0 = for preset 0,
                                     bit 1 for preset 1 and so on..) */
        trkghost[16]:ARRAY OF CHAR /* ghosted tracks (like trkshow[]) */
        notetr[64]:ARRAY OF CHAR   /* -24 - +24 (if bit #6 is negated, hidden) */
        pad:CHAR        /* perhaps info about future extensions */
ENDOBJECT

/* This structure exists in V6+ blocks with multiple command pages */
EXPORT OBJECT blockcmdpagetable
        num_pages:INT           /* number of command pages */
        reserved:INT            /* zero = compatibility */
/*      UWORD   *page[0];          page pointers follow... */
ENDOBJECT

/* Below structs for MMD1 only! */
EXPORT OBJECT blockinfo
        hlmask:PTR TO LONG      /* highlight data */
        blockname:PTR TO CHAR   /* block name */
        blocknamelen:LONG       /* length of block name (including term. 0) */
        pagetable:PTR TO blockcmdpagetable   /* (V6) command page table */
        reserved[5]:ARRAY OF LONG /* future expansion */
ENDOBJECT

EXPORT OBJECT mmd1block
        numtracks:INT
        lines:INT
        info:PTR TO blockinfo
ENDOBJECT

EXPORT CONST MMD1BLKHDRSZ=8

/* This header exists in the beginning of each sample */
EXPORT OBJECT mmdsample
/* length of one channel in bytes */
        length:LONG
/* see definitions below */
        type:INT
/* 8- or 16-bit data follows */
ENDOBJECT

/* Type definitions: */
EXPORT ENUM SAMPLE=0,IFF5OCT,IFF3OCT,IFF2OCT,IFF4OCT,IFF6OCT,
            IFF7OCT,EXTSAMPLE
EXPORT CONST SYNTHETIC=-1,HYBRID=-2
/* 16-bit (flag), only type SAMPLE supported */
EXPORT CONST S_16=$10
/* stereo (flag) */
EXPORT CONST STEREO=$20
/* only supported while reading... V5 Aura sample */
EXPORT CONST OBSOLETE_MD16=$18

/* Please refer to 'MMD.txt' for a complete description of MMD file format. */
