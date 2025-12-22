/* ASpecT Window Source Debugger by Ric & JvH 18.6.1992 */
#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <signal.h>
#include <sys/time.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/resource.h>
#include <sys/ioctl.h>


#ifdef XView

#include <xview/xview.h>
#include <xview/panel.h>
#include <xview/textsw.h>
#include <xview/seln.h>
#include <xview/scrollbar.h>

#else

#include <suntool/sunview.h>
#include <suntool/panel.h>
#include <suntool/textsw.h>
#include <suntool/seln.h>
#include <suntool/scrollbar.h>

#endif


#include "ASpecT.icon"

#ifndef XView
DEFINE_ICON_FROM_IMAGE(icon,aspectIcon);
#else
  Xv_Window focus_shell; 
#endif

#define MAX_FN 255
static Window frame;
static Panel message,panel;
static Textsw display,shell;
Textsw_index shell_mark=0;
static Panel_item msg_item,fn_item,depth_item;
char current_file[MAX_FN];
char **arguments;
int current_pid;


Notify_client client1 = (Notify_client)10;
Notify_client client2 = (Notify_client)11;

int pipe_io[2][2];

#define TRUE 1
#define FALSE 0

static int get_line() {
  Seln_holder holder;
  Seln_request *response;
  long line_num;
  Textsw_index first,last,dummy;
  int len=0;
  char *ptr;
  holder = seln_inquire(SELN_PRIMARY);
  if(!seln_holder_same_client(&holder,display)) return -1;
  response = seln_ask(&holder,
                      SELN_REQ_FIRST,         NULL,
                      SELN_REQ_LAST,          NULL,
                      SELN_REQ_FAKE_LEVEL,    SELN_LEVEL_LINE,
                      SELN_REQ_FIRST_UNIT,    NULL,
                      NULL);
  ptr = response->data;
  first = *(Textsw_index *)(ptr += sizeof(SELN_REQ_FIRST));
  ptr += sizeof(Textsw_index);
  last = *(Textsw_index *)(ptr += sizeof(SELN_REQ_LAST));
  ptr += sizeof(Textsw_index) +
         sizeof(SELN_REQ_FAKE_LEVEL) +
         sizeof(SELN_LEVEL_LINE);
  line_num = *(long *)(ptr += sizeof(SELN_REQ_FIRST_UNIT));
  while (first <= last) 
    if(textsw_find_bytes(display,&first,&dummy,"\n",1,0) >= 0) 
         len++,first=dummy;
    else first=last+1;
  if(len>1) return -1;
  return line_num+1;
}

 
static void msg(s) char *s; {
  /** if(strlen(s)!=0) {printf("\7");fflush(stdout);} **/
  panel_set(msg_item,PANEL_LABEL_STRING,s,0);
}

static void cmd(s) char *s; {
  int len = strlen(s);
  msg("");
  write(pipe_io[0][1],s,len);
  window_set(shell,TEXTSW_INSERTION_POINT,TEXTSW_INFINITY,0);
  textsw_insert(shell,s,len);
  shell_mark = (Textsw_index) window_get(shell,TEXTSW_INSERTION_POINT);
}

static void set_fn(fn) char *fn; {
  panel_set(fn_item,PANEL_LABEL_STRING,fn,0);
}

void loadfile(f) char *f;
{ Textsw_status status;
  if (strcmp(f,current_file)==0) return;
  window_set(display,
             TEXTSW_STATUS,&status,
             TEXTSW_FILE,f,
             TEXTSW_FIRST,0,
             0);
  if (status != TEXTSW_STATUS_OKAY) 
    msg("Error loading");
  else {
    msg("");
    strncpy(current_file,f,MAX_FN);
    set_fn(current_file);
  }
}

static void show_line(l,c) unsigned l; unsigned c; {
  Textsw_index idx1,idx2; int t,b;
  if (l==0) return;
  l--;c--;
  idx1=(Textsw_index)textsw_index_for_file_line(display,l);
  textsw_file_lines_visible(display,&t,&b);
  l=l-(b-t)/2; if (l<0) l=0;
  idx2 = (Textsw_index)textsw_index_for_file_line(display,l);
  window_set(display,TEXTSW_FIRST,idx2,0);
  textsw_set_selection(display,idx1+c,idx1+c+1,1);
}
 
static int filter_output(buf) char *buf; {
  int valid,len;
  unsigned row,col;
  char str[MAX_FN], *eol;
  
  if (*buf++ == '\177') { /* interpret output */
    switch (*buf++) {
      case '\0': /* row */
        valid = sscanf(buf,"%d %d\n%n",&row,&col,&len);
        if (valid >= 2) {
          show_line(row,col);
          return len+2;
        }
        else return 0;
      case '\2': /* file */
        valid = sscanf(buf,"%s\n%n",str,&len);
        if (valid >= 1) {
          loadfile(str);
          return len+2;
        }
        else return 0;
      case '\3': /* error message */
        eol = strchr(buf,'\n');
        if (eol) {
          *eol = '\0';
          msg(buf);
          return (eol - buf) + 3;
        }
        else return 0;
      default: /* ?? */
        return 0;
    }
  }
  else
    return 0;
}

