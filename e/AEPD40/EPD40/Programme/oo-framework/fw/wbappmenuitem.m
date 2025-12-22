
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
    