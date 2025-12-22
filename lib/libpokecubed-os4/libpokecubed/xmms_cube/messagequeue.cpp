#include "messagequeue.h"
#include <unistd.h>
#include <sys/poll.h>

CMessageQueue::CMessageQueue() : 
  m_bClose(false)
{
  m_fd[0] = -1;
  m_fd[1] = -1;
}
 
CMessageQueue::CMessageQueue(bool bCloseHandles,int read,int write) :
    m_bClose(bCloseHandles)
{
  m_fd[0] = read;
  m_fd[1] = write;
}

CMessageQueue::~CMessageQueue()
{
  Destroy();
}

bool CMessageQueue::Create()
{
  m_bClose = true;
  return (pipe(m_fd) == 0);
}

void CMessageQueue::Destroy()
{
  if (m_bClose)
  {
    if (m_fd[0] >= 0)
      close(m_fd[0]);
    
    if (m_fd[1] >= 0)
      close(m_fd[1]);
  }
  
  m_fd[0] = -1;
  m_fd[1] = -1;
}
  
bool CMessageQueue::SendMessage(LPMSG pMsg)
{
  pMsg->source = getpid();
  return (write(m_fd[1],pMsg,sizeof(MSG)) == sizeof(MSG));
}

bool CMessageQueue::GetMessage(LPMSG pMsg)
{
  return (read(m_fd[0],pMsg,sizeof(MSG)) == sizeof(MSG));
}

bool CMessageQueue::PeekMessage(LPMSG pMsg,unsigned int flags)
{
  struct pollfd fd;
  int ret;
  bool bSuccess;
  
  fd.fd = m_fd[0];
  fd.events = POLLIN;
  
  ret = poll(&fd,1,0);
  
  bSuccess = ((ret > 0) && (fd.revents & POLLIN));
  if (bSuccess && (flags & PM_REMOVE))
  {
    return GetMessage(pMsg);
  }
  return bSuccess;
}
