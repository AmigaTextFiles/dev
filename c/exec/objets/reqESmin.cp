// ReqESmin: Dimanche 22-Nov-92 par Gilles Dridi

#include <exec/typesF.h>
#include <debogue/ES.h>
#include <exec/reqESmin.h>

ReqESmin::ReqESmin(PortMsg *portRep, TEXTE *nomReq, OCTET pri): 
	(portRep, nomReq, pri),
	AdrPeripherique(0), AdrUnite(0), Commande(0), Traitement(0), Erreur(0) {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": ReqESmin.ReqESmin("<<
		long(portRep)<<", \""<<nomReq<<\", "<<pri<<")\n";
   sode->vasY();
#endif
   Longueur= tailleDe(*moiMeme);
#if DEBOGUE
   sode->puisJe();
   *sode<<"}\n";
   sode->vasY();
#endif
}

NEANT ReqESmin::initialise() {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": ReqES.initialise() {\n";
   sode->vasY();
#endif
   Commande= CMD_INITIALISATION;
   faisES();
#if DEBOGUE
   sode->puisJe();
   *sode<<"}\n";
   sode->vasY();
#endif
}

NEANT ReqESmin::efface() {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": ReqES.efface() {\n";
   sode->vasY();
#endif
   Commande= CMD_EFFACEMENT;
   faisES();
#if DEBOGUE
   sode->puisJe();
   *sode<<"}\n";
   sode->vasY();
#endif
}

NEANT ReqESmin::arrete() {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": ReqES.arrete() {\n";
   sode->vasY();
#endif
   Commande= CMD_ARRET;
   faisES();
#if DEBOGUE
   sode->puisJe();
   *sode<<"}\n";
   sode->vasY();
#endif
}

NEANT ReqESmin::demarre() {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": ReqES.demarre() {\n";
   sode->vasY();
#endif
   Commande= CMD_DEMARRAGE;
   faisES();
#if DEBOGUE
   sode->puisJe();
   *sode<<"}\n";
   sode->vasY();
#endif
}

NEANT ReqESmin::vide() {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": ReqES.vide() {\n";
   sode->vasY();
#endif
   Commande= CMD_VIDANGE;
   faisES();
#if DEBOGUE
   sode->puisJe();
   *sode<<"}\n";
   sode->vasY();
#endif
}

