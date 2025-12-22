/*
 * PrintPkt.C - This doesn't do much, it takes a packet type (number) and
 *     gives you something more readable on stdout.
 *
 *       Phillip Lindsay (c) 1987 Commodore-Amiga Inc. 
 * You may use this source as long as the copyright notice is left intact.
 * 
 * Modified to print details of packet contents
 *    by Davide P. Cervone, 4/25/87
 */

#include <exec/types.h>
#include <libraries/dosextens.h>

/*
 *  packet types
 */

#define _ACTION_NIL                0L
#define _ACTION_GET_BLOCK          2L
#define _ACTION_SET_MAP            4L
#define _ACTION_DIE                5L
#define _ACTION_EVENT              6L
#define _ACTION_CURRENT_VOLUME     7L
#define _ACTION_LOCATE_OBJECT      8L
#define _ACTION_RENAME_DISK        9L
#define _ACTION_FREE_LOCK         15L
#define _ACTION_DELETE_OBJECT     16L
#define _ACTION_RENAME_OBJECT     17L
#define _ACTION_MORE_CACHE        18L
#define _ACTION_COPY_DIR          19L
#define _ACTION_WAIT_CHAR         20L
#define _ACTION_SET_PROTECT       21L
#define _ACTION_CREATE_DIR        22L
#define _ACTION_EXAMINE_OBJECT    23L
#define _ACTION_EXAMINE_NEXT      24L
#define _ACTION_DISK_INFO         25L
#define _ACTION_INFO              26L
#define _ACTION_FLUSH             27L
#define _ACTION_SET_COMMENT       28L
#define _ACTION_PARENT            29L

/*
 *  This is normally a returning timer device request. (internal)
 */
#define _ACTION_TIMER             30L

#define _ACTION_INHIBIT           31L
#define _ACTION_DISK_TYPE         32L
#define _ACTION_DISK_CHANGE       33L
#define _ACTION_SET_FILE_DATE     34L
#define _ACTION_READ              82L
#define _ACTION_WRITE             87L
#define _ACTION_SET_SCREEN_MODE  994L

/*
 * When a handler internally sends a device i/o request they are sent using
 * their process port and in the form of a "packet" the packet types below:
 * (ACTION_TIMER above also falls into this catagory)
 */
#define _ACTION_READ_INTERNAL   1001L   
#define _ACTION_WRITE_INTERNAL  1002L   

#define _ACTION_FIND_INPUT      1005L
#define _ACTION_FIND_OUTPUT     1006L
#define _ACTION_CLOSE           1007L
#define _ACTION_SEEK            1008L


/*
 *  Short-hand for the parts of the DosPacket
 */
#define ARG1    pkt->dp_Arg1
#define ARG2    pkt->dp_Arg2
#define ARG3    pkt->dp_Arg3
#define ARG4    pkt->dp_Arg4
#define RES1    pkt->dp_Res1

#define BCPL(s,p)   ((struct s *)(((ULONG)p)<<2))



int Dump_OK = TRUE;    /* it's OK to perform HEX dumps for long data buffers */
int Lock_OK = TRUE;    /* it's OK to print LOCKs */

/*
 *  printall()
 *
 *  Prints all the important parts of a DosPacket when we don't know
 *  what they are.
 */

void printall(s,pkt)
char *s;
struct DosPacket *pkt;
{
   printf("%s (%X,%X,%X) Returning: %X\n",s,ARG1,ARG2,ARG3,RES1);
}


/*
 *  printINT()
 *
 *  Prints a label and an integer in decimal notation.
 */

void printINT(s,i)
char *s;
int i;
{
   printf("   %s: %d",s,i);
}


/*
 *  printBOOL()
 *
 *  Prints return values as OK or FALSE
 */

void printBOOL(b)
int b;
{
   printf("   Return: %s\n",(b)? "OK": "FALSE");
}


/*
 *  printX()
 *
 *  Prints a label and HEX value
 */

void printX(s,x)
char *s;
unsigned int x;
{
   printf("   %s: %X",s,x);
}


/*
 *  printQuoted()
 *
 *  Prints a data buffer as a quoted string.  Special characters are shown
 *  as '\n','\r','\t', '\001', etc.
 */

