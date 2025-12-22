## Version $VER: SimpleCat.catalog 3.25 (09.10.2015)
## Languages english deutsch français español
## Codeset english 0
## Codeset deutsch 0
## Codeset français 0
## Codeset español 0
## Chunk deutsch AUTH Guido Mersmann
## Chunk français AUTH Gilles Mathevet
## Chunk español AUTH Victor Gutierrez
## SimpleCatConfig CharsPerLine 200
## TARGET C english "SimpleCat_strings.h" NoCode NoArray NoBlockStatic
;
##define CATCOMP_NUMBERS
;
MSG_APPLICATION_DESCRIPTION (1//)
Catalog Creation Suite
Katalogdatei-Editor
Éditeur de fichiers de localisation
Generador de Catálogos
;
MSG_Requester_Title
SimpleCat Request
SimpleCat-Meldung
Requête SimpleCat
Peitición de SimpleCat
;
MSG_Requester_MCCMissing
MUI custom class '%s' v%lu.%lu is outdated.\n\nPlease visit '%s'\nand make sure you have at least V%ld.%ld installed.
Die benötigte MUI Klasse '%s' v%lu.%lu ist veraltet.\n\nBitte besuchen Sie '%s'\nund stellen Sie sicher, dass Sie mindestens V%ld.%ld installieren.
La classe MUI '%s' v%lu.%lu est obsolète.\n\nVisitez '%s'\net installez la V%ld.%ld ou supérieure.
Clase MUI '%s' v%lu.%lu obsoleta.\n\nVisite '%s' y compruebe que tiene al menos instalada V%ld.%ld.
;
MSG_ERROR_UNABLETOSETUPMUICLASS
Unable to set-up MUI class!
Konnte MUI Klasse nicht erzeuge!
Impossible d'initialiser la classe MUI !
¡Imposible establecer clase MUI!
;
MSG_Requester_Ok
*\033b_OK\033n
*\033b_Ok\033n
*\033b_Fermer\033n
*\033bAceptar\033n
;
MSG_Requester_YESNO
*\033b_Yes\033n|_No
*\033b_Ja\033n|_Nein
*\033b_Oui\033n|_Non
*\03bbSí\033n|_No
;
MSG_Requester_ALLUSELESSABORT
*\033bA_ll\033n|_Useless|_Abort
*\033bA_lle\033n|_Unsinnige|Abbrechen
*\033b_Tous\033n|_Partiel|_Annuler
*\033bTodo\033n|Inválidas|_Abortar
;
MSG_Requester_CONTINUEABORT
*\033b_Continue\033n|_Abort
*\033b_Fortsetzen\033n|_Abbrechen
*\033b_Continuer\033n|_Annuler
*\033b_Continuar\033n|_Abortar
;
MSG_Requester_CONTINUEBACKUPMODEABORT
*\033b_Continue\033n|_Backup Mode|_Abort
*\033b_Fortsetzen\033n|_Sicherungsmodus|_Abbrechen
*\033b_Continuer\033n|Mode _Sauvegarde|_Annuler
*\033b_Continuar\033n|Modo _Backup|_Abortar
;
MSG_Requester_Quit
Do you really want to quit SimpleCat?
Wollen Sie SimpleCat wirklich beenden?
Quitter vraiment SimpleCat ?
¿Desea salir de SimpleCat?
;
MSG_REQUESTER_NEW
Do you really want to free current\nproject and create a a new one?
Wollen Sie wirklich das aktuelle\nProjekt löschen und ein neues beginnen?
Do you really want to free current\nproject and create a a new one?
Do you really want to free current\nproject and create a a new one?
;
MSG_Requester_Strip
Strip trailing spaces or tabs from strings?\n\n'\033bAll\033n' will remove all trailing characters from any string.\n\n'\033bUseless\033n' will only remove those chars that aren't\nalso defined in \
default (first) language.
Abschließende Tabulatoren oder Leerzeichen aus den Übersetzungen entfernen?\n\n'\033bAlle\033n' entfernt sämtliche abschließenden Zeichen aus allen Übersetzungen.\n\n'\033bUnsinnige\033n' entfernt nur \
die Zeichen,die nicht auch in der Hauptsprache\n(erste Sprache) definiert sind.
Suppression des espaces et tabulations en fin de chaînes :\n\n'\033bTous\033n' les supprime de toutes les chaînes.\n\n'\033bPartiel\033n' les supprime uniquement s'ils ne sont pas définis dans la \
langue par défaut (la première).
¿Eliminar espacios o tabuladores de cadenas?\n\n'\033bTodo\033n' eliminará todos los caracteres de cola del texto.\n\n'\033bSin uso\033n' sólo eliminará los caracteres que no estén\ndefinidos enel \
lenguaje por defecto.
;
MSG_Requester_UnableToOpenMainWindow
Unable to open main window.
Hauptfenster konnte nicht geöffnet werden.
Impossible d'ouvrir la fenêtre principale.
Imposible abrir ventana.
;
MSG_Requester_NonCFileWarning
\033b\033cWarning!\033n\n\nThe source file is no .c or .h file.\n\nCode replacement only works for C/C++, because all strings will be replaced by "function( MSG_label),\nso the source code may be \
rendered useless.
\033b\033cWarnung!\033n\n\nDer Quellkode ist keine .c oder .h Datei.\n\nDie Übernahme in den Quellkode funktioniert nur mit C/C++ Dateien,\nweil alle Texte durch die Funktion "function( MSG_label)" \
ersetzt werden.\nDer Programmkode kann unbrauchbar werden.
\033b\033cAttention !\033n\n\nLe fichier source n'est pas un fichier .c ou .h\n\nLe remplacement du code fonctionne uniquement pour le C/C++ car toutes les chaînes seront remplacées\npar la fonction \
"function( MSG_label)".\nIl y a donc le risque de rendre le code source inutilisable.
\033b\033c¡Aviso!\033n\n\nEl fuente no es fichero .c ni .h\n\nCódigo de reemplazo sólo funciona con C/C++, porque las cadenas se reemplazan por "funcion( MSG_label),\ny el código fuente puede \
sergenerado inútilmente".
;
MSG_Requester_NoBackupWarning
\033b\033cWarning!\033n\n\nThe source file will be modified and overwritten!\n\nDo this on your own risk! Consider making a backup or use\nthe backup mode.
\033b\033cWarnung!\033n\n\nDer Quellkode wird modifiziert und überschrieben!\n\nSetzen Sie die Bearbeitung auf eigene Gefahr fort oder\naktivieren sie den "Sicherungsmodus".
\033b\033cAttention !\033n\n\nLe fichier source sera modifié et écrasé !\n\nPensez à réaliser une sauvegarde ou utilisez\nle mode sauvegarde.
\033b\033c¡Aviso!\033n\n\n¡El fichero fuente será sobreescrito y modificado!\n\n¡Tenga cuidado! Contemple la opción de hacer copia o emplear\nel modo backup.
;
; Error strings sorted by warning level
;
MSG_Error_LineNew
Line %4ld: %s - %s\n
Zeile %4ld: %s - %s\n
Ligne %4ld : %s - %s\n
Línea %4ld: %s -%s\n
;
MSG_Error_Line
%s: Line %4ld - File '%s': %s\n
%s: Zeile %4ld - Datei '%s': %s\n
%s : Ligne %4ld - Fichier '%s' : %s\n
%s: Línea %4ld - Fichero '%s' : %s\n
;
MSG_ERROR_TYPE_INFO
Info\x20\x20\x20\x20
Info\x20\x20\x20\x20
Info\x20\x20\x20\x20
Info\x20\x20\x20\x20
;
MSG_INFO_SimpleCat
SimpleCat V%ld.%ld by Guido Mersmann
SimpleCat V%ld.%ld by Guido Mersmann
SimpleCat V%ld.%ld par Guido Mersmann
SimpleCat V%ld.%ld por Guido Mersmann
;
MSG_INFO_ImportEnglishAsDefault
No language specified for the import of file '%s'! Using 'English' as default.
Der zu importierenden Datei '%s' wurde keine Sprache zugeordnet! 'English' wird benutzt.
Pas de langue spécifiée lors de l'importation du fichier '%s' ! 'English' utilisé par défaut.
No ha indicado lenguaje para el fichero '%s' Se empleará "Inglés" por defecto.
;
MSG_INFO_ImportLanguageNotFound
Language '%s' does not exist. New language has been created.
Sprache '%s' existiert nicht. Neue Sprache wurde erzeugt.
La  langue '%s' n'existe pas. Une nouvelle langue a été créée.
Lenguaje '%s' inexistente. Se creará un lenguaje nuevo.
;
MSG_INFO_ImportingCT
Importing CT file '%s'...
Importiere CT-Datei '%s' ...
Chargement du fichier CT '%s'...
Importando fichero CT '%s'...
;
MSG_INFO_ExportingCT
Exporting CT file as '%s' as language '%s'...
Exportiere CT-Datei unter '%s' in der Sprache '%s' ...
Création du fichier CT '%s' pour la langue '%s'...
Exportando fichero CT '%s' como lenguaje '%s'...
;
MSG_INFO_ImportingCD
Loading CD file '%s'...
Lese CD-Datei '%s' ...
Chargement du fichier CD '%s'...
Cargando fichero CD '%s'...
;
MSG_INFO_ExportingCD
Saving CD file as '%s' as language '%s'...
Speichere CD-Datei unter '%s' in der Sprache '%s' ...
Création du fichier CD '%s' pour la langue '%s'...
Guardando fichero CD '%s' como lenguaje '%s'...
;
MSG_INFO_ImportingCS
Loading CS file '%s'...
Lese CS-Datei '%s' ...
Chargement du fichier CS '%s'...
Cargando fichero CS '%s'...
;
MSG_INFO_ExportingCS
Saving CS file as '%s'...
Speichere CS-Datei unter '%s' ...
Création du fichier CS '%s'...
Guardando fichero CS como '%s'...
;
MSG_INFO_ImportingCatalog
Importing catalog file '%s'...
Importiere Katalog '%s' ...
Chargement du fichier catalogue '%s'...
Importando catálogo '%s'...
;
MSG_INFO_ExportingCatalog
Exporting catalog file '%s' for language '%s'...
Exportiere Katalog '%s' in der Sprache '%s' ...
Création du fichier catalogue '%s' pour la langue '%s'...
Exportando catálogo '%s' para lenguaje '%s'...
;
MSG_INFO_ImportingMTL
Loading MTL file '%s'...
Lese MTL-Datei '%s' ...
Chargement du fichier MTL '%s'...
Cargando fichero MTL '%s'...
;
MSG_INFO_ExportingMTL
Saving MTL file as '%s'...
Speichere MTL-Datei unter '%s' ...
Création du fichier MTL '%s'...
Guardando fichero MTL como '%s'...
;
MSG_INFO_ExportingC
Saving C source file '%s' for language '%s'...
Speichere C-Quellcode-Datei '%s' für die Sprache '%s' ...
Création du fichier source C '%s' pour la langue '%s'...
Guardando fuente de C '%s' para lenguaje '%s'...
;
MSG_INFO_ExportingASM
Saving ASM source file as '%s' for language '%s'...
Speichere ASM Quellcode-Datei '%s' für die Sprache '%s' ...
Création du fichier source C '%s' pour la langue '%s'...
Guardando fuente ASM '%s' para lenguaje '%s'...
;
MSG_INFO_ExportingE
Saving E source file '%s' for language '%s'...
Speichere E-Quellcode-Datei '%s' für die Sprache '%s' ...
Création du fichier source E '%s' pour la langue '%s'...
Guardando fuente de E '%s' para lenguaje '%s'...
;
MSG_INFO_ExportingLocale
Saving Locale source file as '%s' mode: %ld...
Speichere Locale Quellcode-Datei '%s' Modus: %ld ...
Création du fichier source local '%s' mode : %ld...
Guardando fuente Locale para '%s' modo:%ld...
;
MSG_INFO_Done
Processing completed.
Vorgang abgeschlossen.
Processus terminé.
Procesamiento completado.
;
MSG_INFO_CheckingDatabase
Checking database...
Prüfe Datenbank ...
Vérification de la base de données...
Comprobando base de datos...
;
MSG_INFO_CheckingDatabaseFailed
Database check failed!
Datenbankprüfung fehlgeschlagen!
Échec lors de la vérification de la base de données !
¡Error en la comprobación!
;
MSG_INFO_CheckingDatabaseSucceeded
Database check successful, no errors found.
Datenbankprüfung erfolgreich, es wurden keine Fehler festgestellt.
Vérification de la base de données terminée : pas d'erreur trouvée.
Comprobación correcta, no hubo errores.
;
MSG_INFO_MissingTranslationNoMore
No further missing translations found.
Es wurden keine weiteren fehlenden Übersetzungen festgestellt.
Pas d'autre traduction manquante trouvée.
No se encuentra más texto por traducir.
;
MSG_INFO_MissingTranslationNo
No missing translations found.
Es wurden keine fehlenden Übersetzungen festgestellt.
Pas de traduction manquante trouvée.
No queda texto sin traducir.
;
MSG_ERROR_TYPE_WARNING
Warning\x20
Warnung\x20
Alerte\x20
Advertencia\x20
;
MSG_ERROR_TargetTypeInvalid
Type of target is unknown.
Typ des Ziels in unbekannt.
Le type de la cible est inconnu.
Tipo de objetivo desconocido.
;
MSG_Error_InvalidHexArgument
Label '%s', language: '%s' - Hex argument is invalid!
Bezeichner '%s', Sprache: '%s' - Hexadezimal-Argument ist ungültig!
Étiquette '%s', langue : '%s' - Argument Hexadécimal non valide !
Etiqueta '%s', lenguaje: '%s' - ¡Argumento Hex no válido!
;
MSG_Error_InvalidOctArgument
Label '%s', language: '%s' - Oct argument is invalid!
Bezeichner '%s', Sprache: '%s' - Oktal-Argument ist ungültig!
Étiquette '%s', langue : '%s' - Argument Octal non valide !
Etiqueta '%s', lenguaje '%s' - ¡Argumento Oct no válido!
;
MSG_Error_StringToShort
Label '%s', language: '%s' - Translation is too short!
Bezeichner '%s', Sprache: '%s' - Die Übersetzung ist zu kurz!
Étiquette '%s', langue : '%s' - Traduction trop courte !
Etiqueta '%s', lenguaje: '%s' - ¡Traducción muy corta!
;
MSG_Error_StringToLong
Label '%s', language: '%s' - Translation is too long!
Bezeichner '%s', Sprache: '%s' - Die Übersetzung ist zu lang!
Étiquette '%s', langue : '%s' - Traduction trop longue !
Etiqueta '%s', lenguaje: '%s' - ¡Traducción demasiado larga!
;
MSG_Error_UnknownBackSlash
Label '%s', language: '%s': Unknown backslash identifier '%s'!
Bezeichner '%s', Sprache: '%s' - Backslash-Code '%s' ist unbekannt!
Étiquette '%s', langue : '%s' - le code '\\%s' est inconnu !
Etiqueta '%s', lenguaje: '%s': - ¡Barra invertida '%s' desconocida!
;
MSG_Error_TrailingEllipsisOrg
Label '%s', language: '%s' - Original string has trailing ellipsis (...)!
Bezeichner '%s', Sprache: '%s' - Originaltext hat eine abschließende Punktierung (...)!
Étiquette '%s', langue : '%s' - La chaîne originale se termine par des points de suspension (...) !
Etiqueta '%s'. lenguaje: '%s' -¡El texto original presenta puntos (...)!
;
MSG_Error_TrailingSpacesOrg
Label '%s', language: '%s' - Original string has trailing spaces!
Bezeichner '%s', Sprache: '%s' - Originaltext hat Leerzeichen am Ende!
Étiquette '%s', langue : '%s' - La chaîne originale se termine par des espaces !
Etiqueta '%s', lenguaje '%s' - ¡El texto original presenta espacios al final!
;
MSG_Error_TrailingEllipsis
Label '%s', language: '%s' - String has trailing ellipsis (...)!
Bezeichner '%s', Sprache: '%s' - Text hat eine abschließende Punktierung (...)!
Étiquette '%s', langue : '%s' - La chaîne se termine par des points de suspension (...) !
Etiqueta '%s', lenguaje: '%s' -¡Texto con puntos (...)!
;
MSG_Error_TrailingSpaces
Label '%s', language: '%s' - String has trailing space(s) (use \\x20)!
Bezeichner '%s', Sprache: '%s' - Leerzeichen am Ende des Textes (Benutzen Sie \\x20)!
Étiquette '%s', langue : '%s' - La chaîne se termine par des espaces (utilisez \\x20) !
Etiqueta '%s', lenguaje: '%s' -¡Texto con espacio(s) (utilice \\x20)!
;
MSG_Error_TrailingTabsOrg
Label '%s', language: '%s' - Original string has trailing tab(s)!
Bezeichner '%s' Sprache: '%s' - Originaltext hat Tabulator(en) am Ende!
Étiquette '%s', langue : '%s' - La chaîne originale se termine par des tabulations !
Etiqueta '%s', lenguaje: '%s' -¡Texto original con tabulación(es) al final!
;
MSG_Error_TrailingTabs
Label '%s', language: '%s' - String has trailing tab(s) (use \\x09)!
Bezeichner '%s', Sprache: '%s' - Tabulator(en) am Ende des Textes (Benutzen Sie \\x09)!
Étiquette '%s', langue: '%s' - La chaîne se termine par des tabulations (utilisez \\x09) !
Etiqueta '%s', lenguaje: '%s' -!Texto con tabulación(es) al final (utilice \\x09)!
;
MSG_Error_ImportVersionIDBeforeLanguages
Import of version ID failed because ##LANGUAGES is missing (or not at top).
Versions-ID konnte nicht importiert werden, weil ##LANGUAGES fehlt (oder nicht am Anfang steht).
L'identifiant (ID) de version ne peut être importé car ##LANGUAGES est manquant (ou absent au début du fichier).
Error al importar ID de versión al faltar ##LANGUAGES (o no estar al comienzo).
;
MSG_Error_ImportVersionIDMissingLanguage
Import of version ID failed, language '%s' is unknown!
Versions-ID konnte nicht importiert werden, die Sprache '%s' ist unbekannt!
L'identifiant (ID) de version ne peut être importé car la langue '%s' est inconnue !
¡Error al importar ID de versión, lenguaje '%s' desconocido!
;
MSG_Error_ImportChunkBeforeLanguages
Import of ##chunk failed because ##LANGUAGES is missing (or not at top).
Das Kommando ##chunk konnte nicht bearbeitet werden, weil ##LANGUAGES fehlt (oder nicht am Anfang steht).
La commande ##CHUNK ne peut être utilisée car ##LANGUAGES est manquant (ou absent au début du fichier).
Error al importar ##chunk al faltar ##LANGUAGES (o no estar al comienzo) .
;
MSG_Error_ImportChunkMissingLanguage
Import of ##chunk failed, language '%s' is unknown!
Das Kommando ##chunk konnte nicht bearbeitet werden, die Sprache '%s' ist unbekannt!
La commande ##CHUNK ne peut être utilisée car la langue '%s' est inconnue !
¡Error al importar ##chunk, lenguaje '%s' desconocido!
;
MSG_Error_ImportCodeSetBeforeLanguages
Import of ##codeset failed because ##LANGUAGES is missing (or not at top).
Das Kommando ##codeset konnte nicht bearbeitet werden, weil ##LANGUAGES fehlt (oder nicht am Anfang steht).
La commande ##CODESET ne peut être utilisé car ##LANGUAGES est manquant (ou absent au début du fichier).
Error al importar ##codeset al faltar ##LANGUAGES (o no estar al comienzo).
;
MSG_Error_ImportCodeSetMissingLanguage
Import of ##codeset failed, language '%s' is unknown!
Das Kommando ##codeset konnte nicht bearbeitet werden, die Sprache '%s' ist unbekannt!
La commande ##CODESET ne peut être utilisée car la langue '%s' est inconnue !
¡Error al importar ##codeset, lenguaje '%s' desconocido!
;
MSG_Error_ImportNoCatalogScriptInMemory
No CS File in memory for import of '%s', creating empty file.
Keine CS-Datei im Speicher, um '%s' zu importieren, erzeuge leere Datei.
Pas de fichier CS en mémoire lors du chargement de '%s' : création d'un fichier vide.
No hay fichero CS en memoria para importar '%s', creando fichero vacío.
;
MSG_Error_ImportFileCorrupted
The specified file is corrupted. 0x0d characters got stripped during import. Avoid transmitting catalog data files in uncompressed form.
Datei ist beschädigt. 0x0d Zeichen wurden beim Importieren entfernt. Das Versenden von Katalogdateien in unkomprimierter Form sollte vermieden werden.
Le fichier est corrompu. Les caractères 0x0d ont été supprimés pendant l'importation. Évitez d'utiliser des fichiers de données de catalogue non compressés.
Fichero corrupto. 0x0d caracteres eliminados al importar. Evite el envío de ficheros de catálogo sin comprimir.
;
MSG_ERROR_TYPE_OBSOLETE
Obsolete
Veraltet
Obsolète
Obsoleto
;
MSG_Error_ImportCommandObsolete
Command is obsolete and will be ignored!
Kommando ist veraltet und wird ignoriert!
La commande est obsolète et sera ignorée !
¡Comando obsoleto, será ignorado!
;
MSG_Error_ImportSimpleCatConfigArray
The SimpleCat configuration option "ARRAYNAME" is obsolete and should not be used anymore. Use the #ARRAY command instead.
Die SimpleCat-Konfigurations-Option "ARRAYNAME" ist veraltet und sollte nicht mehr benutzt werden. Benutzen Sie ersatzweise das Kommando #ARRAY.
L'option de configuration de SimpleCat "ARRAYNAME" est obsolète et ne doit plus être utilisée. Utilisez la commande #ARRAY à la place.
Opción de configuración "ARRAYNAME" de SimpleCat obsoleta, se recomienda no utilizarla. Utilice el comando #ARRAY en su lugar.
;
MSG_Error_ImportSimpleCatConfigBlock
The SimpleCat configuration option "BLOCKNAME" is obsolete and should not be used anymore. Use #BLOCK command instead.
Die SimpleCat-Konfigurations-Option "BLOCKNAME" ist veraltet und sollte nicht mehr benutzt werden. Benutzen Sie ersatzweise das Kommando #BLOCK.
L'option de configuration de SimpleCat "BLOCKNAME" est obsolète et ne doit plus être utilisée. Utilisez la commande #BLOCK à la place.
Opción de configuración "BLOCKNAME" de SimpleCat obsoleta, se recomienda no utilizarla. Utilice el comando #BLOCK en su lugar.
;
MSG_Error_ImportCFile
The SimpleCat command "#CFILE" is obsolete and should not be used anymore. Use #TARGET command instead.
Die SimpleCat-Kommando "#CFILE" ist veraltet und sollte nicht mehr benutzt werden. Benutzen Sie ersatzweise das Kommando #TARGET.
La commande SimpleCat "#CFILE" est obsolète et ne doit plus être utilisée. Utilisez la commande #TARGET à la place.
Comando "#CFILE" de SimpleCat obsoleto, se recomienda no utilizarlo. Utilice el comando #TARGET en su lugar.
;
MSG_Error_ImportASMFile
The SimpleCat command "#ASMFILE" is obsolete and should not be used anymore. Use #TARGET command instead.
Die SimpleCat-Kommando "#ASMFILE" ist veraltet und sollte nicht mehr benutzt werden. Benutzen Sie ersatzweise das Kommando #TARGET.
La commande SimpleCat "#ASMFILE" est obsolète et ne doit plus être utilisée. Utilisez la commande #TARGET à la place.
Comando "#ASMFILE" de SimpleCat obsoleto, se recomienda no utilizar. Utilice #TARGET en su lugar.
;
MSG_Error_ImportCatalogDir
The SimpleCat commands "#CATALOGDIR" and "#CATALOGSDIR" are obsolete and should not be used anymore. Use #TARGET command instead.
Die SimpleCat-Kommandos "#CATALOGDIR" und "#CATALOGSDIR" sind veraltet und sollten nicht mehr benutzt werden. Benutzen Sie ersatzweise das Kommando #TARGET.
Les commandes SimpleCat "#CATALOGDIR" et "CATALOGSDIR" sont obsolètes et ne doivent plus être utilisées. Utilisez la commande #TARGET à la place.
Comandos "#CATALOGDIR" y "#CATALOGSDIR" de SimpleCar obsoletos, se recomienda no utilizar. Utilice el comando #TARGET en su lugar.
;
MSG_ERROR_TYPE_FATAL
Fatal\x20\x20\x20
Fatal\x20\x20\x20
Fatal\x20\x20\x20
Fatal\x20\x20\x20
;
MSG_Error_UnableToOpenLibrary
Unable to open '%s' version %ld (or higher)!
'%s' Version %ld (oder höher) konnte nicht geöffnet werden!
Impossible d'ouvrir '%s' version %ld (ou supérieure) !
¡Imposible abrir '%s' versión %ld (o superior)!
;
MSG_Error_UnableToOpen
Unable to open '%s'!
'%s' konnte nicht geöffnet werden!
Impossible d'ouvrir '%s' !
¡Imposible abrir '%s'!
;
MSG_Error_PrefsNotValid
Preferences not valid or too old.
Voreinstellungen sind nicht gültig oder veraltet.
Préférences non valides ou trop anciennes.
Preferencias no válidas u obsoletas.
;
MSG_Error_NotEnoughMemory
Not enough memory for this operation!
Nicht genug Speicher für diese Operation!
Pas assez de mémoire pour cette opération !
¡No hay memoria suficiente!
;
MSG_Error_ImportExportUnableToOpen
Unable to open file!
Datei konnte nicht geöffnet werden!
Impossible d'ouvrir le fichier !
¡Imposible abrir fichero!
;
MSG_Error_ImportExport
The options 'IMPORT' and 'EXPORT' are mutually exclusive!
Die Optionen 'IMPORT' und 'EXPORT' schließen sich gegenseitig aus!
Les options 'IMPORT' et 'EXPORT' ne peuvent être utilisées ensemble !
¡Las opciones 'IMPORTAR' y 'EXPORTAR' son excluyentes entre ellas!
;
MSG_Error_ExportTo
The options 'EXPORT' and 'TO' are mutually exclusive!
Die Optionen 'EXPORT' und 'TO' schließen sich gegenseitig aus!
Les options 'EXPORT' et 'TO' ne peuvent être utilisées ensemble !
¡Las opciones 'EXPORTAR' y 'A' son excluyentes entre ellas!
;
MSG_Error_ImportExportPathIncorrect
Unable to locate drawer '%s'!
Verzeichnis '%s' wurde nicht gefunden!
Impossible de trouver le répertoire '%s' !
¡Imposible localizar cajón '%s'!
;
MSG_Error_VersionStringInvalid
Invalid version string!
Der Versionstext ist ungültig!
Mauvaise chaîne de version !
¡Cadena de versión no válida!
;
MSG_Error_CatalogNotValid
Catalog '%s' is invalid!
Katalog '%s' ist ungültig!
Le catalogue '%s' n'est pas valide !
¡Catálogo '%s' no válido!
;
MSG_Error_TargetLanguageNotFound
Target language '%s' not found!
Zielsprache '%s' nicht gefunden!
Langue cible '%s' non trouvée !
¡Lenguaje de destino '%s' no encontrado!
;
MSG_Error_TargetInvalidCommand
Target command is invalid!
Zielkommando ist ungültig!
La commande cible n'est pas valide !
¡Comando Target no válido!
;
MSG_Error_FilesMissing
Import and export functions require the 'FILES' argument!
Die Import- und Export-Funktionen benötigen das 'FILES'-Argument!
Les fonctions IMPORT et EXPORT nécessitent l'argument 'FILES' !
¡Las funciones exportar e importar requieren el argumento 'FILES'!
;
MSG_Error_ExportLanguageNotFound
Unable to export '%s' - language '%s' not found!
'%s' kann nicht exportiert werden - die Sprache '%s' wurde nicht gefunden!
Impossible de créer '%s' - langue '%s' non trouvée !
¡Imposible exportar '%s' - lenguaje '%s' no encontrado!
;
MSG_Error_UnknownFileType
Unknown file type - ensure the suffix is valid!
Unbekannter Dateityp - stellen sie sicher, dass die Dateiendung korrekt ist!
Type de fichier inconnu - vérifiez que l'extension du fichier est correcte !
¡Tipo de fichero desconocido - compruebe la extensión!
;
MSG_Error_ExportLanguageMissing
Unable to export '%s' - language argument missing!
'%s' konnte nicht exportiert werden - das Sprachargument fehlt!
Impossible de créer '%s' - argument de langue manquant !
¡Imposible exportar '%s' - argumento de lenguaje no presente!
;
MSG_Error_LanguageDoubleDefined
Language '%s' is defined multiple times!
Die Sprache '%s' wurde mehrfach definiert!
La langue '%s' est définie plusieurs fois !
¡Lenguaje '%s' definido múltiples veces!
;
MSG_Error_LabelDoubleDefined
Label '%s' is defined multiple times (see line %ld)!
Bezeichner '%s' wurde mehrfach definiert! (siehe Zeile %ld)!
L'étiquette '%s' est définie plusieurs fois (voir ligne %ld) !
¡Etiqueta '%s' definida múltiples veces (ver línea %ld)!
;
MSG_Error_IDDoubleDefined
Label '%s': ID %ld is defined multiple times (see line %ld)!
Bezeichner '%s': ID %ld wurde mehrfach definiert! (siehe Zeile %ld)!
L'étiquette '%s': ID %ld est définie plusieurs fois (voir ligne %ld) !
¡Etiqueta '%s': ID %ld definida múltiples veces (ver línea %ld)!
;
MSG_Error_LabelMustNotStartWithNumber
Label '%s': Labels must not start with a digit!
Bezeichner '%s': Bezeichner dürfen nicht mit einer Zahl beginnen!
Étiquette '%s' : les étiquettes ne doivent pas commencer par un chiffre !
¡Etiqueta '%s': Las Etiquetas no deben comenzar por un número!
;
MSG_Error_LabelCharNotAllowed
Label '%s': Character '%s' not permitted here!
Bezeichner '%s': Zeichen '%s' ist hier nicht erlaubt!
Étiquette '%s' : le caractère '%s' n'est pas permis ici !
¡Eiqueta '%s': Caracter '%s' no permitido!
;
MSG_Error_LanguageHeadInvalid
Language header is invalid!
Sprachkopf ist ungültig!
En-tête de langue non valide !
¡Cabecera de lenguaje no válida!
;
MSG_Error_ImportSourceFiles
It is not possible to import source file '%s'!
Es ist nicht möglich, Quellcode '%s' zu importieren!
Il est impossible d'importer le fichier source '%s' !
¡Imposible importar fichero fuente '%s'!
;
MSG_Error_ImportMissingVersionChunk
Catalog does not contain a valid 'FVER' chunk!
Katalog enthält keinen gültigen 'FVER'-Chunk!
Le catalogue ne contient pas de champ 'FVER' valide !
¡Catálogo carente de porción 'FVER' válida!
;
MSG_Error_ImportMissingLanguageChunk
Catalog does not contain a valid 'LANG' chunk, using 'unknown' as language name.
Katalog enthält keinen gültigen 'LANG'-Chunk, benutze 'unbekannt' als Sprachname.
Le catalogue ne contient pas de champ 'LANG' valide, 'inconnu' sera utilisé comme nom de langue.
Catálogo carente de porción 'LANG' válida, se empleará 'desconocido' como nombre de lenguaje.
;
MSG_Error_MaxNumberOfLanguages
Unable to add language '%s' because the maxium number of languages has been reached (contact developer)!
Sprache '%s' konnte nicht hinzugefügt werden, weil die maximale Anzahl von Sprachen erreicht wurde (kontaktieren sie den Entwickler)!
Impossible d'ajouter la langue '%s' car le nombre maximum de langues a été atteint (contactez le développeur) !
¡Imposible añadir lenguaje '%s' por alcanzarse el número máximo de lenguajes (contacte con el programador)!
;
MSG_Error_Unknown
Unknown
Unbekannt
Inconnu
Desconocido
;
MSG_Error_ImportMissingLanguagesCommand
File does not contain a valid '##LANGUAGES' command!
Datei enthält kein gültiges '##LANGUAGES'-Kommando!
Le fichier ne contient pas de commande '##LANGUAGES' valide !
¡Fichero carente de comando '##LANGUAGES' válido!
;
MSG_Error_ImportMissingLanguageCommand
File does not contain a valid '##LANGUAGE' command!
Datei enthält kein gültiges '##LANGUAGE'-Kommando!
Le fichier ne contient pas de commande '##LANGUAGE' valide !
¡Fichero carente de comando '##LANGUAGE' válido!
;
MSG_DEFAULTLABEL
MSG_x_GAD
MSG_x_GAD
MSG_x_GAD
MSG_x_GAD
;
; New GUI Stuff
;
MSG_LV_Type
Type
Typ
Type
Tipo
;
MSG_LV_Name
Name
Name
Nom
Nombre
;
MSG_LV_Label
Label
Bezeichner
Étiquettes
Etiqueta
;
MSG_LV_Language
Language
Sprache
Langue
Lenguaje
;
MSG_LV_String
Translation
Übersetzung
Traduction
Traducción
;
MSG_LV_Valid
Valid
Gültig
Valide
Válido
;
MSG_LV_Message
Message
Nachricht
Message
Mensaje
;
MSG_LV_ID
ID
ID
ID
ID
;
MSG_LV_Min
Min
Min
Min
Mín
;
MSG_LV_Max
Max
Max
Max
Máx
;
MSG_LV_NOID
Auto
Auto
Auto
Auto
;
MSG_LV_NOLIMIT
No
Nein
Non
No
;
MSG_LV_No
No
Nein
Non
No
;
MSG_LV_Yes
Yes
Ja
Oui
Sí
;
MSG_LV_EMPTY
<empty>
<leer>
<vide>
<vacío>
;
MSG_LV_CSITYPE_LANGUAGE
Translation
Übersetzung
Traduction
Traducción
;
MSG_LV_CSITYPE_COMMENT
Comment
Kommentar
Commentaire
Comentario
;
MSG_LV_CSITYPE_CODE
Code
Code
Code
Código
;
MSG_LV_CSITYPE_HEADER
HEADER
HEADER
HEADER
HEADER
;
MSG_LV_CSITYPE_IFDEF
IFDEF
IFDEF
IFDEF
IFDEF
;
MSG_LV_CSITYPE_ENDIF
ENDIF
ENDIF
ENDIF
ENDIF
;
MSG_LV_CSITYPE_ELSE
ELSE
ELSE
ELSE
ELSE
;
MSG_LV_CSITYPE_IFNDEF
IFNDEF
IFNDEF
IFNDEF
IFNDEF
;
MSG_LV_CSITYPE_DEFINE
DEFINE
DEFINE
DEFINE
DEFINE
;
MSG_LV_CSITYPE_VERSIONID
VersionID
VersionID
VersionID
VersionID
;
MSG_LV_CSITYPE_CHUNK
Chunk
Chunk
Chunk
Chunk
;
MSG_LV_CSTTYPE_ASM
ASM
ASM
ASM
ASM
;
MSG_LV_CSTTYPE_C
C
C
C
C
;
MSG_LV_CSTTYPE_E
E
E
E
E
;
MSG_LV_CSTTYPE_CATALOGS
Catalogs
Kataloge
Catalogues
Catálogos
;
MSG_LV_CSTTYPE_CATALOG
Catalog
Katalog
Catalogue
Catálogo
;
MSG_LV_CSTLANGUAGE_NONE
<None>
<Keine>
<Aucun>
<Ninguno>
;
; ### ASL requester stuff
;
MSG_ASL_Open
Open
Öffnen
Ouvrir
Abrir
;
MSG_ASL_Save
Save
Speichern
Enregistrer
Guardar
;
MSG_ASL_Import
Import
Importieren
Importer
Importar
;
MSG_ASL_Export
Export
Exportieren
Exporter
Exportar
;
MSG_ASL_Use
Use
Benutzen
Utiliser
Utilizar
;
MSG_ASL_SelectFileToOpen
Select file to open
Datei zum Öffnen wählen
Sélection du fichier à ouvrir
Seleccione fichero
;
MSG_ASL_SelectFileToSaveAs
Select file to save as
Datei zum Speichern wählen
Sélection du fichier à enregistrer
Selecciones fichero para guardar como
;
MSG_ASL_SelectFileToImport
Select file file to import
Datei zum Importieren wählen
Sélection du fichier à importer
Seleccione fichero a importar
;
MSG_ASL_SelectFileToExport
Select file file to export
Datei zum Exportieren wählen
Sélection du fichier à exporter
Seleccione fichero a exportar
;
MSG_ASL_SelectCatalogDir_killme
Select catalog dir
Katalogverzeichnis wählen
Sélection du répertoire du catalogue
Selecciones directorio de catálogos
;
MSG_ASL_SelectTargetName
Select target name
Dateinamen für Ziel wählen
Sélection du nom de la cible
Seleccione nombre de objetivo
;
MSG_ASL_SelectTargetPath
Select target path
Zielpfad wählen
Sélection du répertoire de la cible
Seleccione ruta de objetivo
;
; Filetype names
;
MSG_FILETYPE_UNKNOWN
Unknown
Unbekannt
Inconnu
Desconocido
;
MSG_FILETYPE_CATALOG
Catalog
Katalog
Catalogue
Catálogo
;
MSG_FILETYPE_ASM
Assembler (.asm)
Assembler (.asm)
Assembleur (.asm)
Ensamblador (.asm)
;
MSG_FILETYPE_C
C (.c)
C (.c)
C (.c)
C (.c)
;
MSG_FILETYPE_E
E (.e)
E (.e)
E (.e)
E (.e)
;
MSG_FILETYPE_CT
CT (.ct)
CT (.ct)
CT (.ct)
CT (.ct)
;
MSG_FILETYPE_CD
CD (.cd)
CD (.cd)
CD (.cd)
CD (.cd)
;
MSG_FILETYPE_MTL
MTL (.mtl)
MTL (.mtl)
MTL (.mtl)
MTL (.mtl)
;
MSG_FILETYPE_CS
CS (.cs)
CS (.cs)
CS (.cs)
CS (.cs)
;
MSG_FILETYPE_LOCALE
Locale Code (.c/.h)
Locale Programmkode (.c/.h)
Code Localisé (.c/.h)
Código Locale (.c/.h)
;
; ### CS Class (muiclass_cs.c)
;
MSG_MUICLASS_CS_TitleWindow
Simplecat V%ld.%ld %s
Simplecat V%ld.%ld %s
Simplecat V%ld.%ld %s
Simplecat V%ld.%ld %s
;
MSG_MUICLASS_CS_CatalogScript_GROUP
Catalog Script (CS)
Katalog Skript (CS)
Script Catalogue (CS)
Catalog Script (CS)
;
MSG_MUICLASS_CS_CatalogScript_HELP
This list contains all available catalog script items. The number and type of items depends on the state of the developer mode and its configuration.
Diese Liste enthält alle verfügbaren Einträge in der Katalogdatenbank. Je nach Einstellung des Entwicklermodus wird die Anzeige von bestimmten Typen unterdrückt.
Cette liste contient tous les champs disponibles dans le script catalogue. Le numéro et le type des objets dépendent du choix du mode développeur et de sa configuration.
Listado con todos los tipos de guión de catálogo. El número y tipo de elementos depende del estado del modo desarrollador y su configuración.
;
MSG_MUICLASS_CS_GROUP
Log
Log
Journal
Registro
;
MSG_MUICLASS_CS_Add_GAD
_Add
_Neu
_Ajouter
_Añadir
;
MSG_MUICLASS_CS_Add_HELP
Add new item to list.
Fügt einen neuen Eintrag zur Liste hinzu.
Ajoute un nouveau champ à la liste.
Añadir elemento a la lista.
;
MSG_MUICLASS_CS_Remove_GAD
_Remove
_Entfernen
_Supprimer
Eliminar
;
MSG_MUICLASS_CS_Remove_HELP
Removes the current item from list.
Entfernt den aktuellen Eintrag aus der Liste.
Supprime le champ sélectionné de la liste.
Elimina elemento de la lista.
;
MSG_MUICLASS_CS_Prefs_GAD
CS _Preferences...
CS-_Voreinstellungen ...
_Préférences CS...
Ajustes CS...
;
MSG_MUICLASS_CS_Prefs_HELP
Opens preferences for current catalog database.
Öffnet das Voreinstellungsfenster für die aktuelle Katalogdatenbank.
Ouvre les préférences de la base de données du script caatalogue.
Abre las preferencias para la base de datos de catálogo actual.
;
MSG_MUICLASS_CS_Check_GAD
C_heck
_Prüfen
_Vérifier
Verificar
;
MSG_MUICLASS_CS_Check_HELP
The entire catalog script database will be checked.
Die komplette Katalogskriptdatenbank wird geprüft.
Le script catalogue sera totalement vérifié.
Verifica toda la base de datos del guión de catálogo.
;
MSG_MUICLASS_CS_LogClear_GAD
_Clear
_Löschen
_Effacer
Vaciar
;
MSG_MUICLASS_CS_LogClear_HELP
The entire log list will be cleared.
Alle Einträge in der Logliste werden gelöscht.
L'historique du journal sera effacé.
Borra toda la lista del registro.
;
; CS Class Menu items (muiclass_cs.c)
;
MSG_Menu_CS_Project
Project
Projekt
Projet
Proyecto
;
MSG_Menu_CS_New
New (.cs)...
Neu (.cs) ...
Nouveau (.cs)...
Nuevo (.cs)...
;
MSG_Menu_CS_New_KEY
~
~
~
~
;
MSG_Menu_CS_Open
Open (.cs)...
Öffnen (.cs) ...
Ouvrir (.cs)...
Abrir (.cs)...
;
MSG_Menu_CS_Open_KEY
O
O
O
O
;
MSG_Menu_CS_Save
Save (.cs)
Speichern (.cs)
Enregistrer (.cs)
Guardar (.cs)
;
MSG_Menu_CS_Save_KEY
S
S
S
S
;
MSG_Menu_CS_SaveAs
Save As (.cs)...
Speichern als (.cs) ...
Enregistrer sous (.cs)...
Guardar como (.cs)...
;
MSG_Menu_CS_SaveAs_KEY
A
A
A
A
;
MSG_Menu_CS_Preferences
Preferences...
Voreinstellungen ...
Préférences...
Ajustes...
;
MSG_Menu_CS_Preferences_KEY
P
P
P
P
;
MSG_Menu_CS_About
About...
Über ...
À propos...
Acerca de...
;
MSG_Menu_CS_About_KEY
?
?
?
?
;
MSG_Menu_CS_Quit
Quit
Beenden
Quitter
Salir
;
MSG_Menu_CS_Quit_KEY
Q
Q
Q
Q
;
MSG_Menu_CS_Edit
Edit
Editieren
Éditer
Editar
;
MSG_Menu_CS_CSPreferences
CS Preferences...
CS Voreinstellungen ...
Préférences CS...
Ajustes CS...
;
MSG_Menu_CS_CSPreferences_KEY
R
R
R
R
;
MSG_Menu_CS_TranslationFind
Find Translation...
Suche Übersetzung ...
Rechercher texte...
Buscar Traducción...
;
MSG_Menu_CS_TranslationFind_KEY
E
E
E
E
;
MSG_Menu_CS_TranslationNext
Find Next Translation
Suche nächste Übersetzung
Rechercher suivant
Buscar siguiente
;
MSG_Menu_CS_TranslationNext_KEY
T
T
T
T
;
MSG_Menu_CS_MissingTranslationFind
Find Missing Translation
Suche fehlende Übersetzung
Rechercher traduction manquante
Buscar Traducción vacía
;
MSG_Menu_CS_MissingTranslationFind_KEY
F
F
F
F
;
MSG_Menu_CS_MissingTranslationNext
Find Next Missing Translation
Suche nächste fehlende Übersetzung
Rechercher suivante
Buscar siguiente vacía
;
MSG_Menu_CS_MissingTranslationNext_KEY
N
N
N
N
;
MSG_Menu_CS_StripTrailing
Skip trailing chars...
Folgezeichen entfernen ...
Supprimer caractères de fin...
Saltar caracteres de final...
;
MSG_Menu_CS_Import
Import
Importieren
Importer
Importar
;
MSG_Menu_CS_ImportCD
Catalog Descriptor (.cd)...
Katalogbeschreibung (.cd) ...
Descripteur de catalogue (.cd)...
Descriptor de Catálogo (.cd)...
;
MSG_Menu_CS_ImportCD_KEY
~
~
~
~
;
MSG_Menu_CS_ImportCT
Translator File (.ct)...
Übersetzerdatei (.ct) ...
Fichier de traduction (.ct)...
Fichero de Traductor (.ct)...
;
MSG_Menu_CS_ImportCT_KEY
~
~
~
~
;
MSG_Menu_CS_ImportMTL
Catalog Descriptor (.mtl)...
Katalogbeschreibung (.mtl) ...
Descripteur de catalogue (.mtl)...
Descriptor de Catálogo (.mtl)...
;
MSG_Menu_CS_ImportMTL_KEY
~
~
~
~
;
MSG_Menu_CS_ImportCatalog
Catalog File (.catalog)...
Katalogdatei (.catalog) ...
Fichier catalogue (.catalog)...
Fichero de Catálogo (.catalog)...
;
MSG_Menu_CS_ImportCatalog_KEY
~
~
~
~
;
MSG_Menu_CS_Export
Export
Exportieren
Exporter
Exportar
;
MSG_Menu_CS_ExportCD
Catalog Descriptor (.cd)...
Katalogbeschreibung (.cd) ...
Descripteur de catalogue (.cd)...
Descriptor de Catálogo (.cd)...
;
MSG_Menu_CS_ExportCD_KEY
~
~
~
~
;
MSG_Menu_CS_ExportCT
Translator File (.ct)...
Übersetzerdatei (.ct) ...
Fichier de traduction (.ct)...
Fichero de Traductor (.ct)...
;
MSG_Menu_CS_ExportCT_KEY
~
~
~
~
;
MSG_Menu_CS_ExportMTL
Catalog Descriptor (.mtl)...
Katalogbeschreibung (.mtl) ...
Descripteur de catalogue (.mtl)...
Descriptor de Catálogo (.mtl)...
;
MSG_Menu_CS_ExportMTL_KEY
~
~
~
~
;
MSG_Menu_CS_ExportCatalog
Catalog File (.catalog)...
Katalogdatei (.catalog) ...
Fichier catalogue (.catalog)...
Fichero de Catálogo (.catalog)...
;
MSG_Menu_CS_ExportCatalog_KEY
~
~
~
~
;
MSG_Menu_CS_ExportC
C Source (.c)...
C-Quellcode (.c) ...
Source C (.c)...
Fuente C (.c)...
;
MSG_Menu_CS_ExportC_KEY
~
~
~
~
;
MSG_Menu_CS_ExportE
E Source (.e)...
E-Quellcode (.e) ...
Source E (.e)...
Fuente E (.e)...
;
MSG_Menu_CS_ExportE_KEY
~
~
~
~
;
MSG_Menu_CS_ExportASM
Assembler Source (.asm)...
Assembler-Quellcode (.asm) ...
Source assembleur (.asm)...
Fuente Ensamblador (.asm)...
;
MSG_Menu_CS_ExportASM_KEY
~
~
~
~
;
MSG_Menu_CS_ExportLocaleCode
Locale Code Source (.c/.h)...
Locale Quellcode (.c/.h) ...
Source de code localisé (.c/.h)...
Código Fuente Locale (.c/.h)...
;
MSG_Menu_CS_ExportLocaleCode_KEY
~
~
~
~
;
MSG_Menu_CS_ExportTargets
Create Targets
Ziele erzeugen
Créer cibles
Crear Objetivos
;
MSG_Menu_CS_ExportTargets_KEY
~
~
~
~
;
MSG_Menu_CS_Extras
Extras
Extras
Suppléments
Extras
;
MSG_Menu_CS_SourceSnoop
Localization Wizard...
Lokalisierungs-Assistent ...
Assistant localisation...
Ayuda de Localización...
;
MSG_Menu_CS_SourceSnoop_KEY
~
~
~
~
;
; ### CSI Class (muiclass_csi.c)
;
MSG_CSICLASS_Translation_GROUP
String Translations
Textübersetzungen
Traductions des chaînes
Traducciones de cadenas
;
MSG_CSICLASS_Translation_HELP
Displays the current list of translations.
Zeigt die aktuelle Liste der Übersetzungen an.
Affiche la liste courante des traductions.
Muestra la lista de traducciones.
;
MSG_CSICLASS_Translation_String_GAD
_Translation:
Über_setzung:
_Traduction
_Traducción:
;
MSG_CSICLASS_Translation_String_HELP
Translation of the current selected item
Übersetzung des aktuellen Eintrags
Traduction de l'objet sélectionné
Traducción del elemento seleccionado
;
MSG_CSICLASS_CONFIG_GROUP
Translation Configuration
Übersetzungskonfiguration
Configuration traduction
Configuración de la Traducción
;
MSG_CSICLASS_LABEL_GAD
_Label:
_Bezeichner:
Éti_quette
Etiqueta:
;
MSG_CSICLASS_LABEL_HELP
Defines the label which represents the localized text in the source code.
Hier wird der Bezeichner angegeben, der den lokalisierten Text im Quellcode repräsentiert.
Définit l'étiquette qui représente le texte traduit dans le code source.
Define la etiqueta que representa el texto localizado en el códifgo fuente.
;
MSG_CSICLASS_ID_GAD
_ID:
_ID:
_ID
_ID:
;
MSG_CSICLASS_ID_HELP
This number will be assigned to the translation.
Diese Zahl wird der Übersetzung zugeordnet.
Ce nombre sera associé à ce champ.
Número que será asignado a la traducción.
;
MSG_CSICLASS_MIN_GAD
_Minimum:
_Minimum:
_Minimum
_Mínimo:
;
MSG_CSICLASS_MIN_HELP
The translatation may not be shorter than this value.
Der Übersetzungstext darf nicht kürzer sein, als hier angegeben.
La traduction ne peut pas être plus courte que cette valeur.
La traducción no será inferior a este valor.
;
MSG_CSICLASS_MAX_GAD
Ma_ximum:
Ma_ximum:
Ma_ximum
Má_ximo:
;
MSG_CSICLASS_MAX_HELP
The translation may not be longer than this value.
Der Übersetzungstext darf nicht länger sein, als hier angegeben.
La traduction ne peut pas être plus longue que cette valeur.
La traducción no será superior a este valor.
;
MSG_CSICLASS_VersionID_GROUP
Version ID
Version ID
Identifiant de version
Version ID
;
MSG_CSICLASS_VersionID_Language_GAD
Language:
Sprache:
Langue
Lenguaje:
;
MSG_CSICLASS_VersionID_Language_HELP
Language associated with this item.
Die Sprache, an die dieses Element geknüpft ist.
Langue associée à cet objet.
Lenguaje asociado con este elemento.
;
MSG_CSICLASS_VersionID_ID_GAD
ID:
ID:
ID
ID:
;
MSG_CSICLASS_VersionID_ID_HELP
Element ID.
Die ID dieses Elements.
Identifiant de cet élément.
ID de elemento.
;
MSG_CSICLASS_Comment_GROUP
Comment line
Kommentarzeile
Ligne de commentaires
Línea de comentario
;
MSG_CSICLASS_Comment_String_GAD
_Comment line:
_Kommentarzeile:
Ligne de _commentaires
Línea de _Comentario:
;
MSG_CSICLASS_Comment_String_HELP
Comment string of the current entry
Kommentartext des aktuellen Eintrags
Chaîne de commentaire de l'entrée sélectionnée
Texto de comentario para la entrada actual
;
MSG_CSICLASS_Code_GROUP
Code
Code
Code
Código
;
MSG_CSICLASS_Code_String_GAD
C_ode:
C_ode:
C_ode :
C_ódigo:
;
MSG_CSICLASS_Code_String_HELP
Contains commands which will be exported into the source code.
Enthält Befehle, die beim Exportieren in den Quellcode übernommen werden.
Contient les commandes qui seront exportées avec le code source.
Contiene los comandos que se exportarán en el código fuente.
;
MSG_CSICLASS_Chunk_GROUP
Chunk
Chunk
En-tête
Chunk
;
MSG_CSICLASS_ChunkLanguage_GAD
Language:
Sprache:
Langue
Lenguaje:
;
MSG_CSICLASS_ChunkLanguage_HELP
Language associated with this item.
Die Sprache, an die dieses Element geknüpft ist.
Langue associée à cet objet.
Lenguaje asociado a este elemento.
;
MSG_CSICLASS_ChunkID_GAD
ID:
ID:
ID
ID:
;
MSG_CSICLASS_ChunkID_HELP
Contains the chunk id which will be exported to catalog.
Enthält Chunk-Kennung der in den Katalog übernommen wird.
Contient l'identifiant de l'en-tête qui sera exporté vers le catalogue.
Contiene la id de chunk que se exportará en el catálogo.
;
MSG_CSICLASS_ChunkData_GAD
Data:
Data:
Données
Data:
;
MSG_CSICLASS_Chunk_Data_HELP
Contains the data which will be store inside the chunk.
Enthält die Daten, die in dem Chunk gespeichert werden.
Contient les données qui seront stockées à l'intérieur de l'en-tête.
Contiene los datos almacenados dentro del chunk.
;
; ### CS Prefs Class (muiclass_csprefs.c)
;
MSG_MUICLASS_CSPREFS_TitleWindow
Simplecat - Catalog Script Preferences
Simplecat - Katalog Skript Voreinstellungen
Simplecat - Préférences du script catalogue
Simplecat - Ajustes de Guiones de Catálogo
;
MSG_MUICLASS_CSPREFS_CST_GROUPTITLE
Targets
Ziele
Cibles
Objetivos
;
MSG_MUICLASS_CSPREFS_CODE_GROUPTITLE
Source
Quelltext
Source
Fuente
;
MSG_MUICLASS_CSPREFS_CATALOG_GROUPTITLE
Catalog
Katalog
Catalogue
Catálogo
;
MSG_MUICLASS_CSPREFS_LANGUAGE_GROUPTITLE
Languages
Sprachen
Langues
Lenguajes
;
MSG_MUICLASS_CSPREFS_LANGUAGE_HELP
These languages are currently available in the database.
Diese Sprachen sind derzeit in der Datenbank verfügbar.
Voici les langues disponibles dans la base de données.
Lenguajes disponibles en la base de datos actualmente.
;
MSG_MUICLASS_CSPREFS_CST_GROUP
Targets
Ziele
Cibles
Objetivos
;
MSG_MUICLASS_CSPREFS_CSTLIST_HELP
These are the currently defined targets in the catalog database.
Dies sind die derzeit in der Datenbank vorhandenen Ziele.
Voici les cibles actuellement définies dans la base de données du catalogue.
Objetivos definidos en la base de datos de catálogos.
;
MSG_MUICLASS_CSPREFS_CSTADD_GAD
_Add
_Neu
_Ajouter
_Añadir
;
MSG_MUICLASS_CSPREFS_CSTADD_HELP
Add a catalog script target.
Ein neues Katalogskriptziel hinzufügen.
Ajoute une cible au script catalogue.
Añade guión de catálogo a objetivos.
;
MSG_MUICLASS_CSPREFS_CSTREMOVE_GAD
_Remove
_Entfernen
_Supprimer
Eliminar
;
MSG_MUICLASS_CSPREFS_CSTREMOVE_HELP
Removes a catalog script target.
Entfernt das aktive Katalogskriptziel.
Supprime la cible sélectionnée du script catalogue.
Elimina objetivo de guión de catálogo.
;
MSG_MUICLASS_CSPREFS_CSTNAME_GAD
_File:
_Datei:
_Fichier :
_Fichero:
;
MSG_MUICLASS_CSPREFS_CSTNAME_HELP
File name of target.
Dateiname des Ziels.
Nom du fichier pour la cible.
Nombre del fichero de objetivo.
;
MSG_MUICLASS_CSPREFS_CSTPATH_GAD
_Path:
_Pfad:
_Chemin :
Ruta:
;
MSG_MUICLASS_CSPREFS_CSTPATH_HELP
path of the target.
Pfad des Ziels.
Chemin de la cible.
Ruta del objetivo.
;
MSG_MUICLASS_CSPREFS_CSTTYPE_GAD
_Type:
_Typ:
T_ype :
_Tipo:
;
MSG_MUICLASS_CSPREFS_CSTTYPE_HELP
Type of the current catalog script target.
Typ des aktiven Katalogskriptziels.
Type de la cible sélectionnée du script catalogue.
Tipo objetivo de guión de catálogo actual.
;
MSG_MUICLASS_CSPREFS_CSTLANGUAGE_GAD
_Language:
_Sprache:
_Langue :
_Lenguaje:
;
MSG_MUICLASS_CSPREFS_CSTLANGUAGE_HELP
Language of the active target.
Sprache des aktiven Ziels.
Langue de la cible sélectionnée.
Lenguaje del Objetivo activo.
;
MSG_MUICLASS_CSPREFS_CSTNOBLOCK_GAD
No _Block
_Kein Block
Pas de _Bloc
Sin bloque
;
MSG_MUICLASS_CSPREFS_CSTNOBLOCK_HELP
Do not export text block along with target.
Keinen Textblock mit dem Ziel exportieren.
Ne pas exporter de bloc pour cette cible.
No exportar bloque de texto junto al objetivo.
;
MSG_MUICLASS_CSPREFS_CSTNOBLOCKSTATIC_GAD
N_o static Block
Kein statischer _Block
Pas de Bloc stati_que
Sin Bloque Estático
;
MSG_MUICLASS_CSPREFS_CSTNOBLOCKSTATIC_HELP
Do not export block as static.
Den Textblock nicht als statisch exportieren.
Ne pas exporter le bloc en statique.
No exportar bloque como estático.
;
MSG_MUICLASS_CSPREFS_CSTNOCODE_GAD
No _Code
Kein _Programmcode
Pas de _Code
Sin _Código
;
MSG_MUICLASS_CSPREFS_CSTNOCODE_HELP
Do not export locale-specific code along with target.
Keine Programmteile zusammen mit Ziel exportieren.
Ne pas exporter de code localisé pour cette cible.
No exportar código específico de locale junto al objetivo.
;
MSG_MUICLASS_CSPREFS_CSTNOARRAY_GAD
_No Array
Kein _Array
Pas de _Tableau
Sin Array
;
MSG_MUICLASS_CSPREFS_CSTNOARRAY_HELP
Do not export a string array along with target.
Keine Texttabelle zusammen mit dem Ziel exportieren.
Ne pas exporter un tableau de chaînes pour cette cible.
No exportar array de cadena junto al objetivo.
;
MSG_MUICLASS_CSPREFS_CSTNOSTRINGS_GAD
No _Strings
Keine Te_xte
Pas de C_haînes
Sin Cadenas
;
MSG_MUICLASS_CSPREFS_CSTNOSTRINGS_HELP
Do not export strings along with target.
Keine Texte zusammen mit dem Ziel exportieren.
Ne pas exporter de chaînes pour cette cible.
No exportar cadenas junto al objetivo.
;
MSG_MUICLASS_CSPREFS_CSTOPTIMIZE_GAD
O_ptimize
_Optimierung
_Optimiser
_Optimizar
;
MSG_MUICLASS_CSPREFS_CSTOPTIMIZE_HELP
Strings will be removed, if they are identical to the main language.
Texte werden aus dem Katalog entfernt, wenn sie identisch mit dem Text in der der Hauptsprache sind.
Si elles sont identiques à celles de la langue principale, les chaînes seront supprimées.
Se eliminarán cadenas de texto que sean idénticas al lenguaje principal.
;
MSG_MUICLASS_CSPREFS_SOURCE_GROUP
Source:
Quelltext:
Source :
Fuente:
;
MSG_MUICLASS_CSPREFS_SOURCEHEADERNAME_GAD
_Header name:
_Header-Name:
Nom de l'_en-tête :
Nombre de Header:
;
MSG_MUICLASS_CSPREFS_SOURCEHEADERNAME_HELP
Name of the #IFNDEF header constant. Define "HELLO" here to obtain a file with "#IFNDEF HELLO_H".
Name des #IFNDEF Kopfes. Wenn sie wollen, dass die Datei mit "#IFNDEF HALLO_H" beginnt, dann definieren sie hier "HALLO".
Nom de la constante pour l'en-tête #IFNDEF. Définir "HELLO" ici pour obtenir un fichier avec #IFNDEF HELLO_H".
Nombre de la constante de cabecera #IFNDEF. Defina "HELLO" para obtener un fichero con "#IFNDEF HELLO_H".
;
MSG_MUICLASS_CSPREFS_SOURCEARRAYNAME_GAD
_Array Name:
_Array-Name:
Nom du _tableau :
Nombre de _Array:
;
MSG_MUICLASS_CSPREFS_SOURCEARRAYNAME_HELP
Defines the name of the string array.
Definiert den Namen des String-Arrays.
Définit le nom du tableau de chaînes.
Define el nombre del array de cadenas.
;
MSG_MUICLASS_CSPREFS_SOURCEARRAYOPTS_GAD
Array _Options:
Array-_Optionen:
_Options tableau :
Opciones de Array:
;
MSG_MUICLASS_CSPREFS_SOURCEARRAYOPTS_HELP
Defines qualifier options for the array, e.g. static const
Definiert qualifizierende Parameter für das Array, z.B. static const
Définit les options du qualificateur pour le tableau, par exemple static const
Define las opciones del array, p.ej la constante static
;
MSG_MUICLASS_CSPREFS_SOURCEFUNCTIONNAME_GAD
_Function Name:
_Funktionsname:
Nom de la _fonction :
Nombre de _Función:
;
MSG_MUICLASS_CSPREFS_SOURCEFUNKTIONNAME_HELP
Defines the name of the function.
Definiert den Namen der Funktion.
Définit le nom de la fonction.
Define el nombre de la función.
;
MSG_MUICLASS_CSPREFS_SOURCEFUNCTIONPROTO_GAD
Function _Prototype:
Funktions-_Prototyp:
_Prototype de fonction :
_Prototipo de Función:
;
MSG_MUICLASS_CSPREFS_SOURCEFUNKTIONPROTO_HELP
Defines the prototype of the function.
Definiert den Prototypen der Funktion.
Définit le prototype de la fonction.
Define el prototipo de la función.
;
MSG_MUICLASS_CSPREFS_SOURCEVERSIONID_GAD
Version ID:
Versions _ID:
Identifiant de _version :
ID de Versión:
;
MSG_MUICLASS_CSPREFS_SOURCEVERSIONID_HELP
Defines the version of the catalog.
Definiert die Version des Katalogs.
Définit la version du catalogue.
Define la versión del catálogo.
;
MSG_MUICLASS_CSPREFS_SOURCEAUTONUM_GAD
Automatic Numbering:
Automatische _Numerierung:
_Numérotation automatique :
Numeración Automática:
;
MSG_MUICLASS_CSPREFS_SOURCEAUTONUM_HELP
Defines the number at which auto numbering starts.
Definiert, mit welcher Nummer das automatische Numerieren startet.
Définit à partir de quel nombre la numérotation automatique commence.
Define el valor de inicio de la numeración automática.
;
MSG_MUICLASS_CSPREFS_CATALOG_GROUP
Catalog:
Katalog:
Catalogue :
Catálogo:
;
MSG_MUICLASS_CSPREFS_CATALOGVERSIONSTRING_GAD
Version String:
Versionskennung:
Chaîne de version :
Texto de Versión:
;
MSG_MUICLASS_CSPREFS_CATALOGVERSIONSTRING_HELP
Version string of the given cs file. Version and revision will be used as catalog version and the name will be used as catalog name.
Versionstext der aktuellen Skriptdatei. Version und Revision werden als Katalogversion und der Name als Katalogname verwendet.
Chaîne pour la version du fichier CS. Version et révision seront utilisées comme version de catalogue et le nom sera utilisé comme nom de catalogue.
Texto de versión de un fichero cs. Utiliza Versión y revisión como versión del catálogo, y el nombre será empleado para el catálogo.
;
MSG_MUICLASS_CSPREFS_CATALOGNAME_GAD
Catalog _Name:
Katalog-_Name:
_Nom du Catalogue :
_Nombre de Catálogo:
;
MSG_MUICLASS_CSPREFS_CATALOGNAME_HELP
Name of the catalog file to be created.
Name des zu erzeugenden Katalogs.
Nom du fichier catalogue qui sera créé.
Nombre del catálogo a crear.
;
MSG_MUICLASS_CSPREFS_CATALOGVERSION_GAD
_Version:
_Version:
_Version :
_Versión:
;
MSG_MUICLASS_CSPREFS_CATALOGVERSION_HELP
Defines the version of the catalog.
Definiert die Version des Katalogs.
Définit la version du catalogue.
Define la versión del catálogo.
;
MSG_MUICLASS_CSPREFS_CATALOGREVISION_GAD
_Revision:
_Revision:
_Révision :
_Revisión:
;
MSG_MUICLASS_CSPREFS_CATALOGREVISION_HELP
Defines the revision of the catalog.
Definiert die Revision des Katalogs.
Définit la révision du catalogue.
Define la revisión del catálogo.
;
MSG_MUICLASS_CSPREFS_CATALOGDAY_GAD
_Day:
_Tag:
_Jour :
_Día:
;
MSG_MUICLASS_CSPREFS_CATALOGDAY_HELP
Defines the day the catalog was created.
Definiert den Tag, an dem der Katalog erstellt wurde.
Définit le jour auquel le catalogue a été créé.
Define el día de creación del catálogo.
;
MSG_MUICLASS_CSPREFS_CATALOGMONTH_GAD
_Month:
_Monat:
_Mois :
_Mes:
;
MSG_MUICLASS_CSPREFS_CATALOGMONTH_HELP
Defines the month the catalog was created.
Definiert den Monat, in dem der Katalog erstellt wurde.
Définit le mois auquel le catalogue a été créé.
Define el mes de creación del catálogo.
;
MSG_MUICLASS_CSPREFS_CATALOGYEAR_GAD
_Year:
_Jahr:
_Année :
Año:
;
MSG_MUICLASS_CSPREFS_CATALOGYEAR_HELP
Defines the year the catalog was created.
Definiert das Jahr, in dem der Katalog erstellt wurde.
Définit l'année à laquelle le catalogue a été créé.
Define el año de creación del catálogo.
;
MSG_MUICLASS_CSPREFS_LANGUAGE_GROUP
Languages
Sprachen
Langues
Lenguajes
;
MSG_MUICLASS_CSPREFS_LANGUAGELIST_HELP
These are the currently defined languages in the catalog database.
Dies sind die derzeit in der Datenbank vorhandenen Sprachen.
Voici les langues actuellement définies dans la base de données du catalogue.
Son los lenguajes definidos en la base de datos de catálogos.
;
MSG_MUICLASS_CSPREFS_SOURCECODESET_GAD
Code Set:
Code-_Set:
Identifiant du _code :
Juego de Código:
;
MSG_MUICLASS_CSPREFS_SOURCECODESET_HELP
Defines the code set used for this catalog.
Definiert den Zeichencode, der für diesen Katalog benutzt wird.
Définit le code utilisé pour ce catalogue.
Define el juego de códigos empleados en el catálogo.
;
MSG_MUICLASS_CSPREFS_LANGUAGEADD_GAD
_Add
_Hinzufügen
_Ajouter
_Añadir
;
MSG_MUICLASS_CSPREFS_LANGUAGEADD_HELP
Adds a new language to the database. Use the name field to specify a name.
Fügt eine neue Sprache hinzu. Benutzen sie das Namensfeld, um den Namen der Sprache festzulegen.
Ajoute une nouvelle langue à la base de données. Utilisez le champ 'Nom de la langue' pour spécifier un nom.
Añade un nuevo lenguaje a la base de datos. Utilice el campo para indicar el nombre.
;
MSG_MUICLASS_CSPREFS_LANGUAGEREMOVE_GAD
_Remove...
_Entfernen ...
_Supprimer...
Eliminar...
;
MSG_MUICLASS_CSPREFS_LANGUAGEREMOVE_HELP
Removes the current language and its associated translations from the database.
Entfernt die komplette Sprache und alle zugeordneten übersetzungen aus der Datenbank.
Supprime la langue actuelle et les traductions associées de la base de données.
Borra el lenguaje actual y sus traducciones asociadas de la base de datos.
;
MSG_MUICLASS_CSPREFS_LANGUAGENAME_GAD
Language Name:
Sprachname:
Nom de la _langue :
Nombre de Lenguaje:
;
MSG_MUICLASS_CSPREFS_LANGUAGENAME_HELP
This gadget specifies the name of the language. Use the pop-up to select one of the pre-defined names.
Dieses Eingabefeld erlaubt es, den Namen der Sprache zu ändern. Benutzen Sie die Aufklappmöglichkeit, um einen vordefinierten Namen auszuwählen.
Cette fonction spéficie le nom de la langue. Utilisez le menu pour sélectionner l'une des langues prédéfinies.
Campo que indica el nombre del lenguaje. Utilice el emergente para escoger uno de los pre-definidos.
;
; ### ImEx Class (muiclass_imex.c)
;
MSG_MUICLASS_IMEX_Export_TitleWindow
%s Export
%s Exportieren
Exportation %s
%s Exportar
;
MSG_MUICLASS_IMEX_Import_TitleWindow
%s Import
%s importieren
Importation %s
%s Importar
;
MSG_MUICLASS_IMEX_FILENAME_GAD
_File name:
_Dateiname:
Nom du _fichier :
_Fichero:
;
MSG_MUICLASS_IMEX_FILENAME_HELP
Name of the file to be imported or exported.
Name der Datei, die importiert oder exportiert werden soll.
Nom du fichier qui doit être importé ou exporté.
Nombre del fichero a importar o exportar.
;
MSG_MUICLASS_IMEX_LANGUAGEDEFAULT_GAD
_Default
_Vorgabe
_Défaut
Por defecto
;
MSG_MUICLASS_IMEX_LANGUAGEDEFAULT_HELP
Normally the language is derived from the imported file. By using this button, you may create a new language or select an existing one to override the file's internal language.
Normalerweise wird die Sprache aus der zu importierenden Datei genommen. Mit diesem Schalter kann das umgangen und eine neue Sprache erstellt oder eine bestehende ausgewählt werden, die dann als Ziel \
genommen wird.
Normalement, la langue découle du fichier importé. En utilisant ce bouton, vous pouvez créer une nouvelle langue ou en sélectionner une existante et la substituer à la langue définie dans le fichier.
Generalmente el lenguaje se deriva del fichero importado. Mediante este botón, puede crear un nuevo lenguaje o escoger uno existente para sobreescribir el lenguaje interno del fichero.
;
MSG_MUICLASS_IMEX_LANGUAGE_GAD
_Language:
_Sprache:
_Langue :
_Lenguaje:
;
MSG_MUICLASS_IMEX_LANGUAGE_HELP
Language to be imported or exported.
Sprache die importiert oder exportiert werden soll.
Langue qui doit être importée ou exportée.
Lenguaje a importar o exportar.
;
MSG_MUICLASS_IMEX_DIFF_GAD
_Mix (diffing)
_Mischen
_Mixer (par différence)
_Mezclar
;
MSG_MUICLASS_IMEX_DIFF_HELP
The file to imported will be regarded as newer .CS file.\nStrings defined in the file but not in the database will be added to the database.\nStrings missing in the file will be removed from the \
database.
Diese zu importierende Datei wird als neuere .CS-Datei angesehen.\nBezeichner, die in der neuen Datei existieren und nicht in der Datenbank, werden geladen.\nBezeichner in der Datei fehlen, werden aus \
der Datenbank gelöscht.
Le fichier à importer sera considéré comme un nouveau fichier .CS\nLes chaînes définies dans le fichier mais pas dans la base de données y seront ajoutées.\nLes chaînes manquantes dans le fichier \
seront supprimées de la base.
El fichero importado se tratará como un nuevo fichero .CS\nLos textos definidos en el fichero pero no en la base de datos se añadirán\na la base de datos.\nLas cadenas no existentes en el fichero \
serán\neliminadas de la base de datos.
;
MSG_MUICLASS_IMEX_STRICT_GAD
_Strict
Stri_kt
_Strict
Estricto
;
MSG_MUICLASS_IMEX_STRICT_HELP
The file to imported will be handled strictly according to standard.\nSome programs dot not write catalog files correctly. For example, some catalogs may have 0x00 at the end of strings.\nThis switch \
allows to enable a tolerant mode which, in such cases, might provide better results (but maybe also produce a wrong result).
Die zu impotierende Datei wird strikt nach Standard behandelt.\nEinige Programme schreiben Katalog-Dateien nicht 100% standardkonform. Beispielsweise haben einige Kataloge 0x00 am Ende der Text.\n\
Dieser Schalter erlaubt das Umschalten in einen toleranten Modus, der dann möglicherweise bessere Ergebnisse erziehlt, aber in seltenen Fällen auch zu Fehlern führt.
Le fichier à importer sera considéré comme concordant strictement aux standards.\nQuelques programmes n'ont pas un catalogue écrit correctement. Par exemple, des catalogues peuvent avoir un 0x00 à la \
fin des chaînes.\nCette option permet d'autoriser le mode tolérant qui, dans certains cas, donne de meilleurs résultats (mais peut également produire un résultat éronné).
El fichero importado será tratado estrictamente según el estándar.\nAlgunos programas no generan catálogos correctamente. Por ejemplo, algunos catálogos\npueden contener 0x00 al final de las cadenas.\n\
Esta opción activa un modo tolerante, que en tal caso,\npuede ofrecer mejores resultados\n(aunque puede ofrecer resultados erróneos).
;
MSG_MUICLASS_IMEX_OPTIMIZE_GAD
_Optimization
_Optimierung
_Optimiser
_Optimización
;
MSG_MUICLASS_IMEX_OPTIMIZE_HELP
If a translation is identical with the original string, it may be ommitted, provided that the program using the catalog was programmed smartly. Some programs can not deal with missing translations. In \
that case, deactivate this optimization.
Wenn eine Übersetzung mit dem Originaltext identisch ist, kann man bei guten Programmen die Übersetzung im Katalog einfach weglassen. Manche Programme können mit fehlenden Übersetzungen aber nicht \
umgehen. Dann sollte man diese Optimierung deaktivieren.
Si une traduction est identique à la chaîne originale, elle peut être omise si le programme a été programmé intelligement. Certains programmes ne savent pas gérer les traductions manquantes. Dans ce \
cas, désactivez l'optimisation.
Si una traducción es idéntica a la cadena original, podrá ser omitida, siempre que el programa que haga uso del catálogo se haya programado convenientemente. Algunos programas no manejan traducciones \
vacías. En ese caso, desactive esta optimización.
;
MSG_MUICLASS_IMEX_NOCODE_GAD
No _Code
Kein _Programmcode
Pas de _Code
Sin _Código
;
MSG_MUICLASS_IMEX_NOCODE_HELP
Do not export locale-specific code along with this target.
Keine Programmteile mit diesem Ziel exportieren.
Ne pas exporter de code localisé avec cette cible.
No exportar código específico de locale junto al objetivo.
;
MSG_MUICLASS_IMEX_NOARRAY_GAD
_No Array
Kein _Array
Pas de _Tableau
Sin _Array
;
MSG_MUICLASS_IMEX_NOARRAY_HELP
Do not export a string array along with this target.
Keine Texttabelle mit dem aktuellen Ziel exportieren.
Ne pas exporter un tableau de chaînes avec cette cible.
No exportar array de texto junto al objetivo.
;
MSG_MUICLASS_IMEX_NOSTRINGS_GAD
No _Strings
Keine Te_xte
Pas de C_haînes
Sin Texto
;
MSG_MUICLASS_IMEX_NOSTRINGS_HELP
Do not export strings along with this target.
Keine Texte mit dem aktuellen Ziel exportieren.
Ne pas exporter les chaînes avec cette cible.
No exportar texto junto al objetivo.
;
MSG_MUICLASS_IMEX_NOBLOCK_GAD
No Block
_Kein Block
Pas de _Bloc
Sin Bloque
;
MSG_MUICLASS_IMEX_NOBLOCK_HELP
Do not export text block along with this target.
Keinen Textblock mit dem aktuellen Ziel exportieren.
Ne pas exporter le bloc texte avec cette cible.
No exportar bloque de texto junto al objetivo.
;
MSG_MUICLASS_IMEX_NOBLOCKSTATIC_GAD
No Static Block
Kein statischer _Block
Pas de Bloc Stati_que
Sin bloque estático
;
MSG_MUICLASS_IMEX_NOBLOCKSTATIC_HELP
Do not export block as static.
Den Textblock nicht als "static" exportieren.
Ne pas exporter le bloc comme statique.
No exportar bloque como estático.
;
MSG_MUICLASS_IMEX_CANCEL_GAD
_Cancel
_Abbrechen
_Annuler
_Cancelar
;
MSG_MUICLASS_IMEX_CANCEL_HELP
Abort the current process.
Den aktuellen Vorgang abbrechen.
Annule le travail en cours.
Abortar el proceso.
;
MSG_MUICLASS_IMEX_Import_GAD
_Import
_Importieren
_Importer
_Importar
;
MSG_MUICLASS_IMEX_Import_HELP
Starts import.
Startet den Importiervorgang.
Démarre l'importation des données.
Comienza a importar.
;
MSG_MUICLASS_IMEX_Export_GAD
_Export
_Exportieren
_Exporter
_Exportar
;
MSG_MUICLASS_IMEX_Export_HELP
Starts export.
Startet den Exportiervorgang.
Démarre l'exportation des données.
Comienza a exportar.
;
MSG_MUICLASS_IMEX_Unknown
Unknown
Unbekannt
Inconnu
Desconocido
;
; ### SCPrefs Class (muiclass_scprefs.c)
;
MSG_MUICLASS_SCPREFS_TitleWindow
SimpleCat - Preferences
SimpleCat - Voreinstellungen
SimpleCat - Préférences
Ajustes - SimpleCat
;
MSG_MUICLASS_SCPREFS_GENERAL_GROUP
General Preferences
Generelle Einstellungen
Préférences générales
Ajustes Generales
;
MSG_MUICLASS_SCPREFS_DEVELOPERMODE_GAD
_Developer mode
_Entwicklermodus
Mode _développeur
Modo _Desarrollador
;
MSG_MUICLASS_SCPREFS_DEVELOPERMODE_HELP
This option enables additional functions not needed by a normal translator.
Diese Option aktiviert zusätzliche Funktionen, die ein normaler Übersetzer nicht benötigt.
Cette option active des fonctions non nécessaires pour un traducteur standard.
Activa funciones adicionales que un traductor normal no suele necesitar.
;
MSG_MUICLASS_SCPREFS_AUTOSAVEPATH_GAD
_Auto-save paths on exit
_Pfade beim Beenden sichern
Enregistrement des c_hemins
Guardar rutas al salir
;
MSG_MUICLASS_SCPREFS_AUTOSAVEPATH_HELP
This option forces SimpleCat to store and reload paths used in previous sessions.
Bei aktivierter Option werden die benutzten Pfade beim Beenden Gespeichert und stehen nach dem Neustart wieder zur Verfügung.
Cette fonction force SimpleCat à enregistrer et à recharger les chemins des fichiers utilisés lors des sessions précédentes.
Opción que obliga a SimpleCat a almacenar y cargar nuevamente las rutas empleadas en sesiones previas.
;
MSG_MUICLASS_SCPREFS_SAFETYREQONEXIT_GAD
Confirmation requester
Sicherheitsrequester
_Requête de confirmation
Petición de Confirmación
;
MSG_MUICLASS_SCPREFS_SAFETYREQONEXIT_HELP
Avoids accidental exit of SimpleCat by putting up a requester that must be confirmed.
Verhindert, das SimpleCat versehentlich beendet wird. Ein Sicherheitsabfrage erscheint und muss bestätigt werden.
Permet d'éviter les sorties non désirées de SimpleCat en ouvrant une requête de confirmation.
Evita salir accidentalmente de SimpleCat mostrando una petición que debe confirmar.
;
MSG_MUICLASS_SCPREFS_DISPLAY_GROUP
Display Options
Darstellungsoptionen
Options d'affichage
Opciones Visuales
;
MSG_MUICLASS_SCPREFS_SHOWCOMMENTS_GAD
Show C_omments
Zeige _Kommentare
C_ommentaires
Mostrar Comentarios
;
MSG_MUICLASS_SCPREFS_SHOWCOMMENTS_HELP
This options enables display of comments from the .cs file in the item list.
Diese Option erlaubt das Anzeigen von Kommentaren in der Zeilenliste.
Cette option active l'affichage dans la liste des commentaires inclus dans le fichier .cs.
Opción que permite mostrar los comentarios de un fichero .cs en la lista.
;
MSG_MUICLASS_SCPREFS_SHOWCOMMENTSEMPTY_GAD
Show _Empty Comments
Zeige _leere Kommentare
Commentaires _vides
Mostrar Comentarios Vacíos
;
MSG_MUICLASS_SCPREFS_SHOWCOMMENTSEMPTY_HELP
Normally empty comments are used as separators only. This option make them visible.
Normalerweise dienen leere Kommentarzeilen nur zu Zeilentrennung. Mit dieser Option werden auch diese Zeilen sichtbar.
Normalement les commentaires vides sont utilisés uniquement comme séparateurs. Cette option les rend visibles.
Los comentarios vacíos suelen utilizarse sólo como separadores. Esta opción los hace visibles.
;
MSG_MUICLASS_SCPREFS_SHOWCODE_GAD
_Show Code
Zeige _Programmtext
_Code
Mostrar Código
;
MSG_MUICLASS_SCPREFS_SHOWCODE_HELP
This options enables display of code lines in the item list.
Diese Option erlaubt das Anzeigen von Programmzeilen in der Zeilenliste.
Cette option active l'affichage des lignes du code dans la liste.
Opción que permite mostrar líneas de código de la lista.
;
MSG_MUICLASS_SCPREFS_SHOWCHUNK_GAD
Show Chunk
Zeige Chunk
_En-tête
Mostrar Chunk
;
MSG_MUICLASS_SCPREFS_SHOWCHUNK_HELP
This options enables display of chunk lines in the item list.
Diese Option erlaubt das Anzeigen von Chunk-Zeilen in der Zeilenliste.
Cette option active l'affichage des lignes d'en-tête dans la liste.
Opción que permite mostrar líneas chunk de la lista.
;
MSG_MUICLASS_SCPREFS_SHOWTRANSLATION_GAD
Show _Translation
_Zeige Übersetzung
_Traduction
Mostrar _Traducción
;
MSG_MUICLASS_SCPREFS_SHOWTRANSLATION_HELP
This options enables display of translations in the item list. It usually makes no sense to disable that.
Diese Option erlaubt das Anzeigen von Übersetzungen. Normalerweise macht es keinen Sinn, diese nicht anzuzeigen.
Cette option active l'affichage des traductions dans la liste. Généralement, cela n'a aucun sens de la désactiver.
Activa la muestra de traducciones en la lista. No tiene sentido desactivarlo.
;
MSG_MUICLASS_SCPREFS_SHOWVERSIONID_GAD
Show _Version ID
Zeige _Versions-ID
_Identifiant de version
Mostrar ID de _Versión
;
MSG_MUICLASS_SCPREFS_SHOWVERSIONID_HELP
This options enables display of version ID lines in the item list.
Diese Option erlaubt das Anzeigen von Versions-ID-Zeilen in der Zeilenliste.
Cette option active l'affichage de l'identifiant de version dans la liste.
Activa la muestra de las líneas de ID de Versión en la lista.
;
MSG_MUICLASS_SCPREFS_SAVE_GAD
_Save
_Speichern
Enregi_strer
Guardar
;
MSG_MUICLASS_SCPREFS_SAVE_HELP
Settings will be saved and the window will be closed.
Einstellungen werden gespeichert und das Fenster wird geschlossen.
Les préférences seront enregistrées et la fenêtre fermée.
Guarda los ajustes y cierra la ventana.
;
MSG_MUICLASS_SCPREFS_USE_GAD
_Use
_Benutzen
_Utiliser
_Utilizar
;
MSG_MUICLASS_SCPREFS_USE_HELP
Settings will be used and the window will be closed.
Einstellungen werden benutzt und das Fenster wird geschlossen.
Les préférences seront utilisées et la fenêtre fermée.
Utiliza los ajustes y cierra la ventana.
;
MSG_MUICLASS_SCPREFS_CANCEL_GAD
_Cancel
_Abbrechen
_Annuler
_Cancelar
;
MSG_MUICLASS_SCPREFS_CANCEL_HELP
Settings will be rejected and the window will be closed.
Die Einstellungen werden verworfen und das Fenster wird geschlossen.
Les préférences ne seront pas modifiées et la fenêtre fermée.
Omite los ajustes y cierra la ventana.
;
; ### Sourcesnoop class (muiclass_sourcesnoop.c)
;
MSG_MUICLASS_SOURCESNOOP_TitleWindow
SimpleCat - Localization Wizard
SimpleCat - Lokalisierungs-Assistent
SimpleCat - Assistant de localisation
SimpleCat - Ayuda a la Localización
;
MSG_MUICLASS_SOURCESNOOP_SEARCH_GROUP
Search
Suche
Recherche
Búsqueda
;
MSG_MUICLASS_SOURCESNOOP_SOURCENAME_GAD
_Sourcecode:
_Quellkode:
C_ode source :
Código Fuente:
;
MSG_MUICLASS_SOURCESNOOP_SOURCENAME_HELP
This file will be searched for strings.
Diese Datei wird auf Texte durchsucht.
Les chaînes seront recherchées dans ce fichier.
Buscará en este fichero en busca de texto.
;
MSG_MUICLASS_SOURCESNOOP_PROCESS_GROUP
Processing
Bearbeiten
Travail en cours
Procesando
;
MSG_MUICLASS_SOURCESNOOP_LINEFILTER_GAD
_Line pattern:
_Zeilenfilter:
Motif (_ligne du code) :
Patrón de Línea:
;
MSG_MUICLASS_SOURCESNOOP_LINEFILTER_HELP
This pattern that will used for elements that should not be used as locale string.\nThe entire source line will be compared with pattern.
Dieses Pattern wird dazu benutzt um die Texte zu ermitteln, die nicht lokalisiert werden sollen.\nDie gesamte Quelltextzeile wird mit der Maske verglichen.
Ce filtre est utilisé pour les élements qui ne doivent pas être considérés comme une chaîne à localiser.\nLa ligne entière du code source sera comparée avec ce motif.
Patrón a emplear para aquellos elementos que no suelen emplearse como texto.\nComparará toda la línea de código fuente con el patrón.
;
MSG_MUICLASS_SOURCESNOOP_TYPESTRING_GAD
String _type:
_Texttyp:
C_haîne de type :
_Tipo de Cadena:
;
MSG_MUICLASS_SOURCESNOOP_TYPESTRING_HELP
Normally strings are enclosed in "", but some languages\nuse different characters as string container. This gadget allows to adjust them.
Normalerweise werden Texte in Gänsefüßchen gesetzt, aber\neinige Programmiersprachen nutzen andere Zeichen um die Textinformationen\neinzuschließen. Dieses Gadget erlaubt das Einstellen des \
zubenutzenden Zeichens.
Normalement, les chaînes sont incluses entre guillemets,\nmais quelques langages de programmation utilisent des apostrophes.\nCette option permet de choisir.
Los textos suelen ir entre"", pero algunos lenguajes\nutilizan caracteres diferentes como contenedores. Ajústelos desde este artefacto.
;
MSG_MUICLASS_SOURCESNOOP_TEXTFILTER_GAD
Text _pattern:
Text_filter:
Motif (_chaîne)
_Patrón de Texto:
;
MSG_MUICLASS_SOURCESNOOP_TEXTFILTER_HELP
This pattern that will used for elements that should not be used as locale string.\nJust the string part will be compared with pattern.
Dieses Pattern wird dazu benutzt um die Texte zu ermitteln, die nicht lokalisiert werden sollen.\nNur der Textteil wird mit der Maske verglichen.
Ce filtre est utilisé pour les éléments qui ne doivent pas être considérés comme des chaînes à localiser.\nSeules les chaînes de texte seront comparées à ce motif.
Patrón que se empleará para elementos que no deberían ser utilizados como texto.\nSólo la parte de la cadena será contrastada con el patrón.
;
MSG_MUICLASS_SOURCESNOOP_MINLENGTH_GAD
_Minimum length:
_Minimale Länge:
Taille _min. texte :
Longitud _Mínima:
;
MSG_MUICLASS_SOURCESNOOP_MINLENGTH_HELP
Text which are smaller than this will be automatically removed from list.
Alle Texte die kleiner als die hier definierte Größe sind, werden automatisch aus der Liste entfernt.
Tout texte de plus petite longueur que cette valeur sera automatiquement supprimé de la liste.
Eliminará del texto todas aquellas cadenas que sean inferiores a este valor.
;
MSG_MUICLASS_SOURCESNOOP_LABELFORMAT_GAD
Label f_ormat:
_Bezeichnerformat:
_Format étiquette :
Formato de Etiqueta:
;
MSG_MUICLASS_SOURCESNOOP_LABELFORMAT_HELP
Here you can specify the format of the label set. '%s' represents the part which gets replaced by the string.
Hier kann angegeben werden, wie der Label aussehen soll. '%s' gibt den Teil an, der durch den String ersetzt wird.
Indiquez ici le format des étiquettes. '%s' représente la partie qui sera remplacée par la chaîne.
Aquí podrá indicar el formato del juego de etiquetas. '%s' representa la porción que es reemplazada por el texto.
;
MSG_MUICLASS_SOURCESNOOP_LABELLENGTH_GAD
Label len_gth:
ma_ximale Bezeichnerlänge:
Taille ma_x. de l'étiquette :
Longitud de Etiqueta:
;
MSG_MUICLASS_SOURCESNOOP_LABELSIZE_HELP
Defines the maximum length of the created label. This size does not include the additional characters added by "Label Format" gadget.
Definiert die maximale Länge des Bezeichners. Diese Länge beinhaltet nicht die zusätzlichen Zeichen die im Textfeld "Bezeichnerformat" hinzugefügt werden.
Définit la longueur maximum de l'étiquette créée. Cette taille ne comprend pas les caractères additionnels ajoutés par l'option "Format étiquette".
Define la longitud máxima de la etiqueta creada. El tamaño no incluye caracteres adicionales añadidos por la opción "Label Format".
;
MSG_MUICLASS_SOURCESNOOP_STRINGSFOUND_HELP
This list contains all strings found in the specified source code.
Diese Liste enthält alle Texte, die in der spezifizierten Datei gefunden wurde.
Cette liste contient toutes les chaînes trouvées dans le code source spécifié.
Listado con todas las cadenas encontradas en el código fuente.
;
MSG_MUICLASS_SOURCESNOOP_LABEL_GAD
Lab_el:
_Bezeichner:
Éti_quette :
Etiqueta
;
MSG_MUICLASS_SOURCESNOOP_LABEL_HELP
The label of the current text may be edited here.
Hier kann der Bezeichner des aktuellen Textes geändert werden.
L'étiquette du champ sélectionné peut être modifiée ici.
Etiqueta del texto actual a editar.
;
MSG_MUICLASS_SOURCESNOOP_REMOVE_GAD
_Remove
_Entfernen
_Supprimer
Eliminar
;
MSG_MUICLASS_SOURCESNOOP_REMOVE_HELP
Remove string from list.
Text aus der Liste entfernen.
Supprime le champ sélectionné de la liste.
Eliminar texto de la lista.
;
MSG_MUICLASS_SOURCESNOOP_REMOVEINVALID_GAD
Remove _invalid
_Ungültige Entfernen
S_upprimer non valides
Eliminar no válidas
;
MSG_MUICLASS_SOURCESNOOP_REMOVEINVALID_HELP
Any invalid string item will be removed from list.
Alle ungültigen Einträge werden aus der Liste entfernt.
Les entrées non valides seront supprimées de la liste.
Eliminará de la lista cualquier entrada de texto no válida.
;
MSG_MUICLASS_SOURCESNOOP_NONE_GAD
All _valid
Alle _gültig
Toutes _valides
Todas Válidas
;
MSG_MUICLASS_SOURCESNOOP_NONE_HELP
All strings in list are marked as valid.
Alle Einträge der Liste werden als gültig markiert.
Toutes les entrées seront marquées comme valides.
Marca todas las entradas como válidas.
;
MSG_MUICLASS_SOURCESNOOP_ALL_GAD
All invali_d
A_lle ungültig
Toutes _non valides
Todas no válidas
;
MSG_MUICLASS_SOURCESNOOP_ALL_HELP
All entries get marked as invalid.
Alle Einträge der Liste werden als ungültig markiert.
Toutes les entrées seront marquées comme non valides.
Marca todas las entradas como no válidas.
;
MSG_MUICLASS_SOURCESNOOP_APPLY_GROUP
Apply data
Daten übernehmen
Intégration des données
Aplicar datos
;
MSG_MUICLASS_SOURCESNOOP_BACKUPMODE_GAD
_Backup mode
_Sicherungsmodus
Mode sauve_garde
Modo _Backup
;
MSG_MUICLASS_SOURCESNOOP_BACKUPMODE_HELP
In backup mode SimpleCat is not replacing the source. It will create a new file with ".bak" added to filename.
Im Sicherungsmodus überschreibt SimpleCat die Quellkodes nicht, sondern fügt den Dateinamen mit Zusatz ".bak" hinzu.
En mode sauvegarde, SimpleCat ne modifie pas le fichier source. Il créé un fichier de même nom suivi de l'extension ".bak".
En modo Backup SimpleCat no sustituye el código fuente. Creará un nuevo fichero con ".bak" como nueva extensión.
;
MSG_MUICLASS_SOURCESNOOP_APPLYCS_GAD
Apply to _CS
In _CS übernehmen
_Appliquer au CS
Aplicar a CS
;
MSG_MUICLASS_SOURCESNOOP_APPLYCS_HELP
Integrate strings into current .CS database.
Strings in aktuelle .CS Datenbank übernehmen.
Intègre les chaînes dans la base de données courante .CS.
Integrar cadenas de texto en la base de datos .CS actual.
;
MSG_MUICLASS_SOURCESNOOP_APPLYCODE_GAD
Apply _to code
I_n Code übernehmen
A_ppliquer au code source
Aplicar al código
;
MSG_MUICLASS_SOURCESNOOP_APPLYCODE_HELP
Replaces all strings in source by inserting a C function.\nMake sure you set up a proper function name for the project within\nthe CS preferences. By default "GetString()" is used.
Die Texte im Quellcode werden durch eine C-Funktion ersetzt.\nStellen Sie sicher, dass der für dieses Projekt gewünschte\nFunktionsname in den CS Voreinstellungen definiert ist.\nVoreingestellt ist \
"GetString()".
Remplace toutes les chaînes du code source par une fonction C.\nEn mode développeur, définissez un nom correct de fonction dans\nles préférences CS. Par défaut "GetString()" est utilisé.
Reemplaza todas las cadenas del fuente insertando una función C.\nAjuste correctamente el nombre de la función para el proyecto\nen los ajustes de CS. Por defecto se emplea "GetString()".
;
MSG_MUICLASS_SOURCESNOOP_SCANSOURCE_ASLTITLE
Scan source code
Quellcode scannen
Code source à analyser
Analizar código fuente
;
MSG_MUICLASS_SOURCESNOOP_CY_TYPESTRING
"string"
"text"
"chaîne"
"texto"
;
MSG_MUICLASS_SOURCESNOOP_CY_TYPECHAR
'string'
'text'
'chaîne'
'texto'
;
; ### Search class (muiclass_search.c)
;
MSG_MUICLASS_SEARCH_TitleWindow
SimpleCat - Search
SimpleCat - Suche
SimpleCat - Recherche
SimpleCat - Búsqueda
;
MSG_MUICLASS_SEARCH_Pattern_GAD
_Pattern
_Muster
_Motif
_Patrón
;
MSG_MUICLASS_SEARCH_Pattern_HELP
Pattern to search for in database. AmigaDOS patterns like #? are allowed.
Muster nach dem in der Datenbank gesucht werden soll. AmigaDOS muster wie #? werden unterstützt.
Motif à rechercher dans la base de données. Les jokers AmigaDOS du type #? sont autorisés.
Patrón de búsqueda en la base de datos. Permite patrones AmigaDOS del estilo #?.
;
MSG_MUICLASS_SEARCH_Language_GAD
_Language
_Sprache
_Langue
_Lenguaje
;
MSG_MUICLASS_SEARCH_Language_HELP
Specifies the language items to search. Any option beside <all> limites search to the specified language.
Hier kann eine spezuelle Sprache gewählt werden, die durchsucht werden soll. <Alle> hebt die Limitierung auf.
Indique dans quelle localisation chercher. Toute option autre que <Tout> limite la recherche à la langue spécifiée.
Indica los elementos de lenguaje a buscar. Toda opción entre <all> limita la búsqueda a ese lenguaje.
;
MSG_MUICLASS_SEARCH_Underscore_GAD
_Filter Underscore
_Unterstrich filtern
_Filtrer les tirets bas
_Filtrar Guión bajo
;
MSG_MUICLASS_SEARCH_Underscore_HELP
Before comparing with pattern all "_" are removed, so the pattern "foobar" will find "foo_bar"
Bevor das Muster verglichen wird, werden alle Unterstriche entfernt. Das Muster "foobar" findet also "foo_bar"
Permet d'ignorer tous les "_" : la recherche du motif "foobar" trouvera aussi "foo_bar" par exemple
Antes de confrontar con el patrón, se eliminan todos los "_", de modo que el patrón "foobar" encontrará "foo_bar"
;
MSG_MUICLASS_SEARCH_CaseSensitive_GAD
_Case Sensitive
_Groß/Klein beachten
_Sensible à la casse
Importan Masyúsculas
;
MSG_MUICLASS_SEARCH_CaseSensitive_HELP
Normaly the case is ignored, so "FOO" is equal to "foo". This option allows to separate them.
Normalerweise wird die Groß/Kleinschrift nicht beachtet und "FOO" ist identisch mit "foo". Diese Option ändert das.
Par défaut la casse est ignorée, "FOO" et "foo" sont équivalents. Cette option permet de les distinguer.
Se suelen ignorar las myúsculas, y "FOO" será igual que "foo". Esta opción permite diferenciarlas.
;
MSG_MUICLASS_SEARCH_Comments_GAD
Co_mments
_Kommentare
_Commentaires
Comentarios
;
MSG_MUICLASS_SEARCH_Comments_HELP
Activates the comment search. Normally comment lines will be skipped.
Aktiviert die Suche in Kommentarzeilen. Ansonsten werden Kommentarzeilen ignoriert.
Active la recherche dans les commentaires. Par défaut les lignes de commentaires sont ignorées.
Activa la búsqueda de comentario. Normalmente esta búsqueda se omite.
;
MSG_MUICLASS_SEARCH_Results_GAD
Results
Resultate
Résultats
Resultados
;
MSG_MUICLASS_SEARCH_Results_HELP
List contains all matching entries in database.
In der Datenbank gefundene Texte, die auf das Muster passen.
Cette liste contient toutes les entrées de la base de données correspondant à la recherche.
Listado con todas las entradas concordantes en la base de datos.
;
MSG_LV_CONTEXT
Context
Kontext
Contexte
Contexto
;
MSG_ALL
All
Alle
Tout
Todas
;
MSG_LABELS
Labels
Bezeichner
Étiquettes
Etiquetas
;
##ifndef __MORPHOS__
;
MSG_MUICLASS_About_TitleWindow
About
Über
À propos
Acerca de
;
MSG_MUICLASS_About_Programming
Programming:
Programmierung:
Programmation :
Programación:
;
MSG_MUICLASS_About_Translation
Translation:
Übersetzungen:
Traduction :
Traducción:
;
MSG_MUICLASS_About_ThanksTo
Thanks to:
Dank an:
Remerciements :
Gracias a:
;
MSG_About_SpecialThanksTo
Special thanks to:
Besonderer Dank an:
Remerciements spécifiques :
Agradecimientos especiales a:
;
MSG_MUICLASS_About_Documentation
Documentation:
Dokumentation:
Documentation :
Documentación:
;
MSG_MUICLASS_About_Icons
Icons:
Piktogramme:
Icônes :
Iconos:
;
MSG_MUICLASS_About_Website
Website:
Web-Support:
Site Internet :
Sitio web:
;
MSG_MUICLASS_About_Graphics
Graphics:
Grafiken:
Graphismes :
Gráficos:
;
MSG_MUICLASS_About_OK_GAD
_Ok
_Ok
_Fermer
Aceptar
;
MSG_MUICLASS_About_OK_HELP
Closes this window.
Schließt dieses Fenster.
Ferme cette fenêtre.
Cierra esta ventana.
;
##endif __MorphOS__
;
