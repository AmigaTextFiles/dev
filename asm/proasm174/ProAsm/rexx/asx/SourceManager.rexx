/******************************************************************************
 *                                                                            *
 * ARexx script:    SourceManager.rexx    for the ASX (ProAsm User Interface) *
 *                                                                            *
 * This script is an example how the source manager of ASX could be used.     *
 *                                                                            *
 * by Daniel Weber                                                            *
 * 30.Jan.94                                                                  *
 *                                                                            *
 *                                                                            *
 * Supported editors, tools:                                                  *
 *  - CygnusEd Professional                                                   *
 *  - TurboText                                                               *
 *  - Edge                                                                    *
 *  - Directory Opus 4.x                                                      *
 *                                                                            *
 ******************************************************************************/


OPTIONS RESULTS
PARSE ARG source,pubscreen                        /* get arguments */


/**
 ** handle the 'internal' variables
 ** '$<variable name>:'
 **/
PARSE VALUE source WITH 1 '$'path':'remainder
SELECT
   WHEN UPPER(path)='ASM' THEN source = 'sources:sources/ass/'remainder
   WHEN UPPER(path)='PRO' THEN source = 'sources:sources/pro/'remainder
   WHEN UPPER(path)='NOG' THEN source = 'sources:sources/nog/'remainder
   WHEN UPPER(path)='SRC' THEN source = 'sources:sources/'remainder
   WHEN UPPER(path)='SIM' THEN source = 'sources:sources/newsim/'remainder
   OTHERWISE ;
END


/**
 ** handle special entries
 **
 ** '*'<source>  : assemble <source>
 ** ';'<comment> : skip
 **
 **/
SELECT
   WHEN LEFT(source,1)='*' THEN DO
      ADDRESS command
      'asm:pro68 '||SUBSTR(source,2)||' -w'
      EXIT(0)
      END
   WHEN LEFT(source,1)=';' THEN EXIT(0)
   OTHERWISE ;
END


/**
 ** source manager opened on screen xy
 **/

/** CygnusEd Professional **/
IF LEFT(pubscreen,14)='CygnusEdScreen' THEN DO
   IF source ~='' THEN DO
     cednumber = RIGHT(pubscreen,1)-1
     IF cednumber = 0 THEN ADDRESS 'rexx_ced'	/* evaluate ced's arexx port */
       ELSE ADDRESS ('rexx_ced'||cednumber)

     Jump To File source		/* no need to load the file a second */
     IF (result = 0) THEN DO		/* time...                           */

       STATUS 16			/* current size of the active file   */
       FileState = result
       STATUS 18			/* #of changes made to the act. file */
       FileState = FileState + result	/* load it only if no file is loaded */
       IF (FileState ~= 0) THEN DO	/* and no changes are made ...       */
         open new			/* else open a new view  :)          */
         IF (result = 0) THEN DO
           okay1 "Couldn't open a new view!"
           EXIT(0)
         END
       END
       OPEN source			/* load the requested file */
     END
   END
END



/** Edge **/
IF pubscreen='EDGE' THEN DO
   ADDRESS 'EDGE'
   getenvvar _ge_errlevel
   errlevel = result
   New
   IF RC == 0 THEN DO
     ADDRESS value result
     open source
     EXIT(0)
   END
   IF RC >= errlevel THEN DO
     fault
     requestnotify '"'result'"'
     EXIT(0)
   END
END



/** TurboText **/
IF pubscreen='TURBOTEXT' THEN DO
   ADDRESS 'TURBOTEXT'
   OpenDoc
   IF RC==0 THEN DO
     ADDRESS value result
     OpenFile source
     IF RC==0 THEN EXIT(0)
   END
   'SetStatusBar Cound not open file '||source
   EXIT(0)
END



/** Directory Opus 4.x **/
IF LEFT(pubscreen,5)='DOPUS' THEN DO
   IF source ~='' THEN DO
     PARSE VALUE pubscreen WITH 1 remainder '.' dopusnumber
     ADDRESS ('DOPUS.'||dopusnumber)
     status 3                           /* get #of active window      */
     win = result
     tp = POS('/',source)		/* strip filename             */
     IF tp = 0 THEN DO
       PARSE VALUE source WITH 1 source ':'
       source = source||':'
     END
     ELSE DO
       DO WHILE tp~=0
         lp = tp
         tp = POS('/',source,tp+1)
       END
       source = LEFT(source,lp)
     END
     ScanDir source win			/* scan the source's directory */
   END
   EXIT(0)
END


/**
 ** Workbench
 **
 ** open a new CygnusEd view, or launch CygnusEd...
 ** Required: ED (the CygnusEd Professional activator, here referenced as ED36)
 **/
IF pubscreen='Workbench' THEN DO
   IF source ~='' THEN DO
       ADDRESS COMMAND 'ED36 '||source
   END
   EXIT(0)
END



EXIT(0)

