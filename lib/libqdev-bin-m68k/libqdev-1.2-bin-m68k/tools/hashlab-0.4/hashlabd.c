/*
 * hashlabd - hashlab daemon
 * by megacz
 *
 * This is portable(i hope)  laboratory support that tries to fullfill
 * 'hashlab'. Consider  this daemon "remote thread". Being able to use
 * other  computers to  detect hash collisions speeds up whole process
 * greatly, thus huge dictionaries is not such a pain.
 *
 * All you have  to do is to compile it for your platform and run. The
 * client  will  try  to  find  it, provided the daemon and client are
 * running on the same local network.
 *
 * Despite the fact that this proggy is quite simple there are options
 * to  control  it.  You can choose specific home address or port, set
 * delay  values  between  checks,  set new process priority or decide
 * whether  to  run in  the  background or foreground and/or if daemon
 * discovery should be disabled.
 *
 * Portability:
 *
 * -------------------------------------------------------------------
 * |         Operating System         |   build notes   |   works?   |
 * -------------------------------------------------------------------
 * |  AmigaOS      3.xx    (ixemul)   |   outta box     |   yip      |
 * |  Debian       6.0x    (32bit)    |   outta box     |   yip      |
 * |  Ubuntu       9.10    (32bit)    |   outta box     |   yip      |
 * |  Ubuntu      10.04    (32bit)    |   outta box     |   yip      |
 * |  Windows      xxxx    (cygwin)   |   outta box     |   yip      |
 * -------------------------------------------------------------------
 *
 * If you did compile this thing for a platform that is not listed yet
 * above  then please drop me a line possibly with the compiler output
 * and changes documented or a patch file. Thanks in advance!
 *
 * Please note, this  code is big/little endian proof, but i dont know
 * if it will work properly on 64bit systems!
 *
 * To Amiga folks: In  Unices  priorities are reversed and are shorter
 * in range(-20 to 20), which means that -20 is not less power like on
 * the  Amiga, but more power! Plus, if you are running as an ordinary
 * user  then  the  kernel may refuse to set negative priorites! I did
 * point  this  out  because it  also applies to you, since using *NIX
 * API!
 *
 * To hackers: Daemon  does not receive whole data set, but a crippled
 * one! This  really  speeds  up network transfers. Study the code for
 * more details.
 *
 * Important!  Some systems do not allow multiple 'bind()' on the same
 * port!  What  it  means  is that you could be unable to use multiple
 * clients  on  the same machine while the server discovery is enabled
 * in the  client or you  could be unable to discover local daemon. In
 * the latter case pass '-x' option to the deamon.
*/

#include <sys/types.h>
#include <sys/socket.h>
#include <sys/ioctl.h>
#include <netdb.h>
#include <netinet/in.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <signal.h>
#include <stdio.h>
#include <pthread.h>
#include <arpa/inet.h>
#include <time.h>
#include <sys/time.h>
#include <sys/resource.h>

#ifndef MSG_WAITALL
#define MSG_WAITALL 0
#endif

#ifndef PRIO_USER
#define PRIO_USER  0
#define PRIO_MIN  -1
#define PRIO_MAX   1
#define setpriority(a, b, c) (0)
#endif

#define DEVICES_TIMER_H

#include "hashlab.h"



struct _hashlabd
{
  int              hld_maxiter;    /* System speed information              */
  int              hld_tresh;      /* Delay between checks(micro)           */
  pthread_mutex_t  hld_mx;         /* Static synchronisation                */
  unsigned long    hld_svaddr;     /* Global daemon ip address              */
  int              hld_svport;     /* Global daemon port(TCP/UDP)           */
  int              hld_svsock;     /* Laboratory socket(TCP)                */
  int              hld_bcsock[2];  /* Service discovery sockets             */
  int              hld_isock[HASHLABD_MAXPROC];
                                   /* Separate thread sockets               */
  void            *hld_dptr[HASHLABD_MAXPROC];
                                   /* Separate memory pointers              */
};



