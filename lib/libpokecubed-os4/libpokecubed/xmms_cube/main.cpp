#include <xmms/util.h>
#include <xmms/configfile.h>
#include <xmms/plugin.h>
#include <unistd.h>
#include <pthread.h>
#include "windows.h"
#include "config.h"
#include "gui.h"
#include "decode.h"
#include "messagequeue.h"
#include "settings.h"

#define TM_QUIT 0
#define TM_PLAY 1
#define TM_SEEK 2

static CDecoder decoder;
static CMessageQueue queue;
static pthread_t threadId;

static void *cube_thread(void *param);
static void cube_about();
static void cube_configure();
static void cube_init();
static void cube_destroy();
static int cube_is_our_file(char *);
static void cube_play(char *);
static void cube_stop();
static void cube_seek(int time);
static void cube_pause(short paused);
static int cube_get_time();
static void cube_get_song_info(char *,char **,int *);
static void cube_file_info_box(char *);

typedef struct _tagTHREADDATA
{
  CMessageQueue *pQueue;
  CUBEFILE *pCubeFile;
} THREADDATA,*PTHREADDATA,*LPTHREADDATA;

class CWaitEvent
{
public:
  CWaitEvent()
  {
    pthread_mutex_init(&m_mutex,NULL); // default is fast
    pthread_cond_init(&m_cond,NULL);
  }
  ~CWaitEvent()
  {
    pthread_mutex_destroy(&m_mutex);
    pthread_cond_destroy(&m_cond);
  }
  void Wait()
  {
    pthread_mutex_lock(&m_mutex);
    while (pthread_cond_wait(&m_cond,&m_mutex)) 
    {
    }
    pthread_mutex_unlock(&m_mutex);
  }
  void Signal()
  {
    pthread_mutex_lock(&m_mutex);
    pthread_cond_signal(&m_cond);
    pthread_mutex_unlock(&m_mutex);
  }
private:
  pthread_cond_t m_cond;
  pthread_mutex_t m_mutex;
};

static InputPlugin iplug = {
  NULL,				// handle
  NULL,				// filename
  "Cube Decoder " VERSION,	// description
  cube_init,			// init
  cube_about,			// about
  cube_configure,		// configure
  cube_is_our_file,		// is_our_file
  NULL,				// scan_dir
  cube_play,			// play
  cube_stop,			// stop
  cube_pause,			// pause
  cube_seek,			// seek
  NULL,				// set_eq
  cube_get_time,		// get_time
  NULL,				// get_volume
  NULL,				// set_volume
  cube_destroy,			// cleanup
  NULL,				// get_vis_type
  NULL,				// add_vis_pcm
  NULL,				// set_info
  NULL,				// set_info_text
  cube_get_song_info,		// get_song_info
  cube_file_info_box,		// file_info_box
  NULL				// OutputPlugin *output
};

extern "C" InputPlugin *get_iplugin_info()
{
  return &iplug;
}

static void* cube_thread(void *param)
{
  MSG msg;
  CMessageQueue *pQueue = reinterpret_cast<CMessageQueue*>(param);
  unsigned char buffer[576*4];
  long l;
  
  while (pQueue->GetMessage(&msg))
  {
    switch (msg.message)
    {
    case TM_QUIT:
      goto exit_thread;
    case TM_SEEK:
      l = reinterpret_cast<long>(msg.wParam) * 1000;
      if (decoder.Seek(l))
      {
	iplug.output->flush(l);
      }
      // set flag to caller
      reinterpret_cast<CWaitEvent*>(msg.lParam)->Signal();
      /* now fall through */
    case TM_PLAY:
      /* go into play mode */
      
      // can we write?
      while (1)
      {
	if (pQueue->PeekMessage(&msg,0))
	  break;
	
	if (!decoder.IsEOF())
	{	
	  l = decoder.Get576Samples(reinterpret_cast<short*>(buffer));
	  if (!l) 
	  {
	    // signal completion, EOF
	    iplug.output->buffer_free();
	    iplug.output->buffer_free();
	    xmms_usleep(10000);
	  }
	  else
	  {
	    iplug.add_vis_pcm(iplug.output->written_time(), 
			      (decoder.GetBitsPerSample() == 16) ? FMT_S16_LE : FMT_U8,
			      decoder.GetChannels(),l,buffer);
	    
	    while ((iplug.output->buffer_free() < l) && 
		   !pQueue->PeekMessage(&msg,0))
	    {
	      xmms_usleep(10000);
	    }
	    if (!pQueue->PeekMessage(&msg,0))
	    {
	      iplug.output->write_audio(buffer,l);
	    }
	  }
	}
	else
	{
	  xmms_usleep(10000);
	}
      };
      break;
    }
  }
 exit_thread:
  return 0;
}

