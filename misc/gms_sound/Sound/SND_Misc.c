/************************************************************************************
** Action: CheckFile()
** Object: Sound
*/

LIBFUNC LONG SND_CheckFile(mreg(__a0) LONG argFile,
                           mreg(__a1) LONG argBuffer)
{
  LONG *Buffer = (LONG *)argBuffer;

  if (Buffer[0] IS CODE_FORM AND Buffer[2] IS CODE_8SVX) {
     DPrintF("CheckFile:","File identified as Sound.");
     return(99);
  }
  else return(NULL);
}

