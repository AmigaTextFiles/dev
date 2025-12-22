extern int lines;
extern int num_errors;
extern char id_string[];
extern char char_lit[];
extern char num_lit[];

main()  {
        printf( "\nStarting Ada grammatical analysis\n\n[1]\t" );
        yyparse();
        printf( "---> Grammatical analysis complete. %d error(s) <---\n", num_errors);
        }

yyerror(s)
char *s;
        {
        printf(  "?? %s ??\n\t", s );
        ++num_errors;
        }
