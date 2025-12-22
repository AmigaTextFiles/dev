Echo "Alte Version StormC:StormSYS/StormC"
Version StormC:StormSYS/StormC full
ECHO ""
ECHO "StormC wird gepatcht!"
StormC-Patch3
ECHO ""
Echo "Neue Version StormC:StormSYS/StormC"
Version StormC:StormSYS/StormC full
ECHO ""
ECHO ""
ECHO ""
ECHO "Alte Version StormC:StormSYS/StormLink"
Version StormC:StormSYS/StormLink full
ECHO ""
ECHO "StormLink wird gepatcht!"
StormLink-Patch2
ECHO ""
ECHO "Neue Version StormC:StormSYS/StormLink"
Version StormC:StormSYS/StormLink full
ECHO ""
ECHO ""
rename StormC:LIB/Storm.LIB StormC:LIB/StormLIB.BACKUP
:C/LHA x StormLib.LHA StormC:LIB
ECHO ""
ECHO "Installation der Patches abgeschlossen!"