BOOL stringcompare(char *, char *);
char *makelower(char *, const char *);
char *stringcopy(char *, const char *);
char *stringcopywithoutspace(char *, const char *);
void make_entry(void);
void AllocListbrowserNodes(struct List *);

struct List founded_files_list;
char founded_files_list_col1_raw[1024][31];
char founded_files_list_col2_raw[1024][31];
char founded_files_list_col3_raw[1024][31];
char founded_files_list_col4_raw[1024][31];
char founded_files_list_col5_raw[1024][31];
char indexdir[101] = "CD0:Lists/Aminet_Dir.doc";
char convert[101];
char executepuffer[300][101];
char pattern[5][31];
char patternlower[5][31];
char puffer[101];
char puffer2[201];

BOOL stringcompare(char *buffer1, char *buffer2)
{
  BYTE count = 0, length = 0, count2 = 0;

  while(*buffer1++) length++;
  buffer1 -= length;
  buffer1--;
  while((*buffer2) && (count != length))
  {
    count2++;
    buffer2++;
    if(*buffer1 == *buffer2)
    {
      count++;
      buffer1++;
    }
    else
    {
      buffer1 -= count;
      count = 0;
    }
  }
  if(length == count) return(TRUE);
  else return(FALSE);
}

char *makelower(char *buffer1, const char *buffer2)
{
  char *d = buffer1, c;

  do
  {
    c = *buffer2++;
    if((c >= (char) 65) && (c <= (char) 90)) c += (char) 32;
    *buffer1++ = c;
  }
  while(c);

  return(d);
}

char *stringcopy(char *buffer1, const char *buffer2)
{
  char *d = buffer1, c;

  do
  {
    c = *buffer2++;
    if(c != 0x0a) *buffer1++ = c;
  }
  while(c);

  return(d);
}

char *stringcopywithoutspace(char *buffer1, const char *buffer2)
{
  char *d = buffer1, c;

  do
  {
    c = *buffer2++;
    if(c != ' ') *buffer1++ = c;
    else
    {
      *buffer1 = NULL;
      break;
    }
  }
  while(c);

  return(d);
}

void make_entry(void)
{
  char buffer1[41];
  BOOL changed = FALSE;
  WORD i;

  for(i = 0;i < 5;i++)
  {
    if(pattern[i][0])
    {
      if(stringcompare(patternlower[i], convert))
      {
        strcpy(founded_files_list_col1_raw[entryzahl], pattern[i]);
        changed = TRUE;
      }
    }
  }
  if(changed)
  {
    for(i = 0;i < 19;i++) founded_files_list_col2_raw[entryzahl][i] = puffer[i + 00]; founded_files_list_col2_raw[entryzahl][19] = NULL;
    for(i = 0;i < 9;i++)  founded_files_list_col3_raw[entryzahl][i] = puffer[i + 19]; founded_files_list_col3_raw[entryzahl][9] = NULL;
    for(i = 0;i < 06;i++) founded_files_list_col4_raw[entryzahl][i] = puffer[i + 29]; founded_files_list_col4_raw[entryzahl][06] = NULL;
    for(i = 0;i < 40;i++) buffer1[i] = puffer[i + 39]; buffer1[39] = NULL;
    stringcopy(founded_files_list_col5_raw[entryzahl], buffer1);
    entryzahl++;
    AllocListbrowserNodes(&founded_files_list);
    Emperor_SetGadgetAttrComplex(Listbrowser1, LISTBROWSER_Labels, (STRPTR) &founded_files_list);
  }
}

void AllocListbrowserNodes(struct List *list)
{
  struct Node *node;
  WORD i;

  NewList(list);
  for(i = 0;i < entryzahl;i++)
  {
    node = AllocListBrowserNode(5, LBNA_Column, 0, LBNCA_CopyText, TRUE, LBNCA_Text, founded_files_list_col1_raw[i],
                                   LBNA_Column, 1, LBNCA_CopyText, TRUE, LBNCA_Text, founded_files_list_col2_raw[i],
                                   LBNA_Column, 2, LBNCA_CopyText, TRUE, LBNCA_Text, founded_files_list_col3_raw[i],
                                   LBNA_Column, 3, LBNCA_CopyText, TRUE, LBNCA_Text, founded_files_list_col4_raw[i],
                                   LBNA_Column, 4, LBNCA_CopyText, TRUE, LBNCA_Text, founded_files_list_col5_raw[i], TAG_DONE);
    AddTail(list, node);
  }
}