static void cube_about()
{
  cube_gui_about();
}

static void cube_configure()
{
  cube_gui_configure();
}

static void cube_init()
{
  SETTINGS s;

  if (LoadSettings(&s))
  {
    looptimes  = s.looptimes;
    fadelength = s.fadelength;
    fadedelay  = s.fadedelay;
    BASE_VOL   = s.ADXVolume;
    adxonechan = s.ADXChannel;
  }
  else
  {
    BASE_VOL = 0x2000;
    looptimes = 2;
  }
  
  decoder.Init();
}

static void cube_destroy()
{
  decoder.Destroy();
}

static int cube_is_our_file(char *pFile)
{
  if (!pFile)
    return 0;

  return (CDecoder::CanPlay(pFile) ? TRUE : FALSE);
}

static void cube_play(char *pFile)
{
  MSG msg;
  char title[256];
  
  if (!decoder.Open(pFile))
  {
    DisplayError("Failed to open %s",pFile);
    return;
  }
  // open the audio device
  if (iplug.output->open_audio((decoder.GetBitsPerSample() == 16) ? FMT_S16_LE : FMT_U8,decoder.GetFrequency(),decoder.GetChannels()) == 0)
  {
    decoder.Destroy();
    DisplayError("Failed to open audio output (check your output plugin configuration)");
    return;
  }
  // set the info
  if (!decoder.GetLoadedFileTitle(title))
    strcpy(title,pFile);
  
  iplug.set_info(title,
		 /* length */ decoder.GetLength(),
		 /* rate */decoder.GetBitsPerSecond(),
		 /* freq */decoder.GetFrequency(),
		 /* n channels */decoder.GetChannels());
  
  queue.Create();
  pthread_create(&threadId,NULL,cube_thread,&queue);
  // tell the thread to play
  msg.message = TM_PLAY;
  queue.SendMessage(&msg);
}

static void cube_stop()
{
  MSG msg;
  
  if (decoder.IsLoaded())
  {
    // kill thread
    msg.message = TM_QUIT;
    queue.SendMessage(&msg);
    // wait for it to die
    pthread_join(threadId,NULL);
    // close audio output
  }
  iplug.output->close_audio();
  // cleanup 
  queue.Destroy();
  decoder.Destroy();
}

static void cube_seek(int time)
{
  MSG msg;
  CWaitEvent event;

  if (decoder.IsLoaded())
  {
    msg.message = TM_SEEK;
    msg.wParam = reinterpret_cast<void*>(time);
    msg.lParam = &event;
    queue.SendMessage(&msg);
    
    event.Wait();
  }
}

static void cube_pause(short paused)
{
  iplug.output->pause(paused);
}

static int cube_get_time()
{
  if (!decoder.IsLoaded())
    return -2;
  
  if (decoder.IsEOF() && !iplug.output->buffer_playing())
    return -1;
  
  return iplug.output->output_time();
}

static void cube_get_song_info(char *pFile,char **title,int *length)
{
  char *name = NULL;
  CDecoder decoder;
  if (decoder.Open(pFile))
  {
    if ((name = reinterpret_cast<char*>(g_malloc(256))))
    {
      decoder.GetLoadedFileTitle(name);
    }
    *length = decoder.GetLength();
  }
  else
  {
    *length = 0;
  }
  
  *title = name;
}

static void cube_file_info_box(char *pFile)
{
  char msg[512];
  CDecoder decoder;
  if (decoder.Open(pFile))
  {
    sprintf(msg,"%s\nSample rate: %d\nStereo: %s\nTotal samples: %d",pFile,
	    decoder.GetFrequency(),(decoder.GetChannels() == 2) ? "yes" : "no",
	    decoder.GetNumberOfSamples());
    
    xmms_show_message("File information",msg,"OK",FALSE,NULL,NULL);
  }
}
