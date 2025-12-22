#ifndef __GUI__
#define __GUI__

#ifdef __cplusplus
  extern "C" void DisplayError(char *pMsg,...);
#else
  void DisplayError(char *pMsg,...);
#endif

void cube_gui_about();
void cube_gui_configure();

#endif