void printQuoted(buf,length)
unsigned char *buf;
int length;
{
   short i;
   unsigned char c, c7;
   char line[200];
   char *s = &line[0];

   for (i=0; i<length; i++)
   {
      c = *(buf++); c7 = c & 0x7F;
      if (c7 < ' ' || c7 > 0x7E)
      {
         switch(c)
         {
            case '\b':
               *s++ = '\\';
               *s++ = 'b';
               break;

            case '\t':
               *s++ = '\\';
               *s++ = 't';
               break;

            case '\r':
               *s++ = '\\';
               *s++ = 'r';
               break;

            case '\n':
               *s++ = '\\';
               *s++ = 'n';
               break;

            default:
               sprintf(s,"\\%03o",c);
               s += 4;
               break;
         }
      } else {
         if (c == '"' || c == '\\') *s++ = '\\';
         *s++ = c;
      }
   }
   *s = '\0';
   printf("\"%s\"",line);
}


/*
 *  printDump()
 *
 *  Prints a data buffer in HEX dump format with ASCII equivalents.
 *  Non-printing characters are shown as '.'  Only the first 80 characters 
 *  are displayed.
 */

void printDump(buf,length)
unsigned char *buf;
unsigned int length;
{
   short i,j,count;
   int l = (length > 80)? 80: length;
   unsigned char c, c7;
   char line[40];

   line[39] = '\0';
   count = 0;
   printf("\n");
   for (i=l/8; i>=0; i--)
   {
      for (j=0; j<39; j++) line[j] = ' ';
      for (j=0; j<8 & count<l; j++,count++)
      {
         c = *(buf++); c7 = c & 0x7F;
         sprintf(&line[j*3],"%02X ",c);
         sprintf(&line[j+26],"%c ",(c7 < ' ' || c7 > 0x7E)? '.': c);
      }
      line[24] = ' ';
      printf("\n         %s",line);
   }
   if (l < length) printf("\n                 [more]\n"); else printf("\n");
}


/*
 *  printBUF()
 *
 *  Prints a data buffer as a quoted string (if it is small enough)
 *  or as a HEX dump (if it is big).
 */

void printBUF(s,buf,length)
char *s;
unsigned char *buf;
unsigned int length;
{
   printf("   %s: ",s);
   if (length <= 50)
      printQuoted(buf,length);
     else
      if (Dump_OK) printDump(buf,length);
}


/*
 *  printBSTR()
 *
 *  Prints the contents of a BCPL string buffer
 */

void printBSTR(s1,s2)
char *s1,*s2; 
{
   printBUF(s1,BADDR(s2)+1,(long)(*((char *)BADDR(s2))));
}

/*
 *  printBPTR()
 *
 *  Prints the contents of a buffer pointed to by a BPTR
 */

#define printBPTR(s,b,l)    printBUF(s,BADDR(b),l)


/*
 *  printLOCK()
 *
 *  Prints the name of the file locked by a FileLock.  DON'T ATTEMPT TO
 *  MONITOR LOCKS FROIM FILE HANDLERS!  It will put you into a deadlock 
 *  situation:  the handler is waiting for the returned packet from 
 *  PacketWait, and we are waiting for the handler to process our DupLock 
 *  in GetPathFromLock.  Use MONPROC NOLOCK when you want to monitor file
 *  handlers.
 *  Notice that we expect a BPTR to a Lock.
 */

void printLOCK(s,FL)
char *s;
BPTR FL;
{
   struct FileLock *fl = BCPL(FileLock,FL);
   char name[60];

   if (Lock_OK)
   {
      name[0] = '\0';
      if (FL) GetPathFromLock(name,FL);
      printBUF(s,name,strlen(name));
   } else {
      if (fl)
      {
         printBSTR("Lock Volume",BCPL(DeviceList,fl->fl_Volume)->dl_Name);
         printINT("Lock Access",fl->fl_Access);
      } else {
         printf("   Volume: \"\"");
      }
   }

/*
   printX(s,fl);
   if (fl)
   {
      printINT("Key",fl->fl_Key);
      printINT("Access",fl->fl_Access);
      printX("Task",fl->fl_Task);
      printf("\n");
      printBSTR("Volume",BCPL(DeviceList,fl->fl_Volume)->dl_Name);
   }
*/
}


/*
 *  printFH()
 *
 *  Should print the contents of a FileHandle.  Does anyone have a good idea
 *  about what's useful in a Filehandle?
 *  Note that we expect a BPTR to a FileHandle.
 */

