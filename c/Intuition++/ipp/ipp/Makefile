####################################################################################
#
#	Makefile for Intuition++
#
#	Assuming you have the release installed or you made 'useinstalled' (see below)
#	you can perform following actions :
#
#		'smake'			to build the Ipp library
#
#		'smake Ipp.lib' 	to build the Ipp library
#
#		'smake install'		to install Ipp.lib in your 'lib:' directory,
#					and install include files in 'include:ipp'
#
#		'smake update'		to update Ipp.lib in your 'lib:' directory,
#					and update include files in 'include:ipp'
#					(i.e. you already have ipp dir in include:)
#
#		'smake useinstalled'	to add this directory to lib: and include:
#					assigns so you can use the release without
#					having it installed
#
#		'smake printheader'	to print all definition of I++ classes
#
#		'smake print'		to print all code of I++
#
#		'smake clean'		to remove all object file and test program
#
#
#	Note !!!!
#
#	I++ has been made with Ccomeau C++ 3.0, SAS C 6.0
#
#	Please ensure you have an alias or command named 'como' to launch C++ compiler
#	or modify definitions just below for your configuration.
#
#	!!! Please read the comment under CPPOPTIONS just below relying to problem
#	with __stdargs and Ccomeau. !!!
#
#	If you use another C compiler you will need to open all libraries yourself,
#	for this uncomment all relying lines in method initlibs() in all files .cc.
#	Uncomment or add needed prototypes and comment the includes with <clib/...>
#	Then remake the ipp.lib and reinstall it.
#
#	Please modify definition just below for PRINT to use your favourite print
#
#	Please modify INSTALLLIBDIR and INSTALLINCLUDEDIR if you want to install them
#	in a other place.


#########################  Commands & Options ######################################

INSTALLLIBDIR=lib:
INSTALLINCLUDEDIR=CC30include:


CC=sc
CCOPTIONS=


CPP=como
CPPOPTIONS= +Cs6 -c -DCPPPROBLEM
# the option -DCPPPROBLEM is there because some SAS include defines __stdargs
# wich cause problem to Ccomeau, so I had to place those lines between something
# like: #ifndef CPPPROBLEM and #endif. If you know the solution, let me know.


PRINT=scr
RM=delete
CP=copy
MV=move
ASSIGN=assign
MKDIR=makedir



#########################  Objects  ###############################################

IPPLIB=Ipp.lib

CSCREEN=cscreen
GSCREEN=gscreen
WSCREEN=wscreen
WGSCREEN=wgscreen
CFONT=cfont
CRASTPORTHDL=crastporthdl
CWINDOW=cwindow
GFXWINDOW=gfxwindow
MSGWINDOW=msgwindow
MGWINDOW=mgwindow
IMESSAGE=imessage
WAITER=waiter

OBJECTS=$(CSCREEN).o $(GSCREEN).o $(WSCREEN).o $(WGSCREEN).o $(CFONT).o $(CRASTPORTHDL).o $(CWINDOW).o $(GFXWINDOW).o $(MSGWINDOW).o $(MGWINDOW).o $(IMESSAGE).o $(WAITER).o



#########################  Dependencies  ###########################################

all : $(IPPLIB)


$(IPPLIB) : $(OBJECTS)
	oml -v -b -n -s -x $(IPPLIB) R $(OBJECTS)





$(CFONT).o : $(CFONT).cc $(CFONT).h
	$(CPP) $(CPPOPTIONS) -o $(CFONT).o $(CFONT).cc


$(CRASTPORTHDL).o : $(CRASTPORTHDL).cc $(CRASTPORTHDL).h $(CFONT).h
	$(CPP) $(CPPOPTIONS) -o $(CRASTPORTHDL).o $(CRASTPORTHDL).cc


$(CWINDOW).o : $(CWINDOW).cc $(CWINDOW).h $(CSCREEN).h
	$(CPP) $(CPPOPTIONS) -o $(CWINDOW).o $(CWINDOW).cc


