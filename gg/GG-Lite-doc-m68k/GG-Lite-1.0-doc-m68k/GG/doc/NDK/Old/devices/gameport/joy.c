/* joy.c - gameport.device joystick example - 3/26/90 DART
 * ANSI code, compiled and linked with LATTICE 5.04: lc -L joy
 *
 * Copyright (c) 1990 Commodore-Amiga, Inc.
 *
 * This example is provided in electronic form by Commodore-Amiga, Inc. for
 * use with the 1.3 revisions of the Addison-Wesley Amiga reference manuals. 
 * The 1.3 Addison-Wesley Amiga Reference Manual series contains additional
 * information on the correct usage of the techniques and operating system
 * functions presented in this example.  The source and executable code of
 * this example may only be distributed in free electronic form, via bulletin
 * board or as part of a fully non-commercial and freely redistributable
 * diskette.  Both the source and executable code (including comments) must
 * be included, without modification, in any copy.  This example may not be
 * published in printed form or distributed with any commercial product.
 * However, the programming techniques and support routines set forth in
 * this example may be used in the development of original executable
 * software products for Commodore Amiga computers.
 * All other rights reserved.
 * This example is provided "as-is" and is subject to change; no warranties
 * are made.  All use is at your own risk.  No liability or responsibility
 * is assumed.
 */

#include <exec/types.h>
#include <exec/execbase.h>
#include <exec/devices.h>
#include <devices/gameport.h>
#include <devices/inputevent.h>
#include <libraries/dos.h>

#ifdef LATTICE
#include <proto/all.h>
#include <stdlib.h>
#include <stdio.h>
int CXBRK(void) { return(0); }   /* Disable Lattice CTRL/C handling */
#endif

#define XMOVE 1
#define YMOVE 1

/* our functions */
BOOL set_controller_type(BYTE);
VOID set_trigger_conditions(struct GamePortTrigger *);
VOID send_read_request(VOID);
VOID check_move(VOID);      
VOID flush_buffer(VOID);
VOID free_gp_unit(VOID);

extern struct ExecBase *SysBase; /* for vertical blank frequency info */
struct InputEvent game_event;   /* where input event will be stored */
struct IOStdReq *game_io_msg = NULL;
struct MsgPort  *game_msg_port = NULL;


/* GLOBALS */

/* trigger on all joystick key transitions */
struct GamePortTrigger joytrigger =
{
   GPTF_UPKEYS+GPTF_DOWNKEYS,
   0,
   XMOVE,
   YMOVE
};

UBYTE      hertz;   /* vertical blank frequency */
WORD      codeval,error; 
WORD      button_count, timeouts = 0;
BOOL       not_finished = TRUE;

VOID main(int argc,char **argv)
{
/* Create port for gameport device communications */
if (game_msg_port = CreatePort("RKM_game_port",0))
   {
   /* Create message block for device IO */
   if (game_io_msg = CreateStdIO(game_msg_port))
      {
      /* Open the right/back (unit 1, number 2) gameport.device unit */
      if (!(error=OpenDevice("gameport.device",1,game_io_msg,0)))
         {
         /* Set controller type to joystick */
         if (set_controller_type(GPCT_ABSJOYSTICK)) 
            {
            /* Specify the trigger conditions */
            set_trigger_conditions(&joytrigger);

            printf("\n >>> gameport.device joystick Demo <<<\n\n");

            if (hertz==60)printf(" Running on NTSC system (%u Hz).\n",hertz);
            else if (hertz==50)printf(" Running on PAL system (%u Hz).\n",hertz);

            printf(" Attach joystick to right port (A2000) or  rear port (A1000).\n");
            printf(" Then move joystick and click its button(s).\n\n");
            printf(" To exit program press and release fire button 3 times. \n");
            printf(" The program also exists if no activity occurs for 1 minute.\n\n");

            /* Clear device buffer. There might still be events left */
            flush_buffer(); /* To start from a known state */

            /* From now on, just read input events into the event buffer, 
             * one at a time.  READEVENT waits for the preset conditions. */

            send_read_request(); /* Send the initial gameport read request */

            while( (timeouts < 3) && (not_finished))
               {
               Wait(1L << game_msg_port->mp_SigBit);  /* Wait for joystick action */
               GetMsg(game_msg_port); /* Remove message from message port */

               codeval = game_event.ie_Code;
               switch(codeval) 
                  {
                  case IECODE_LBUTTON:   printf(" FIRE BUTTON PRESSED \n");
                                         break;

                  case (IECODE_LBUTTON | IECODE_UP_PREFIX):
                                         printf(" FIRE BUTTON RELEASED \n");
                                         button_count++;
                                         if (button_count==3)not_finished = FALSE; 
                                         break;

                  case IECODE_NOBUTTON:  timeouts++;   /* Program will timeout after 1 minute */
                                         button_count = 0;
                                         break;

                  default:               break;
                  }
               check_move();    /* Check for change in position */ 

               /* We can now re-use our game_event... Send the next read request */
               send_read_request();
               }
            /********************************************************* 
             * Free gameport unit so other applications can use it ! *
             ********************************************************/
            free_gp_unit();
            }
         CloseDevice( game_io_msg);
         }
      DeleteStdIO(game_io_msg);
      }
   DeletePort(game_msg_port);
   }
exit(0);      
}
/* end of main */