void printFH(s,FH)
char *s;
BPTR FH;
{
/*
   struct FileHandle *fh = BCPL(FileHandle,FH);

   if (fh)
   {
      printX("FH Port",fh->fh_Port);
      printX("FH Type",fh->fh_Type);
   }
*/
}


/*
 *  printFIB()
 *
 *  Prints the fib_FileName field of a FileInfoBlock.
 *  Note that we expect a BPTR to a FileInfoBlock.
 */

void printFIB(FIB)
BPTR FIB;
{
   struct FileInfoBlock *fib = BCPL(FileInfoBlock,FIB);

   if (fib)
      printBUF("File Name",&(fib->fib_FileName[1]),fib->fib_FileName[0]);
     else
      printf("   File Name: \"\"");
}


/*
 *  printfINFO()
 *
 *  Prints the volume name from an InfoData structure.
 *  Note that we expect a BPTR to InfoData.
 */

void printINFO(INFO)
BPTR INFO;
{
   struct InfoData *info = BCPL(InfoData,INFO);
   char name[60];

   name[0] = '\0';
   if (info) GetInfoVolume(name,info);
   printBUF("Volume",name,strlen(name));
}


/*
 *  PrintPkt()
 *
 *  Prints the type of packet and the information appropriate to
 *  that packet type (if known).  Packet types and contents are described
 *  in the AmigaDOS Technical Reference Manual, secion 3.8.1.
 */

