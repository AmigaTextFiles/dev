
#ifndef CL_Y_PROGRAM_HPP
#include "class_Y_program.hpp"
#endif



int main(int argc, char *argv[])
{
Y_program *ypg=0;
int x;
long dss=4000,rss=1000;  // Data stack size, Return Stack size : default values
char *argument_prog=0;   // program given as a shell argument


if(argc<2||argc>4|| (argv[1][0]=='-'&&argv[1][1]=='h'))
{printf("Y Interpreter V0.71beta (c) 1995 T.Fischbacher.\n"
        "Usage: %s [-d<NUMBER>] [-r<NUMBER>] <progname>\n"
        "d: DataStack size\nr:ReturnStack size\n"
        "or:    %s [-d<NUMBER>] [-r<NUMBER>] -c<command-line-program>\n"
        "In the latter case, think of properly escaping special shell characters!\n"
        ,argv[0],argv[0]);

 return 20;
}
x=1;
while(argv[x][0]=='-')
 {
  if(argv[x][1]=='d')dss=atol(&argv[x][2]);
  if(argv[x][1]=='r')rss=atol(&argv[x][2]);
  if(argv[x][1]=='c')argument_prog=&argv[x][2];
  x++;
 }
if(dss<=1||rss<=1||(argument_prog&&strlen(argument_prog)==0))
  {fprintf(stderr,"Parameter Error!\n");return 20;}

if(argument_prog==0)
 ypg=new Y_program(argv[x],dss,rss);

else ypg=new Y_program(dss,rss,argument_prog);

//<See class_Y_program.hpp constructors for an explanation>

ypg->setvar('c',(ulword)(argc-x-1));    // c => argc
ypg->setvar('v',(ulword)(&argv[x+1]));  // v => argv
ypg->setvar('i',(ulword)stdin);         // i => stdin
ypg->setvar('o',(ulword)stdout);        // o => stout
ypg->setvar('e',(ulword)stderr);        // e => stderr


if((ypg->is_valid())==0){fprintf(stderr,"Program error!\n");return 20;}

ypg->go();
delete ypg;


return 0;
}

