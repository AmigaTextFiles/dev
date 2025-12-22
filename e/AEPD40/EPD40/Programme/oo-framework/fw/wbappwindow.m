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
                                    'trackv