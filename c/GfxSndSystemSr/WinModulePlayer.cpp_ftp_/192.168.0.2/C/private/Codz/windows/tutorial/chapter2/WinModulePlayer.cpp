#include "ModulePlayer.h"
#include "windows.h"

CModulePlayer::CModulePlayer()
{

}

CModulePlayer::~CModulePlayer()
{
  Free();
}

void CModulePlayer::Init(DWORD hwnd)
{
  if(FALSE == MIDASstartup())
    DisplayError();

  if(FALSE == MIDASsetOption(MIDAS_OPTION_DSOUND_HWND, hwnd))
    DisplayError();

  if(FALSE == MIDASinit())
    DisplayError();
    
}

void CModulePlayer::Free()
{
  MIDASfreeModule(m_module);
  MIDASclose();
}

void CModulePlayer::Load(char* filename)
{
  m_module = MIDASloadModule(filename);
  if( m_module == 0)
    DisplayError();
}

void CModulePlayer::Play()
{
  m_playHandle = MIDASplayModule(m_module, TRUE);
  if( m_playHandle == 0)
    DisplayError();

}

void CModulePlayer::Stop()
{
  if( FALSE == MIDASstopModule(m_playHandle))
    DisplayError();
}

void CModulePlayer::FillBuffer()
{
  MIDASpoll();
  //get pos
  MIDASgetPlayStatus(m_playHandle,&m_status);

}

int CModulePlayer::GetPosition()
{
  return m_status.row;
}

int CModulePlayer::GetPattern()
{
  return m_status.position;
}

int CModulePlayer::GetEffect()
{
  return m_status.syncInfo;
}

void CModulePlayer::DisplayError()
{
  MessageBox(0, MIDASgetErrorMessage(MIDASgetLastError()),"Midas Error",MB_OK);
}