#ifdef XView
#define min(x,y) (((x) > (y)) ? (y) : (x))
#endif

Notify_value read_it(client,fd)
Notify_client client; int fd; {
  char buf[BUFSIZ],*eot;
  int bytes,i,j,k;
  
  if (ioctl(fd,FIONREAD,&bytes) == 0) {
    window_set(shell,TEXTSW_INSERTION_POINT,TEXTSW_INFINITY,0);
    while (bytes > 0) {
      if ((i = read(fd,buf,sizeof(buf))) > 0) {
        k = 0; j = 0;
        while (k < i) { 
          while ((j = filter_output(&(buf[k]))) > 0) k += j;
          eot = strchr(&(buf[k]),'\177');
          j = (eot) ? min(i-k,eot - &(buf[k])) : (i-k);
          textsw_insert(shell,&(buf[k]),j);
          shell_mark = (Textsw_index) window_get(shell,TEXTSW_INSERTION_POINT);
          k += j;
        }
      }
      else if (i == -1)
        break;
      bytes -= i;
    }
  }
  return NOTIFY_DONE;
}


/* handle child's death */
Notify_value sigchldcatcher(client,pid,status,rusage)
Notify_client client; int pid;
union wait *status;
struct rusage *rusage; {
  char s[80];
  if (WIFEXITED(*status)) {
    if (client == client1) /* read remaining input */
      read_it(client,pipe_io[1][0]);
    
    window_set(shell,TEXTSW_INSERTION_POINT,TEXTSW_INFINITY,0);
    sprintf(s,"Process terminated with status %d\n",status->w_retcode);
    msg(s);
    notify_set_input_func(client,NOTIFY_FUNC_NULL,
      (client == client1) ? pipe_io[1][0] : 0);
    
    current_pid = 0;
     
    /* close pipes */
    close(pipe_io[0][0]);
    close(pipe_io[0][1]);
    close(pipe_io[1][0]);
    close(pipe_io[1][1]);
    return NOTIFY_DONE;
  }
  msg("SIGCHLD not handled");
  return NOTIFY_IGNORED;
}

static void create_child(pn,argv) char *pn; char *argv[]; {
  int i;
  FILE *fp;
  pipe(pipe_io[0]);  /* input pipe */
  pipe(pipe_io[1]);  /* output pipe */
  
  switch(current_pid = fork()) {
    case -1:
      close(pipe_io[0][0]);
      close(pipe_io[0][1]);
      close(pipe_io[1][0]);
      close(pipe_io[1][1]);
      perror("fork failed");
      exit(1);
    case 0: /* child */
      /* redirect child's stdin (0), stdout(1) and stderr(2) */
      dup2(pipe_io[0][0],0);
      dup2(pipe_io[1][1],1);
      dup2(pipe_io[1][1],2);
      for (i = getdtablesize(); i > 2; i--)
        (void) close(i);
      for (i = 0; i < NSIG; i++)
        (void) signal(i,SIG_DFL);
/**/ printf("Run: %s\n",pn);
      execvp(pn,argv);
      if (errno == ENOENT)
        printf("%s: command not found.\n",pn);
      else
        perror(pn);
      perror("execvp");
      exit(-1);
    default: /* parent */
      /* close unused pipes */
      close(pipe_io[0][0]);
      close(pipe_io[1][1]);
  }
  
  /* read process' output */
  notify_set_input_func(client1,read_it,pipe_io[1][0]);
  notify_set_wait3_func(client1,sigchldcatcher,current_pid);
  
  /* set interactive mode & start program */
  write(pipe_io[0][1],"\177\n",2);
 
}


#define MAX_SELN 100
static char selection[MAX_SELN];
static char *get_selection() {
  Seln_holder holder;
  Seln_request *response;
  
  holder = seln_inquire(SELN_PRIMARY);
  response = seln_ask(&holder,
                      SELN_REQ_CONTENTS_ASCII,NULL,
                      NULL);
  
  strncpy(selection,response->data + sizeof(SELN_REQ_CONTENTS_ASCII),MAX_SELN);
  selection[MAX_SELN-1] = '\0';
  return selection;
}

