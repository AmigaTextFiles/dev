/************************************************************************************
** Action: CopyToUnv()
** Object: Sound
*/

LIBFUNC void SND_CopyToUnv(mreg(__a0) LONG argUniverse,
                           mreg(__a1) LONG argSound)
{
  struct Universe *unv = (struct Universe *)argUniverse;
  struct Sound    *snd = (struct Sound *)argSound;

  unv->Frequency = snd->Frequency;
  unv->Length    = snd->Length;
  unv->Octave    = snd->Octave;
  unv->Priority  = snd->Priority;
  unv->Source    = snd->Source;
  unv->Volume    = snd->Volume;
}

/************************************************************************************
** Action: CopyFromUnv()
** Object: Sound
*/

LIBFUNC void SND_CopyFromUnv(mreg(__a0) LONG argUniverse,
                             mreg(__a1) LONG argSound)
{
  struct Universe *unv = (struct Universe *)argUniverse;
  struct Sound    *snd = (struct Sound *)argSound;

  if (!snd->Frequency) snd->Frequency = unv->Frequency;
  if (!snd->Length)    snd->Length    = unv->Length;
  if (!snd->Octave)    snd->Octave    = unv->Octave;
  if (!snd->Priority)  snd->Priority  = unv->Priority;
  if (!snd->Source)    snd->Source    = unv->Source;
  if (!snd->Volume)    snd->Volume    = unv->Volume;
}

