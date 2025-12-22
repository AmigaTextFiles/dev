// TacAuto: Mercredi 20-Jan-93 par Gilles Dridi

#include <stdio.h>
#include <exec/typesF.h>
#include <debogue/ES.h>
#include <exec/tacAuto.h>

TacAuto::TacAuto(TEXTE *nom= NUL, OCTET pri= 0):
                 ((Pile *)&PileTache, nom, pri),
                 PileTache(moiMeme), SDT(0) {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": TacAuto.TacAuto(\""<<
          Nom<<"\", "<<Pri<<") {\n";
   sode->vasY();
#endif
   Tache::ajoute();
#if DEBOGUE
   sode->puisJe();
   *sode<<"}\n";
   sode->vasY();
#endif
}

NEANT TacAuto::termine() {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": TacAuto.termine() {\n";
   sode->vasY();
#endif
   EnsSig etatSain(0);
   SDT.vasY();
   etatSain.attends();
#if DEBOGUE
   sode->puisJe();
   *sode<<"}\n";
   sode->vasY();
#endif
}
 
NEANT TacAuto::corps() {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": TacAuto.corps() {\n";
   sode->vasY();
#endif
}

TacAuto::~TacAuto() {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": TacAuto.~TacAuto() {\n";
   sode->vasY();
#endif
   SDT.puisJe();
   Tache::enleve();
#if DEBOGUE
   sode->puisJe();
   *sode<<"}\n";
   sode->vasY();
#endif
}
