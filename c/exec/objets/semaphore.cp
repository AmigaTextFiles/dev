// Semaphore: Mercredi 27-Jan-93 par Gilles Dridi

#include <exec/typesF.h>
#include <debogue/ES.h>
#include <exec/semaphore.h>
#include <exec/tacMin.h>

Semaphore::Semaphore(MOTN processus): (), Processus(processus) {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(moiMeme)<<": Semaphore.Semaphore("<<Processus<<") {}\n";
   sode->vasY();
#endif
}

NEANT Semaphore::puisJe() {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(moiMeme)<<": Semaphore.puisJe() \""<<
          TrouveTache(NULLE)->nom()<<"\" {\n";
   sode->vasY();
#endif
   MonoTache();
   si ( --Processus < 0 ) {
      Patient Pat;
      EnsSig es_sem((Signal)BS_SEMAPHORE);
      File::enfile(&Pat);
      es_sem.attends(); // réactive le multitâche
   }
   MultiTache();
#if DEBOGUE
   sode->puisJe();
   *sode<<"}\n";
   sode->vasY();
#endif
}

NEANT Semaphore::vasY() {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(moiMeme)<<": Semaphore.vasY() \""<<
          TrouveTache(NULLE)->nom()<<"\" {\n";
   sode->vasY();
#endif
   MonoTache();
   si ( ++Processus <= 0 ) {
      Patient *ptrP= (Patient *)File::defile();
      si ( ptrP ) {
         TacMin *Pat= ptrP->adrPatient();
         EnsSig es_sem((Signal)BS_SEMAPHORE);
         es_sem.signale(Pat);
      }
#if DEBOGUE
      sinon {
         sode->puisJe();
         *sode<<" Compteur <= 0 et file vide !\n";
         sode->vasY();
      }
#endif
   }
   MultiTache();
#if DEBOGUE
   sode->puisJe();
   *sode<<"}\n";
   sode->vasY();
#endif
}

/*
Semaphore::~Semaphore() {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(moiMeme)<<": Semaphore.~Semaphore() Semaphore.Processus "<<
          Processus<<" {}\n";
   sode->vasY();
#endif
}
*/
