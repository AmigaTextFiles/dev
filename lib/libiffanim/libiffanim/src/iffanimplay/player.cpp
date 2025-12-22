#include <iostream>
#include <stdint.h>    //integer type definitions

#include "player.h"


/******************************************************************************/
int AnimPlayer::printhelp()
{
 cout << "USAGE: iffanimplay file [options]" << endl;
 cout << "OPTIONS:" << endl;
 cout << "  -fixtime...     //use a fixed delay between frames, delay in ms (example: -fixtime1000)" << endl;
 cout << "  -extract <path> //all frames are extracted to single .bmp files" << endl;
 cout << "  -loop           //animation loops" << endl;
 cout << "  -loopanim       //doesn't play the first 2 frames when looping (for animations where the 2 first and the 2 last frames are the same)" << endl;
 cout << "  -neww...        //scale to requested width (example: -neww300) for display" << endl;
 cout << "  -newh...        //scale to requested height" << endl;
 cout << "  -h              //print this help" << endl;
}


/******************************************************************************/
void AnimPlayer::audio_callback(void *userdata, Uint8 *stream, int len)
{
 AnimPlayer *player = (AnimPlayer*)userdata;

 if(player->audiopos >= player->audiolen)
  return;

 //Mix as much data as possible
 int remaining = player->audiolen - player->audiopos;
 len = ( len > remaining ? remaining : len );
 SDL_MixAudio(stream, (Uint8*)(player->audiodata + player->audiopos), len, SDL_MIX_MAXVOLUME);
 player->audiopos += len;
}


/******************************************************************************/
//-create a file name from a value with a specified number of digits, a "prefix" and a file extension
//-returns NULL if value exceeds number of digits
//-note "fname" must be large enough for: prefix, ndigits, extension
int AnimPlayer::mkfname(int val, int ndigits, char *fname, char *prefix, char *ext)
{
 char strbuf[256]; 
 int len;
 int prefixlen;

 //number to string conversion
 sprintf(strbuf, "%d", val);
 len = strlen(strbuf);

 //handle a too big value
 if(len > ndigits) {
   cout << "file naming error: number too large" << endl;
   return -1;
 }
 //add prefix
 prefixlen = strlen(prefix);
 strcpy(fname, prefix);

 //-fill fname with '0's
 memset(&fname[prefixlen], '0', ndigits-len);

 //-merge "0"s, number and extension
 strcpy(&fname[ prefixlen + ndigits - len ], strbuf);
 strcat(fname, ext);
 return 0;
}







/******************************************************************************/
// - scale 8 bit bitmap to requested size (32 bit padded lines), pitch conversion
// - use prepared step, fixedpoint 16.16
// dst: destination to scale to
// src: source
// w: width
// h: height
// pitch: length of a scanline
void AnimPlayer::ScaleBitmap8(char *dst, int dstw, int dsth, int dstpitch, char *src, int srcw, int srch, int srcpitch)
{
 int i, j;

 //if simple copy can be done
 if((srcpitch == dstpitch) && (srcw == dstw) && (srch == dsth)) {
   memcpy(dst, src, srcpitch * srch);
   return;
 }
   
 //fixed point vars: 16.16 
 uint32_t xratio = (srcw << 16) / dstw;
 uint32_t yratio = (srch << 16) / dsth;
 uint32_t xofs;    //x position in source
 uint32_t yofs;    //y position in source

 //holds address of line start in src
 char *srcT = src;

 yofs = 0;
 for(j = 0; j < dsth; j++) {
   src = srcT + ((yofs >> 16) * srcpitch);
   xofs = 0;
   for(i = 0; i < dstw; i++) {
     dst[i] = src[xofs >> 16];
     xofs += xratio;
   }
   yofs += yratio;
   dst += dstpitch;
 }
}