static const UBYTE ___version[] =
               "\0$VER: hashlabd 0.1 (02/08/2011) " _QV_STRING "\0";



void switch_thread(void)
{
  struct timeval tv;
  pthread_mutex_t mp;
  pthread_cond_t cv;


  if (!(pthread_mutex_init(&mp, NULL)))
  {
    if (!(pthread_cond_init(&cv, NULL)))
    {
      tv.tv_sec = 0;

      tv.tv_usec = 0;

      pthread_mutex_lock(&mp);

      pthread_cond_timedwait(&cv, &mp, (struct timespec *)&tv);

      pthread_mutex_unlock(&mp);

      pthread_cond_destroy(&cv);
    }

    pthread_mutex_destroy(&mp);
  }
}

int spawn_thread(void *fptr, void *farg)
{
  pthread_attr_t attr;
  pthread_t thread;
  int rc = 0;


  if (pthread_attr_init(&attr) == 0)
  {
    if (pthread_attr_setdetachstate(&attr,
                                      PTHREAD_CREATE_DETACHED) == 0)
    {
      if (pthread_attr_setstacksize(&attr, HASHLABD_STACK) == 0)
      {
        if (pthread_create(&thread, &attr, fptr, farg) == 0)
        {
          rc = 1;
        }
      }
    }

    pthread_attr_destroy(&attr);
  }

  return rc;
}

void discovery_daemon(void *fdata)
{
  struct _hashlabd *hld = fdata;
  struct hashlabmsg hlm;
  struct sockaddr_in rsin;
  int rlen = sizeof(struct sockaddr_in);


  for(;;)
  {
    hlm.hlm_head = 0;

    while (recvfrom(hld->hld_bcsock[0], &hlm,
                                       sizeof(struct hashlabmsg), 0,
                              (struct sockaddr *)&rsin, &rlen) >= 0)
    {
      _HASHLABD_SWAPLONG(hlm.hlm_head);

      if (hlm.hlm_head == HASHLABD_M_QUERY)
      {
        fprintf(stdout, " HLP received help query from host %s .\n",
                                          inet_ntoa(rsin.sin_addr));

        hlm.hlm_head = HASHLABD_M_ANSWER;

        hlm.hlm_size = hld->hld_maxiter;

        _HASHLABD_SWAPLONG(hlm.hlm_head);

        _HASHLABD_SWAPLONG(hlm.hlm_size);

        rsin.sin_family = AF_INET;

        rsin.sin_port = hld->hld_svport;

        sendto(hld->hld_bcsock[1], &hlm, sizeof(struct hashlabmsg),
                                 0, (struct sockaddr *)&rsin, rlen);
      }

      hlm.hlm_head = 0;

      switch_thread();
    }

    fprintf(stdout, " *** warning, recvfrom() failed with"
                                        " error code %d!\n", errno);

    sleep(HASHLABD_TRYAGAN);
  }

  pthread_exit(NULL);
}

