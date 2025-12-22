/*
** This demo will load the TEST.CNF config file and then print out
** some of the details in it.  This illustrates how you can use config
** files for user modifications etc.
**
*/

#include <proto/dpkernel.h>
#include <files/files.h>
#include <misc/config.h>
#include <pragmas/config_pragmas.h>

BYTE *ProgName      = "Config Loader";
BYTE *ProgAuthor    = "Paul Manias";
BYTE *ProgDate      = "August 1998";
BYTE *ProgCopyright = "DreamWorld Productions (c) 1998.";
BYTE *ProgShort     = "Tests the configuration module.";

struct Module *ConfigMod;
APTR CNFBase;

struct FileName FName = {
  ID_FILENAME, "TEST.CNF"
};

void main()
{
   LONG result, i;
   BYTE *buffer;
   struct Config *Config;

   if (ConfigMod = OpenModule(MOD_CONFIG,"config.mod")) {
      CNFBase = ConfigMod->ModBase;

      if (Config = InitTags(NULL,
         TAGS_CONFIG, NULL,
         CFA_Source, &FName,
         TAGEND)) {

         /* Use this loop if you want to search an entire
         ** configuration object.
         */

         for(i=NULL; i < Config->AmtEntries; i++) {
            if (Config->Entries[i].Item) {
               DPrintF("!Demo:","Section: %s, Item: %s, Data: \"%s\"",Config->Entries[i].Section,Config->Entries[i].Item,Config->Entries[i].Data);
            }
            else {
               DPrintF("!Demo:","Array: %s",Config->Entries[i].Section);
            }
         }

         /* This function picks up specific fields */

         if (buffer = ReadConfig(Config,"Map","Terrain")) {
            DPrintF("!MAP:Terrain:","%s",buffer);
         }

         if (buffer = ReadConfig(Config,"Map","Width")) {
            DPrintF("!MAP:Width:","%s",buffer);
         }

         /* Read an integer */

         result = ReadConfigInt(Config,"Map","Height");
         DPrintF("!MAP:Height:","%d",result);

         /* Use this method if you want to read an array */

         if ((buffer = ReadConfig(Config,"Waypoints",NULL))) {
            /*DPrintF("!MAP:Waypoints:","%s",buffer);*/
         }
         else DPrintF("!Demo:","Failed to read array from config file.");

      Free(Config);
      }
   Free(ConfigMod);
   }
}

