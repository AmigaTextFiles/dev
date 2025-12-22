typedef struct
{
  char *string;
  int value;
  void *next;
} tablenode;

typedef struct
{
  char *string;
  int value;
  int params;
  int retval;
  int param[32];
  void *next;
} functnode;

int findsymbol(char *string);
void newsymbol(char *string, int value);
functnode *findfunct(char *string);
functnode *newfunct(char *string, int value);
int findextern(char *string);
void newextern(char *string, int value);