void server_context(void *fdata)
{
  struct hashlabmsg shlm;
  struct hashlabwrap *hlw = fdata;
  struct _hashlabd *hld = hlw->hlw_imem;
  struct hashentryd *hed;
  struct hashentryd *ihed;
  struct timeval tv;
  struct timeval src = {0, 0};
  struct timeval dst = {0, 0};
  struct tm *tm;
  fd_set mask;
  int cnt;
  int isock;
  int sel;
  int isize;
  int osize;
  int trig;
  char *ptrreg;
  char *endreg;
  char *memreg;
  char *ireg;
  char *ereg;
  unsigned long csum = 0;
  int cell = 0;


  cnt = hlw->hlw_icnt;

  gettimeofday(&tv, NULL);

  pthread_mutex_lock(&hld->hld_mx);

  tm = gmtime(&tv.tv_sec);

  tm->tm_year += 1900;

  fprintf(stdout,
                " %03d start: [%02d/%02d/%04d] [%02d:%02d:%02d]\n",
                                                               cnt,
                              tm->tm_mday, tm->tm_mon, tm->tm_year,
                              tm->tm_hour, tm->tm_min, tm->tm_sec);

  pthread_mutex_unlock(&hld->hld_mx);

  /*
   * Firstly receive crippled data set.
  */
  fprintf(stdout, " %03d receiving continous data...\n", cnt);

  ptrreg = fdata;

  ptrreg += sizeof(struct hashlabwrap);

  endreg = ptrreg;

  endreg += hlw->hlw_hlm.hlm_size;

  memreg = ptrreg;

  ireg = ptrreg;

  ereg = ptrreg;

  isock = hld->hld_isock[cnt];

  tv.tv_sec = HASHLABD_SCKTIME;

  tv.tv_usec = 0;

  setsockopt(isock, SOL_SOCKET,
                 SO_RCVTIMEO, (char *)&tv, sizeof(struct timeval));

  tv.tv_sec = HASHLABD_SCKTIME;

  tv.tv_usec = 0;

  setsockopt(isock, SOL_SOCKET,
                 SO_SNDTIMEO, (char *)&tv, sizeof(struct timeval));

  while (ptrreg < endreg)
  {
    FD_ZERO(&mask);  

    FD_SET(isock, &mask);

    tv.tv_sec = HASHLABD_SCKTIME;

    tv.tv_usec = 0;

    sel = select(isock + 1, &mask, 0, 0, &tv);
        
    if (FD_ISSET(isock, &mask))
    {
      /*
       * This will generate healthy warning on 32bit systems.
      */
      isize = (long)((unsigned long long)endreg -
                                       (unsigned long long)ptrreg);

      if (isize > HASHLABD_MAXREAD)
      {
        isize = HASHLABD_MAXREAD;
      }

      osize = recv(isock, ptrreg, isize, 0);

      if (osize > 0)
      {
        /*
         * Compute global checksum.
        */
        csum = QDEV_HLP_FNV32CSUM(csum, ptrreg, osize);

        ptrreg += osize;
      }
      else
      {
        fprintf(stdout,
                 " %03d !!! recv() failed to obtain data!\n", cnt);

        goto ___failure;
      }
    }
    else
    {
      fprintf(stdout,
                  " %03d !!! network timeout encountered!\n", cnt);

      goto ___failure;
    }

    switch_thread();
  }

  /*
   * Send the checksum.
  */
  shlm.hlm_head = HASHLABD_M_CHKSUM;

  shlm.hlm_size = csum;

  shlm.hlm_data = 0;

  shlm.hlm_inum = 0;

  _HASHLABD_SWAPLONG(shlm.hlm_head);

  _HASHLABD_SWAPLONG(shlm.hlm_size);

  if (send(isock, &shlm, sizeof(struct hashlabmsg), 0) > 0)
  {
    FD_ZERO(&mask);  

    FD_SET(isock, &mask);

    tv.tv_sec = HASHLABD_SCKTIME;

    tv.tv_usec = 0;

    sel = select(isock + 1, &mask, 0, 0, &tv);
        
    if (FD_ISSET(isock, &mask))
    {
      shlm.hlm_head = 0;

      shlm.hlm_size = 0;

      shlm.hlm_data = 0;

      shlm.hlm_inum = 0;

      recv(isock, &shlm, sizeof(struct hashlabmsg), MSG_WAITALL);

      _HASHLABD_SWAPLONG(shlm.hlm_head);

      _HASHLABD_SWAPLONG(shlm.hlm_size);

      _HASHLABD_SWAPLONG(shlm.hlm_data);

      _HASHLABD_SWAPLONG(shlm.hlm_inum);

      if ((shlm.hlm_head == HASHLABD_M_ALLOK)  &&
          (shlm.hlm_inum == HASHLABD_M_ALLOK))
      {
        /*
         * Start looking for possible collisions.
        */
        fprintf(stdout,
                 " %03d detection(%ld-%ld) in progress...\n",
                                cnt, shlm.hlm_size, shlm.hlm_data);

        ireg += (shlm.hlm_size * sizeof(struct hashentryd));

        ereg += (shlm.hlm_data * sizeof(struct hashentryd));

        while (ireg < ereg)
        {
          cell++;

          trig = 0;

          hed = (void *)ireg;

          ptrreg = memreg;

          while (ptrreg < endreg)
          {
            ihed = (void *)ptrreg;

            if (hed != ihed)
            {
              /*
               * Compare the hashes. Byte ordering is not important
               * here.
              */
              if ((hed->hed_hash.vuhi_hi == ihed->hed_hash.vuhi_hi)  &&
                  (hed->hed_hash.vuhi_lo == ihed->hed_hash.vuhi_lo)  &&
                  (hed->hed_hash.vulo_hi == ihed->hed_hash.vulo_hi)  &&
                  (hed->hed_hash.vulo_lo == ihed->hed_hash.vulo_lo))
              {
                trig = 1;

                shlm.hlm_head = HASHLABD_M_HCOLL;

                /*
                 * Do not endian-swap these two!!!
                */
                shlm.hlm_size = hed->hed_addr;

                shlm.hlm_data = ihed->hed_addr;


                shlm.hlm_inum = HASHLABD_M_HCOLL;

                ___repeat:

                _HASHLABD_SWAPLONG(shlm.hlm_head);

                _HASHLABD_SWAPLONG(shlm.hlm_inum);

                if (send(isock,
                         &shlm, sizeof(struct hashlabmsg), 0) <= 0)
                {
                  fprintf(stdout,
                     " %03d !!! client died unexpectedly!\n", cnt);

                  goto ___failure;
                }
              }
            }

            ptrreg += sizeof(struct hashentryd);
          }
 
          if (trig)
          {
            trig = 0;

            shlm.hlm_head = HASHLABD_M_HTELL;

            shlm.hlm_size = 0;

            shlm.hlm_data = 0;

            shlm.hlm_inum = 0;

            goto ___repeat;
          }

          ireg += sizeof(struct hashentryd); 

          gettimeofday(&src, NULL);

          if ((src.tv_sec > dst.tv_sec) ||
              (ireg >= ereg))
          {
            shlm.hlm_head = ((ireg >= ereg) ?
                                HASHLABD_M_QUIT : HASHLABD_M_PING);

            shlm.hlm_size = cell;

            shlm.hlm_data = 0;

            shlm.hlm_inum = 0;

            _HASHLABD_SWAPLONG(shlm.hlm_head);

            _HASHLABD_SWAPLONG(shlm.hlm_size);

            if (send(isock,
                         &shlm, sizeof(struct hashlabmsg), 0) <= 0)
            {
              fprintf(stdout,
                     " %03d !!! client died unexpectedly?\n", cnt);

              goto ___failure;
            }

            cell = 0;

            gettimeofday(&dst, NULL);
          }

          if (hld->hld_tresh)
          {
            usleep(hld->hld_tresh);
          }
          else
          {
            switch_thread();
          }
        }
      }
      else
      {
        fprintf(stdout,
                   " %03d !!! markers message is corrupt!\n", cnt);
      }
    }
    else
    {
      fprintf(stdout,
                  " %03d !!! no marker position response!\n", cnt);
    }
  }
  else
  {
    fprintf(stdout,
               " %03d !!! send() failed to emit checksum!\n", cnt);
  }

  ___failure:

  gettimeofday(&tv, NULL);

  pthread_mutex_lock(&hld->hld_mx);

  tm = gmtime(&tv.tv_sec);

  tm->tm_year += 1900;

  fprintf(stdout,
                 " %03d stop: [%02d/%02d/%04d] [%02d:%02d:%02d]\n",
                                                               cnt,
                              tm->tm_mday, tm->tm_mon, tm->tm_year,
                              tm->tm_hour, tm->tm_min, tm->tm_sec);

  close(isock);

  free(fdata);

  hld->hld_isock[cnt] = -1;

  hld->hld_dptr[cnt] = NULL;

  pthread_mutex_unlock(&hld->hld_mx);

  pthread_exit(NULL);
}

