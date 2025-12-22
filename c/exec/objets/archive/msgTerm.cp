// MsgTerm: Dimanche 24-Jan-93 par Gilles Dridi

#include <exec/typesF.h>
#include <debogue/ES.h>
#include <exec/msgTerm.h>

MsgTerm::MsgTerm(Tache *exp, TEXTE *nom, OCTET pri):
                 (NUL, nom, pri), AdrExpediteur(exp) {
#if DEBOGUE_MSGTERM
   sode->puisJe();
   *sode<<long(this)<<": MsgTerm.MsgTerm("<<long(AdrExpediteur)<<
          ", \""<<Nom<<"\", "<<Pri<<") {";
   sode->vasY();
#endif
Longueur= tailleDe(*moiMeme);
#if DEBOGUE_MSGTERM
   sode->puisJe();
   *sode<<"}\n";
   sode->vasY();
#endif
}

MsgTerm::~MsgTerm() {
#if DEBOGUE_MSGTERM
   sode->puisJe();
   *sode<<long(this)<<": MsgTerm.~MsgTerm() {}\n";
   sode->vasY();
#endif
}

