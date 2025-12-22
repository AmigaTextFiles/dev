#include <stdio.h>
#include <math.h>

#if defined(WIN32) || defined(OS2) | defined(__amigaos__)
#define MAXINT 0x7fffffff
#else
#include <values.h>
#endif

#ifdef WIN32
#include <windows.h>
#endif

#include <GL/gl.h>

#ifdef XWINDOWS
#include <GL/glx.h>
#endif

#ifdef OS2
#include "aux.h"
#elif __amigaos__
#include <gl/glaux.h>
#endif

#include "viewperf.h"
#include "vpDefine.h"

extern char teststring[][32];
extern struct EventBlock eventblock;

#if !defined(MP)
#define START_THREADS(pevent)
#define WAIT_FOR_THREADS(pevent)
#define WAIT_FOR_START(pevent, threadNum)
#define SET_THREAD_DONE(pevent, threadNum)

#elif defined(WIN32)
#define START_THREADS(pevent) { \
        struct ThreadBlock *tb; \
        int thread; \
        tb = &pevent->tb[1]; \
            for (thread = 1; thread < pevent->threads; thread++, tb++) \
            SetEvent(tb->startEvent); \
        }

#define WAIT_FOR_THREADS(pevent) { \
        struct ThreadBlock *tb; \
        int thread; \
        tb = &pevent->tb[1]; \
            for (thread = 1; thread < pevent->threads; thread++, tb++) \
            WaitForSingleObject(tb->doneEvent, INFINITE); \
        }

#define WAIT_FOR_START(pevent, threadNum) \
        WaitForSingleObject(pevent->tb[threadNum].startEvent, INFINITE)

#define SET_THREAD_DONE(pevent, threadNum) \
        SetEvent(pevent->tb[threadNum].doneEvent)

#elif defined(SOME_OTHER_OS)
/* Put os specific code to:
    Control MACRO to start all threads
    Control MACRO to wait for the completion of all threads
    Thread MACRO to wait for start
    Thread MACRO to indicate completion
*/
#endif

extern GLfloat iang, jang, kang;

