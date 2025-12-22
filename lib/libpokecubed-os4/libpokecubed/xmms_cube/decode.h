#ifndef __DECODE__
#define __DECODE__

#include "windows.h"

extern "C"
{
  #include "cube.h"
}

extern int looptimes;
extern int fadelength;
extern int fadedelay;

class CDecoder
{
 public:
  CDecoder();
  ~CDecoder();

  void Init();
  void Destroy();

  static bool CanPlay(const char *pFile);
  bool Open(const char *pFile);
  bool IsLoaded();
  
  const char *GetLoadedFileName();
  bool GetLoadedFileTitle(char *buffer);
  int GetLength();
  int GetFrequency();
  int GetBitsPerSecond();
  int GetBitsPerSample();
  int GetChannels();
  bool GetLoopFlag();
  int GetNumberOfSamples();
  bool IsEOF(); 
  CUBEFILE &GetCubeFile() { return m_cFile; }

  int GetBytesAvailable();

  int Get576Samples(short *buf);
  bool Seek(int time);
 private:
  bool m_bLoaded;
  CUBEFILE m_cFile;
  char m_strLoadedFile[256];
  double m_decode_pos_ms;
  bool m_bEOF;
};

#endif
