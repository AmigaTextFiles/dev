# works in GNU and BSD `make',
# and should work ok with the quirks in the linux linker

CC ?= cc
objects = src/Clown_Args.o src/Clown_InteractiveFile.o src/Clown_TypeSystem.o src/Clown_main.o src/Compiler_AssemblyOutput.o src/Compiler_BinaryOutput.o src/Compiler_Dictionary.o src/Compiler_DynamicArrayExp.o src/Compiler_Formatter.o src/Compiler_Utilities.o src/Compiler_WeighLines.o src/Compiler_main.o src/ParentheseSolverV2.o src/SDL_GraphicsMgr.o src/SDL_events.o src/SDL_utils.o src/VM_ProgramFile.o src/fastVM.o src/framerate.o 

headers = src/AssemblyOutputTable.h src/Clown_Args.h src/Clown_HEADERS.h src/Clown_InteractiveFile.h src/Clown_TypeSystem.h src/Clown_main.h src/Clown_state.h src/Compiler_AssemblyOutput.h src/Compiler_BinaryOutput.h src/Compiler_Compiler.h src/Compiler_Debug.h src/Compiler_Dictionary.h src/Compiler_DynamicArrayExp.h src/Compiler_Formatter.h src/Compiler_Global.h src/Compiler_Logic.h src/Compiler_TypicalBinaryOp.h src/Compiler_TypicalSubExp.h src/Compiler_Utilities.h src/Compiler_Version.h src/Compiler_WeighLines.h src/ParentheseSolverV2.h src/SDLHeaders.h src/SDL_GraphicsMgr.h src/SDL_events.h src/SDL_utils.h src/VM_Binary.h src/VM_Opcodes.h src/VM_ProgramFile.h src/framerate.h src/mouse.h 

clown: $(objects)
	$(CC) $(CFLAGS) -o sdlclown $(objects) -lm `sdl-config --cflags --libs`

clean:
	rm -f sdlclown $(objects)

# For some reason, if I do not write the ugly explicit
# rules below, BSD `make' compiles src/*.c to *.o
# before trying to link src/*.o (and failing).

src/Clown_Args.o: src/Clown_Args.c $(headers)
	$(CC) $(CFLAGS) -c -o src/Clown_Args.o src/Clown_Args.c
src/Clown_InteractiveFile.o: src/Clown_InteractiveFile.c $(headers)
	$(CC) $(CFLAGS) -c -o src/Clown_InteractiveFile.o src/Clown_InteractiveFile.c
src/Clown_TypeSystem.o: src/Clown_TypeSystem.c $(headers)
	$(CC) $(CFLAGS) -c -o src/Clown_TypeSystem.o src/Clown_TypeSystem.c
src/Clown_main.o: src/Clown_main.c $(headers)
	$(CC) $(CFLAGS) -c -o src/Clown_main.o src/Clown_main.c
src/Compiler_AssemblyOutput.o: src/Compiler_AssemblyOutput.c $(headers)
	$(CC) $(CFLAGS) -c -o src/Compiler_AssemblyOutput.o src/Compiler_AssemblyOutput.c
src/Compiler_BinaryOutput.o: src/Compiler_BinaryOutput.c $(headers)
	$(CC) $(CFLAGS) -c -o src/Compiler_BinaryOutput.o src/Compiler_BinaryOutput.c
src/Compiler_Dictionary.o: src/Compiler_Dictionary.c $(headers)
	$(CC) $(CFLAGS) -c -o src/Compiler_Dictionary.o src/Compiler_Dictionary.c
src/Compiler_DynamicArrayExp.o: src/Compiler_DynamicArrayExp.c $(headers)
	$(CC) $(CFLAGS) -c -o src/Compiler_DynamicArrayExp.o src/Compiler_DynamicArrayExp.c
src/Compiler_Formatter.o: src/Compiler_Formatter.c $(headers)
	$(CC) $(CFLAGS) -c -o src/Compiler_Formatter.o src/Compiler_Formatter.c
src/Compiler_Utilities.o: src/Compiler_Utilities.c $(headers)
	$(CC) $(CFLAGS) -c -o src/Compiler_Utilities.o src/Compiler_Utilities.c
src/Compiler_WeighLines.o: src/Compiler_WeighLines.c $(headers)
	$(CC) $(CFLAGS) -c -o src/Compiler_WeighLines.o src/Compiler_WeighLines.c
src/Compiler_main.o: src/Compiler_main.c $(headers)
	$(CC) $(CFLAGS) -c -o src/Compiler_main.o src/Compiler_main.c
src/ParentheseSolverV2.o: src/ParentheseSolverV2.c $(headers)
	$(CC) $(CFLAGS) -c -o src/ParentheseSolverV2.o src/ParentheseSolverV2.c
src/SDL_GraphicsMgr.o: src/SDL_GraphicsMgr.c $(headers)
	$(CC) $(CFLAGS) -c -o src/SDL_GraphicsMgr.o src/SDL_GraphicsMgr.c
src/SDL_events.o: src/SDL_events.c $(headers)
	$(CC) $(CFLAGS) -c -o src/SDL_events.o src/SDL_events.c
src/SDL_utils.o: src/SDL_utils.c $(headers)
	$(CC) $(CFLAGS) -c -o src/SDL_utils.o src/SDL_utils.c
src/VM_ProgramFile.o: src/VM_ProgramFile.c $(headers)
	$(CC) $(CFLAGS) -c -o src/VM_ProgramFile.o src/VM_ProgramFile.c
src/fastVM.o: src/fastVM.c $(headers)
	$(CC) $(CFLAGS) -c -o src/fastVM.o src/fastVM.c
src/framerate.o: src/framerate.c $(headers)
	$(CC) $(CFLAGS) -c -o src/framerate.o src/framerate.c
