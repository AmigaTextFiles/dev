// Semaphore: Jeudi 17-Sep-92 par Gilles Dridi
// L'appel à construis/detruis est balancé et local à une fonction.

#include <exec/typesF.h>
#include <debogue/ES.h>
#include <exec/semaphore.h>

Semaphore::Semaphore(TEXTE *nomSem, OCTET priSem, MOTN processus):
                     (nomSem, priSem, AP_IGNORE),
                     Processus(processus) {
   Type= TN_SEMAPHORE;  // pas TN_PORTMSG de la classe hérité
   if ( nomSem ) ajoute();
#if DEBOGUE_SEMAPHORE
   sode->puisJe();
   *sode<<long(this)<<": Semaphore.Semaphore(\""<<Nom<<
          "\", "<<Pri<<", "<<Processus<<")\n";
   sode->vasY();
#endif DEBOGUE_SEMAPHORE
}

BOOLEEN Semaphore::procure(Message *msgDem) {
#if DEBOGUE_SEMAPHORE
   sode->puisJe();
   *sode<<long(this)<<": Semaphore.procure("<<long(msgDem)<<")\n";
   sode->vasY();
#endif DEBOGUE_SEMAPHORE
   BOOLEEN  valB;

   MonoTache(); // interdit le multitâche
   if ( --Processus < 0 ) {
      ListeDesMsg.enQueue(msgDem);
      valB= FAUX;
   }
   else valB= VRAI;
   // L'ordre des demandes est respectée en ne réautorisant le multitâche
   // qu'ici
   MultiTache();
#if DEBOGUE_SEMAPHORE
   sode->puisJe();
   *sode<<">"<<valB<<"\n";
   sode->vasY();
#endif DEBOGUE_SEMAPHORE
   return valB;
}

Message *Semaphore::vaque() {
#if DEBOGUE_SEMAPHORE
   sode->puisJe();
   *sode<<long(this)<<": Semaphore.vaque()\n";
   sode->vasY();
#endif DEBOGUE_SEMAPHORE
   Message *ptrM= NUL;

   MonoTache();
   if ( ++Processus <= 0 )
      if ( ptrM= (Message *)(ListeDesMsg.premier()) ) {
         ptrM->enleve();
         ptrM->reponds();
      }
   MultiTache();
#if DEBOGUE_SEMAPHORE
   sode->puisJe();
   *sode<<">"<<long(ptrM)<<"\n";
   sode->vasY();
#endif DEBOGUE_SEMAPHORE
   renvoie ptrM;
}

NEANT Semaphore::puisJe(Message *msgDem) {
#if DEBOGUE_SEMAPHORE
   sode->puisJe();
   *sode<<long(this)<<": Semaphore.puisJe("<<long(msgDem)<<") \""<<
          TrouveTache(NULLE)->Nom<<"\"\n";
   sode->vasY();
#endif DEBOGUE_SEMAPHORE
   if ( !msgDem ) {
      Message  *ptrM= NUL;
      PortStd  *ptrP= NUL;

      if ( !procure(ptrM= construis Message(ptrP= construis PortStd)) )
      ptrP->attends();
      ptrP->prends();
      detruis ptrM;
      detruis ptrP;
   }
   else {
      if ( !procure(msgDem) )
      (msgDem->portReponse())->attends();
      (msgDem->portReponse())->prends();
   }
}

NEANT Semaphore::vasY() {
#if DEBOGUE_SEMAPHORE
   sode->puisJe();
   *sode<<long(this)<<": Semaphore.vasY() \""<<
          TrouveTache(NULLE)->Nom<<"\"\n";
   sode->vasY();
#endif DEBOGUE_SEMAPHORE
   vaque();
}

Semaphore::~Semaphore() {
#if DEBOGUE_SEMAPHORE
   sode->puisJe();
   *sode<<long(this)<<": Semaphore.~Semaphore() Semaphore.Processus "<<
          Processus<<"\n";
   sode->vasY();
#endif DEBOGUE_SEMAPHORE
   if ( Nom ) enleve();
}
