/* main.h*/



/*----------------------------------------------------------------------------------*/
ULONG _strlen(char *in);
VOID VSPrintf(STRPTR buffer, STRPTR formatString, va_list varArgs);
int Sprintf(STRPTR buffer, STRPTR formatString, ...);
int strcasecmp(const char *s1, const char *s2);
char *strchr(const char *s, int c);
char *strncpy( char * destination, const char * source, size_t num );
char *strrchr(const char *s, int c);
int isspace(int c);
int isdigit( int c );
int isalnum( int c );
int tolower ( int c );
int toupper ( int c );
