#include <dos/dos.h>
#include <clib/dos_protos.h>       /* General dos functions...    */
#include <stdio.h>                 /* Std functions [printf()...] */
#include <stdlib.h>                /* Std functions [exit()...]   */
#include <string.h>


/*We pass 'GP' alot but it allows for multiple GUI's in a single aplication*/
 int main( int argc, char *argv[]);
 int getline(struct GUIpipe * GP);
 __stdargs int topipe(struct GUIpipe * GP, UBYTE * data,...);
 int gperror(struct GUIpipe * GP,int error);
 int buildgui(struct GUIpipe * GP);
 int getevent(struct GUIpipe * GP);
 int gadgets(struct GUIpipe * GP);
 int menu(struct GUIpipe * GP);
 UBYTE * eventstr(struct GUIpipe * GP, int num);
 VOID setdefaults(VOID);
 int updategui(struct GUIpipe * GP);
 int saveform(VOID);
 int loadform(struct GUIpipe * GP);

/* This structure is used to magage a GUI*/
/*events information and results from topipe() are kept seperate */
 struct GUIpipe
  {
   BPTR file;
   UBYTE * nextline;
   int count,error;
   int val1,val2,val3,val4,val5,val6;
   UBYTE buf[500],str3[200];
   UBYTE str1[20],result1[50],result2[50];
  };

/* the structure to mantain the GUI */
 struct GUIpipe myGP;

/* Storage for gadget ID's */
 int namegad,agegad,sexgad,knogad,basgad,aregad,cgad,asmgad,resgad,
 dongad,cangad;

/*NEW GADGETS FOR TUTORIAL3*/
 int savegad,loadgad,getfilegad;

/* the forms information */
 int age,sex,knowledge,basic,arexx,c,asm;
 UBYTE name[104];


 int main( int argc, char *argv[] )
  {
   struct GUIpipe * GP = &myGP;
   int stop=0;
   setdefaults();
/*try to build the GUI and use it*/
   if(!buildgui(GP))
    {
/* we disable the savegadget after the gui first opens*/
     topipe(GP,"id %ld dis 1 ref\n",savegad);

/* we loop until we are told to stop or an error happens*/
     while(!GP->error&&!stop)
      {
/*send continue to tell the pipe no more modify commands are comming and we
want an event*/
       topipe(GP,"con\n");

/* read an event.*/
       getevent(GP);
/*since we have received an event the pipe is now ready to get modify
commands again*/

/* the first two letter of each event type are different. For this GUI one
letter would be enough . SASC requires you turn the Multiple Character
Constants option on (MCConstants) .*/
       switch(GP->str1[1]+(GP->str1[0]<<8))
        {
         case('ga'):
         stop=gadgets(GP);
         break;
         case('me'):
         stop=menu(GP);
         break;
         case('cl'):
         printf("Use Closed Window or uses CTRl\\\n");
         stop=1;
         break;
        }
      }
    }

/*close the pipe connection*/
   if(GP->file)Close(GP->file);
   exit( 0 );
  }

/* read a  line from the pipe*/
/* get rid of the old line if there is one*/
 int getline(struct GUIpipe * GP)
  {
   int in;
   if(GP->nextline)
    {
     GP->count-=(GP->nextline-GP->buf);
memmove(GP->buf,GP->nextline,GP->count);
     GP->nextline=0;
    }
/*read pipe until we have an linefeed*/
while (!(GP->nextline=memchr(GP->buf,'\n',GP->count))) {

       if(!(in=Read(GP->file,&(GP->buf[GP->count]),499-GP->count)))
        {
/*error on EOF or lines over 499 chars.*/
         gperror(GP,1);
         return(1);
        }
       GP->count+=in;
      }

/* mark the end of line*/
   *GP->nextline++=0;
   return(0);
  }
/*write formated data to the pipe (works like printf),
 read the responce from the pipe and parse it,
 return the value of the second parameter is the responce is ok,
 return 0 if we have a problem*/
 __stdargs int topipe(struct GUIpipe * GP, UBYTE * data,...)
  {
   VFPrintf(GP->file,data,(APTR)(4+(int)(&data)) );
   if(getline(GP)) return(0);
   sscanf(GP->buf,"%50s %50s",GP->result1,GP->result2);
   if(!strcmp(GP->result1,"ok"))return(atoi(GP->result2));
   gperror(GP,2);
   return(0);
  }


/* GP->error could simply be set rather then calling this routine
but its politer to alert the user somehow */
 int gperror(struct GUIpipe * GP,int error)
  {
   GP->error=error;
   printf("ERROR %ld\n",GP->error);
   return(0);
  }

