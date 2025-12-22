%{
/*
 * This lex file is used to generate a simple
 * scanner using lex or flex (comes with the
 * GeekGadgets stuff). The resulting scanner
 * separates the C-header file in a list of
 * tokens, each separated by a newline.
 * Each outputted line has the following format:
 *
 *    k######    -> The stuff after "k" is a keyword
 *    i######    -> The stuff after "i" is an identifier
 *    o######    -> The stuff after "o" is a sequence of special characters
 *    d######    -> The stuff after "d" is a decimal number
 *    h######    -> The stuff after "h" is a hexadecimal number
 *
 */
#include <stdio.h>
#define YY_MAIN
int depth = 0;   /* Needed to ignore comments properly */
%}
CYPHER      [0-9]
HEXADIGIT   [0-9a-fA-F]
LETTER      [A-Z_a-z]
%%
("#define"|"#ifdef"|"#endif"|"#ifndef"|"#include"|"struct") {
  if( depth == 0 ) {
    printf( "k%s\n", yytext );
  }; /* endif */
}
("\x22\x22") {
  if( depth == 0 ) {
    printf( "i\x22\x22\n" );
  }; /* endif */
}
("\x22"|"("|")"|"~"|"|"|"&"|"{"|"}"|","|";"|"*"|"<"|">"|"="|"/"|"+"|"-"|"."|"\["|"\]"|"\\") {
  if( depth == 0 ) {
    printf( "o%s\n", yytext );
  }; /* endif */
}
({LETTER})({LETTER}|{CYPHER})* {
  if( depth == 0 ) {
    printf( "i%s\n", yytext );
  }; /* endif */
}
({CYPHER})+("L")? {
  if( depth == 0 ) {
    printf( "d%s\n", yytext );
  }; /* endif */
}
("0x")({HEXADIGIT})+ {
  if( depth == 0 ) {
    printf( "h%s\n", yytext );
  }; /* endif */
}
"//".*\n {
}
"/*" {
  depth += 1;
}
"*/" {
  depth -= 1;
}
['? \n$\t#:@!] {
}