static void print(){ cmd("p\n"); }
static void next(){ cmd("\n"); }
static void skip(){ cmd("s\n"); }
static void stopin(){ 
  char s[MAX_SELN+10], *sel;
  
  sel = get_selection();
  if (strlen(sel)) {
    sprintf(s,"ss:%s\n",get_selection());
    cmd(s);
  }
  else msg("Bad selection");
}
static void stopat(){ 
  char s[MAX_FN+10];
  int line = get_line();
  if(line > 0 && strlen(current_file) > 0) { 
    sprintf(s,"s:%s:%d\n",current_file,line);
    cmd(s);
  }
  else msg("Bad selection");
}
static void clear(){ 
  char s[MAX_SELN+10],*sel;
  int line = get_line();
  
  if(line > 0 && strlen(current_file) > 0) { 
    sprintf(s,"d:%s:%d\n",current_file,line);
    cmd(s);
  }
  
  sel = get_selection();
  if (strlen(sel)) {
    sprintf(s,"ds:%s\n",get_selection());
    cmd(s);
  }
}
static void leap(){ cmd("l\n"); }
static void run(){ 
  if (current_pid) {
    kill(current_pid,9);
    wait(NULL);
    /* close pipes */
    close(pipe_io[0][0]);
    close(pipe_io[0][1]);
    close(pipe_io[1][0]);
    close(pipe_io[1][1]);
  }
  create_child(*arguments,arguments);
}
static void typeof(){ cmd("pp\n"); }
static void hide(){ 
  char s[MAX_SELN+10], *sel;
  
  sel = get_selection();
  if (strlen(sel)) {
    sprintf(s,"np:%s\n",get_selection());
    cmd(s);
  }
  else msg("Bad selection");
}
static void load(){ loadfile(get_selection()); }

static void depth(item,value,event)
  Panel_item item; int value; Event event; {
  char s[5];
  sprintf(s,"pd%d\n",value);
  cmd(s);
}


#ifdef XView
static Notify_value kbd_focus(client,event,arg,type) 
  Frame client;
  Event *event;
  Notify_arg arg;
  Notify_event_type type; 
{ win_set_kbd_focus(client,xv_get(focus_shell,XV_XID));
  return notify_next_event_func(client,event,arg,type);
}
#endif

static Notify_value shell_input(client,event,arg,type) 
  Frame client;
  Event *event;
  Notify_arg arg;
  Notify_event_type type; 
{
  Textsw_index ip;
  char buf[BUFSIZ];

  if((event_action(event) == ACTION_CUT)) {
    /* eat up cut */
#ifdef XView
    event_init(event);
#else
    return NOTIFY_DONE;
#endif
  }

  /* Check for illegal position of insertion point */
  ip = (Textsw_index) window_get(shell,TEXTSW_INSERTION_POINT);
  if (ip<shell_mark) {
    window_set(shell,TEXTSW_INSERTION_POINT,shell_mark,0);
  }

  if (event_is_up(event)) return notify_next_event_func(client,event,arg,type); 

  if (event_is_ascii(event)) {
    switch (event_id(event))  {
      case (char)127: /* delete */
        if (ip<=shell_mark) return NOTIFY_DONE;
        break;
      case (char) 13: /* newline */
        (void)window_get(shell,TEXTSW_CONTENTS,shell_mark,buf,ip-shell_mark);
        buf[ip-shell_mark] = '\n';
        buf[ip-shell_mark+1] = '\0';
        shell_mark=ip+1;
        msg("");
        write(pipe_io[0][1],buf,strlen(buf));
        break;
      case (char)  3: /* CTRL-C */
        run();
        return NOTIFY_DONE;
      default:
        break;
    }
  }
  return notify_next_event_func(client,event,arg,type); 
}

static void create_msg_items() {
  fn_item = panel_create_item(message,PANEL_MESSAGE,
                    PANEL_LABEL_X,ATTR_COL(0),
                    PANEL_LABEL_Y,ATTR_ROW(0),
                    PANEL_VALUE_DISPLAY_LENGTH,80,
                    PANEL_LABEL_STRING,
                      strlen(current_file)? current_file
                                            : "No source displayed",
                    0);
  msg_item = panel_create_item(message,PANEL_MESSAGE,
                    PANEL_LABEL_X,ATTR_COL(0),
                    PANEL_LABEL_Y,ATTR_ROW(1),
                    PANEL_VALUE_DISPLAY_LENGTH,25,
                    PANEL_LABEL_STRING,"   ",
                    0);  
}

#ifdef XView
#define button_label(str) PANEL_LABEL_STRING,str
#else
#define button_label(str) PANEL_LABEL_IMAGE,panel_button_image(panel,str,0,0)
#endif

