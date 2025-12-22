// ChaineMem: Jeudi 31-Déc-92 par Gilles Dridi

#include <exec/typesF.h>
#include <debogue/ES.h>
#include <exec/chaineMem.h>

ChaineMem::ChaineMem(MOTN att, PTRNEANT bas, PTRNEANT haut):
                     ("", TN_MEMOIRE),
                     Attributs(att), EnTete((ChainonMem *)bas),
                     Bas(bas), Haut(haut),
                     OctetLibre(haut-bas) {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": ChaineMem.ChaineMem() {\n";
   sode->vasY();
#endif
   *(LONGN *)bas= NUL;
   *((LONGN *)bas+4)= haut-bas;	// bas+4 incrément pointeur (mauvais code!)
#if DEBOGUE
   sode->puisJe();
   *sode<<"}\n";
   sode->vasY();
#endif
}

