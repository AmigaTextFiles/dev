/* === SDL_clown v0.3.5, based on clown v0.2.5 === */

/*
   Clown Script Interpreter
      v0.2.5 - Public
    Written by Bl0ckeduser
*/

#define MEMORY_QTY 2*1000*1000

/* SDL_clown extensions headers */
#include "framerate.h"
#include "mouse.h"
#include "SDLHeaders.h"
#include "SDL_GraphicsMgr.h"
#include "SDL_utils.h"
#include "SDL_events.h"

/* Double precision */
#define clown_int_t signed long
#define clown_float_t double

/* Libraries */
#include <assert.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <strings.h>

/* Definitions & declarations */
#include "AssemblyOutputTable.h"
#include "Clown_Args.h"
#include "Clown_InteractiveFile.h"
#include "Clown_TypeSystem.h"
#include "Clown_main.h"
#include "Clown_state.h"
#include "Compiler_AssemblyOutput.h"
#include "Compiler_BinaryOutput.h"
#include "Compiler_Compiler.h"
#include "Compiler_Debug.h"
#include "Compiler_Dictionary.h"
#include "Compiler_DynamicArrayExp.h"
#include "Compiler_Formatter.h"
#include "Compiler_Global.h"
#include "Compiler_Logic.h"
#include "Compiler_Utilities.h"
#include "Compiler_Version.h"
#include "Compiler_WeighLines.h"
#include "ParentheseSolverV2.h"
#include "VM_Binary.h"
#include "VM_ProgramFile.h"

