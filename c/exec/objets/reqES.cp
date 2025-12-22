// ReqES: Lundi 28-Déc-92 par Gilles Dridi

#include <exec/typesF.h>
#include <debogue/ES.h>
#include <exec/reqES.h>

ReqES::ReqES(PortMsg *portRep, TEXTE *nomReq= 0, OCTET pri= 0):
	(portRep, nomReq, pri),
	DonneeEchangee(0), LongueurDonnee(0), TamponDonnee(NULLE), Deplacement(0) {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": ReqES.ReqES("<<
		long(portRep)<<", \"<<nomReq<<"\","<<pri<<") {\n";
   sode->vasY();
#endif
   Longueur= tailleDe(*moiMeme);
#if DEBOGUE
   sode->puisJe();
   *sode<<"}\n";
   sode->vasY();
#endif
}

LONGN ReqES::lis(OCTETN *tpDon, LONG lg) {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": ReqES.lis("<<
          long(tpDon)<<", "<<
          long(lg)<<")\n";
   sode->vasY();
#endif
   Commande= CMD_LECTURE;
   LongueurDonnee= lg;
   TamponDonnee= tpDon;
   faisES();
#if DEBOGUE
   sode->puisJe();
   *sode<<">"<<long(DonneeEchangee)<<"\n";
   sode->vasY();
#endif
   renvoie DonneeEchangee;
}

LONGN ReqES::ecris(OCTETN *tpDon, LONG lg) {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": ReqES.ecris("<<
          long(tpDon)<<", "<<
          long(lg)<<")\n";
   sode->vasY();
#endif
   Commande= CMD_ECRITURE;
   LongueurDonnee= lg;
   TamponDonnee= tpDon;
   faisES();
#if DEBOGUE
   sode->puisJe();
   *sode<<">"<<long(DonneeEchangee)<<"\n";
   sode->vasY();
#endif
   renvoie DonneeEchangee;
}

LONGN ReqES::metAjour(OCTETN *tpDon, LONG lg) {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": ReqES.metAjour("<<
          long(tpDon)<<", "<<
          long(lg)<<")\n";
   sode->vasY();
#endif
   Commande= CMD_MISEAJOUR;
   LongueurDonnee= lg;
   TamponDonnee= tpDon;
   faisES();
#if DEBOGUE
   sode->puisJe();
   *sode<<">"<<long(DonneeEchangee)<<"\n";
   sode->vasY();
#endif
   renvoie DonneeEchangee;
}