void server_daemon(void *fdata)
{
  struct _hashlabd *hld = fdata;
  struct hashlabwrap hlw;
  struct sockaddr_in rsin;
  struct timeval tv;
  fd_set mask;
  int rlen = sizeof(struct sockaddr_in);
  int sel;
  int cnt;
  int isock;
  void *imem;


  for(;;)
  {
    while ((isock = accept(hld->hld_svsock,
                             (struct sockaddr *)&rsin, &rlen)) >= 0)
    {
      imem = NULL;

      fprintf(stdout, " LAB connection established with host %s ."
                                    "\n", inet_ntoa(rsin.sin_addr));

      FD_ZERO(&mask);  

      FD_SET(isock, &mask);

      tv.tv_sec = HASHLABD_MAXWAIT;

      tv.tv_usec = 0;

      sel = select(isock + 1, &mask, 0, 0, &tv);
        
      if (sel < 0)
      {
        fprintf(stdout,
               " *** oops, error while doing select(), sorry...\n");
      } 
      else if (sel == 0)
      {
        fprintf(stdout,
             " *** oops, looks like client died unexpectedly...\n");
      }
      else if (FD_ISSET(isock, &mask))
      {
        hlw.hlw_hlm.hlm_head = 0;

        hlw.hlw_hlm.hlm_size = 1;

        hlw.hlw_hlm.hlm_data = 2;

        hlw.hlw_hlm.hlm_inum = 0;

        recv(isock,
              &hlw.hlw_hlm, sizeof(struct hashlabmsg), MSG_WAITALL);

        _HASHLABD_SWAPLONG(hlw.hlw_hlm.hlm_head);

        _HASHLABD_SWAPLONG(hlw.hlw_hlm.hlm_size);

        _HASHLABD_SWAPLONG(hlw.hlw_hlm.hlm_data);

        if (hlw.hlw_hlm.hlm_head == HASHLABD_M_DSIZE)
        {
          if (hlw.hlw_hlm.hlm_size <=
                                (HASHLABD_MEMLIM * HASHLABD_ONEMEG))
          {
            if (((hlw.hlw_hlm.hlm_size / hlw.hlw_hlm.hlm_data) *
                      hlw.hlw_hlm.hlm_data) == hlw.hlw_hlm.hlm_size)
            {
              if ((imem = malloc(hlw.hlw_hlm.hlm_size +
                                       sizeof(struct hashlabwrap))))
              {
                fprintf(stdout, " LAB alloc. %ld B"
                                  " for data set, entry = %ld B.\n",
                        hlw.hlw_hlm.hlm_size, hlw.hlw_hlm.hlm_data);

                for(cnt = 0; cnt < HASHLABD_MAXPROC; cnt++)
                {
                  if ((hld->hld_isock[cnt] == -1)   &&
                      (hld->hld_dptr[cnt] == NULL))
                  {
                    fprintf(stdout, " LAB space found at slot %d,"
                                  " starting new thread...\n", cnt);

                    /*
                     * Copy current message to the very top of
                     * this fresh allocation.
                    */
                    hlw.hlw_icnt = cnt;

                    hlw.hlw_imem = hld;

                    *((struct hashlabwrap *)imem) = hlw;

                    hlw.hlw_hlm.hlm_head = HASHLABD_M_ALLOK;

                    hlw.hlw_hlm.hlm_size = 0;

                    hlw.hlw_hlm.hlm_data = 0;

                    hlw.hlw_hlm.hlm_inum = 0;

                    _HASHLABD_SWAPLONG(hlw.hlw_hlm.hlm_head);

                    send(isock, &hlw.hlw_hlm,
                                      sizeof(struct hashlabmsg), 0);

                    /*
                     * Create server context.
                    */
                    hld->hld_isock[cnt] = isock;

                    hld->hld_dptr[cnt] = imem;

                    if (spawn_thread(server_context, imem))
                    {
                      isock = -1;

                      imem = NULL;
                    }
                    else
                    {
                      fprintf(stdout,
                         " *** warning, failed to create new server"
                                                  " subcontext!\n");

                      hld->hld_isock[cnt] = -1;

                      hld->hld_dptr[cnt] = NULL;
                    }

                    break;
                  }
                }

                if (cnt == HASHLABD_MAXPROC)
                {
                  fprintf(stdout, " LAB oops, there is no empty"
                                         " slot for new client!\n");
                }
              }
              else
              {
                fprintf(stdout,
                   " *** warning, unable to alloc. %ld bytes"
                               " of mem.!\n", hlw.hlw_hlm.hlm_size);
              }
            }
            else
            {
              fprintf(stdout,
                 " *** warning, request inconsistency detected!\n");
            }
          }
          else
          {
            fprintf(stdout,
                " *** warning, client wants more than %ld bytes!\n",
                (unsigned long)(HASHLABD_MEMLIM * HASHLABD_ONEMEG));
          }
        }
        else
        {
          fprintf(stdout,
                   " *** warning, unknown msg(0x%08lx) received!\n",
                                              hlw.hlw_hlm.hlm_head);
        }
      }

      if (imem)
      {
        free(imem);
      }

      if (isock > -1)
      {
        hlw.hlw_hlm.hlm_head = HASHLABD_M_NOROOM;

        hlw.hlw_hlm.hlm_size = 0;

        hlw.hlw_hlm.hlm_data = 0;

        hlw.hlw_hlm.hlm_inum = 0;

        _HASHLABD_SWAPLONG(hlw.hlw_hlm.hlm_head);

        send(isock, &hlw.hlw_hlm, sizeof(struct hashlabmsg), 0);

        close(isock);
      }

      switch_thread();
    }

    fprintf(stdout, " *** warning, accept() failed with"
                                        " error code %d!\n", errno);

    sleep(HASHLABD_TRYAGAN);
  }

  pthread_exit(NULL);
}

