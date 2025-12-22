// codeServeur(): Samedi 20-Mars-93 par Gilles Dridi

#include <exec/typesF.h>
#include <debogue/ES.h>
#include <exec/unite.h>

NEANT Unite::codeServeur() {
   ReqESmin *reqES;

   signalAssocie().alloue();

   while( VRAI ) {
      attends();
      while( reqES= (ReqESmin *)prends() ) {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(reqES)<<": reqES.Commande "<<reqES->commande()<<"\n";
   sode->vasY();
#endif
         SemExcl.puisJe();
         faisES(reqES);
         SemExcl.vasY();
         Message::reponds();
      }
   }
}

