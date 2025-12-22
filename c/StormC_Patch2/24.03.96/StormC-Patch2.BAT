ECHO "StormC wird gepatcht!"
StormC-Patch2
ECHO ""
ECHO ""
ECHO "STORM.LIB wird gepatcht!"
rename StormC:LIB/Storm.Lib StormC:LIB/Storm.Lib.backup
copy Storm.Lib StormC:LIB
