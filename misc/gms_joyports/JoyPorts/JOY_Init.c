
#define JP_MOUSE    0
#define JP_JOYSTICK 1
#define JP_ANALOGUE 2
#define JP_JOYPAD   3
#define JP_SEGAPAD  4
#define JP_KEYBOARD 5

void ReadAnalogue(struct JoyData *JoyData);
void ReadJoyPad(struct JoyData *JoyData);
void ReadSegaPad(struct JoyData *JoyData);
void ReadJoystick(struct JoyData *JoyData);
void ReadKeyboard(struct JoyData *JoyData);
void ReadMouse(struct JoyData *JoyData);

/***********************************************************************************/

void ReadAnalogue(struct JoyData *JoyData)
{
  ReadMouse(JoyData);
}

/***********************************************************************************/

void ReadJoyPad(struct JoyData *JoyData)
{
  ReadJoystick(JoyData);
}

/***********************************************************************************/

void ReadSegaPad(struct JoyData *JoyData)
{
  ReadJoystick(JoyData);
}

/************************************************************************************
** This is the joystick emulator for the Keyboard.  It uses the Keyboard object
** to read the keys and compares them to the emulation keys set out by the user.
** I guess it is kind of slower than what might be preferred, but it is an emulator
** after all.
**
** BUG/HACK - Using this method the program will actually interfere with the Task's
** use of the keyboard, so we should allow for a qualifier key from GMSPrefs
** and also prevent the key buffer position from moving.
*/

void ReadKeyboard(struct JoyData *JoyData)
{
   struct Keyboard *keys;
   struct JoyKeys  *emu;
   WORD  i;
   WORD  qual;
   UBYTE value;

   JoyData->XChange = NULL;
   JoyData->YChange = NULL;
   JoyData->ZChange = NULL;
   JoyData->Buttons = NULL;

   if ((keys = JoyData->prvKeys) AND (emu = JoyData->prvEmu)) {
      Query(keys);

      for (i = 0; i < keys->AmtRead; i++) {
         qual  = keys->Buffer[i].Qualifier;

         if (qual & KQ_HELD) {
            value = keys->Buffer[i].Value;

                 if (value IS emu->Left)  JoyData->XChange -= 1;
            else if (value IS emu->Right) JoyData->XChange += 1;
            else if (value IS emu->Up)    JoyData->YChange -= 1;
            else if (value IS emu->Down)  JoyData->YChange += 1;
            else if (value IS emu->Fire1) JoyData->Buttons |= JD_FIRE1;
            else if (value IS emu->Fire2) JoyData->Buttons |= JD_FIRE2;
            else if (value IS emu->Fire3) JoyData->Buttons |= JD_FIRE3;
            else if (value IS emu->Fire4) JoyData->Buttons |= JD_FIRE4;
            else if (value IS emu->Fire5) JoyData->Buttons |= JD_FIRE5;
            else if (value IS emu->Fire6) JoyData->Buttons |= JD_FIRE6;
            else if (value IS emu->Fire7) JoyData->Buttons |= JD_FIRE7;
            else if (value IS emu->Fire8) JoyData->Buttons |= JD_FIRE8;
         }
      }
   }
}

/***********************************************************************************/

void ReadMouse(struct JoyData *JoyData)
{
   UWORD tmp;
   WORD  X, Y;
   LONG  buttons = NULL;

   /*** PORT 1 ***/

   if (JoyData->Port IS 1) {
      tmp = custom->joy0dat;
      X   = tmp & 0x00ff;
      Y   = (tmp>>8);

      tmp = JoyData->prvOldX;
      JoyData->prvOldX = X;
      X -= tmp;

      tmp = JoyData->prvOldY;
      JoyData->prvOldY = Y;
      Y -= tmp;

      if (!(X > -127)) { X += 255; }
      if (!(X < +127)) { X -= 255; }
      if (!(Y > -127)) { Y += 255; }
      if (!(Y < +127)) { Y -= 255; }

      tmp = custom->potinp;
      if (!(cia->ciapra & (1<<6))) buttons |= JD_LMB;
      if (!(tmp & (1<<10)))        buttons |= JD_RMB;
      if (!(tmp & (1<<12)))        buttons |= JD_MMB; /* This is a guess... */
   }

   /*** PORT 2 ***/

   else if (JoyData->Port IS 2) {
      tmp = custom->joy1dat;
      X   = tmp & 0x00ff;
      Y   = (tmp>>8);
      tmp = JoyData->prvOldX;
      JoyData->prvOldX = X;
      X  -= tmp;
      tmp = JoyData->prvOldY;
      JoyData->prvOldY = Y;
      Y  -= tmp;

      if (!(X > -127)) { X += 255; }
      if (!(X < +127)) { X -= 255; }
      if (!(Y > -127)) { Y += 255; }
      if (!(Y < +127)) { Y -= 255; }

      tmp = custom->potinp;
      if (!(cia->ciapra & (1<<7))) buttons |= JD_LMB;
      if (!(tmp & (1<<14)))        buttons |= JD_RMB; /* WRONG */
      if (!(tmp & (1<<8)))         buttons |= JD_MMB; /* This is a guess... */
   }

   /*** UNSUPPORTED PORT ***/

   else {
      JoyData->XChange = NULL;
      JoyData->YChange = NULL;
      JoyData->ZChange = NULL;
      JoyData->Buttons = NULL;
      return;
   }

   JoyData->XChange = X;
   JoyData->YChange = Y;
   JoyData->ZChange = NULL;
   JoyData->Buttons = buttons;
}

