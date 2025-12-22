/*
 */

#include <sys/time.h>
#include <time.h>
#include <stdio.h>

#include <proto/exec.h>
#include <proto/graphics.h>
#include <proto/Picasso96API.h>
#include <proto/intuition.h>
#include <proto/timer.h>

#include <exec/types.h>
#include <graphics/rpattr.h>
#include <dos/dos.h>

#include <SDL/SDL.h>
#include <SDL/SDL_image.h>
#include <SDL/SDL_ttf.h>

#include <ablit/ablit.h>
#include <ablit/ablit_SDL.h>
#include <ablit/ablit_utils.h>

TTF_Font *pFallbackFont = NULL;

const SDL_Color  white = { 255,255,255 },
                 black = {   0,  0,  0 },
                 red   = { 255,  0,  0 },
                 green = {   0,255,  0 },
                 blue  = {   0,  0,255 };

void drawText( const char* text, struct BitMap * bitmap,
               int32 x, int32 y, SDL_Color col,
               TTF_Font* font  )
{
    if (font == NULL) font = pFallbackFont;
    if (font == NULL) return;
    SDL_Surface *surface = TTF_RenderText_Blended( font, text, col);
    if (surface)
    {
        SDL_BlitAlphaSurfaceBitMap( surface, 0, 0,
                                    bitmap,  x, y,
                                    surface->w, surface->h,
                                    BLM_SRC_ALPHA );
        SDL_FreeSurface( surface );
    }
}

void drawTextRastPort( const char* text, struct RastPort *rp,
                       int32 x, int32 y, SDL_Color col,
                       TTF_Font* font  )
{
    if (font == NULL) font = pFallbackFont;
    if (font == NULL) return;
    SDL_Surface *surface = TTF_RenderText_Blended( font, text, col);
    if (surface)
    {
        SDL_BlitAlphaSurfaceRastPort( surface, 0, 0,
                                      rp,  x, y,
                                      surface->w, surface->h,
                                      BLM_SRC_ALPHA );
        SDL_FreeSurface( surface );
    }
}

void dumpSurfaceInfo( const char* desc, SDL_Surface * surface )
{
    SDL_PixelFormat *fmt = surface->format;

    DebugPrintF("************************************************************\n");
    DebugPrintF( "Surface %s: depth = %d, bpp = %d, blend = %s value = %d\n", desc,
                    fmt->BitsPerPixel, fmt->BytesPerPixel,
                    surface->flags & SDL_SRCALPHA ? "ON" : "OFF", fmt->alpha );
    DebugPrintF( "Shift: a[%8d] r[%8d] g[%8d] b[%8d]\n",
                    fmt->Ashift, fmt->Rshift, fmt->Gshift, fmt->Bshift );
    DebugPrintF( "Mask:  a[%08x] r[%08x] g[%08x] b[%08x]\n",
                    fmt->Amask , fmt->Rmask , fmt->Gmask , fmt->Bmask);
    DebugPrintF( "Loss:  a[%8d] r[%8d] g[%8d] b[%8d]\n",
                    fmt->Aloss , fmt->Rloss, fmt->Gloss, fmt->Bloss);
    DebugPrintF("************************************************************\n");
}

