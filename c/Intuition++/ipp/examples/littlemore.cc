///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
//
//	Little test program implementing a simple 'more' to illustrate
//	how objects are easy to use, and easy to handle.
//
//	For all comment email 'brulhart@cuilima.unige.ch'
//
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////


#include <stream.h>
#include <stdlib.h>


#include <ipp/mgwindow.h>


MGWindow window;
FILE *file;


//////////////////////////////////////////////////////////////////////////////
//
//	Callbacks
//

void moveon(IMessage& message)
{
IMessage mess;
char buf[255];
	while (!(window.getImsg(mess)->iclass & (RAWKEY+MOUSEBUTTONS)))
	{
		if (fgets(buf,255,file)==NULL) exit(0);
		window.scrollraster(0,12,0,0,window.width(),window.height());
		window.writetext(0,window.height()-22,buf);
	}
}


void quit(IMessage& message)
{
	fclose(file);
	exit(0);
}




/////////////////////////////////////////////////////////////////////////////
//
//	Main
//

main(int argc,char **argv)
{
	if (argc!=2)
	{
		cout << "Usage : more <file>\n";
		exit(1);
	} 
	if ((file=fopen(argv[1],"r"))==NULL)
	{
		cout << "Can't open file\n";
		exit(1);
	}

	window.setflags(GIMMEZEROZERO+WINDOWCLOSE+WINDOWDEPTH+WINDOWDRAG+WINDOWSIZING);
	window.setIDCMPflags(RAWKEY+MOUSEBUTTONS+CLOSEWINDOW);

	window.linkIevent(CLOSEWINDOW,0,0,NULL,quit);
	window.linkIevent(MOUSEBUTTONS,SELECTDOWN,0,NULL,moveon);
	window.linkIevent(RAWKEY,0x45,IEQUALIFIER_LSHIFT|IEQUALIFIER_RSHIFT,NULL,quit);
	window.linkIevent(RAWKEY,0x40,0,NULL,moveon);

	window.resize(500,300);
	window.setlimit(100,100,1000,1000);
	window.setpos(50,50);
	window.setfont((STRPTR)"Helvetica.font",11,0,0);

	window.open();

	window.setapen(1);
	window.activate();
	window.writetext(100,80,argv[1]);
	window.writetext(100,110,"Press Left Mouse Button");
	window.writetext(100,130," or Space Bar to read");
	window.writetext(100,170,"Click Upper Left Corner");
	window.writetext(100,190,"or Press Shift ESC to quit");

	window.hardcontrol();
}
	
