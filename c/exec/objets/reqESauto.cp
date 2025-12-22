// ReqESauto: Lundi 28-Déc-92 par Gilles Dridi

#include <exec/typesF.h>
#include <debogue/ES.h>
#include <exec/reqESauto.h>

ReqESauto::ReqESauto(TEXTE *nomPeri, OCTETN numUnite, LONGN options):
                     PortDeCom(), (&PortDeCom, nomPeri) {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": ReqESauto.ReqESauto(\""<<
          nomPeri<<"\", "<<
          numUnite<<", "<<
          long(options)<<") {\n";
   sode->vasY();
#endif
   Longueur= tailleDe(*moiMeme);
   ReqES::dialogueAvecLePeripherique(nomPeri, numUnite, options);
#if DEBOGUE
   sode->puisJe();
   *sode<<"}\n";
   sode->vasY();
#endif
}

ReqESauto::~ReqESauto() {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": ReqESauto.~ReqESauto() {\n";
   sode->vasY();
#endif
   ReqES::termineDialogue();
#if DEBOGUE
   sode->puisJe();
   *sode<<"}\n";
   sode->vasY();
#endif
}

