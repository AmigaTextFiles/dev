/*
   Clown Script Interpreter
      v0.2.5 - Public
    Written by Bl0ckeduser
*/

/* Eliminates redundant code in Compiler_main.c */

#define ParseTypicalBinaryOp(condition, code) 			\
								\
if (condition) 							\
{ 								\
    parsed=1; 							\
    fscanf(source,"%s", param); 				\
    param2=Dictionary_FetchEntry(param); 			\
    								\
    if (address_of_last_variable_name==0) 			\
    { 								\
        printf("Error: variable expected (line %d)\n", currentSourceLine); \
        compiling = 0; 						\
    } 								\
    								\
    if (Dictionary_isLegalEntry(param2)) 			\
    { 								\
            /* variable */ 					\
            fprintf(phase_output, "Do %d %d 2 %d\n", address_of_last_variable_name, code, Dictionary_EntryValue(param2)); \
    } 								\
    else 							\
    { 								\
        if (stringRepresentsNumeral(param)) 			\
        { 							\
            /* litteral */ 					\
       	    fprintf(phase_output, "Do %d %d 1 %s\n", address_of_last_variable_name, code, param); 	\
        } 							\
        else 							\
        { 							\
                            /* check for a sub-expression */	\
                         					\
                            if((sub_exp_adr = subExp(source, phase_output, param)))	\
                            {					\
				/* generate code */		\
                                fprintf(phase_output, "Do %d %d 2 %d\n", \
                                        address_of_last_variable_name,	 \
					code, 			\
                                        sub_exp_adr); 		\
                            } else {				\
                                printf("Error: cannot resolve '%s' (line %d)\n", param, currentSourceLine); \
                                compiling = 0;			\
                            }					\
        } 							\
    } 								\
}


