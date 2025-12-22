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
        songnamelen:LONG                /* length (inclu