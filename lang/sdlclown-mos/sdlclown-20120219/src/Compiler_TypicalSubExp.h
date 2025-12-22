/*
   Clown Script Interpreter
      v0.2.5 - Public
    Written by Bl0ckeduser
*/

#ifndef _COMPILER_SUBEXP_H
#define _COMPILER_SUBEXP_H

/* Eliminates otherwise redundant code in Compiler_main.c */

#define ParseTypicalSubExp(condition, name)					\
    if(condition)								\
    {										\
        fscanf(input, "%s", param);						\
										\
        param_val = Dictionary_FetchEntry(param);				\
										\
        if(Dictionary_isLegalEntry(param_val))					\
        {									\
                /* variable */							\
										\
                allocated_variable_memory = AllocateMoreProgramMemory();	\
										\
                fprintf(phase_output, "Do %d 10 2 %d \n %s %d\n",		\
                        allocated_variable_memory,				\
                        Dictionary_EntryValue(param_val),			\
			name,							\
                        allocated_variable_memory);				\
										\
                return allocated_variable_memory;				\
        }									\
        else									\
        {									\
            if(stringRepresentsNumeral(param))					\
            {									\
                /* litteral */							\
										\
                allocated_variable_memory = AllocateMoreProgramMemory();	\
										\
                fprintf(phase_output, "Do %d 10 1 %s\n %s %d\n",		\
                        allocated_variable_memory,				\
                        param,							\
			name,							\
                        allocated_variable_memory);				\
										\
                return allocated_variable_memory;				\
            }									\
            else								\
            {									\
		/* 								\
		 * Parentheses syntax system implements nesting,		\
		 * we do not need to implement it here.				\
		 */								\
                printf("Error: cannot resolve '%s' (line %d)\n", param, currentSourceLine); \
                return 0;							\
            }									\
        }									\
    }

#endif