/*open the file on AWNPipe:, send the window and gadget definitions,
 open the GUI window, return 0 for sucess or an error number*/
 buildgui(struct GUIpipe * GP)
  {
/* Open pipe 'tut3' with GUI creation option '/xc' */
   if(!( GP->file=Open("awnpipe:tut3/xc",MODE_OLDFILE))) return(1);

   /* The first line of every GUI is the window definition. The window is titled
"Tutorial 3" and its elements will be laid out verticaly (v). It has a
closegadget (cg) , depthgadget (dg) , and dragbar (db). It will have spaces
inbetween its gadgets (si). It will open on the topleft (tl) of the screen
becoming active (a) when opened. The GUI can be modified (m)*/

   topipe(GP," \"Tutorial 3\" v cg dg db si a tl m\n");

   /* define the gadgets*/
   /* Labels are used to tell the user what information to enter in each gadget.
These labels are unatached (ua) when they are defined so don't go directly
into the GUI. Instead they are attached to the following gadget by the
childlabel (chl) keyword. */

   topipe(GP," layout b 0 v\n");
   topipe(GP," label gt \"Name: \" ua\n");
   namegad=topipe(GP,"string lj chl\n");
   topipe(GP," label gt \"Age: \" ua\n");
   agegad=topipe(GP,"integer chl minn 10 maxn 99 arrows defn 30  weiw 0\n");
   topipe(GP," label gt \"Sex: \" ua\n");
   sexgad=topipe(GP,"radiobutton rl \"Male|Female\" chl\n");
   topipe(GP," label gt \"Knowledge: \" ua\n");
   knogad=topipe(GP,"chooser pu cl \"Novice|Average|Good|Expert\" chl\n");
   topipe(GP," label gt \"Language(s): \" ua\n");
   topipe(GP," layout b 0 chl\n");
   basgad=topipe(GP,"checkbox gt \"Basic \" chl\n");
   aregad=topipe(GP,"checkbox gt \"Arexx \" chl\n");
   cgad=topipe(GP,"checkbox gt \"C \" chl\n");
   asmgad=topipe(GP,"checkbox gt \"ASM \" chl\n");
   topipe(GP," le\n");
   topipe(GP," le\n");
   topipe(GP," layout si so\n");
   savegad= topipe(GP,"button gt \"Save\" \n");
   loadgad= topipe(GP,"button gt \"Load\" \n");
   resgad= topipe(GP,"button gt \"Reset Form\" \n");
   dongad= topipe(GP,"button gt \"Done\" c\n");
   cangad= topipe(GP,"button gt \"Cancel\" c\n");
   topipe(GP," le\n");
   topipe(GP," menu gt \"Project  |About|$!   Tutorial 2   |$!  AWNPipe: Example\"\n");
   topipe(GP," menu gt \"Data|@AShow all data|Show part|$@PPersonal|$@SSkill\"\n");

/* this gadget is unattached so does not show in the GUI. It is used by the
loadform() routine. */
   getfilegad= topipe(GP,"getfile gt \"Select Information File\" fn \"t:\" ua pat \"#?.tut3\" \n");

   /*open the GUI window if all is ok*/
   if(!GP->error) topipe(GP,"open\n");
   return(GP->error);
  }


/* read a line from the pipe and parse it for event information*/
 int getevent(struct GUIpipe * GP)
  {
UBYTE * s3;
   if(!getline(GP))
    {
     sscanf(GP->buf,"%20s %d %d %d %d %d",
            GP->str1,&GP->val2,&GP->val3,
            &GP->val4,&GP->val5,&GP->val6);
     sscanf(GP->buf,"%d",&GP->val1);
if (s3=eventstr(GP,3)){
if (strlen(s3)<200)strcpy(GP->str3,s3);
else memmove(GP->str3,s3,199);
    }
}
   return(GP->error);
  }

/* find the start of the 'num' parameter.
ONLY CALL THIS FUCNTION IMEDIATLY AFTER RECEIVING A LINE.
Then store a copy of the string, NOT THE POINTER */
 UBYTE * eventstr(struct GUIpipe * GP,int num)
  {
   UBYTE *a;
   a=GP->buf;
   while((num--)>1)
    {
     a=strchr(a,' ');
     if(!a)return(0);
     a++;
    }
   return(a);
  }

