typedef union  {
    struct int_rec {
            int            val;
            int            line;
            int            start, end;
    } i;

    struct float_rec {
            float          val;
            int            line;
            int            start, end;
    } f;
    
    struct char_rec {
            char          *val;
            int            line;
            int            start, end;
    } s;
    
    struct ptr_rec {
            void          *val;
            int            line;
            int            start, end;
    } p;
    
    struct line_rec {
        int    line;
        struct command *cmd;
    } l;
} YYSTYPE;
#define	TOK_NUM	257
#define	TOK_FLOAT	258
#define	TOK_NAME	259
#define	TOK_STRING	260
#define	TOK_CHAR	261
#define	TOK_DOL	262
#define	TOK_DIV	263
#define	TOK_DOT	264
#define	TOK_COM	265
#define	TOK_STAR	266
#define	TOK_PLUS	267
#define	TOK_MINUS	268
#define	TOK_PLUSPLUS	269
#define	TOK_MINUSMINUS	270
#define	TOK_PLUS_S	271
#define	TOK_MINUS_S	272
#define	TOK_DIV_S	273
#define	TOK_MUL_S	274
#define	TOK_CLOSE	275
#define	TOK_CLOSEB	276
#define	TOK_NL	277
#define	TOK_OPEN	278
#define	TOK_OPENB	279
#define	TOK_COLON	280
#define	TOK_SCOL	281
#define	TOK_AT	282
#define	TOK_EQ	283
#define	TOK_IN	284
#define	TOK_EQEQ	285
#define	TOK_LT	286
#define	TOK_NE	287
#define	TOK_GT	288
#define	TOK_NOT	289
#define	TOK_AND	290
#define	TOK_OR	291
#define	TOK_LTEQ	292
#define	TOK_GTEQ	293
#define	TOK_IF	294
#define	TOK_ELSE	295
#define	TOK_ENDIF	296
#define	TOK_EMBED	297
#define	TOK_EMIT	298
#define	TOK_OUTPUT	299
#define	TOK_LOCAL	300
#define	TOK_PUSH	301
#define	TOK_POP	302
#define	TOK_FUNCTION	303
#define	TOK_ENDFUNCTION	304
#define	TOK_SWITCH	305
#define	TOK_CASE	306
#define	TOK_FOR	307
#define	TOK_ENDSWITCH	308
#define	TOK_ENDFOR	309
#define	TOK_RETURN	310
#define	TOK_BREAK	311
#define	TOK_USE	312
#define	TOK_EXIT	313


extern YYSTYPE yylval;
