ifndef __SETTINGS__
#define __SETTINGS__

typedef struct _tagSETTINGS
{
  int looptimes;
  int fadelength;
  int fadedelay;
  unsigned int ADXVolume;
  unsigned int ADXChannel;
} SETTINGS,*PSETTINGS,*LPSETTINGS;

bool LoadSettings(LPSETTINGS pSettings);
bool SaveSettings(LPSETTINGS pSettings);


#endif