/***********************************************************************************/

void ReadJoystick(struct JoyData *JoyData)
{
   UWORD joy;
   UWORD tmp;
   LONG  buttons = NULL;

   tmp = custom->potinp;

   /*** PORT 1 ***/

   if (JoyData->Port IS 1) {
      joy = custom->joy0dat;
      if (!(cia->ciapra & (1<<6))) buttons |= JD_FIRE1;
      if (!(tmp & (1<<10)))        buttons |= JD_FIRE2; /* WRONG */
      if (!(tmp & (1<<14)))        buttons |= JD_FIRE3; /* This is a guess... */
   }

   /*** PORT 2 ***/

   else if (JoyData->Port IS 2) {
      joy = custom->joy1dat;
      if (!(cia->ciapra & (1<<7))) buttons |= JD_FIRE1;
      /*if (!(tmp & (1<<14)))*/    buttons |= JD_FIRE2; /* WRONG */
      if (!(tmp & (1<<8)))         buttons |= JD_FIRE3; /* This is a guess... */
   }

   /*** UNSUPPORTED PORT ***/

   else {
      JoyData->XChange = NULL;
      JoyData->YChange = NULL;
      JoyData->ZChange = NULL;
      JoyData->Buttons = NULL;
      return;
   }

   if (joy & 0x0002)      JoyData->XChange = 1;
   else if (joy & 0x0200) JoyData->XChange = -1;
   else JoyData->XChange = NULL;

   if ((joy >> 1^ joy) & 0x0001)      JoyData->YChange = 1;
   else if ((joy >> 1^ joy) & 0x0100) JoyData->YChange = -1;
   else JoyData->YChange = NULL;

   JoyData->Buttons = buttons;
}

/************************************************************************************
** Action: Free()
** Object: JoyData
*/

LIBFUNC void JOY_Free(mreg(__a0) struct JoyData *JoyData)
{
  if (JoyData->prvKeys) {
     Free(JoyData->prvKeys);
  }
  Public->OpenCount--;
}

/************************************************************************************
** Action: Get()
** Object: JoyData
*/

LIBFUNC struct JoyData * JOY_Get(mreg(__a0) struct Stats *Stats)
{
  struct JoyData *JoyData;

  if (JoyData = AllocMemBlock(sizeof(struct JoyData), MEM_RESOURCED|Stats->MemFlags)) {
     JoyData->Head.ID      = ID_JOYDATA;
     JoyData->Head.Version = VER_JOYDATA;
     Public->OpenCount++;
     return(JoyData);
  }
  else {
     ErrCode(ERR_FAILED);
     return(NULL);
  }
}

/************************************************************************************
** Action: Init()
** Object: JoyData
**
** Resets the timer and all of the values in the structure.
*/

