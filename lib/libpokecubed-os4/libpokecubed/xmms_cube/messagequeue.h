#ifndef __MESSAGE_QUEUE__
#define __MESSAGE_QUEUE__

#include <sys/types.h>
#include <unistd.h>

typedef struct _tagMSG
{
  unsigned int message;
  pid_t source;
  void *wParam;
  void *lParam;
} MSG,*LPMSG;

#define PM_NOREMOVE 0
#define PM_REMOVE   (1 << 0)
class CMessageQueue
{
public:
  CMessageQueue();
  CMessageQueue(bool bCloseHandles,int read,int write);
  ~CMessageQueue();

  bool Create();
  void Destroy();
  
  bool SendMessage(LPMSG pMsg);
  bool GetMessage(LPMSG pMsg);
  bool PeekMessage(LPMSG pMsg,unsigned int flags);
  
  int GetFileDescriptor() { return m_fd[0]; }
private:
  int m_fd[2];
  bool m_bClose;
};

#endif
