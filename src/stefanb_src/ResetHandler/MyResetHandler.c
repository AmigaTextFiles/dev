/*
 * MyResetHandler.c  V1.0
 *
 * Main program
 *
 * (c) 1991-93 Stefan Becker
 *
 */
#include "ResetHandler.h"

/* Data */
static const char Version[]="$VER: MyResetHandler V1.0 (" __COMMODORE_DATE__
                            ")";
static const char Name[]="MyResetHandler V1.0, © 1991-93 Stefan Becker";
struct Interrupt MyInt;

/* Reset Handler code */
__geta4 void ResetHandler(void)
{
 ColdReboot();
}

/* Main program */
int _main()
{
 struct MsgPort *kp;

 /* Create message port for keyboard.device */
 if (kp=CreateMsgPort()) {
  struct IOStdReq *kior;

  /* Create I/O request for keyboard.device */
  if (kior=CreateIORequest(kp,sizeof(struct IOStdReq))) {

   /* Open keyboard.device */
   if (!OpenDevice("keyboard.device",0,(struct IORequest *) kior,0)) {

    /* Set up data for the reset handler */
    MyInt.is_Node.ln_Name=Name;
    MyInt.is_Node.ln_Pri=32;    /* Highest priority */
    MyInt.is_Code=ResetHandler;

    /* Add reset handler */
    kior->io_Data=&MyInt;
    kior->io_Command=KBD_ADDRESETHANDLER;
    DoIO((struct IORequest *) kior);

    /* Wait until break signal */
    Wait(SIGBREAKF_CTRL_C);

    /* Remove reset handler */
    kior->io_Data=&MyInt;
    kior->io_Command=KBD_REMRESETHANDLER;
    DoIO((struct IORequest *) kior);

    CloseDevice((struct IORequest *) kior);
   }
   DeleteIORequest(kior);
  }
  DeleteMsgPort(kp);
 }

 /* All OK */
 return(0);
}
