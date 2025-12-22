// codeTerminal(): Samedi 20-Mars-93 par Gilles Dridi
// Ce code de terminaison de tâche assure la synchronisation entre
// elle et sa parente. Ensuite, le tâche attend d'être tuée.

#include <exec/typesF.h>
#include <debogue/ES.h>
#include <exec/tacheStd.h>

NEANT codeTerminal() {
   EnsSig etatSain(0);
   ((TacheStd *)TrouveTache(NULLE))->MoniteurDeTerminaison.sigTerm();
   etatSain.attends();
}

