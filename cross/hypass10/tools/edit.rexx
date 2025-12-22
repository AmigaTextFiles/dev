/* savenode.rexx                                                        */
/* by Edd Dumbill                                                       */
/* 2 July 1994                                                          */
/* returns a document from GoldED to Heddley                            */
/* use this macro as a basis for interfacing with other aynschronous    */
/* text editors.                                                        */

/* modified by RST to find out if it works to edit a "node" within a  */
/* HyperSource file by using Heddley. I personally don't use Heddley, */
/* this was just a one hour experiment... Please fix it and send it!  */

OPTIONS RESULTS                             /* enable return codes      */
OPTIONS FAILAT 6                            /* ignore warnings          */
SIGNAL ON SYNTAX                            /* ensure clean exit        */
SIGNAL ON FAILURE                           /* trap Heddley errors      */
ARG file node

address 'HEDDLEY.1'                         /* talk to Heddley          */
LOCK                                        /* lock front panel       */
LOAD file                                   /* reload document text     */
INFO NOINDEX NOHELP
GOTO NAME node
EDIT GUI
LOCK UNLOCK                                 /* unlock front panel       */
EXIT                                        /* quit this macro          */

SYNTAX:                                     /* ARexx error...           */

SAY "Sorry, error line" SIGL ":" ERRORTEXT(RC) /* report it...          */
LOCK UNLOCK                                 /* unlock front panel       */
EXIT                                        /* exit                     */

FAILURE:                                    /* Heddley error...         */
ERRV=address().LASTERROR                    /* get name of error var.   */
SAY "Error:" VALUE(ERRV)                    /* report the error         */
LOCK UNLOCK                                 /* unlock front panel       */
EXIT                                        /* exit                     */

