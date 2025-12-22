#include "Tunnel.h"        
       
// SDL Stuff
SDL_Surface	*screen;
SDL_Surface	*bBuffer;               
SDL_Surface	*Image;         
SDL_Rect	rScreen;     
SDL_Rect	rBuffer;           

#ifdef WIN32
// Timer maison... cuz GetTickCount ca SUXX ! :) ----------------------------------
static __int64 timerstart;
static __int64 timerfrq;

static void Tunnel_Timer() {
  QueryPerformanceCounter((LARGE_INTEGER *)&timerstart);
  QueryPerformanceFrequency((LARGE_INTEGER *)&timerfrq);
}

static double Tunnel_GetTime() {
  __int64 a;
  QueryPerformanceCounter((LARGE_INTEGER *)&a);
	
  return (double)(a - timerstart)/(double)(timerfrq);
}
#else

void Tunnel_Timer(){}
double Tunnel_GetTime()
{
  return SDL_GetTicks()*1.0/1000;
}

#endif
// ---------------------------------------------------------------------------------

int main (int argc, char **argv)
{
               
  // on init SDL
  int flag = SDL_SWSURFACE;
#ifdef WIN32
  int fullscreen = MessageBox(NULL, "Un jolie tunnel en plein ecran ? :)", "Screen Setting", MB_YESNO);

  if (fullscreen==IDYES)
    {
      flag |= SDL_FULLSCREEN; 
    }
#endif
          
  // Init du Timer
  Tunnel_Timer();

  SDL_Init( SDL_INIT_VIDEO );             

#ifdef AMIGA
  atexit(SDL_Quit);
#endif
	
  // on set la resolution 
  screen = SDL_SetVideoMode( 320, 240, 32, flag);     

  bBuffer = SDL_CreateRGBSurface( SDL_HWSURFACE, screen->w, 
				  screen->h, 
				  screen->format->BitsPerPixel,
				  screen->format->Rmask,
				  screen->format->Gmask,
				  screen->format->Bmask,
				  screen->format->Amask);
  Image = SDL_LoadBMP( "tunnel_map.bmp" );                          

  if (!bBuffer || !Image)              
    {                
      printf("Error: I can't load or create bmp !!!\n\n");
      return -1;
    }                                 
          
  Image = SDL_ConvertSurface(Image, screen->format, SDL_HWSURFACE);       
             
  rBuffer.x = 0;                                               
  rBuffer.y = 0;            
  rBuffer.w = bBuffer->w;       
  rBuffer.h = bBuffer->h;                    

  SDL_EventState(SDL_ACTIVEEVENT, SDL_IGNORE);
  SDL_EventState(SDL_MOUSEMOTION, SDL_IGNORE);  
            
  SDL_ShowCursor( SDL_DISABLE );         

  Tunnel.Set( 320, 240 ); // Dimension du tunnel 
  Tunnel.Precalc( 16 ); // Diametre du tunnel

  while (SDL_PollEvent(NULL)==0)                    
    {              
      float fTime = Tunnel_GetTime();            
	
      SDL_LockSurface(bBuffer);
      SDL_LockSurface(Image);

      // et on le dessine normalement ! 
      // Tunnel.Draw(bBuffer, Image, fTime*100, fTime*100);

      // ou un peu plus delire
      Tunnel.Draw(bBuffer, Image, 180*sin(fTime), fTime*100);

      SDL_UnlockSurface(bBuffer);
      SDL_UnlockSurface(Image);

      SDL_BlitSurface( bBuffer, NULL, screen, &rBuffer );  
      SDL_UpdateRect( screen, 0, 0, 0, 0 );      
	
    }                                           
	
  Tunnel.Free();

  return 0;
}                                        
              
       
