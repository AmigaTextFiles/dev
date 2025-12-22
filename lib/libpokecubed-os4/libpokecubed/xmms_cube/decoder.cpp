#include "decode.h"

int looptimes = 2;
int fadelength = 0;
int fadedelay = 0;

CDecoder::CDecoder()
{
  Init();
}

CDecoder::~CDecoder()
{
  Destroy();
}

void CDecoder::Init()
{
  m_bLoaded = false;
  m_strLoadedFile[0] = 0;
  m_decode_pos_ms = 0;
  m_bEOF = false;
  
  memset(&m_cFile,0,sizeof(CUBEFILE));
  m_cFile.ch[0].infile = INVALID_HANDLE_VALUE;
  m_cFile.ch[1].infile = INVALID_HANDLE_VALUE;
}

void CDecoder::Destroy()
{
  if (m_bLoaded)
    CloseCUBEFILE(&m_cFile);

  m_bLoaded = false;
}

bool CDecoder::CanPlay(const char *pFile)
{
  unsigned int i;
  const char *pExt;
  CDecoder cFile;
  bool bRet = false;
  static const char *supportedExtensions [] = {
    /* DSP audio files */
    "dsp",		
    "gcm",
    "hps",
    "idsp",
    "spt",
    "spd",
    "mss",
    "mpdsp",
    "ish",
    "ymf",
    /* ADX audio files */
    "adx",
    /* ADP */
    "adp",
    /* RSD */
    "rsd",
    "rsp",
    /* AST */
    "ast",
    /* AFX */
    "afc"
  };
  
  if (!pFile)
    return false;
  /* get the extension */
  pExt = strrchr(pFile,'.');
  if (!pExt)
    return false;
  /* move it past the . */
  ++pExt;
  /* now scan */
  for (i=0;i<sizeof(supportedExtensions)/sizeof(supportedExtensions[0]);++i)
  {
    if (strcasecmp(pExt,supportedExtensions[i]) == 0)
    {
      /* now try to load it */
      bRet = cFile.Open(pFile);
      break;
    }
  }
  return bRet;
}

bool CDecoder::Open(const char *pFile)
{
  m_bLoaded = (InitCUBEFILE(const_cast<char*>(pFile),&m_cFile) == 0);
  strcpy(m_strLoadedFile,m_bLoaded ? pFile : "");
  m_decode_pos_ms = 0;
  m_bEOF = false;
  
  return m_bLoaded;
}

bool CDecoder::IsEOF()
{
  return m_bEOF;
}

bool CDecoder::IsLoaded()
{
  return m_bLoaded;
}

const char *CDecoder::GetLoadedFileName()
{
  return (m_bLoaded ? m_strLoadedFile : NULL);
}

bool CDecoder::GetLoadedFileTitle(char *buffer)
{
  char *end;
  
  if (!m_bLoaded)
    return false;
  
  end = strrchr(m_strLoadedFile,'/');
  if (end)
  {
    strcpy(buffer,end+1);
  }
  else
  {
    strcpy(buffer,m_strLoadedFile);
  }
  return true;
}

int CDecoder::GetFrequency()
{
  return m_cFile.ch[0].sample_rate;
}

int CDecoder::GetBitsPerSecond()
{
  return (GetFrequency() * (GetBitsPerSample()/8) * GetChannels());
}

int CDecoder::GetBitsPerSample()
{
  return BPS;
}

int CDecoder::GetChannels()
{
  return m_cFile.NCH;
}

bool CDecoder::GetLoopFlag()
{
  return m_cFile.ch[0].loop_flag;
}

int CDecoder::GetLength()
{
  return (GetNumberOfSamples() / GetFrequency() * 1000);
}

int CDecoder::GetNumberOfSamples()
{
  return m_cFile.nrsamples;
}

int CDecoder::GetBytesAvailable()
{
  return 576 * GetChannels() * (GetBitsPerSample() / 8);
}

// render 576 samples into buf. 
// note that if you adjust the size of sample_buffer, for say, 1024
// sample blocks, it will still work, but some of the visualization 
// might not look as good as it could. Stick with 576 sample blocks
// if you can, and have an additional auxiliary (overflow) buffer if 
// necessary.. 
int CDecoder::Get576Samples(short *buf)
{
  int i;
  
  if (m_bEOF || (m_decode_pos_ms >= GetLength()))
  {
    m_bEOF = true;
    return 0;
  }

  for (i=0;i<576;i++) {
    if ((looptimes || !GetLoopFlag()) && 
	(m_decode_pos_ms*GetFrequency()/1000+i) >= GetNumberOfSamples())
    {
      return (i*GetChannels()*(GetBitsPerSample()/8));
    }
    if (m_cFile.ch[0].readloc == m_cFile.ch[0].writeloc) {
      fillbuffers(&m_cFile);
      //if (m_cFile.ch[0].readloc != m_cFile.ch[0].writeloc) return i*m_cFile.NCH*(BPS/8);
    }
    buf[i*m_cFile.NCH]=m_cFile.ch[0].chanbuf[m_cFile.ch[0].readloc++];
    if (m_cFile.NCH==2) buf[i*m_cFile.NCH+1]=m_cFile.ch[1].chanbuf[m_cFile.ch[1].readloc++];
    if (m_cFile.ch[0].readloc>=0x8000/8*14) m_cFile.ch[0].readloc=0;
    if (m_cFile.ch[1].readloc>=0x8000/8*14) m_cFile.ch[1].readloc=0;
    
    // fade
    if (looptimes && GetLoopFlag() && m_cFile.nrsamples*1000.0/m_cFile.ch[0].sample_rate-m_decode_pos_ms < fadelength*1000) 
    {
      buf[i*m_cFile.NCH]=(short)((double)buf[i*m_cFile.NCH]*(m_cFile.nrsamples*1000.0/m_cFile.ch[0].sample_rate-m_decode_pos_ms)/fadelength/1000.0);
      if (m_cFile.NCH==2) 
      {
	buf[i*m_cFile.NCH+1]=(short)((double)buf[i*m_cFile.NCH+1]*(m_cFile.nrsamples*1000.0/m_cFile.ch[0].sample_rate-m_decode_pos_ms)/fadelength/1000.0);
      }
    }
  }
  // update position
  m_decode_pos_ms += 576.0 * 1000.0 / GetFrequency();
  //return (576*m_cFile.NCH*(BPS/8));
  return (576 * GetChannels() * GetBitsPerSample() / 8);
}

bool CDecoder::Seek(int time)
{
  unsigned char buffer[576*2*2];
  
  if (m_decode_pos_ms > time)	// i am already too far, reinitialize
  {
    Destroy();
    if (!Open(m_strLoadedFile))
      return false;
  }
  
  while (m_decode_pos_ms < time)
  {
    if (!Get576Samples(reinterpret_cast<short*>(buffer)))
      return false;
  }
  return true;
}