void PrintPkt(pkt)
struct DosPacket *pkt;
{
   switch(pkt->dp_Type)
   {
      case _ACTION_NIL:
         printall("ACTION_NIL",pkt);
         break;

      case _ACTION_GET_BLOCK:
         printall("ACTION_GET_BLOCK",pkt);
         break;

      case _ACTION_SET_MAP:
         printall("ACTION_SET_MAP",pkt);
         break;

      case _ACTION_DIE:
         printall("ACTION_DIE",pkt);
         break;

      case _ACTION_EVENT:
         printall("ACTION_EVENT",pkt);
         break;

      case _ACTION_CURRENT_VOLUME:
         printall("ACTION_CURRENT_VOLUME",pkt);
         break;

      case _ACTION_LOCATE_OBJECT:
         printf("ACTION_LOCATE_OBJECT (Lock)\n");
         printLOCK("Lock",ARG1);
         printBSTR("Name",ARG2);
         printINT("Mode",ARG3);
         printf("\n");
         printLOCK("NewLock",RES1);
         printf("\n");
         break;

      case _ACTION_RENAME_DISK:
         printf("ACTION_RENAME_DISK\n");
         printBSTR("New Name",ARG1);
         printBOOL(RES1);
         break;

      case _ACTION_FREE_LOCK:
         printf("ACTION_FREE_LOCK\n");
         printLOCK("Lock",ARG1);
         printBOOL(RES1);
         break;

      case _ACTION_DELETE_OBJECT:
         printf("ACTION_DELETE_OBJECT\n");
         printLOCK("Dir Lock",ARG1);
         printBSTR("Name",ARG2);
         printf("\n");
         printBOOL(RES1);
         break;

      case _ACTION_RENAME_OBJECT:
         printf("ACTION_RENAME_OBJECT\n");
         printLOCK("From Lock",ARG1);
         printBSTR("From Name",ARG2);
         printf("\n");
         printLOCK("To Lock",ARG3);
         printBSTR("To Name",ARG4);
         printf("\n");
         printBOOL(RES1);
         break;

      case _ACTION_MORE_CACHE:
         printall("ACTION_MORE_CACHE",pkt);
         break;

      case _ACTION_COPY_DIR:
         printf("ACTION_COPY_DIR (DupLock)\n");
         printLOCK("Lock",ARG1);
         printLOCK("NewLock",RES1);
         printf("\n");
         break;

      case _ACTION_WAIT_CHAR:
         printf("ACTION_WAIT_CHAR\n");
         printINT("Timeout",ARG1);
         printBOOL(RES1);
         break;

      case _ACTION_SET_PROTECT:
         printf("ACTION_SET_PROTECT\n");
         printLOCK("Dir Lock",ARG2);
         printBSTR("Name",ARG3);
         printf("\n");
         printX("Mask",ARG4);
         printBOOL(RES1);
         break;

      case _ACTION_CREATE_DIR:
         printf("ACTION_CREATE_DIR\n");
         printLOCK("Dir Lock",ARG1);
         printBSTR("Name",ARG2);
         printf("\n");
         printLOCK("New Lock",RES1);
         printf("\n");
         break;

      case _ACTION_EXAMINE_OBJECT:
         printf("ACTION_EXAMINE_OBJECT\n");
         printLOCK("Lock",ARG1);
         printFIB(ARG2);
         printBOOL(RES1);
         break;

      case _ACTION_EXAMINE_NEXT:
         printf("ACTION_EXAMINE_NEXT\n");
         printLOCK("Dir Lock",ARG1);
         printFIB(ARG2);
         printBOOL(RES1);
         break;

      case _ACTION_DISK_INFO:
         printf("ACTION_DISK_INFO\n");
         printINFO(ARG1);
         printBOOL(RES1);
         break;

      case _ACTION_INFO:
         printall("ACTION_INFO",pkt);
         break;

      case _ACTION_FLUSH:
         printall("ACTION_FLUSH",pkt);
         break;

      case _ACTION_SET_COMMENT:
         printf("ACTION_SET_COMMENT\n");
         printLOCK("Lock",ARG2);
         printBSTR("Name",ARG3);
         printf("\n");
         printBSTR("Comment",ARG4);
         printBOOL(RES1);
         break;

      case _ACTION_PARENT:
         printf("ACTION_PARENT\n");
         printLOCK("Dir Lock",ARG1);
         printLOCK("Parent",RES1);
         printf("\n");
         break;

      case _ACTION_TIMER:
         printall("ACTION_TIMER",pkt);
         break;

      case _ACTION_INHIBIT:
         printf("ACTION_INHIBIT\n");
         printINT("On/Off",ARG1);
         printBOOL(RES1);
         break;

      case _ACTION_DISK_TYPE:
         printall("ACTION_DISK_TYPE",pkt);
         break;

      case _ACTION_DISK_CHANGE:
         printall("ACTION_DISK_CHANGE",pkt);
         break;

      case _ACTION_SET_FILE_DATE:
         printall("ACTION_SET_FILE_DATE",pkt);
         break;

      case _ACTION_READ:
         printf("ACTION_READ\n");
         printX("Arg1",ARG1);
         printX("Buffer",ARG2);
         printINT("Length",ARG3);
         printINT("Actual Length",RES1);
         printf("\n");
         printBUF("Data",ARG2,RES1);
         printf("\n");
         break;

      case _ACTION_WRITE:
         printf("ACTION_WRITE\n");
         printX("Arg1",ARG1);
         printX("Buffer",ARG2);
         printINT("Length",ARG3);
         printINT("Actual Length",RES1);
         printf("\n");
         printBUF("Data",ARG2,RES1);
         printf("\n");
         break;

      case _ACTION_SET_SCREEN_MODE:
         printall("ACTION_SET_SCREEN_MODE",pkt);
         break;

      case _ACTION_READ_INTERNAL:
         printall("ACTION_READ_INTERNAL",pkt);
         break;

      case _ACTION_WRITE_INTERNAL:
         printall("ACTION_WRITE_INTERNAL",pkt);
         break;

      case _ACTION_FIND_INPUT:
         printf("ACTION_FIND_INPUT\n");
         printFH("File Handle",ARG1);
         printLOCK("Dir Lock",ARG2);
         printBSTR("Name",ARG3);
         printf("\n");
         printBOOL(RES1);
         break;

      case _ACTION_FIND_OUTPUT:
         printf("ACTION_FIND_OUTPUT\n");
         printFH("File Handle",ARG1);
         printLOCK("Lock",ARG2);
         printBSTR("Name",ARG3);
         printf("\n");
         printBOOL(RES1);
         break;

      case _ACTION_CLOSE:
         printf("ACTION_CLOSE\n");
         printX("Arg1",ARG1);
         printBOOL(RES1);
         break;

      case _ACTION_SEEK:
         printf("ACTION_SEEK\n");
         printFH("File Handle",ARG1);
         printINT("Position",ARG2);
         printINT("Mode",ARG3);
         printINT("Old Pos",RES1);
         printf("\n");
         break;

      default:
         printf("Unknown packet: %ld",pkt->dp_Type);
         printall("",pkt);
         break;
  }
}