$(GFXWINDOW).o : $(GFXWINDOW).cc $(GFXWINDOW).h $(CWINDOW).h $(CRASTPORTHDL).h $(CFONT).h
	$(CPP) $(CPPOPTIONS) -o $(GFXWINDOW).o $(GFXWINDOW).cc


$(MSGWINDOW).o : $(MSGWINDOW).cc $(MSGWINDOW).h $(CWINDOW).h $(IMESSAGE).h
	$(CPP) $(CPPOPTIONS) -o $(MSGWINDOW).o $(MSGWINDOW).cc


$(MGWINDOW).o : $(MGWINDOW).cc $(MGWINDOW).h $(GFXWINDOW).h $(MSGWINDOW).h $(CWINDOW).h $(IMESSAGE).h $(CRASTPORTHDL).h $(CFONT).h
	$(CPP) $(CPPOPTIONS) -o $(MGWINDOW).o $(MGWINDOW).cc


$(IMESSAGE).o : $(IMESSAGE).cc $(IMESSAGE).h
	$(CPP) $(CPPOPTIONS) -o $(IMESSAGE).o $(IMESSAGE).cc


$(WAITER).o : $(WAITER).cc $(MSGWINDOW).h $(CWINDOW).h $(IMESSAGE).h
	$(CPP) $(CPPOPTIONS) -o $(WAITER).o $(WAITER).cc


$(CSCREEN).o : $(CSCREEN).cc $(CSCREEN).h $(CWINDOW).h
	$(CPP) $(CPPOPTIONS) -o $(CSCREEN).o $(CSCREEN).cc


$(GSCREEN).o : $(GSCREEN).cc $(GSCREEN).h $(CSCREEN).h  $(CRASTPORTHDL).h $(CFONT).h
	$(CPP) $(CPPOPTIONS) -o $(GSCREEN).o $(GSCREEN).cc


$(WSCREEN).o : $(WSCREEN).cc $(WSCREEN).h $(CSCREEN).h $(WAITER).h $(MSGWINDOW).h $(IMESSAGE).h
	$(CPP) $(CPPOPTIONS) -o $(WSCREEN).o $(WSCREEN).cc


$(WGSCREEN).o : $(WGSCREEN).cc $(WGSCREEN).h $(GSCREEN).h $(WSCREEN).h $(WAITER).h $(MSGWINDOW).h $(IMESSAGE).h $(CFONT).h
	$(CPP) $(CPPOPTIONS) -o $(WGSCREEN).o $(WGSCREEN).cc






#########################  Utils  ###############################################


install : 
	$(CP) $(IPPLIB) 	$(INSTALLLIBDIR)
	$(MKDIR) $(INSTALLINCLUDEDIR)ipp
	$(CP) $(CSCREEN).h	$(INSTALLINCLUDEDIR)ipp
	$(CP) $(GSCREEN).h	$(INSTALLINCLUDEDIR)ipp
	$(CP) $(WSCREEN).h	$(INSTALLINCLUDEDIR)ipp
	$(CP) $(WGSCREEN).h	$(INSTALLINCLUDEDIR)ipp
	$(CP) $(CWINDOW).h	$(INSTALLINCLUDEDIR)ipp
	$(CP) $(GFXWINDOW).h	$(INSTALLINCLUDEDIR)ipp
	$(CP) $(MSGWINDOW).h	$(INSTALLINCLUDEDIR)ipp
	$(CP) $(MGWINDOW).h	$(INSTALLINCLUDEDIR)ipp
	$(CP) $(IMESSAGE).h	$(INSTALLINCLUDEDIR)ipp
	$(CP) $(WAITER).h	$(INSTALLINCLUDEDIR)ipp
	$(CP) $(CFONT).h	$(INSTALLINCLUDEDIR)ipp
	$(CP) $(CRASTPORTHDL).h	$(INSTALLINCLUDEDIR)ipp