/* store the information from the event, or perform an action
 we return 1 if the gui should be closed, or 0 to keep going*/
 int gadgets(struct GUIpipe * GP)
  {
   int a;
   a=GP->val2;
   if(a==agegad)     age=GP->val3;
   if(a==sexgad)     sex=GP->val3;
   if(a==knogad)     knowledge=GP->val3;
   if(a==basgad)     basic=GP->val3;
   if(a==aregad)     arexx=GP->val3;
   if(a==cgad)       c=GP->val3;
   if(a==asmgad)     asm=GP->val3;
   if(a==namegad)
    {
     strcpy(name,GP->str3);
/* disable the save gadget if we do not have a name, enable it if we do*/
     return(topipe(GP,"id %ld dis %ld ref\n",savegad, (strlen(name))?0:1 ));
    }
   if(a==loadgad) return(loadform(GP));
   if(a==savegad) return(saveform());
   if(a==resgad)
    {
     setdefaults();
     return(updategui(GP));
    }
   if(a==cangad)
    {
     printf("User Canceled\n");
     return(1);
    }
   if(a==dongad)
    {
     printf("name: %s\n age: %ld\n sex: %ld\n", name,age,sex);
     printf("knowledge: %ld\n basic: %ld arexx: %ld c: %ld asm: %ld \n",
            knowledge,basic,arexx,c,asm);
     return(1);
    }
   return(0);
  }

/*react to the menu event. menu#=val2, menuitem#=val3,subitem#=val4
 menu 0 is only informational so we ignore it and just handle menu 1*/
 int menu(struct GUIpipe * GP)
  {
   if(GP->val2==1)
    {
     if(GP->val3==0)
      {
       printf("name %s age %ld sex %ld\n", name,age,sex);
       printf("knowledge %ld basic %ld arexx %ld c %ld asm %ld \n",
              knowledge,basic,arexx,c,asm);
      }

     if(GP->val3==1)
      {
       if(GP->val4==0)
        {
         printf("name %s age %ld sex %ld\n", name,age,sex);
        }
       if(GP->val4==1)
        {
         printf("knowledge %ld basic %ld arexx %ld c %ld asm %ld \n",
                knowledge,basic,arexx,c,asm);
        }
      }
    }
   return(0);
  }

/*initialize our information to default state*/
 VOID setdefaults()
  {
   *name=0;
   age=30;
   sex=0 ;
   knowledge=0;
   basic=0;
   c=0;
   asm=0;
   arexx=0;
  }

/* send modify commands to update our GUI to the current information*/
 int updategui(struct GUIpipe * GP)
  {
   topipe(GP,"id %ld defn %ld ref\n",agegad,age);
   topipe(GP,"id %ld s %ld ref\n",sexgad,sex);
   topipe(GP,"id %ld s %ld ref \n",knogad,knowledge);
   topipe(GP,"id %ld s %ld ref\n",basgad,basic);
   topipe(GP,"id %ld s %ld ref\n",aregad,arexx);
   topipe(GP,"id %ld s %ld ref \n",cgad,c );
   topipe(GP,"id %ld s %ld ref\n",asmgad,asm);
   topipe(GP,"id %ld gt \"%ls\" ref\n",namegad,name);
   topipe(GP,"id %ld dis %ld ref\n",savegad,(strlen(name))?0:1);
   return(GP->error);
  }

/*write our information to a file. Build the file name from the 'name'
information*/
 int saveform()
  {
   UBYTE buf[300];
   BPTR fh;
   int a;
   if (!strlen(name))return(1);
   a=sprintf(buf,"t:%ls.tut3",name);
   buf[a]=0;
   if(fh=Open(buf,MODE_READWRITE))
    {
     FPrintf(fh,"%ld %ld %ld %ld %ld %ld %ld %ls",
             age ,sex ,knowledge,basic,arexx,c,asm,name);
     Close(fh);
     return(0);
    }
   return(1);
  }

/* open our unattached getfile gadget to select a file.
read the file and store the information.*/
 int loadform(struct GUIpipe * GP)
  {
   UBYTE buf[300],*b,*c;
   BPTR fh;
   int a;
   b=buf;
   c=buf;
/* we do not use topipe() since we want to parse the return from this modify
command as an event. This is a special case */
   FPrintf(GP->file,"id %ld fn \"t:\" s 1\n",getfilegad);
   if (getevent(GP)) return(1);
/*val 1 is 0 if the user canceled the file requester, non zero if a file was
selected*/
   if(GP->val1)
    {
/*The file name is returned in quotes. Copy the real file name from between
the quotes. Damn the "Ram Disk:"*/
     if(!(b=eventstr(GP,2))) return(1);
     b++;
     while(*b!='"')*c++=*b++;
     *c++=0;
/*open and read the file, parse the info*/
     if(fh=Open(buf,MODE_OLDFILE))
      {
       a=Read(fh,buf,299);
       buf[a]=0;
       Close(fh);
       sscanf(buf,"%ld %ld %ld %ld %ld %ld %ld",
              &age ,&sex ,&knowledge,&basic,&arexx,&c,&asm);
       strcpy(name,&buf[15]);
       updategui(GP);
      }
    }
   return(0);
  }