void ___dummy_c_handler(int sig)
{
}

int main(int argc, char **argv)
{
  struct _hashlabd hld;
  struct sockaddr_in sin;
  struct sockaddr_in bcsin;
  sigset_t sigs;
  struct timeval src;
  struct timeval dst;
  int nobc = 0;
  int nobg = 0;
  int pri = 0;
  int sig;
  int opt;
  int cnt;
  int rc = 5;


  /*
   * Initialize the mandatory stuff.
  */
  signal(SIGINT, &___dummy_c_handler);

  signal(SIGPIPE, SIG_IGN);

  hld.hld_maxiter = 0;

  hld.hld_tresh = 0;

  pthread_mutex_init(&hld.hld_mx, NULL);

  for(cnt = 0; cnt < HASHLABD_MAXPROC; cnt++)
  {
    hld.hld_isock[cnt] = -1;

    hld.hld_dptr[cnt] = NULL;
  }

  hld.hld_svaddr = INADDR_ANY;

  hld.hld_svport = htons(HASHLABD_PORT);

  /*
   * Parse arguments if any.
  */
  for(cnt = 1; cnt < argc; cnt++)
  {
    if(argv[cnt][0] == '-')
    {
      switch(argv[cnt][1])
      {
        case 'a':
        {
          if ((argv[cnt][2] == ' ')  ||
              (argv[cnt][2] == '='))
          {
            hld.hld_svaddr = inet_addr(&argv[cnt][3]);
          }
          else
          {
            hld.hld_svaddr = inet_addr(&argv[cnt][2]);
          }

          break;
        }

        case 'p':
        {
          if ((argv[cnt][2] == ' ')  ||
              (argv[cnt][2] == '='))
          {
            hld.hld_svport = htons(atoi(&argv[cnt][3]));
          }
          else
          {
            hld.hld_svport = htons(atoi(&argv[cnt][2]));
          }

          break;
        }

        case 't':
        {
          if ((argv[cnt][2] == ' ')  ||
              (argv[cnt][2] == '='))
          {
            hld.hld_tresh = atoi(&argv[cnt][3]);
          }
          else
          {
            hld.hld_tresh = atoi(&argv[cnt][2]);
          }

          if (hld.hld_tresh <= 0)
          {
            hld.hld_tresh = 0;
          }
          else if (hld.hld_tresh > HASHLABD_MAXTRES)
          {
            hld.hld_tresh = HASHLABD_MAXTRES;
          }

          if (hld.hld_tresh)
          {
            fprintf(stdout,
                       " /// new loop treshold set to %d micros.\n",
                                                     hld.hld_tresh);
          }

          break;
        }

        case 'n':
        {
          if ((argv[cnt][2] == ' ')  ||
              (argv[cnt][2] == '='))
          {
            pri = atoi(&argv[cnt][3]);
          }
          else
          {
            pri = atoi(&argv[cnt][2]);
          }

          if (pri < PRIO_MIN)
          {
            pri = PRIO_MIN;
          }
          else if (pri > PRIO_MAX)
          {
            pri = PRIO_MAX;
          }

          if (setpriority(PRIO_USER, 0, pri) > -1)
          {
            fprintf(stdout,
                       " /// process priority is now set to %d .\n",
                                                               pri);
          }
          else
          {
            fprintf(stdout,
                       " *** error, failed to set new priority!\n");

            return 5;
          }

          break;
        }

        case 'f':
        {
          nobg = 1;

          break;
        }

        case 'x':
        {
          nobc = 1;

          break;
        }

        case 'h':
        {
          fprintf(stdout, " *** template: hashlabd [-a<ip>]"
                   " [-p<port>] [-t<micro>] [-n<pri>] [-f] [-x]\n");

          return 0;
        }

        ___err:
        default:
        {
          fprintf(stdout, " *** error, invalid option: '%s' !\n",
                                                     &argv[cnt][0]);

          return 5;
        }

        ;
      }
    }
    else
    {
      goto ___err;
    }
  }

  /*
   * Try to run in the background.
  */
#ifndef __amigaos__
  if (nobg == 0)
  {
    pid_t pid;


    pid = fork();

    if (pid < 0)
    {
      fprintf(stdout,
                     " *** error, cannot run in the background!\n");

      return 5;
    }
    else if (pid > 0)
    {
      return 0;
    }
  }
#endif

  /*
   * Gather system speed information.
  */
  fprintf(stdout,
                " /// checking system speed, gimmie a second...\n");

  gettimeofday(&src, NULL);

  dst = src;

  src.tv_usec += 1000000;

  while (src.tv_usec > dst.tv_usec)
  {
    if (hld.hld_tresh)
    {
      usleep(hld.hld_tresh);
    }

    hld.hld_maxiter++;

    gettimeofday(&dst, NULL);

    dst.tv_usec += ((dst.tv_sec - src.tv_sec) * 1000000);
  }  

  fprintf(stdout,
             " /// the machine is capable of %d i/s.\n",
                                                   hld.hld_maxiter);

  /*
   * Prepare broadcast endpoint, so server discovery is
   * possible.
  */
  if (nobc == 0)
  {
    fprintf(stdout,
               " /// attempting to create broadcast endpoint...\n");
  }

  if ((hld.hld_bcsock[0] = socket(AF_INET, SOCK_DGRAM, 0)) >= 0)
  {
    if ((hld.hld_bcsock[1] = socket(AF_INET, SOCK_DGRAM, 0)) >= 0)
    {
      opt = 1;

      setsockopt(hld.hld_bcsock[0], SOL_SOCKET, SO_REUSEADDR,
                                         (char *)&opt, sizeof(opt));

      opt = 1;

      setsockopt(hld.hld_bcsock[0], SOL_SOCKET, SO_BROADCAST,
                                         (char *)&opt, sizeof(opt));

      bcsin.sin_family = AF_INET;

      bcsin.sin_port = hld.hld_svport;

      bcsin.sin_addr.s_addr = INADDR_ANY;

      bzero(&bcsin.sin_zero, sizeof(bcsin.sin_zero));

      if ((nobc == 1)                                             ||
          (bind(hld.hld_bcsock[0], (struct sockaddr *)&bcsin,
                                  sizeof(struct sockaddr)) >= 0))
      {
        /*
         * Now try to start us on a given TCP port.
        */
        fprintf(stdout,
                  " /// attempting to create server endpoint...\n");

        if ((hld.hld_svsock = socket(AF_INET, SOCK_STREAM, 0)) >= 0)
        {
          opt = 1;

          setsockopt(hld.hld_svsock, SOL_SOCKET, SO_REUSEADDR,
                                         (char *)&opt, sizeof(opt));

          sin.sin_family = AF_INET;

          sin.sin_port = hld.hld_svport;

          sin.sin_addr.s_addr = hld.hld_svaddr;

          bzero(&sin.sin_zero, sizeof(sin.sin_zero));

          if (bind(hld.hld_svsock, (struct sockaddr *)&sin,
                                      sizeof(struct sockaddr)) >= 0)
          {
            if (listen(hld.hld_svsock, HASHLABD_MAXPROC) >= 0)
            {
              /*
               * Create service discovery daemon.
              */
              if ((nobc == 1)                             ||
                  (spawn_thread(discovery_daemon, &hld)))
              {
                /*
                 * Then create the server.
                */
                if (spawn_thread(server_daemon, &hld))
                {
                  rc = 0;

                  fprintf(stdout, " /// waiting for queries"
                                                  " on %s:%d ...\n", 
                                            inet_ntoa(sin.sin_addr),
                                             htons(hld.hld_svport));

                  /*
                   * Wait for the termination signal and if caught
                   * clean everything up.
                  */
                  sigemptyset(&sigs);

                  sigaddset(&sigs, SIGINT);

                  sigwait(&sigs, &sig);

                  for(cnt = 0; cnt < HASHLABD_MAXPROC; cnt++)
                  {
                    if (hld.hld_isock[cnt] > -1)
                    {
                      close(hld.hld_isock[cnt]);
                    }

                    if (hld.hld_dptr[cnt])
                    {
                      free(hld.hld_dptr[cnt]);
                    }
                  }

                  fprintf(stdout, " *** process terminated!\n");
                }
                else
                {
                  fprintf(stdout, " *** error, cannot start server"
                                               " daemon thread!\n");
                }
              }
              else
              {
                fprintf(stdout, " *** error, cannot start discovery"
                                               " daemon thread!\n");
              }
            }
            else
            {
              fprintf(stdout, " *** error, listen() failed with"
                                        " error code %d!\n", errno);
            }
          }
          else
          {
            fprintf(stdout, " *** error, bind() failed with"
                                        " error code %d!\n", errno);
          }

          close(hld.hld_svsock);
        }
        else
        {
          fprintf(stdout, " *** error, socket() failed with"
                                        " error code %d!\n", errno);
        }
      }
      else
      {
        fprintf(stdout, " *** error, bind() failed with"
                                        " error code %d!\n", errno);
      }

      close(hld.hld_bcsock[1]);
    }
    else
    {
      fprintf(stdout, " *** error, socket() failed with"
                                        " error code %d!\n", errno);
    }

    close(hld.hld_bcsock[0]);
  }
  else
  {
    fprintf(stdout, " *** error, socket() failed with"
                                        " error code %d!\n", errno);
  }

  return rc;
}
