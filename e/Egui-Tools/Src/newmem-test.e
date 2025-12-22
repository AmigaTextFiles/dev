MODULE  'exec/memory'                           /* Allgemeine Konstanten zum Memoryhandling     */
MODULE  'classes/newmem_dbg'                    /* Das newmem-Modul... (Debug-Variante!)        */

DEF     newmemlist=NIL                          /* Variable (LONG) für den PTR auf die liste    */

PROC main() HANDLE                              /* Das Hauptprogramm (mit Handlerdefinition!)   */
 DEF    mem1=NIL,                               /* PTR auf den 1 Block - wird nicht freigegeben */
        mem2=NIL,                               /* PTR auf den 2 Block - wird korrekt freigeg.  */
        mem3=NIL                                /* PTR auf den 3 Block - wird zuviel freigeg.   */
  newmemlist:=initNewMem()                      /* Hier wird die Liste initialisiert (!!!)      */

   mem1:=newAllocMem(1024,MEMF_ANY,newmemlist)  /* Speicher anfordern...                        */

    mem2:=newAllocVec(1024,MEMF_ANY,newmemlist) /* Speicher anfordern (2)                       */

     mem3:=newAllocMem(1024,MEMF_ANY,newmemlist)/* Speicher anfordern (3)                       */

      WriteF('Now freeing...\n')                /* hier die aktivitäten des Programmes...       */

     newFreeMem(mem3,2048,newmemlist)           /* Speicher wieder freigeben.(Falsche Größe!)   */
->                   ^^^^ Führt normalerweise zu einem Absturtz!
    newFreeVec(mem2,newmemlist)                 /* Speicher wieder freigeben                    */

-> ^ mem1 wird NICHT freigegeben (der Speicher ist nun normalerweise verloren!)

EXCEPT DO                                       /* Exception-Handling (Wird immer durchlaufen!) */
 freeNewMem(newmemlist)                         /* Den ganzen Speicher freigeben!               */
  IF exception                                  /* Wenn eine Exception vorliegt...              */
   SELECT exception                             /* Diese analysieren...                         */

   ENDSELECT                                    /* ende der Exceptionauswertung                 */
  ENDIF                                         /* Ende der Exceptionabfrage                    */
 CleanUp(exception)                             /* Mit der Exception als Returncode aufhören... */
ENDPROC