void dumpSurfaceInfoXY( const char* desc, SDL_Surface * surface,
                        struct BitMap * bitmap,  int32 x, int32 y,
                        SDL_Color col,
                        TTF_Font* font )
{
    char c[256];
    uint32 h = 13; // TTF_FontHeight( font );
    SDL_PixelFormat *fmt = surface->format;
    sprintf(c, "************************************************************");
    drawText( c, bitmap, 1 + x, 1 + y, black, font );
    drawText( c, bitmap, x, y, col, font ); y += h;
    //
    sprintf( c, "Surface '%s': depth = %d, bpp = %d, blend = %s value = %d", desc,
                    fmt->BitsPerPixel, fmt->BytesPerPixel,
                    surface->flags & SDL_SRCALPHA ? "ON" : "OFF", fmt->alpha );
    drawText( c, bitmap, 1 + x, 1 + y, black, font );
    drawText( c, bitmap, x, y, col, font ); y += h;
    //
    sprintf( c, "Shift: a[%8d] r[%8d] g[%8d] b[%8d]",
                    fmt->Ashift, fmt->Rshift, fmt->Gshift, fmt->Bshift );
    drawText( c, bitmap, 1 + x, 1 + y, black, font );
    drawText( c, bitmap, x, y, col, font ); y += h;
    //
    sprintf( c, "Mask:  a[%08x] r[%08x] g[%08x] b[%08x]",
                    fmt->Amask , fmt->Rmask , fmt->Gmask , fmt->Bmask);
    drawText( c, bitmap, 1 + x, 1 + y, black, font );
    drawText( c, bitmap, x, y, col, font ); y += h;
    //
    sprintf( c, "Loss:  a[%8d] r[%8d] g[%8d] b[%8d]",
                    fmt->Aloss , fmt->Rloss, fmt->Gloss, fmt->Bloss);
    drawText( c, bitmap, 1 + x, 1 + y, black, font );
    drawText( c, bitmap, x, y, col, font ); y += h;
    //
    sprintf(c, "************************************************************");
    drawText( c, bitmap, 1 + x, 1 + y, black, font );
    drawText( c, bitmap, x, y, col, font ); y += h;
}

#define RAW_KEY_ESC  0x45

void drawImage( SDL_Surface *surface, struct BitMap *bitmap, int32 x, int32 y )
{
#define SHOW_TIME
#ifdef SHOW_TIME
    char buffer[128];
//    sprintf( buffer, "Blitting SDL_Surface to a struct BitMap ... \n");
//    printf( buffer );
//    DebugPrintF( buffer );
    uint32 ticks = SDL_GetTicks();
#endif

    SDL_BlitAlphaSurfaceBitMap( surface ,
                                0, 0,
                                bitmap,
                                x, y,
                                surface->w, surface->h,
                                BLM_SRC_ALPHA );

#ifdef SHOW_TIME
    ticks = SDL_GetTicks() - ticks;
    double fps = 1.0/(double)ticks*1000.0;
    double bm_size = ((double)surface->w * (double)surface->h * (double)surface->format->BytesPerPixel / 1024 / 1024);
    sprintf( buffer, "draw(): %d ms, %.3g frames per sec, %4.04g MB/sec (%.4g MB)", ticks, fps, bm_size * fps, bm_size );
//    printf( buffer ); printf("\n");
//    DebugPrintF( buffer ); DebugPrintF( "\n" );
    drawText( buffer, bitmap, 3, 580, white, NULL );
#endif
}

void drawImageSDL( SDL_Surface *src, SDL_Surface *dst, int32 x, int32 y )
{
#define SHOW_TIME
#ifdef SHOW_TIME
    fprintf( stderr, "Blitting Image to a SDL_Surface ... ");
    uint32 ticks = SDL_GetTicks();
#endif
    SDL_Rect sr = { 0, 0, src->w, src->h };
    SDL_Rect dr = { x, y, src->w, src->h };

    // These three lines are equivalent:
//    SDL_BlitSurface( src, NULL, dst, &dr );
//    SDL_LowerBlit( src, &sr, dst, &dr );
    SDL_BlitAlphaSurface( src, NULL, dst, &dr );

#ifdef SHOW_TIME
    ticks = SDL_GetTicks() - ticks;
    char buffer[128];
    double fps = 1.0/(double)ticks*1000.0;
    double bm_size = ((double)src->w * (double)src->h * (double)src->format->BytesPerPixel / 1024 / 1024);
    sprintf( buffer, "%d ms, %.3g frames per sec, %4.04g MB/sec (%.4g MB)\n", ticks, fps, bm_size * fps, bm_size );
    printf( buffer );
    DebugPrintF( buffer );
#endif
}

