#ifndef MODULEPLAYER_H
#define MODULEPLAYER_H

#ifdef _AMIGAOS
#include "AmigaType.h"
struct Library *PTReplayBase = NULL;
#endif

#ifdef _WINDOWS
#include "../../midas/include/midasdll.h"
#endif
	
class CModulePlayer
{
public:
  
  CModulePlayer();
  virtual ~CModulePlayer();

  void Load(char* filename);
  void Play();
  void Stop();
  void FillBuffer();

  int GetPosition();
  int GetPattern();
  int GetEffect();
  
protected:

  void Init();
  void Free();
  
private:

#ifdef _AMIGAOS  

	struct Module *m_pMod;

#endif

#ifdef _WINDOWS
public:
  void Init(DWORD hwnd);

private:
  void DisplayError();
  MIDASmodule m_module;
  MIDASmodulePlayHandle m_playHandle;
  MIDASplayStatus m_status;

#endif
};


#endif