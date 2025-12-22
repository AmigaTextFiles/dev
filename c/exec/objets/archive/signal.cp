// Signal: Lundi 17-Août-1992 par Gilles Dridi

#include <exec/typesF.h>
#include <debogue/ES.h>
#include <exec/signal.h>

Signal::Signal(OCTET n): Numero(n) {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": Signal.Signal("<<Numero<<") {}\n";
   sode->vasY();
#endif
}

