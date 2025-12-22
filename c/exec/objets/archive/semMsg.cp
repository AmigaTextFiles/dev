// SemMsg: Jeudi 17-Sep-92 par Gilles Dridi

#include <exec/typesF.h>
#include <debogue/ES.h>
#include <exec/semMsg.h>

SemMsg::SemMsg(TEXTE *nomSem, OCTET priSem, MOTN processus):
                     (nomSem, priSem, AP_IGNORE),
                     Processus(processus) {
   Type= TN_SEMAPHORE;  // pas TN_PORTMSG de la classe hérité
   if ( nomSem ) ajoute();
#if DEBOGUE_SEMMSG
   sode->puisJe();
   *sode<<long(this)<<": SemMsg.SemMsg(\""<<Nom<<
          "\", "<<Pri<<", "<<Processus<<")\n";
   sode->vasY();
#endif DEBOGUE_SEMMSG
}

BOOLEEN SemMsg::procure(Message *msgDem) {
#if DEBOGUE_SEMMSG
   sode->puisJe();
   *sode<<long(this)<<": SemMsg.procure("<<long(msgDem)<<")\n";
   sode->vasY();
#endif DEBOGUE_SEMMSG
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
#if DEBOGUE_SEMMSG
   sode->puisJe();
   *sode<<">"<<valB<<"\n";
   sode->vasY();
#endif DEBOGUE_SEMMSG
   return valB;
}

Message *SemMsg::vaque() {
#if DEBOGUE_SEMMSG
   sode->puisJe();
   *sode<<long(this)<<": SemMsg.vaque()\n";
   sode->vasY();
#endif DEBOGUE_SEMMSG
   Message *ptrM= NUL;

   MonoTache();
   if ( ++Processus <= 0 )
      if ( ptrM= (Message *)(ListeDesMsg.premier()) ) {
         ptrM->enleve();
         ptrM->reponds();
      }
   MultiTache();
#if DEBOGUE_SEMMSG
   sode->puisJe();
   *sode<<">"<<long(ptrM)<<"\n";
   sode->vasY();
#endif DEBOGUE_SEMMSG
   renvoie ptrM;
}

NEANT SemMsg::puisJe(Message *msgDem) {
#if DEBOGUE_SEMMSG
   sode->puisJe();
   *sode<<long(this)<<": SemMsg.puisJe("<<long(msgDem)<<") \""<<
          TrouveTache(NULLE)->Nom<<"\"\n";
   sode->vasY();
#endif DEBOGUE_SEMMSG
   if ( !procure(msgDem) ) {
      (msgDem->portReponse())->attends();
      (msgDem->portReponse())->prends();
   }
}

NEANT SemMsg::vasY() {
#if DEBOGUE_SEMMSG
   sode->puisJe();
   *sode<<long(this)<<": SemMsg.vasY() \""<<
          TrouveTache(NULLE)->Nom<<"\"\n";
   sode->vasY();
#endif DEBOGUE_SEMMSG
   vaque();
}

SemMsg::~SemMsg() {
#if DEBOGUE_SEMMSG
   sode->puisJe();
   *sode<<long(this)<<": SemMsg.~SemMsg() SemMsg.Processus "<<
          Processus<<"\n";
   sode->vasY();
#endif DEBOGUE_SEMMSG
   if ( Nom ) enleve();
}