void FUNCTION(int threadNum)
{
        struct EventBlock *pevent = &eventblock;
        GLenum err;
        float period, fps;
        float minperiod = pevent->minperiod;
        int numframes;
        int oldnumframes;
        int frameCountBumped=VP_FALSE;
        #ifdef WALKTHRU
        GLfloat **walkthru = pevent->walkthru;
        #endif
        #ifdef MOTION_BLUR
        GLfloat decay_frames = pevent->blur_frames;
        #endif
        #ifdef FS_ANTIALIASING
        int jit;
        int redraws;
        struct vector *jitter;
        #endif
        /* Begin Windowing system dependent */
        #ifdef WIN32
        HDC display = pevent->display;
        #elif !defined(OS2) && !defined(__amigaos__)
        Display *pdisplay = pevent->display;
        Window pwin = pevent->window;
        #endif
        /* End Windowing system dependent */
        #ifdef DISPLAY_LIST
        GLuint list;
        #endif
        int framenum;
        struct RenderBlock *renderblock = pevent->rb;
        void (*func)(struct ThreadBlock *rb) = pevent->func;
        #ifdef DISPLAY_LIST
        #ifdef WIN32
        void (APIENTRY *glCallListP)(GLuint);
        #else
        void (*glCallListP)(GLuint);
        #endif
        #endif
        #if defined(WIN32)
        void (APIENTRY *swapOrFinish)(HDC);
        #elif defined(OS2) || defined(__amigaos__)
        void (*swapOrFinish)(void);
        #else
        void (*swapOrFinish)(Display*, GLXDrawable);
        #endif
        enum { Prime, Calibrate, Measure, Done } testState;
        GLfloat minCalibratePeriod = 1.0;
        GLfloat measuredFramerate;
        GLfloat *trans = pevent->trans;
        GLfloat ltrans0 = trans[0];
        GLfloat ltrans1 = trans[1] * (GLfloat) 0.98;
        GLfloat ltrans2 = trans[2];
        GLfloat ltrans3 = trans[3] * ZTRANS_SCALE;
        GLfloat translateX = (pevent->clip) ? -pevent->center[0] : 0.0;
        GLfloat translateY = (pevent->clip) ? -pevent->center[1] : 0.0;
        GLfloat translateZ = -ltrans3;
        GLbitfield clearMask = GL_COLOR_BUFFER_BIT;

        if (pevent->zbuffer)
            clearMask |= GL_DEPTH_BUFFER_BIT;

        #if defined(FS_ANTIALIASING) && !defined(MOTION_BLUR)
            clearMask |= GL_ACCUM_BUFFER_BIT;
        #endif

        #ifdef MP
        /* Set up this thread to draw to the window */
        if (threadNum) {
                #if defined(WIN32)
                HDC dc;
                dc = GetDC(pevent->window);
                wglMakeCurrent(dc, pevent->tb[threadNum].rc);
                #elif defined(SOME_OTHER_OS)
                /* Put os specific code to:
                 * MakeCurrent to context for this thread
                 */
                #endif
        }
        #endif

        glFinish();

        /* =================================================== */
        /* Create display list, if called for                  */
        /* =================================================== */
    #ifdef DISPLAY_LIST
        if (threadNum) {
                WAIT_FOR_START(pevent, threadNum);
        } else {
                startclock();
                START_THREADS(pevent);
        }
        glCallListP = glCallList;
        list = glGenLists(1);
        glNewList(list, GL_COMPILE);
        (*func)(&pevent->tb[threadNum]);
        glEndList();
        glFinish();

        if (threadNum) {
                SET_THREAD_DONE(pevent, threadNum);
        } else {
                WAIT_FOR_THREADS(pevent);
                period = stopclock();
                fprintf(stdout,"%#8.3g\tsec (DL Build)\t--\t%s\n", roundit(period), pevent->teststring);
        }
    #endif

        /* =================================================== */
        /* New all-purpose test loop                           */
        /* Four stages: Prime, Calibrate, Measure, Done        */
        /* =================================================== */
        testState = Prime;
        /* Slave threads will stay in Prime state for their    */
        /* entire existences (that is, until the master kills  */
        /* them.)  That's why numframes is set to MAXINT...    */
        numframes = threadNum ? MAXINT : 1;
        if (pevent->doubleBuffer && threadNum == 0) {
            #if defined(WIN32)
                swapOrFinish = SwapBuffers;
            #elif defined(OS2) || defined(__amigaos__)
                swapOrFinish = auxSwapBuffers;
            #else
                swapOrFinish = glXSwapBuffers;
            #endif
        } else {
            #if defined(WIN32)
                swapOrFinish = FinishFrame;
            #elif defined(OS2)
                swapOrFinish = FinishFrame;
            #else
                swapOrFinish = FinishFrame;
            #endif
        }
        while (testState != Done) {

                if (threadNum == 0)  {
                    startclock();

                 #ifndef WALKTHRU
                    iang = 0.0;
                    jang = 0.0;
                    kang = 0.0;
                #endif
        }

            #if defined(MOTION_BLUR) || defined(FS_ANTIALIASING)
                glClear(GL_ACCUM_BUFFER_BIT);
            #endif
                for (framenum = 0; framenum < numframes; framenum++) {
                    #ifdef MP
                        if (threadNum) {
                                WAIT_FOR_START(pevent, threadNum);
                        } else {
                                glClear(clearMask);
                                glFinish();
                                pevent->walkthruFrame = framenum;
                                START_THREADS(pevent);
                        }
                    #else
                        glClear(clearMask);
                        pevent->walkthruFrame = framenum;
                    #endif

                    #ifdef FS_ANTIALIASING
                        jitter = pevent->jitter;
                        redraws = pevent->redraws;
                        for (jit = 0; jit <= redraws; jit++) {
                                glPushMatrix();
                                glTranslatef(jitter[jit].x, jitter[jit].y, 0);
                    #else
                                glPushMatrix();
                    #endif
                            #ifdef WALKTHRU
                                glLoadMatrixf(walkthru[pevent->walkthruFrame]); 
                            #else
                                glTranslatef(translateX, translateY, translateZ);
                                glRotatef(jang, 0.0, 1.0, 0.0);
                                glRotatef(iang, 1.0, 0.0, 0.0);
                                glRotatef(kang, 0.0, 0.0, 1.0);
                                glTranslatef(-ltrans0, -ltrans1, -ltrans2);
                            #endif
                            #ifdef DISPLAY_LIST
                                (*glCallListP)(list);
                            #else
                                (*func)(&pevent->tb[threadNum]);
                            #endif
                    #ifdef FS_ANTIALIASING
                                glAccum(GL_ACCUM, 1.0/redraws);
                                glPopMatrix();
                        }
                    #else
                                glPopMatrix();
                    #endif

                    #if defined(MOTION_BLUR)
                        glAccum(GL_ACCUM, 1.0);
                    #endif

                    #if defined(MOTION_BLUR) || defined(FS_ANTIALIASING)
                        glAccum(GL_RETURN, 1.0);
                    #endif

                    #ifdef MP
                        if (threadNum) {
                                glFinish();
                                SET_THREAD_DONE(pevent, threadNum);
                        } else {
                                WAIT_FOR_THREADS(pevent);
                    #endif
                            #if defined(WIN32)
                                (*swapOrFinish)(display);
                            #elif defined(OS2) || defined(__amigaos__)
                                (*swapOrFinish)();
                            #else
                                (*swapOrFinish)(pdisplay, pwin);
                            #endif

                      #ifndef WALKTHRU
                          iang -= 1.0;
                          jang += 5.0;
                          kang += 0.5;
                      #endif
                    #ifdef MP
                        }
                    #endif
                }
              #ifndef WIN32
                if (pevent->doubleBuffer) glFinish();
              #endif
                period = stopclock();

                switch (testState) {
                case Prime:
                        /* Finished priming the pump, time to calibrate, if */
                        /* a specific number of frames has not been set     */
                        if (pevent->numframes == 0) {
                                testState = Calibrate;
                        } else {
                                /* Already given a specified number of      */
                                /* frames to draw.  Go directly to Measure  */
                                testState = Measure;
                                numframes = pevent->numframes;
                        }
                        break;
                case Calibrate:
                        if (period < minCalibratePeriod) {
                                numframes *= 2;
                                if (pevent->numframes != 0)
                                        numframes = MIN(numframes, pevent->numframes);
                        } else if (period >= minperiod && pevent->numframes == 0) {
                                /* Well, we fulfilled our test period during */
                                /* Calibration, so we don't need to run again*/
                                testState = Done;
                        } else {
                                testState = Measure;
                                if (pevent->numframes == 0) {
                                        numframes = (int)ceil((float)numframes * minperiod / period);
                                } else {
                                        numframes = pevent->numframes;
                                }
                        }
                        break;
                case Measure:
                        testState = Done;
                        break;
                case Done:
                        /* We should NEVER be here! */
                        fprintf(stdout, "viewperf: Major problem in event loop!\n");
                        exit(-1);
                        break;
                }
        }

        fprintf(stdout,
                "\n\t\tNumber of frames run: %d, Test period: %f (sec)\n",
                numframes, period);
        fprintf(stdout,
                "%#8.3g\tframes/sec\t--\t%s\n", 
                roundit((float)numframes/period), pevent->teststring);

        if (err = glGetError())
                fprintf(stdout, 
                        "<<WARNING>>: glError %s. The above results may be invalid\n",
                        error2str(err));

    #ifdef DISPLAY_LIST
        glDeleteLists(list, 1);
    #endif
}
