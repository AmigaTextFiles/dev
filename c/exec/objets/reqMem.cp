// ReqMem: Jeudi 31-Déc-92 par Gilles Dridi

#include <exec/typesF.h>
#include <debogue/ES.h>
#include <exec/reqMem.h>

ReqMem::ReqMem(LONGN taille, LONGN exigences):
               Taille(taille), Exigences(exigences) {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": ReqMem.ReqMem("<<Taille<<", "<<exigences<<") {}\n";
   sode->vasY();
#endif
}

