// ListeIntLog: Lundi 19-Avr-93 par Gilles Dridi

#include <exec/typesF.h>
#include <debogue/ES.h>
#include <exec/listeIntLog.h>

ListeIntLog::ListeIntLog(): (TN_INTERRUPTION), Bourre(0) {
#if DEBOGUE
   sode->puisJe();
   *sode<<long(this)<<": ListeIntLog.ListeIntLog() {}\n";
   sode->vasY();
#endif
}
