// Unité: Samedi 21-Nov-92 par Gilles Dridi

#include <exec/typesF.h>
#include <debogue/ES.h>
#include <exec/unite.h>

Unite::Unite(TEXTE *nomServ, OCTET priServ): (nomServ, priServ),
             PortReqES((TacMin *)moiMeme, "", 0, AP_IGNORE),
             Abonnes(0), ServeurActif() {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": Unite.Unite(\""<<nomServ<<"\", "<<priServ<<") {}\n";
   sode->vasY();
#endif
}

NEANT Unite::sers() {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": Unite.sers() {\n";
   sode->vasY();
#endif
   ReqESmin *reqES;

   PortReqES.signalAssocie().alloue();

   tantQue( VRAI ) {
      PortReqES.attends();
      tantQue( reqES= (ReqESmin *)PortReqES.prends() ) {
#if DEBOGUE
   sode->puisJe();
   *sode<<"Unite.PortReqES: "<<long(&PortReqES)<<
          " recoit ReqESmin: "<<long(reqES)<<"\n";
   sode->vasY();
#endif
// l'unité assure le traitement séquentiel. P/V positionne un drapeau
         ServeurActif.puisJe();
         faisES(reqES);
         ServeurActif.vasY();
         reqES->Message::reponds(); // reponds() pas hérité pour reqESmin
      }
   }
}

Unite *Unite::ouvre(ReqESmin *reqES, LONGN options) {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": Unite.ouvre("<<long(reqES)<<", "<<options<<") {\n";
   sode->vasY();
#endif
   reqES->AdrUnite= moiMeme;
   si ( ++Abonnes == 1 ) {
      PortReqES.signalAssocie().bourre()= AP_SIGNAL;
      Tache::ajoute();
   }
#if DEBOGUE
   sode->puisJe();
   *sode<<"}\n>"<<long(reqES->AdrUnite)<<"\n";
   sode->vasY();
#endif
   renvoie reqES->AdrUnite;
}

NEANT Unite::ferme() {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": Unite.ferme() {\n";
   sode->vasY();
#endif
   si ( --Abonnes == 0 ) {
      PortReqES.signalAssocie().bourre()= AP_IGNORE;
      Tache::enleve();
   }
#if DEBOGUE
   sode->puisJe();
   *sode<<"}\n";
   sode->vasY();
#endif
}

NEANT Unite::faisES(ReqESmin *reqES) {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": Unite.faisES("<<long(reqES)<<") {\n";
   sode->vasY();
#endif
   switch(reqES->Commande) {
      cas CMD_INVALIDE:    reqES->AdrPeripherique->invalide(reqES); break;
      cas CMD_INITIALISATION:
                           reqES->AdrPeripherique->initialise(reqES); break;
      cas CMD_LECTURE:     reqES->AdrPeripherique->lis((ReqES *)reqES); break;
      cas CMD_ECRITURE:    reqES->AdrPeripherique->ecris((ReqES *)reqES); break;
      cas CMD_MISEAJOUR:   reqES->AdrPeripherique->metAjour((ReqES *)reqES); break;
      cas CMD_EFFACEMENT:  reqES->AdrPeripherique->efface(reqES); break;
      cas CMD_ARRET:       reqES->AdrPeripherique->arrete(reqES); break;
      cas CMD_DEMARRAGE:   reqES->AdrPeripherique->demarre(reqES); break;
      cas CMD_VIDANGE:     reqES->AdrPeripherique->vide(reqES); break;
// => mettre ici d'autre commande
      default: {
         reqES->Erreur= ERRES_CMDINCONNUE;
#if DEBOGUE
   sode->puisJe();
   *sode<<" Erreur: commande inconnnue\n";
   sode->vasY();
#endif
      }
   }
#if DEBOGUE
   sode->puisJe();
   *sode<<"}\n";
   sode->vasY();
#endif
}

NEANT Unite::avorteES(ReqESmin *reqES) {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": Unite.avorteES("<<long(reqES)<<") {\n";
   sode->vasY();
#endif
#if DEBOGUE
   sode->puisJe();
   *sode<<"}\n";
   sode->vasY();
#endif
}

