// Périphérique: Vendredi 20-Nov-92 par Gilles Dridi

#include <exec/typesF.h>
#include <debogue/ES.h>
#include <exec/peripherique.h>
#include <exec/unite.h>
#include <exec/errES.h>

Peripherique::Peripherique(TEXTE *nomPeri, TEXTE *chaineId):
                           (nomPeri, chaineId) {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": Peripherique.Peripherique(\""<<Nom<<
          "\",\n "<<ChaineId<<") {}\n";
   sode->vasY();
#endif
}

Unite *Peripherique::uniteValide(OCTETN numUnite) { renvoie NULLE; }

BOOLEEN Peripherique::estCmdImmediate(MOTN cmd) { renvoie FAUX; }

// OpenDevice() appelle ouvre() avec la plus proche version trouvée.
Peripherique *Peripherique::ouvre(ReqESmin *reqES, OCTETN numUnite,
                                  LONGN options) {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": Peripherique.ouvre("<<
          long(reqES)<<", "<<
          numUnite<<", "<<
          options<<") Peripherique.Version "<<Version<<" {\n";
   sode->vasY();
#endif
Peripherique *ptrPeri= NULLE;
Unite *ptrUnite= uniteValide(numUnite);

   si ( ptrUnite )
      si ( ptrUnite->ouvre(reqES, options) ) // ouvre l'unité
         si ( ptrPeri= (Peripherique *)Bibliotheque::ouvre() )
            reqES->AdrPeripherique= ptrPeri;
         sinon reqES->Erreur= ERRES_OUVERTUREECHOUE;
      sinon reqES->Erreur= ERRES_OUVERTUREECHOUE;
   sinon reqES->Erreur= ERRES_OUVERTUREECHOUE;
#if DEBOGUE
   sode->puisJe();
   *sode<<"}\n>"<<long(ptrPeri)<<"\n";
   sode->vasY();
#endif
   renvoie ptrPeri;
}

// CloseDevice() appelle ferme()
PTRBCPL Peripherique::ferme(ReqESmin *reqES) {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": Peripherique.ferme("<<long(reqES)<<") {\n";
   sode->vasY();
#endif
PTRBCPL	ptr = NULLE;

   reqES->AdrUnite->ferme();
   ptr = Bibliotheque::ferme();
#if DEBOGUE
   sode->puisJe();
   *sode<<"}\n>"<<long(ptr)<<"\n";
   sode->vasY();
#endif
	renvoie ptr;
}

// RemDevice() appelle epure()
PTRBCPL Peripherique::epure() {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": Peripherique.epure() {\n";
   sode->vasY();
#endif
PTRBCPL	ptr = NULLE;

   ptr = Bibliotheque::epure();
#if DEBOGUE
	sode->puisJe();
   *sode<<"}\n>"<<long(ptr)<<"\n";
   sode->vasY();
#endif
	renvoie ptr;
}

// BeginIO() appelle faisES()
NEANT Peripherique::faisES(ReqESmin *reqES) {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": Peripherique.faisES("<<long(reqES)<<") {\n";
   sode->vasY();
#endif
   switch(reqES->Traitement && 1<<BT_IMMEDIAT) {
      cas 1<<BT_IMMEDIAT: {
         si ( estCmdImmediate(reqES->Commande) &&
         // si les cmds sont réentrantes alors enlever la ligne ci-dessous
              !( reqES->AdrUnite->serveurActif() )  ) {
            reqES->AdrUnite->faisES(reqES);
            break;
         } sinon reqES->Traitement&= ~1<<BT_IMMEDIAT;
      // pas pu immédiatement, attention pas de break; pour aller au cas 0
      }
      cas 0: reqES->Message::envoie(&reqES->AdrUnite->PortReqES); break;
   }
#if DEBOGUE
   sode->puisJe();
   *sode<<"}\n";
   sode->vasY();
#endif
}

// AbortIO() appelle AvorteES()
NEANT Peripherique::avorteES(ReqESmin *reqES) {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": Peripherique.avorteES("<<long(reqES)<<") {\n";
   sode->vasY();
#endif
   // si la requête est chainée, elle est avortée puis enlevée
   si ( reqES->Succ != reqES->Pred ) {
      reqES->AdrUnite->avorteES(reqES);
      reqES->enleve();
   }
   reqES->Erreur= ERRES_CMDAVORTE;
#if DEBOGUE
   sode->puisJe();
   *sode<<"}\n";
   sode->vasY();
#endif
}

//----------- virtuelles propres à chaque périphérique --------------

NEANT Peripherique::invalide(ReqESmin *reqES) {                                   
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": Peripherique.invalide("<<long(reqES)<<") {}\n";
   sode->vasY();
#endif
   reqES->Erreur= ERRES_CMDINCONNUE;
}

NEANT Peripherique::initialise(ReqESmin *reqES) {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": Peripherique.initialise("<<long(reqES)<<") {}\n";
   sode->vasY();
#endif
   reqES->Erreur= ERRES_CMDINCONNUE;
}

NEANT Peripherique::lis(ReqES *reqES) {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": Peripherique.lis("<<long(reqES)<<") {}\n";
   sode->vasY();
#endif
   reqES->Erreur= ERRES_CMDINCONNUE;
}

NEANT Peripherique::ecris(ReqES *reqES) {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": Peripherique.ecris("<<long(reqES)<<") {}\n";
   sode->vasY();
#endif
   reqES->Erreur= ERRES_CMDINCONNUE;
}

NEANT Peripherique::metAjour(ReqES *reqES) {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": Peripherique.metAjour("<<long(reqES)<<") {}\n";
   sode->vasY();
#endif
   reqES->Erreur= ERRES_CMDINCONNUE;
}

NEANT Peripherique::efface(ReqESmin *reqES) {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": Peripherique.efface("<<long(reqES)<<") {}\n";
   sode->vasY();
#endif
   reqES->Erreur= ERRES_CMDINCONNUE;
}

NEANT Peripherique::arrete(ReqESmin *reqES) {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": Peripherique.arrete("<<long(reqES)<<") {}\n";
   sode->vasY();
#endif
   reqES->Erreur= ERRES_CMDINCONNUE;
}

NEANT Peripherique::demarre(ReqESmin *reqES) {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": Peripherique.demarre("<<long(reqES)<<") {}\n";
   sode->vasY();
#endif
   reqES->Erreur= ERRES_CMDINCONNUE;
}

NEANT Peripherique::vide(ReqESmin *reqES) {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": Peripherique.vide("<<long(reqES)<<") {}\n";
   sode->vasY();
#endif
   reqES->Erreur= ERRES_CMDINCONNUE;
}