LIBFUNC ECODE JOY_Init(mreg(__a0) struct JoyData *JoyData)
{
  struct DPKTask *Task;

  /* Note that we set mouse port as the system default if the
  ** programmer has not set a port number.
  */

  if (JoyData->Port IS JPORT_ANALOGUE) {
     JoyData->Port = 1;
  }
  else if (JoyData->Port IS JPORT_DIGITAL) {
     JoyData->Port = 2;
  }
  else if (JoyData->Port IS NULL) {
     JoyData->Port = 1;
  }
  else if ((JoyData->Port < 1) OR (JoyData->Port > 4)) {
     DPrintF("!Init:","JoyData port number is out of range (1 - 4).");
     return(ERR_DATA);
  }

  /* Set time-out values (micro-seconds) */

  if (JoyData->ButtonTimeOut IS NULL) {
     JoyData->ButtonTimeOut = 200;
  }

  if (JoyData->MoveTimeOut IS NULL) {
     JoyData->MoveTimeOut = 200;
  }

  /* Set the limits.  We also check that the sign of each setting
  ** is correct.
  */

  if (JoyData->NXLimit IS NULL) JoyData->NXLimit = -100;
  if (JoyData->NYLimit IS NULL) JoyData->NYLimit = -100;
  if (JoyData->PXLimit IS NULL) JoyData->PXLimit = +100;
  if (JoyData->PYLimit IS NULL) JoyData->PYLimit = +100;

  if (JoyData->NXLimit > 0) JoyData->NXLimit = -JoyData->NXLimit;
  if (JoyData->NYLimit > 0) JoyData->NYLimit = -JoyData->NYLimit;
  if (JoyData->PXLimit < 0) JoyData->PXLimit = -JoyData->PXLimit;
  if (JoyData->PYLimit < 0) JoyData->PYLimit = -JoyData->PYLimit;

  /* Find out what type of joystick is plugged in, this is
  ** in accordance with the port number.
  */

  if ((Task = FindDPKTask()) AND (Task->MasterPrefs)) {
          if (JoyData->Port IS 1) JoyData->prvType = Task->MasterPrefs->JoyType1;
     else if (JoyData->Port IS 2) JoyData->prvType = Task->MasterPrefs->JoyType2;
     else if (JoyData->Port IS 3) JoyData->prvType = Task->MasterPrefs->JoyType3;
     else if (JoyData->Port IS 4) JoyData->prvType = Task->MasterPrefs->JoyType4;
  }
  else {
     DPrintF("JoyPorts:","Missing general preferences, using port default.");

     if (JoyData->Port IS 1)
        JoyData->prvType = JP_MOUSE;
     else
        JoyData->prvType = JP_JOYSTICK;
  }

  /* Initialise the port according to
  ** what type it is.
  */

  if (JoyData->prvType IS JP_MOUSE) {
     ReadMouse(JoyData);
     ReadMouse(JoyData);
  }
  else if (JoyData->prvType IS JP_KEYBOARD) {
     if (!(JoyData->prvKeys = Init(Get(ID_KEYBOARD),NULL))) {
        return(ERR_FAILED);
     }
     JoyData->prvEmu = Task->MasterPrefs->Keys + (JoyData->Port - 1);  /* Get emulation table */
  }

  JoyData->Buttons = NULL;
  JoyData->XChange = NULL;
  JoyData->YChange = NULL;
  JoyData->ZChange = NULL;

  DPrintF("JoyPorts:","Initialised to Port %d.",JoyData->Port);

  return(ERR_OK);
}

/************************************************************************************
** Action: Activate()/Query()
** Object: JoyData
*/

LIBFUNC ECODE JOY_Activate(mreg(__a0) struct JoyData *JoyData)
{
        if (JoyData->prvType IS JP_MOUSE)    ReadMouse(JoyData);
   else if (JoyData->prvType IS JP_JOYSTICK) ReadJoystick(JoyData);
   else if (JoyData->prvType IS JP_ANALOGUE) ReadAnalogue(JoyData);
   else if (JoyData->prvType IS JP_JOYPAD)   ReadJoyPad(JoyData);
   else if (JoyData->prvType IS JP_SEGAPAD)  ReadSegaPad(JoyData);
   else if (JoyData->prvType IS JP_KEYBOARD) ReadKeyboard(JoyData);
   else return(ERR_FAILED);

   /* If there is no screen, or if this task does not have the focus, we
   ** have to set the values to null and return.
   **
   ** The reason why we don't do this check first is because previously
   ** some of the Read*() routines wanted to be constantly polled.
   ** This is probably not be true anymore, but it needs to be thoroughly
   ** tested if this code is to go first.
   */

   if ((GVBase->CurrentScreen IS NULL) OR (GVBase->UserFocus != FindDPKTask())) {
      JoyData->Buttons  = NULL;
      JoyData->XChange  = NULL;
      JoyData->YChange  = NULL;
      JoyData->ZChange  = NULL;
   }
   else {
      /* Check the movement ticks */

      if ((GVBase->Ticks - JoyData->prvMoveTicks) > (JoyData->MoveTimeOut/2)) {
         DPrintF("JoyPorts:","Timeout - Ticks: %d, Int.Ticks: %d, Timeout: %d",GVBase->Ticks,JoyData->prvMoveTicks,JoyData->MoveTimeOut);
         JoyData->XChange = NULL;
         JoyData->YChange = NULL;
         JoyData->ZChange = NULL;
      }
      else {
         /* Check the X limits */

         if (JoyData->XChange < JoyData->NXLimit) {
            JoyData->XChange = JoyData->NXLimit;
         }
         else if (JoyData->XChange > JoyData->PXLimit) {
            JoyData->XChange = JoyData->PXLimit;
         }

         /* Check the Y limits */

         if (JoyData->YChange < JoyData->NYLimit) {
            JoyData->YChange = JoyData->NYLimit;
         }
         else if (JoyData->YChange > JoyData->PYLimit) {
            JoyData->YChange = JoyData->PYLimit;
         }
      }

      /* Check the button ticks */

      if ((GVBase->Ticks - JoyData->prvButtonTicks) > (JoyData->ButtonTimeOut/2)) {
         JoyData->Buttons = NULL;
      }

   }

   JoyData->prvMoveTicks   = GVBase->Ticks;
   JoyData->prvButtonTicks = GVBase->Ticks;
   return(ERR_OK);
}

