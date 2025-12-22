
#include <proto/dpkernel.h>
#include <files/all.h>
#include <system/all.h>
#include <misc/config.h>

#include <pragmas/config_pragmas.h>
#include <pragmas/strings_pragmas.h>
#include <pragmas/objects_pragmas.h>

#include "defs.h"

/***********************************************************************************
** Function: PullObject()
** Synopsis: *Object PullObject(*ObjectFile [a0], BYTE *Name [a1]);
*/

LIBFUNC APTR LIBPullObject(mreg(__a0) LONG argObjectFile, mreg(__a1) BYTE *Name)
{
   struct ObjectFile *ObjectFile = (struct ObjectFile *)argObjectFile;
   struct Config     *Config;
   struct Field      *Field;
   struct FileName   *FName;
   struct FieldDef   *Lookup;
   BYTE *Item, *Data, *ClassName, *Temp, *ByteArray;
   APTR Master, Object, Context;
   WORD start, j, i, bracket, *WordArray;
   LONG Number, *LongArray;
   #define COMMA 44

   DPrintF("PullObject()","ObjectFile: $%x, Name: \"%s\"", ObjectFile, Name);

   if ((ObjectFile IS NULL) OR (Name IS NULL)) {
      ErrCode(ERR_ARGS);
      return(NULL);
   }

   Config = ObjectFile->Config;

   /*** Find the place where the named object starts ***/

   for (start=NULL; start < Config->AmtEntries; start++) {
      if (StrCompare(Config->Entries[start].Section, Name, NULL, FALSE) IS TRUE) break;
   }

   /*** Did we succeed in finding a matching name? ***/

   if (start >= Config->AmtEntries) {
      DPrintF("!PullObject:","I could not find object \"%s\".", Name);
      return(NULL);
   }

   /*** Is the ID attached to the object? ***/

   if (StrCompare(Config->Entries[start].Item, "ID", NULL, FALSE) IS FALSE) {
      DPrintF("!PullObject:","I found the object \"%s\" but the ID is not attached.", Name);
      return(NULL);
   }

   /*** Get the object and process the fields ***/

   DPrintF("PullObject:","Processing fields from position %d...", start);

   ClassName = Config->Entries[start].Data;

   if (Master = GetByName(ClassName)) {

      /* Perform the following loop for as long as the Section
      ** matches the object Name that we are processing.
      */

      i = start + 1;
      while ((StrCompare(Config->Entries[i].Section, Name, NULL, FALSE) IS TRUE) AND (i < Config->AmtEntries)) {

         Item   = Config->Entries[i].Item;
         Data   = Config->Entries[i].Data;
         Object = Master;

         /* Check if the Item is accessing a child object.  Keep in
         ** mind that multiple levels could be specified on a single line.
         */

         for (Temp = Item; *Temp != NULL; Temp++) {
            if (*Temp IS '.') {

               *Temp  = NULL;
               Object = (APTR)GetFieldName(Object, Item);

               if (Object IS NULL) {
                  DPrintF("!PullObject:","Could not acquire object %s.",Item);
                  *Temp  = '.';
                  break;
               }

               *Temp  = '.';
               Item = Temp + 1; /* Skip to the next item */
            }
         }

         /*** Try to acquire the field name which has been specified. ***/

         if ((Object) AND (Field = FindField(Object, NULL, Item))) {

            DPrintF("4PullObject:","Acquired item \"%s\"", Item);

            /*** Check for function brackets ***/

            bracket = NULL;
            for (j=0; Data[j] != NULL; j++) {
               if ((bracket IS NULL) AND (Data[j] IS '(')) bracket++;
               else if ((bracket IS 1) AND (Data[j] IS ')') AND (Data[j+1] IS NULL)) bracket++;
            }

            /*** Check for a function call ***/

            if (bracket IS 2) {
               if (StrCompare("Get(", Data, 4, FALSE)) {
                  Data += 4;
                  for (j=0; Data[j] != ')'; j++);
                  Data[j] = NULL;
                  Context = SetContext(Object);
                    SetField(Object, Field->FieldID, (LONG)GetByName(Data));
                  SetContext(Context);
                  Data[j] = ')';
               }
            }

            /*** Check for word, long and byte arrays ***/

            else if ((Field->Flags & FD_BYTEARRAY) OR (StrCompare("[BYTE]", Data, 6, TRUE))) {
               DPrintF("4PullObject:","Detected byte array.");

               /*** Count the amount of commas to get the array size ***/

               Number = 1;
               for (j=0; Data[j] != NULL; j++) {
                  if (Data[j] IS COMMA) Number++;
               }

               Context = SetContext(Object);
                 ByteArray = AllocMemBlock(Number * sizeof(BYTE), MEM_DATA);
                 SetField(Object, Field->FieldID, (LONG)ByteArray);
               SetContext(Context);

               while (*Data) {
                  Number = StrToInt(Data++);
                  *ByteArray++ = (BYTE)Number;
                  while ((*Data != COMMA) AND (*Data != NULL)) Data++;
                  if (*Data IS COMMA) Data++;
               }
            }

            else if ((Field->Flags & FD_WORDARRAY) OR (StrCompare("[WORD]", Data, 6, TRUE))) {
               DPrintF("4PullObject:","Detected word array, Data: $%x.", Data);
               Number = 1;
               for (j=0; Data[j] != NULL; j++) {
                  if (Data[j] IS COMMA) Number++;
               }

               Context = SetContext(Object);
                 WordArray = AllocMemBlock(Number * sizeof(WORD), MEM_DATA);
                 SetField(Object, Field->FieldID, (LONG)WordArray);
               SetContext(Context);

               while (*Data) {
                  Number = StrToInt(Data++);
                  *WordArray++ = (WORD)Number;
                  while ((*Data != COMMA) AND (*Data != NULL)) Data++;
                  if (*Data IS COMMA) Data++;
               }
            }

            else if ((Field->Flags & FD_LONGARRAY) OR (StrCompare("[LONG]", Data, 6, TRUE))) {
               DPrintF("4PullObject:","Detected longword array.");
               Number = 1;

               for (j=0; Data[j] != NULL; j++) {
                  if (Data[j] IS COMMA) Number++;
               }

               Context = SetContext(Object);
                 LongArray = AllocMemBlock(Number * sizeof(LONG), MEM_DATA);
                 SetField(Object, Field->FieldID, (LONG)LongArray);
               SetContext(Context);

               while (*Data) {
                  Number = StrToInt(Data++);
                  *LongArray++ = (LONG)Number;
                  while ((*Data != COMMA) AND (*Data != NULL)) Data++;
                  if (*Data IS COMMA) Data++;
               }
            }

            /*** Check for strings ***/

            else if (Field->Flags & FD_STRING) {
               SetField(Object, Field->FieldID, (LONG)Data);
            }

            /*** Check for flags ***/

            else if (Field->Flags & FD_FLAGS) {
               if (Field->MinRange) {
                  Number = NULL; 
                  while (*Data != NULL) {
                     for (j=0; (Data[j] != NULL) AND (Data[j] != '|'); j++);

                     if (j > 0) {
                        Lookup = (struct FieldDef *)Field->MinRange;
                        while (Lookup->Name != NULL) {
                           if (StrCompare(Lookup->Name, Data, j, FALSE) IS TRUE) {
                              if (StrLength(Lookup->Name) IS j) {
                                 Number |= Lookup->Value;
                              }
                           }
                           Lookup++;
                        }
                     }
                     Data = Data + j + 1;
                  }
                  SetField(Object, Field->FieldID, Number);
               }
               else DPrintF("!PullObject","Missing flag definitions for field \"%s\"", Field->Name);
            }

            /*** Check for source type ***/

            else if (Field->Flags & FD_SOURCE) {
               /* The Source is defined as a string for our purposes, so
               ** we need to convert it to a filename.  Note that this means
               ** making an allocation, but we will use SetContext() to
               ** define memory ownership.
               */

               Context = SetContext(Object);
                 FName       = AllocMemBlock(6 + StrLength(Data) + 1, MEM_DATA);
                 FName->ID   = ID_FILENAME;
                 FName->Name = (BYTE *)(FName + 1);
                 StrCopy(Data, FName->Name, NULL);
               SetContext(Context);
               SetField(Object, Field->FieldID, (LONG)FName);
            }
            else if (Field->Flags & FD_LOOKUP) {
               if (Lookup = (struct FieldDef *)Field->MinRange) {
                  while (Lookup->Name != NULL) {
                     if (StrCompare(Data, Lookup->Name, NULL, FALSE) IS TRUE) {
                        SetField(Object, Field->FieldID, Lookup->Value);
                        break;
                     }
                     Lookup++;
                  }
               }
            }
            else {
               SetField(Object, Field->FieldID, ReadConfigInt(Config, Name, Config->Entries[i].Item));
            }
         }
         else DPrintF("!PullObject:","Invalid field %s in object at $%x", Item, Object);

         i++;
      }

      return(Master);
   }
   else DPrintF("!PullObject:","I could not obtain a \"%s\" structure.", ClassName);

   return(NULL);
}

