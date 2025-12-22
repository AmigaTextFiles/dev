####################################################################################
#
#	Makefile for Examples
#
#	Assuming you have the release installed or you made 'useinstalled' in 'ipp'
#	you can perform following actions :
#
#		'smake'			build all examples
#
#		'smake printtest'	to print the examples
#
#		'smake clean'		to remove all object files
#
#
#	Note !!!!
#
#	I++ has been made with Ccomeau C++ 3.0, SAS C 6.0, recompile the library
#	if you are using another compiler and linker. (See 'ipp' directory)
#
#	Please ensure you have an alias or command named 'como' to launch C++ compiler
#	or modify definitions just below for your configuration.
#
#	!!! Please read the comment under CPPOPTIONS just below relying to problem
#	with __stdargs and Ccomeau. !!!
#
#	Please modify definition just below for PRINT to use your favourite print
#


#########################  Commands & Options ######################################

CC=sc
CCOPTIONS=


CPP=como
CPPOPTIONS= +Cs6 -c -DCPPPROBLEM
# the option -DCPPPROBLEM is there because some SAS include defines __stdargs
# wich cause problem to Ccomeau, so I had to place those lines between something
# like: #ifndef CPPPROBLEM and #endif. If you know the solution, let me know.


LNOPTIONS= -lIpp


PRINT=scr
RM=delete
CP=copy
MV=move
ASSIGN=assign
MKDIR=makedir



#########################  Objects  ###############################################

TEST1=littlepainter
TEST1DATA=littlepainterdata
TEST2=littlemore



#########################  Dependencies  ###########################################

all : $(TEST1) $(TEST2)


$(TEST1) : $(TEST1).o $(TEST1DATA).o
	$(CPP) -o $(TEST1) $(LNOPTIONS) $(TEST1).o $(TEST1DATA).o

$(TEST1).o : $(TEST1).cc
	$(CPP) $(CPPOPTIONS) -o $(TEST1).o $(TEST1).cc

$(TEST1DATA).o : $(TEST1DATA).c
	$(CC) $(CCOPTIONS) $(TEST1DATA).c



$(TEST2) : $(TEST2).cc
	$(CPP) -o $(TEST2) -DCPPPROBLEM -lIpp $(TEST2).cc




printtest:
	$(PRINT) $(TEST1).cc
	$(PRINT) $(TEST2).cc


clean :
	$(RM) $(TEST1).o
	$(RM) $(TEST2).o
	$(RM) $(TEST1DATA).o