/************************
*  function definitions * --------------------------------------------
************************/
BOOL set_controller_type(BYTE type)
{
BOOL success = FALSE;
BYTE controller_type = 0;

   game_io_msg->io_Command = GPD_ASKCTYPE;    /* inquire current status */
   game_io_msg->io_Length = 1; 
   game_io_msg->io_Flags = IOF_QUICK;
   game_io_msg->io_Data = (APTR)&controller_type; /* put answer in here */

   Forbid(); /* critical section start */
   DoIO(game_io_msg);

   /* No one is using this device unit, let's claim it */
   if (controller_type == GPCT_NOCONTROLLER)
      {
      game_io_msg->io_Command = GPD_SETCTYPE;
      game_io_msg->io_Flags = IOF_QUICK;   
      game_io_msg->io_Length = 1;
      game_io_msg->io_Data = (APTR)&type;
      DoIO( game_io_msg);   
      success = TRUE;
      }
   Permit(); /* critical section end */
   return(success);
}    

VOID set_trigger_conditions(struct GamePortTrigger *gpt)
{
   /* get vertical blank frequency 
    * US = 60 Hz, PAL = 50 Hz */
   hertz = SysBase->VBlankFrequency;

   /* trigger every 20 seconds */
   joytrigger.gpt_Timeout = (UWORD)hertz * 20;

   game_io_msg->io_Command = GPD_SETTRIGGER;   
   game_io_msg->io_Length = (LONG)sizeof(struct GamePortTrigger);   
   game_io_msg->io_Data = (APTR)gpt;   
   DoIO(game_io_msg);   
}

VOID check_move(VOID)      
{
   WORD xmove, ymove;

   xmove = game_event.ie_X;
   ymove = game_event.ie_Y;

   if((xmove) || (ymove))
      {
      printf(" x = %2ld , y = %2ld -->",xmove, ymove);

      if (xmove == 1 && ymove == 0) printf(" RIGHT \n");
      else if (xmove ==-1 && ymove == 0) printf(" LEFT \n");
      else if (xmove == 0 && ymove == 1) printf(" DOWN \n");
      else if (xmove == 0 && ymove ==-1) printf(" UP \n");

      else if (xmove == 1 && ymove == 1) printf(" RIGHT DOWN \n");
      else if (xmove ==-1 && ymove == 1) printf(" LEFT DOWN \n");
      else if (xmove == 1 && ymove ==-1) printf(" RIGHT UP \n");
      else if (xmove ==-1 && ymove ==-1) printf(" LEFT UP \n");

      timeouts = 0;
      }
}

VOID flush_buffer(VOID)
{
   game_io_msg->io_Command = CMD_CLEAR;
   game_io_msg->io_Flags = IOF_QUICK;
   DoIO(game_io_msg);
}

VOID send_read_request(VOID)
{
   game_io_msg->io_Command = GPD_READEVENT;   
   game_io_msg->io_Length = sizeof(struct InputEvent); 
   game_io_msg->io_Data = (APTR)&game_event;
   SendIO(game_io_msg);  /* Asynchronous - message will return later */
}

VOID free_gp_unit(VOID)
{
BYTE type = GPCT_NOCONTROLLER;

   game_io_msg->io_Command = GPD_SETCTYPE;
   game_io_msg->io_Flags = IOF_QUICK;   
   game_io_msg->io_Length = 1;
   game_io_msg->io_Data = (APTR)&type;
   DoIO( game_io_msg);   
}
/* eof joy.c */
