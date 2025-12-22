#ifdef _AMIGAOS
#include "ModulePlayer.h"
#include "AmigaType.h"
#include "libraries/ptreplay.h"
#include "clib/ptreplay_protos.h"
#include "pragmas/ptreplay_pragmas.h"

CModulePlayer::CModulePlayer()
{
	m_pMod = NULL;
	Init();
}

CModulePlayer::~CModulePlayer()
{
  Stop();
  Free();
}

void CModulePlayer::Init()
{
  PTReplayBase = OpenLibrary("ptreplay.library",0L);
  if(PTReplayBase == NULL)
  {
  	//Init fails
  	return;
  }
    
}

void CModulePlayer::Free()
{
  if( NULL != PTReplayBase)
  {
    CloseLibrary(PTReplayBase);
  }
}

void CModulePlayer::Load(char* filename)
{
  m_pMod = PTLoadModule(filename);
  if(NULL == m_pMod)
  {
  	//Load fails
  	return;
  }


}

void CModulePlayer::Play()
{
	PTPlay(m_pMod);
}

void CModulePlayer::Stop()
{
  PTStop(m_pMod);
}


void CModulePlayer::FillBuffer()
{


}

int CModulePlayer::GetPosition()
{
  return PTSongPos(m_pMod);
}

int CModulePlayer::GetPattern()
{
  return PTPatternPos(m_pMod);
}


#endif