/***********************************************************************************
** Function: PullObjectList()
** Synopsis: LONG PullObjectList(*ObjectFile [a0], *ObjectEntry [a1]);
** Short:    Calls PullObject() for every object in the list.
*/

LIBFUNC LONG LIBPullObjectList(mreg(__a0) LONG argObjectFile, mreg(__a1) struct ObjectEntry *Entries)
{
  WORD i;
  struct ObjectFile *ObjectFile = (struct ObjectFile *)argObjectFile;

  DPrintF("~PullObjectList","ObjectFile: $%x, ObjectList: $%x", ObjectFile, Entries);

  if (Entries) {
     i = 1; /* Skip the "OBJECTLIST" header */
     while ((Entries[i].Name != (BYTE *)LISTEND) AND (Entries[i].Name != NULL)) {
        Entries[i].Object = PullObject(ObjectFile, Entries[i].Name);

        /* Check for failure.  If a problem has ocurred we will need
        ** to back track and free all of our allocations.
        */

        if (Entries[i].Object IS NULL) {
           i--;
           while (i > 0) {
              Free(Entries[i].Object);
              i--;
           }
           StepBack();
           return(ERR_FAILED);
        }

        i++;
     }

     StepBack();
     return(ERR_OK);
  }
  else { StepBack(); return(ERR_ARGS); }
}