/******************************************************************************/
// - scale 24 bit bitmap to requested size (32 bit padded lines), pitch conversion
// - use prepared step: fixedpoint 16.16
// dst: destination to scale to
// src: source
// w: width
// h: height
// pitch: length of a scanline
void AnimPlayer::ScaleBitmap24(char *dst, int dstw, int dsth, int dstpitch, char *src, int srcw, int srch, int srcpitch)
{    
 int i, j;
 
 //if simple copy can be done
 if((srcpitch == dstpitch) && (srcw == dstw) && (srch == dsth)) {
   memcpy(dst, src, srcpitch * srch);
   return;
 }
 
 //fixed point vars
 uint32_t xratio = (srcw << 16) / dstw;
 uint32_t yratio = (srch << 16) / dsth;
 uint32_t xofs;     //x position in source
 uint32_t yofs;     //y position in source

 char *srcT = src;  //save adress of first line start

 int tmp;
 dstw *= 3; //pixels -> bytes

 yofs = 0;
 for(j = 0; j < dsth; j++) {       //for every line in dst
   src = srcT + ((yofs >> 16) * srcpitch);  //set line start of line
   xofs = 0;
   for(i = 0; i < dstw; i += 3) {  //for every pixel of a line in dst
     tmp = (xofs >> 16) * 3;
     dst[i]     = src[tmp];
     dst[i + 1] = src[tmp + 1];
     dst[i + 2] = src[tmp + 2];
     xofs += xratio;
   }
   yofs += yratio;
   dst += dstpitch;
 }
}



/******************************************************************************/
// -set windows title information
// -icon title doesn't change
void AnimPlayer::SetCaption()
{
 char strbuf[400];
 static char icon[] = "IFFANIM Player";
 static char window_prefix[] = "IFFANIM Player";

 static char *states[] = {"playing","paused","ended"};
 char *state;
 
 //determine state
 if(ended)
   state = states[2];
 else {
   if (playing) state = states[0];
   else         state = states[1];
 }

 // compose window string
 sprintf(strbuf, "%s - [%dx%d / %dx%d] [%d / %d (%d sec)] [%s]", window_prefix, w_disp, h_disp, w_org, h_org, curframe, numframes, lentime / 1000, state);   
   
 SDL_WM_SetCaption(strbuf, icon);
}