update : 
	$(CP) $(IPPLIB) 	$(INSTALLLIBDIR)
	$(CP) $(CSCREEN).h	$(INSTALLINCLUDEDIR)ipp
	$(CP) $(GSCREEN).h	$(INSTALLINCLUDEDIR)ipp
	$(CP) $(WSCREEN).h	$(INSTALLINCLUDEDIR)ipp
	$(CP) $(WGSCREEN).h	$(INSTALLINCLUDEDIR)ipp
	$(CP) $(CWINDOW).h	$(INSTALLINCLUDEDIR)ipp
	$(CP) $(GFXWINDOW).h	$(INSTALLINCLUDEDIR)ipp
	$(CP) $(MSGWINDOW).h	$(INSTALLINCLUDEDIR)ipp
	$(CP) $(MGWINDOW).h	$(INSTALLINCLUDEDIR)ipp
	$(CP) $(IMESSAGE).h	$(INSTALLINCLUDEDIR)ipp
	$(CP) $(WAITER).h	$(INSTALLINCLUDEDIR)ipp
	$(CP) $(CFONT).h	$(INSTALLINCLUDEDIR)ipp
	$(CP) $(CRASTPORTHDL).h	$(INSTALLINCLUDEDIR)ipp


useinstalled : 
	$(ASSIGN) $(INSTALLLIBDIR) /ipp add
	$(ASSIGN) $(INSTALLINCLUDEDIR) / add


print :
	$(PRINT) $(CSCREEN).h
	$(PRINT) $(CSCREEN).cc
	$(PRINT) $(GSCREEN).h
	$(PRINT) $(GSCREEN).cc
	$(PRINT) $(WSCREEN).h
	$(PRINT) $(WSCREEN).cc
	$(PRINT) $(WGSCREEN).h
	$(PRINT) $(WGSCREEN).cc
	$(PRINT) $(CWINDOW).h
	$(PRINT) $(CWINDOW).cc
	$(PRINT) $(GFXWINDOW).h
	$(PRINT) $(GFXWINDOW).cc
	$(PRINT) $(MSGWINDOW).h
	$(PRINT) $(MSGWINDOW).cc
	$(PRINT) $(MGWINDOW).h
	$(PRINT) $(MGWINDOW).cc
	$(PRINT) $(IMESSAGE).h
	$(PRINT) $(IMESSAGE).cc
	$(PRINT) $(WAITER).h
	$(PRINT) $(WAITER).cc
	$(PRINT) $(CFONT).h
	$(PRINT) $(CFONT).cc
	$(PRINT) $(CRASTPORTHDL).h
	$(PRINT) $(CRASTPORTHDL).cc


printheader :
	$(PRINT) $(CSCREEN).h
	$(PRINT) $(GSCREEN).h
	$(PRINT) $(WSCREEN).h
	$(PRINT) $(WGSCREEN).h
	$(PRINT) $(CWINDOW).h
	$(PRINT) $(GFXWINDOW).h
	$(PRINT) $(MSGWINDOW).h
	$(PRINT) $(MGWINDOW).h
	$(PRINT) $(IMESSAGE).h
	$(PRINT) $(WAITER).h
	$(PRINT) $(CFONT).h
	$(PRINT) $(CRASTPORTHDL).h



clean :
	$(RM) $(CSCREEN).o
	$(RM) $(GSCREEN).o
	$(RM) $(WSCREEN).o
	$(RM) $(WGSCREEN).o
	$(RM) $(CWINDOW).o
	$(RM) $(GFXWINDOW).o
	$(RM) $(MSGWINDOW).o
	$(RM) $(MGWINDOW).o
	$(RM) $(IMESSAGE).o
	$(RM) $(WAITER).o
	$(RM) $(CFONT).o
	$(RM) $(CRASTPORTHDL).o