static void create_panel_items() {
  panel_create_item(panel,PANEL_BUTTON,
                    PANEL_LABEL_X,ATTR_COL(0),
                    PANEL_LABEL_Y,ATTR_ROW(0),
                    button_label("print"),
                    PANEL_NOTIFY_PROC,print,
                    0);  
  panel_create_item(panel,PANEL_BUTTON,
                    button_label("next"),
                    PANEL_NOTIFY_PROC,next,
                    0);  
  panel_create_item(panel,PANEL_BUTTON,
                    button_label("skip"),
                    PANEL_NOTIFY_PROC,skip,
                    0);  
  panel_create_item(panel,PANEL_BUTTON,
                    button_label("stop in"),
                    PANEL_NOTIFY_PROC,stopin,
                    0);  
  panel_create_item(panel,PANEL_BUTTON,
                    button_label("stop at"),
                    PANEL_NOTIFY_PROC,stopat,
                    0);  
  panel_create_item(panel,PANEL_BUTTON,
                    button_label("clear"),
                    PANEL_NOTIFY_PROC,clear,
                    0);  
  panel_create_item(panel,PANEL_BUTTON,
                    button_label("leap"),
                    PANEL_NOTIFY_PROC,leap,
                    0);  
  panel_create_item(panel,PANEL_BUTTON,
                    button_label("run"),
                    PANEL_NOTIFY_PROC,run,
                    0);  
  panel_create_item(panel,PANEL_BUTTON,
                    PANEL_LABEL_X,ATTR_COL(0),
                    PANEL_LABEL_Y,ATTR_ROW(1),
                    button_label("typeof"),
                    PANEL_NOTIFY_PROC,typeof,
                    0);  
  panel_create_item(panel,PANEL_BUTTON,
                    button_label("hide"),
                    PANEL_NOTIFY_PROC,hide,
                    0);  
  panel_create_item(panel,PANEL_BUTTON,
                    button_label("load"),
                    PANEL_NOTIFY_PROC,load,
                    0);  
  depth_item = panel_create_item(panel,PANEL_SLIDER,
                    PANEL_LABEL_STRING,"Term depth:",
                    PANEL_VALUE,3,
                    PANEL_MIN_VALUE,0,
                    PANEL_MAX_VALUE,10,
                    PANEL_SLIDER_WIDTH,30,
                    PANEL_NOTIFY_PROC,depth,
                    0);  
}


void main(argc,argv) int argc; char *argv[]; {
int i;
#ifdef XView
  Server_image image;
  Icon 	 icon;
#endif

  if (argc <= 1) {
    printf("Usage: aspdb <aspect_program>\n");
    exit(1);
  }
  
  strcpy(current_file,"");
  frame = window_create(NULL,FRAME,
                        FRAME_LABEL,"ASpecT Source Debugger V1.0",
                        FRAME_NO_CONFIRM,TRUE,
                        0);

#ifdef XView
  image = (Server_image) xv_create(NULL, SERVER_IMAGE, 
				         XV_WIDTH,	64,
					 XV_HEIGHT,	64,
					 SERVER_IMAGE_BITS, aspectIcon,
					 NULL);
  icon = (Icon) xv_create(NULL, ICON,	ICON_IMAGE,	image,
					NULL);
  xv_set(frame,FRAME_ICON,icon,NULL);
#else
  window_set(frame,FRAME_ICON,&icon,NULL);
#endif


  message = window_create(frame,PANEL,
#ifdef XView
			  XV_X, 0,
			  XV_Y, 0,
#endif
                          0);     
  create_msg_items();
  window_fit_height(message);

  display = window_create(frame,TEXTSW,
                        WIN_ROWS,20,
                        WIN_BELOW,message,
                        TEXTSW_BROWSING,TRUE,
                        TEXTSW_LINE_BREAK_ACTION,TEXTSW_CLIP,
                        0);
                        
  panel = window_create(frame,PANEL,
                        WIN_BELOW,display,
                        0);     
  create_panel_items(); 
  window_fit_height(panel);

  shell = window_create(frame,TEXTSW,
                   WIN_BELOW,panel,
                   WIN_ROWS,10,
#ifdef XView
                   WIN_COLUMNS,90,
#else
                   WIN_COLUMNS,80,
#endif
                   TEXTSW_DISABLE_LOAD,TRUE,
                   TEXTSW_IGNORE_LIMIT,TEXTSW_INFINITY,
                   TEXTSW_INSERTION_POINT,TEXTSW_INFINITY,0,
                   0);
  shell_mark = (Textsw_index) window_get(shell,TEXTSW_INSERTION_POINT);

#ifdef XView
  focus_shell = (Xv_Window)xv_get(shell,OPENWIN_NTH_VIEW,0);
  notify_interpose_event_func(focus_shell,shell_input,NOTIFY_SAFE);
  notify_interpose_event_func(frame,kbd_focus,NOTIFY_SAFE);
#else
  notify_interpose_event_func(shell,shell_input,NOTIFY_SAFE);
#endif

  window_fit_height(shell);
  
  window_fit(frame);
  
  argv++; 
  arguments = argv;
  create_child(*arguments,arguments);
  
  window_main_loop(frame);	 
  exit(0);
} 