int main( int argc, char* argv[] )
{
    BOOL use_sdl = FALSE;
    BOOL fullscreen = FALSE;
    double bm_size = 800.0 * 600.0 * 4 / 1024 / 1024;
    double fps, speed;
    uint32 ticks;
    int    i = 5;
    uint32 w   = 800, h  = 600;
    uint32 sw  = 800, sh = 600, sd = 16;
    SDL_Surface *s;
    SDL_Surface *alpha, *background;
    SDL_PixelFormat fmt =
    {
        /* fmt.paletter = */ NULL,
#define USE_BLEND
#define USE32
#ifdef USE24 // RGB/BGR
        /* fmt.BitsPerPixel  = */ 24,
        /* fmt.BytesPerPixel = */ 3,
        /* fmt.Rloss  = */ 0,
        /* fmt.Gloss  = */ 0,
        /* fmt.Bloss  = */ 0,
        /* fmt.Aloss  = */ 8,
        /* fmt.Rshift = */ 16,
        /* fmt.Gshift = */ 8,
        /* fmt.Bshift = */ 0,
        /* fmt.Ashift = */ 0,
        /* fmt.Rmask  = */ 0x00ff0000,
        /* fmt.Gmask  = */ 0x0000ff00,
        /* fmt.Bmask  = */ 0x000000ff,
        /* fmt.Amask  = */ 0x00000000,
#endif
#ifdef USE32 // RGBA/BGRA/ARGB
        /* fmt.BitsPerPixel  = */ 32,
        /* fmt.BytesPerPixel = */ 4,
        /* fmt.Rloss  = */ 0,
        /* fmt.Gloss  = */ 0,
        /* fmt.Bloss  = */ 0,
        /* fmt.Aloss  = */ 0,
        /* fmt.Rshift = */ 8,
        /* fmt.Gshift = */ 16,
        /* fmt.Bshift = */ 24,
        /* fmt.Ashift = */ 0,
        /* fmt.Rmask  = */ 0x00ff0000,
        /* fmt.Gmask  = */ 0x0000ff00,
        /* fmt.Bmask  = */ 0x000000ff,
        /* fmt.Amask  = */ 0xff000000,
#endif
#ifdef USE16 // RGB565/555
        /* fmt.BitsPerPixel  = */ 16,
        /* fmt.BytesPerPixel = */ 2,
        /* fmt.Rloss  = */ 3,
        /* fmt.Gloss  = */ 2,
        /* fmt.Bloss  = */ 3,
        /* fmt.Aloss  = */ 8,
        /* fmt.Rshift = */ 11,
        /* fmt.Gshift = */ 5,
        /* fmt.Bshift = */ 0,
        /* fmt.Ashift = */ 0,
        /* fmt.Rmask  = */ 0x0000F800,
        /* fmt.Gmask  = */ 0x000007E0,
        /* fmt.Bmask  = */ 0x0000001F,
        /* fmt.Amask  = */ 0x00000000,
#endif
        /* fmt.colorkey = */ 0,
        /* fmt.alpha  = */ 0,
    };

    background = IMG_Load( "/pictures/blue.png" );
    if (background == NULL)
    {
        printf("Could not load 'blue.png'\n");
        exit(20);
    }

    alpha = IMG_Load( "/pictures/alpha.png" );
    if (alpha == NULL)
    {
        SDL_FreeSurface(alpha);
        printf("Could not load 'alpha.png'\n");
        exit(20);
    }

    while ( argc > 1 )
    {
        if ( strcmp(argv[1], "--sdl") == 0 ||
             strcmp(argv[1], "-s")    == 0 )
        {
            use_sdl = TRUE;
            argv++;
            argc--;
        }
        else if ( strcmp(argv[1], "--fullscreen") == 0 ||
                  strcmp(argv[1], "-f")           == 0  )
        {
            fullscreen = TRUE;
            argv++;
            argc--;
        }
        else if ( strcmp(argv[1], "--window") == 0 ||
                  strcmp(argv[1], "-w")           == 0  )
        {
            fullscreen = FALSE;
            argv++;
            argc--;
        }
        else if ( strcmp(argv[1], "--depth") == 0 ||
                  strcmp(argv[1], "-d")           == 0  )
        {
            uint32 d;
            d = atoi( argv[2] );
            if (d == 16 || d == 32 )
            {
                sd = d;
            }
            else if (d == 24)
            {
                sd = 32;
            }
            argv += 2;
            argc -= 2;
        }
        else
        {
            argv++;
            argc--;
        }

    }

    dumpSurfaceInfo( "'alpha' before convert", alpha );
    s = SDL_ConvertSurface( alpha, &fmt, 0 );
    if (s)
    {
        SDL_FreeSurface(alpha);
        alpha = s;
    }
#ifdef USE_BLEND
    alpha->flags |= SDL_SRCALPHA;
    alpha->format->alpha = 255;
#endif
    dumpSurfaceInfo( "'alpha' after convert", alpha );

/* convert to format defined above

    s = SDL_ConvertSurface( background, &fmt, 0 );
    if (s)
    {
        SDL_FreeSurface(background);
        background = s;
    }
*/

	if (TTF_Init() == -1)
	{
		fprintf(stderr,
    		"Couldn't initialize SDL_ttf: %s\n", TTF_GetError());
		return -1;
    }
	atexit(TTF_Quit);
    pFallbackFont = TTF_OpenFont( "/fonts/FreeSans.ttf", 13 );

    if ( use_sdl )
    {
        SDL_Surface *screen, *buffer;
        uint32 video_flags = SDL_FULLSCREEN;
        BOOL out = FALSE;

        // Test surface->bitmap->surface blits
        struct TagItem ti[] =
        {
            BMATags_Clear,       TRUE,
            BMATags_Alignment,   8,   // uint64 alignment
            BMATags_NoSprite,    TRUE,
            BMATags_RGBFormat,   RGBFB_R8G8B8A8,
            BMATags_Depth,       32,

            TAG_DONE
        };
        struct BitMap *bitmap;
/*
        bitmap = AllocBitMap( alpha->w, alpha->h, 32, BMF_CHECKVALUE, &ti );
        draw( alpha, bitmap, 0, 0 );
        SDL_BlitAlphaBitmapSurface( bitmap,
                                   0, 0,
                                   alpha,
                                   0, 0,
                                   alpha->w, alpha->h,
                                   128,
                                   BLM_SRC_COPY );
        FreeBitMap(bitmap);
*/
        fprintf(stderr, "Running blittest - SDL version\n" );

        if ( SDL_Init( SDL_INIT_VIDEO ) < 0 )
        {
            fprintf(stderr,
                   "Couldn't initialize SDL: %s\n", SDL_GetError());
            exit(1);
        }
        atexit(SDL_Quit);           /* Clean up on exit */

        screen = SDL_SetVideoMode( sw, sh, sd, video_flags);
        if ( screen == NULL )
        {
            fprintf(stderr, "Couldn't set %dx%dx%d video mode: %s\n",
                    sw, sh, sd, SDL_GetError());
            exit(1);
        }

        DebugPrintF("------------------------------------------------------------\n");
        DebugPrintF("Blittest SDL_image version\n");

        /* Set the window manager title bar */
        SDL_WM_SetCaption("Blittest SDL_image version", "Blittest");
        SDL_EnableKeyRepeat( SDL_DEFAULT_REPEAT_DELAY, SDL_DEFAULT_REPEAT_INTERVAL );

        buffer = SDL_DisplayFormatAlpha( background );
        SDL_FreeSurface(background);
        background = buffer;
        background->flags &= ~SDL_SRCALPHA;
        drawImageSDL( background, screen, 0, 0);

        DebugPrintF( "Screen Format: %d\n", screen->format->BitsPerPixel );
        DebugPrintF("------------------------------------------------------------\n");
        DebugPrintF( "Screen Shift: a[%8d] r[%8d] g[%8d] b[%8d]\n",
                        screen->format->Ashift, screen->format->Rshift, screen->format->Gshift, screen->format->Bshift );
        DebugPrintF( "Screen Mask:  a[%08x] r[%08x] g[%08x] b[%08x]\n",
                        screen->format->Amask ,screen->format->Rmask, screen->format->Gmask, screen->format->Bmask);
        DebugPrintF( "Screen Loss:  a[%8d] r[%8d] g[%8d] b[%8d]\n",
                        screen->format->Aloss, screen->format->Rloss, screen->format->Gloss, screen->format->Bloss);
        DebugPrintF("------------------------------------------------------------\n");
        DebugPrintF( "Alpha Format: %d\n", screen->format->BitsPerPixel );
        DebugPrintF("------------------------------------------------------------\n");
        DebugPrintF( "Alpha Shift: a[%8d] r[%8d] g[%8d] b[%8d]\n",
                        alpha->format->Ashift, alpha->format->Rshift, alpha->format->Gshift, alpha->format->Bshift );
        DebugPrintF( "Blue Mask:  a[%08x] r[%08x] g[%08x] b[%08x]\n",
                        alpha->format->Amask, alpha->format->Rmask, alpha->format->Gmask, alpha->format->Bmask);
        DebugPrintF( "Blue Loss:  a[%8d] r[%8d] g[%8d] b[%8d]\n",
                        alpha->format->Aloss, alpha->format->Rloss, alpha->format->Gloss, alpha->format->Bloss);
        DebugPrintF("------------------------------------------------------------\n");
        DebugPrintF( "Blue Flags: RLE: %s, ALPHA: %s \n", alpha->flags & SDL_RLEACCEL ? "YES" : "NO",
                                                          alpha->flags & SDL_SRCALPHA ? "YES" : "NO" );
        SDL_Rect rc = { 0,0, 800, 600 };

        drawImageSDL( alpha, screen, 0, 0 );
        SDL_UpdateRect( screen, 0, 0, ~0, ~0 );

        while (!out)
        {
            SDL_Event eve;
            while (!out && SDL_WaitEvent( &eve ) > 0)
            {
                switch (eve.type)
                {
                    case SDL_QUIT:
                        out = TRUE;
                        break;
                    case SDL_KEYDOWN:
                        switch (eve.key.keysym.sym)
                        {
    					case SDLK_ESCAPE:
    						out = TRUE;
    						break;
                        }
                    default:
                        SDL_Delay( 10 );
                        break;
                }
            }
        }
    }
    else
    {
        struct ABU_VideoInfo *vi;
        struct IntuiMessage  *IMsg;
        uint32                IClass;
        uint16                ICode;
        APTR                  IAddress;
        uint32                MouseX, MouseY;
        uint32                ISig;
        BOOL                  out   = FALSE;
        TTF_Font             *pFont = NULL;
        SDL_Surface          *text_surface = NULL;
        struct BitMap        *screenBuffer = NULL, *backBuffer = NULL, *backGround;
        BOOL                  refresh = TRUE;
        BOOL                  button_down = FALSE;

        DebugPrintF("---------------------------------------------------\n");
        DebugPrintF("Running blittest - Amiga native version\n" );
        DebugPrintF("---------------------------------------------------\n");

        printf("---------------------------------------------------\n");
        printf("Running blittest - Amiga native version\n" );
        printf("---------------------------------------------------\n");

        /* ABlit Utils */
        if ( vi = ABU_InitVideo( sw, sh, sd, (fullscreen ? ABUF_FULLSCREEN : ABUF_NONE) ) )
        {
            struct TagItem ti[] =
            {
                BMATags_RGBFormat,   RGBFB_R5G6B5, // that's the p96 format we want to have
                BMATags_Clear,       TRUE,      // clear it first
                BMATags_Alignment,   8,         // uint64 alignment
                BMATags_Displayable, FALSE,     // use system mem
                BMATags_NoSprite,    TRUE,      // why not
                BMATags_Depth,       sd,        // clone screen depth

                TAG_DONE,            TAG_DONE
            };
            screenBuffer = vi->screen->RastPort.BitMap;
//#define _VMEM
#ifdef _VMEM // we want it in video mem
            backBuffer   = AllocBitMap( sw, sh, sd, BMF_CLEAR|BMF_DISPLAYABLE, screenBuffer);
            backGround   = AllocBitMap( sw, sh, sd, BMF_CLEAR|BMF_DISPLAYABLE, screenBuffer);
#else        // or system mem
            backBuffer   = AllocBitMap( sw, sh, sd, BMF_CHECKVALUE, (struct BitMap*)&ti );
            {
                struct RenderInfo ri;
                int32 lock = /*IP96->*/p96LockBitMap( screenBuffer, (uint8*)&ri, (uint32)sizeof(struct RenderInfo) );
                if ( lock )
                {
                    ti[0].ti_Data = ri.RGBFormat;
                    p96UnlockBitMap( screenBuffer, lock );
                }
            }
            backGround   = AllocBitMap( sw, sh, sd, BMF_CHECKVALUE, (struct BitMap*)&ti );
#endif
            if (backBuffer == NULL) backBuffer = screenBuffer;

            
            DebugPrintF("Destintion is in %s\n", p96GetBitMapAttr( backBuffer, P96BMA_ISONBOARD )
                                                ? "vmem" : "sys" );
            DebugPrintF("---------------------------------------------------\n");

        	TTF_Font* pFont = TTF_OpenFont( "/fonts/FreeSans.ttf", 18 );
        	if (!pFont)
        	{
                fprintf( stderr, "Could not open '/fonts/FreeSans.ttf' font! ");
        	}
        	TTF_Font* pCourier = TTF_OpenFont( "/fonts/FreeMono.ttf", 12 );
        	if (!pCourier)
        	{
                fprintf( stderr, "Could not open '/fonts/FreeMono.ttf' font! ");
        	}

            drawImage( background, backGround, 0, 0 );
            SDL_BlitAlphaSurfaceBitMap( background,
                                        0, 0,
                                        backGround,
                                        0, 0,
                                        background->w, background->h,
                                        BLM_SRC_ALPHA );

            BltBitMap( backGround, 0, 0, backBuffer, 0, 0, sw, sh, 0xC0, 0xFF, NULL );
            drawImage( alpha, backBuffer, 0, 0  );

            dumpSurfaceInfoXY("alpha", alpha,
                              backBuffer, 3, 25,
                              white, pCourier );

            if (backBuffer != screenBuffer)
            {
                BltBitMapRastPort( backBuffer, 0, 0, vi->window->RPort, 0, 0, sw, sh, 0xC0 );
            }

            int16 blend = alpha->format->alpha;
            uint32 px = (sw - alpha->w)/2, py = (sh - alpha->h)/2;
            do
            {
                ISig = Wait( 1 << vi->window->UserPort->mp_SigBit | SIGBREAKF_CTRL_C );
                if ( ISig & SIGBREAKF_CTRL_C )
                {
                    out = TRUE;
                    break;
                }

                while ( (IMsg = (struct IntuiMessage *)GetMsg( vi->window->UserPort )) )
                {
                    IClass = IMsg->Class;
                    ICode  = IMsg->Code;
                    MouseX = IMsg->MouseX;
                    MouseY = IMsg->MouseY;
                    IAddress = IMsg->IAddress;
                    ReplyMsg((struct Message *)IMsg);

                    switch (IClass)
                    {
                        case IDCMP_CLOSEWINDOW:
                            out = TRUE;
                            break;
                        case IDCMP_RAWKEY:
                            switch (ICode/* & 0x7f , | 0x80 == key up */)
                            {
                                case RAW_KEY_ESC:
                                    out = TRUE;
                                    break;
                                case CURSORRIGHT:
                                    px += 1;
                                    refresh = TRUE;
                                    break;
                                case CURSORLEFT:
                                    px -= 1;
                                    refresh = TRUE;
                                    break;
                                case CURSORUP:
                                    py -= 1;
                                    refresh = TRUE;
                                    break;
                                case CURSORDOWN:
                                    py += 1;
                                    refresh = TRUE;
                                    break;
                                case 94:
                                    if ((blend+=1) > 0xFF) blend = 0xFF;
                                    alpha->format->alpha = blend;
                                    refresh = TRUE;
                                    break;
                                case 74:
                                    if ((blend-=1) < 0x00) blend = 0x00;
                                    alpha->format->alpha = blend;
                                    refresh = TRUE;
                                    break;
                                default:
                                    {
                                        char c[256];

                                        sprintf( c, "Rawkey-Code %d", ICode);
                                        drawText( c, backBuffer, 3, 50, white, NULL );
                                        DebugPrintF(c); DebugPrintF("\n");
                                    }
                                    break;
                            }
                            break;
                        case IDCMP_EXTENDEDMOUSE:
                            if (ICode & IMSGCODE_INTUIWHEELDATA)
                            {
                                struct IntuiWheelData *wd = (struct IntuiWheelData*)IAddress;

                                blend += 8 * wd->WheelY;
                                if (blend > 0xFF) blend = 0xFF;
                                if (blend < 0x00) blend = 0x00;
                                alpha->format->alpha = blend;
                                refresh = TRUE;
                            }
                            break;
                        case IDCMP_MOUSEBUTTONS:
                            if (ICode & IECODE_UP_PREFIX)
                            {
                                button_down = FALSE;
                            }
                            switch (ICode)
                            {
                                case SELECTDOWN:
                                    button_down = TRUE;
                                    px = MouseX - alpha->w/2;
                                    py = MouseY - alpha->h/2;
                                    refresh = TRUE;
                                    break;
                                case SELECTUP:
                                    button_down = FALSE;
                                    break;
                            }
                            break;
                        case IDCMP_MOUSEMOVE:
                            if (button_down)
                            {
                                px = MouseX - alpha->w/2;
                                py = MouseY - alpha->h/2;
                                refresh = TRUE;
                            }
                            break;
                    }
                    if (refresh) // && backBuffer != screenBuffer)
                    {
                        char buffer[256];
                        struct timeval m_time_val;
                        double tt, fps;

                        /*ITimer->*/GetSysTime( &m_time_val );
                        tt = (double)m_time_val.tv_sec + (double)(m_time_val.tv_micro) / 1000.0;

                        // this is a friend bitmap
//                        BltBitMap( backGround, 0, 0, backBuffer, 0, 0, sw, sh, 0xC0, 0xFF, NULL );
                        BltAlphaBitMap( backGround, 0, 0, backBuffer, 0, 0, sw, sh, 0xFF, 0 );
                        // that draws our alpha into the background
                        drawImage( alpha, backBuffer, px, py  );
                        sprintf( buffer, "Alpha: %d, %dx%d", alpha->format->alpha, px, py );
                        drawText( buffer, backBuffer, 3, 3, white, pFont );

                        /*ITimer->*/GetSysTime( &m_time_val );
                        tt = ((double)m_time_val.tv_sec + ((double)m_time_val.tv_micro) / 1000.0) - tt;
                        fps = 1.0/tt * 1000.0;
                        sprintf( buffer, "Total refresh %.2g ms, %.3g frames per sec (without screen update)", tt , fps );
                        drawText( buffer, backBuffer, 3, 25, white, NULL );

                        dumpSurfaceInfoXY("AlphaSurface", alpha,
                                          backBuffer, 3, 38,
                                          white, pCourier );

                        // "flip" the buffer - flip time is not messured. Add ~10ms
                        // for window mode the RP functions are a must, you can choose
                        // for a AmigaOS BltMitMapRastport() or the BltAlphaBitMapRastPort().
                        // Both do the same. Recognize the BLM_SRC_COPY. It ignores all alpha information.
//#define _USEAMIGAOS
#ifndef _USEAMIGAOS
// no rp                       BltAlphaBitMap( backBuffer, 0, 0, screenBuffer, 0, 0, sw, sh, 0xFF, BLM_SRC_COPY );
                        BltAlphaBitMapRastPort( backBuffer, 0, 0, vi->window->RPort, 0, 0, sw, sh,
                                                0xFF, BLM_SRC_COPY );
#else
// no rp                       BltBitMap( backBuffer, 0, 0, screenBuffer, 0, 0, sw, sh, 0xC0, 0xFF, NULL );
                        BltBitMapRastPort( backBuffer, 0, 0, vi->window->RPort, 0, 0, sw, sh, 0xC0 );
#endif

#if 0 // a write pixel array compatible call:
                        WriteAlphaPixelArray( alpha->pixels, 0, 0, alpha->pitch,
                                              vi->window->RPort, -10, -10, alpha->w, alpha->h,
                                              0xff,
                                              PIXF_RGBA32 );
#endif

                        refresh = FALSE;
                    }

                    if (out) break;
                }
            } while (!out) ;

            if (backBuffer && backBuffer != screenBuffer)
            {
                FreeBitMap( backBuffer );
            }
            FreeBitMap( backGround );
		    if (pFont)    TTF_CloseFont( pFont );
            if (pCourier) TTF_CloseFont( pCourier );

            /* ABlit Utils */
            ABU_CloseVideo( vi );
        }
    }
    if (pFallbackFont) TTF_CloseFont( pFallbackFont );
    SDL_FreeSurface(alpha);

    return 0;
}