/******************************************************************************/
int AnimPlayer::Extract(char *outpath)
{
 static char bmp_path[1000];  //directory
 static char file_name[1000]; //filename
 string path;
 
 int i;
 
 strcpy(bmp_path, outpath);
 if( (strlen(bmp_path) > 0) && bmp_path[ strlen(bmp_path) - 1 ] != '/')  //make sure there is the '/' at the end
   strcat(bmp_path, "/");
 cout << "BMP output directory: """ << bmp_path << """" << endl;

 //open file where the timings are written in ms
 ofstream timingfile;
 path = string(bmp_path) + "timing.txt";
 timingfile.open(path.c_str(), ios::out);

 if(!(timingfile.is_open())) {
   cerr << "Cant create file \"" << path << "\"" << endl;
   return -1;
 }
 timingfile << "All timing values in milliseconds:" << endl;


 //to indicate the program is running (at least on Win32), open empty window
 screen = SDL_SetVideoMode(320, 200, 24, SDL_SWSURFACE | SDL_RESIZABLE | SDL_ANYFORMAT);

 //output audio to file
 ofstream audiofile;

 if(anim.GetAudioFormat(NULL, NULL, NULL) == 0)
 {
   path = string(bmp_path) + "audio.raw";
   audiofile.open(path.c_str(), ios::binary | ios::out);

   if(!(audiofile.is_open())) {
     cerr << "Cant create file \"" << path << "\"" << endl;
     return -1;
   }
   
   char *audiodata;
   int audiosize;

   audiodata = anim.GetAudioData(&audiosize);
   audiofile.write(audiodata, audiosize);
   audiofile.close();
 }

 //get length of decimal number, for file numbering
 sprintf(file_name, "%d", numframes);
 int numlen = strlen( file_name );

 //set pointers (points to first frame)
 void *cmap;
 void *bitmap;
 bitmap = anim.GetFrame();
 cmap = anim.GetCmap();

 //create display surface with format of animation (8 or 24 bits per pixel)
 dispimg = SDL_CreateRGBSurface(SDL_SWSURFACE, w_org, h_org, bpp, RMASK, GMASK, BMASK, 0);
 if(dispimg == NULL) {
   cerr << "Couldn't create surface: " << SDL_GetError() << endl;
   return -1;
 }

 //extract each frame to file
 for(i = 0; i < numframes; i++)
 {
   //convert iffanim output to SDL surface
   anim.ConvertFrame();
   //use scale functions for simple copy
    if(bpp == 8) {
      ScaleBitmap8((char*)dispimg->pixels, w_org, h_org, dispimg->pitch, (char*)bitmap, w_org, h_org, pitch);
      //adjust palette (it may have changed)
      memcpy(dispimg->format->palette->colors, cmap, dispimg->format->palette->ncolors * 4);
    }
    else
      ScaleBitmap24((char*)dispimg->pixels, w_org, h_org, dispimg->pitch, (char*)bitmap, w_org, h_org, pitch);

   //generate file name
   mkfname(i, numlen, file_name, "frame", ".bmp");
  
   path = string(bmp_path) + file_name;

   if(SDL_SaveBMP(dispimg, path.c_str()) == -1) {
     cerr << "Error saving .bmp file: " << SDL_GetError() << endl;
     break;
   }
   timingfile << file_name << " " << (double)(anim.GetDelayTimeOriginal()) *  1000 / 60 << endl;
   anim.NextFrame();
 }

 SDL_FreeSurface(dispimg);     
 cout << i << " frames of " << numframes << " extracted" << endl;
 SDL_Quit();
 return 0;
}


/******************************************************************************/
// main function
int AnimPlayer::main(int argc, char **argv)
{
 if(argc <= 1) {
   cout << "Error, too few arguments" << endl;
   printhelp();
   return -1;
 }

 //init SDL
 if(SDL_Init(SDL_INIT_VIDEO) < 0) {
    cout << "Unable to initialize sdl: " << SDL_GetError() << endl;
    return -1;
 }

 //open and load anim file
 int err = anim.Open(argv[1]);
 cout << "Open animation file \"" << argv[1] << "\" ... " << anim.GetError() << endl;
 if(err < 0) {
   cout << "Error loading and initializing anim file, exitting ..." << endl;
   return -1; 
 }


 //print information
 cout << anim.GetInfo() << endl;

 //set default state 
 curframe = 0;
 playing = true;
 ended = false;
 loop = false;
 loopanim = false;
 fixtime = false;


 //format of the frame, which is return by iffanim
 //get format of prepared decompressed image
 anim.GetInfo(&w_org, &h_org, &bpp, &pitch, &numframes, &lentime);
 w_disp = w_org;
 h_disp = h_org;

 //get image and cmap pointer, these pointers remains constant
 //after "anim.ConvertFrame" they point to the new data
 void *cmap;
 void *bitmap;


 //check arguments
 int tmp;
 for(int i = 2; i < argc; i++)
 {
    if( memcmp(argv[i],"-neww",5) == 0) {
       w_disp = atoi( argv[i]+5 );
       if(w_disp <= 0)
          w_disp = w_org;
    }
    if( memcmp(argv[i],"-newh",5) == 0) {
       h_disp = atoi( argv[i]+5 );
       if(h_disp <= 0)
          h_disp = h_org;
    }
    if( strcmp(argv[i],"-extract") == 0)
    {
      if(argv[i + 1] != NULL)
        return Extract(argv[i + 1]);
      else {  
        cerr << "Error, no output path specified, can't save output files" << endl;
        return -1;
      }
    }
    if( strcmp(argv[i],"-loop") == 0)
       loop = true;
    if( strcmp(argv[i],"-loopanim") == 0) {
       loopanim = true;
       anim.SetLoopAnim(true);
       anim.GetInfo(NULL, NULL, NULL, NULL, &numframes, &lentime);  // update info
    }
    if( memcmp(argv[i],"-fixtime",8) == 0) {
       fixtime = true;
       fixtimeval = atoi(argv[i] + 8);
    }
    if( strcmp(argv[i],"-h") == 0)
       printhelp();
 }
 
 
 //before any SDL screen is opened this gives us the the desktop screen format
 const SDL_VideoInfo *info = SDL_GetVideoInfo();
 if(info != NULL)
   cout << "desktop bits per pixel: " << (int)(info->vfmt->BitsPerPixel) << endl;
 
 
 //open window
 //the 8 bit mode is much faster (although for a 32 bit desktop it must be converted by SDL nevertheless)
 //for 8 bit mode the palette must be copied to the "screen" surface before blitting images to it
 screen = SDL_SetVideoMode(w_disp, h_disp, bpp, SDL_SWSURFACE | SDL_RESIZABLE);
 if(screen == NULL) {
   cerr << "unable to open SDL video surface with " << (int)bpp << " bit: " << SDL_GetError() << endl;
   return -1;
 }



 //create display surface with format of animation (8 or 24 bits)
 dispimg = SDL_CreateRGBSurface(SDL_SWSURFACE, w_disp, h_disp, bpp, RMASK, GMASK, BMASK, 0);
 if(dispimg == NULL) {
   cerr << "Couldn't create surface: " << SDL_GetError() << endl;
   return -1;
 }


 //init SDL audio if available in animation
 //anim audio format is always signed Big Endian
 bool audioinitialized = false;
 int nch, bps, freq;
 if(anim.GetAudioFormat(&nch, &bps, &freq) == 0)
 {
   this->audiopos = 0;
   this->audiodata = anim.GetAudioData(&(this->audiolen));
          
   if((nch > 2) || (nch == 0) || ((bps != 8) && (bps != 16)))
     cerr << "invalid audio format, audio not playable" << endl;
   else if ((audiolen <= 0) || (audiodata == NULL))
     cerr << "audio error, audio not playable" << endl;
   else
   {
     SDL_AudioSpec desired;
     desired.freq = freq;
     desired.channels = nch;
     desired.samples = IFFANIMPLAY_SMPBUFSIZE;
     desired.callback = AnimPlayer::audio_callback;
     if(bps == 8) desired.format = AUDIO_S8;
     else         desired.format = AUDIO_S16MSB;  //audio is Big Endian
     desired.userdata = (void*)this;              //pointer to the player instance
     //Open the audio device, forcing the desired format
     if ( SDL_OpenAudio(&desired, NULL) < 0 )
       cerr << "Couldn't open audio: %s\n" << SDL_GetError() << endl;
     else {        //start playing
       audioinitialized = true;
       SDL_PauseAudio(0);
     }
   }
 }

 //playing loop
 int delay;
 curframe = 0;
 while(1)
 {
    SetCaption();    //set window title

    //determine timing for current frame (threshold to next frame)
    if(fixtime) delay = fixtimeval;
    else        delay = anim.GetDelayTime();

    delay += SDL_GetTicks();  //synchronize with SDL ticks

    //convert current frame to display format
    anim.ConvertFrame();
    bitmap = anim.GetFrame();  //get frame buffer pointer
    cmap   = anim.GetCmap();   //format is r,g,b,0 (SDL_Color has the same structure)

    //scale bitmap (8 or 24 bit), don't blit to screen directly so SDL can convert properly: e.g. color channel order
    if(bpp == 8)
    {
      ScaleBitmap8((char*)dispimg->pixels, w_disp, h_disp, dispimg->pitch, (char*)bitmap, w_org, h_org, pitch);
      //adjust palette (it may have changed)
      memcpy(dispimg->format->palette->colors, cmap, dispimg->format->palette->ncolors * 4);
    }
    else
      ScaleBitmap24((char*)dispimg->pixels, w_disp, h_disp, dispimg->pitch, (char*)bitmap, w_org, h_org, pitch);

    //blit to screen, flip double buffer
    if(bpp <= 8)
      SDL_SetPalette(screen, SDL_LOGPAL | SDL_PHYSPAL, dispimg->format->palette->colors, 0, 256);    //copy palette for 8 bit surfaces

    SDL_BlitSurface(dispimg, NULL, screen, NULL);
    SDL_Flip(screen);

    //prepare next frame (internal decoding only)
    anim.NextFrame();

    int ret = Wait(delay - SDL_GetTicks()); //waits automatically when the last frame is reached and loop is deactivated
    if(ret == IFFANIMPLAY_QUIT)
      break;

    //if last frame is reached, handle enabled loop
    if(loop && (curframe == (numframes - 1))) {
      audiopos = 0;          // reset audio position to restart playing
      curframe = -1;         // turns to 0 next frame loop iteration start
    }

   curframe++;
 } // end for nframes
    
 //free all buffers
 SDL_FreeSurface(dispimg);
 SDL_PauseAudio(1);  //stop audio (callback thread), else the program crashes when "anim" is destructed
 anim.Close();

 SDL_Quit();
 return 0;
}



/******************************************************************************/
//resize SDL screen
void AnimPlayer::Resize(int w, int h)
{
 if(w == w_disp  &&  h == h_disp)
   return;

 w_disp = w;
 h_disp = h;

 //dispimg content is currently displayed

 //dispimg must be resized
 SDL_Surface *tempsurf;
 tempsurf = SDL_CreateRGBSurface(dispimg->flags, w_disp, h_disp, dispimg->format->BitsPerPixel,  dispimg->format->Rmask, dispimg->format->Gmask, dispimg->format->Bmask, dispimg->format->Amask); 
 SDL_FreeSurface(dispimg);
 dispimg = tempsurf;
 if(dispimg == NULL) {
   cerr << "Can't allocate surface" << endl;
   exit(1);
 }

 //resize the screen: init new screen and blit dispimg
 screen = SDL_SetVideoMode(w_disp, h_disp,  screen->format->BitsPerPixel, screen->flags); //reinit screen with new dimensions
 if(screen == NULL) {
   cerr << "Unable to resize SDL video surface: " << SDL_GetError() << endl;
   exit(1);
 }


 //the "converted frame" hasn't changed yet, although the internal bitplanar has
 //so get it and scale
 if(bpp == 8) {
    ScaleBitmap8((char*)dispimg->pixels, w_disp, h_disp, dispimg->pitch, (char*)anim.GetFrame(), w_org, h_org, pitch);
    //copy cmap
    memcpy(dispimg->format->palette->colors, anim.GetPrevCmap(), dispimg->format->palette->ncolors * sizeof(SDL_Color));
 }
 else
    ScaleBitmap24((char*)dispimg->pixels, w_disp, h_disp, dispimg->pitch, (char*)anim.GetFrame(), w_org, h_org, pitch);


 //copy palette to screen;
 if(bpp <= 8)
   SDL_SetPalette(screen, SDL_LOGPAL | SDL_PHYSPAL, dispimg->format->palette->colors, 0, 256);    //copy palette for 8 bit surfaces

 SDL_BlitSurface(dispimg, NULL, screen, NULL);  //blit resized frame to screen
 SDL_Flip(screen);
}




/******************************************************************************/
// - wait for "delayms" milliseconds
// - handle events (user input)
// - stay in the delay loop when anim has ended or is paused
int AnimPlayer::Wait(int delayms)
{
 int delayms_passed = 0;
 SDL_Event event;
 int delaythres = delayms + SDL_GetTicks();    // determine threshold when delay is elapsed

 //last frame?
 if(curframe == (numframes - 1) && !(loop)) {
   ended = true;
   SetCaption();
 }

 //delay loop
 do
 {
    SDL_Delay(1); //wait a little

    //poll events
    if(SDL_PollEvent(&event))
    {
       if(event.type == SDL_QUIT)          //if window is closed
          return IFFANIMPLAY_QUIT;
          
       if(event.type == SDL_VIDEORESIZE )
          Resize(event.resize.w, event.resize.h);

       if(event.type == SDL_KEYDOWN)
       {
          switch(event.key.keysym.sym)
          {

            case SDLK_0:
              Resize(w_org/2, h_org/2);
              break;                   
            case SDLK_1:
              Resize(w_org, h_org);
              break;                          
            case SDLK_2:
              Resize(w_org*2, h_org*2);
              break;                                
            case SDLK_3:
              Resize(w_org*3, h_org*3);
              break;        
                 
                                           
            case SDLK_ESCAPE:
              return IFFANIMPLAY_QUIT;
              break;

            case SDLK_SPACE:                              // handle pause/play
              if(playing == true) {                       //stop if currently playing
                SDL_PauseAudio(1);
                playing = false;
                delayms_passed = delayms - (delaythres - SDL_GetTicks()); //needed to resynchronize audio
                delayms = delaythres - SDL_GetTicks();    // save remaining delay when going into pause mode
              }
              else {                                      //start playing if currently stopped
                audiopos = anim.GetAudioOffset(curframe, delayms_passed); // restore playing position                   
                playing = true;
                delaythres = SDL_GetTicks() + delayms;    // restore remaining delay when leaving pause mode
                SDL_PauseAudio(0);
              }
              break;
              
            case SDLK_RIGHT:
              if(ended == false) {
                audiopos = anim.GetAudioOffset(curframe + 1); // resync audio with next frame
                return IFFANIMPLAY_NONE;                      // leave, so the next frame is displayed immidiately              
              }
              break;
          
            case SDLK_r:               // handle reset to first frame
              SDL_PauseAudio(1);
              playing = false;         // stop after reset (playing must be enabled manually)
              curframe = -1;
              ended = false;
              anim.Reset();
              return IFFANIMPLAY_NONE;
              break;
          }

          SetCaption();
      }
    }
 } while((ended == true) || (playing == false) ||(delaythres > SDL_GetTicks()));

 return IFFANIMPLAY_NONE;
}
