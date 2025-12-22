/* fdparse.c */

#include "fdparse.h"

#define EOF -1

BOOL TagCallName(struct fd *fd)

{
  LONG len;

  if(!fd->fd_IsTagFunc) return(FALSE);

  if(strcmp(fd->fd_Function,"VFWritef") == 0 ||
     strcmp(fd->fd_Function,"VFPrintf") == 0 ||
     strcmp(fd->fd_Function,"VPrintf") == 0) {
    STRPTR s;

    for(s = fd->fd_Function;*s;s++) *s = *(s+1);
    return(TRUE);
  }

  len = strlen(fd->fd_Function);

  if(len > 1 && fd->fd_Function[len-1] == 'A') {
    fd->fd_Function[len-1] = '\0';
  }
  else {
    if(len > 7 && strcmp(fd->fd_Function+len-7,"TagList") == 0) {
      fd->fd_Function[len-4] = 's';
      fd->fd_Function[len-3] = '\0';
    }
    else {
      strcat(fd->fd_Function,"Tags");
    }
  }
  return(TRUE);
}

BOOL LibCallAlias(struct fd *fd)

{
  LONG len;

  if(!fd->fd_IsTagFunc) return(FALSE);

  if(strcmp(fd->fd_Function,"VFWritef") == 0 ||
     strcmp(fd->fd_Function,"VFPrintf") == 0 ||
     strcmp(fd->fd_Function,"VPrintf") == 0) return(FALSE);

  len = strlen(fd->fd_Function);

  if(len > 1 && fd->fd_Function[len-1] == 'A') return(FALSE);

  if(len > 7 && strcmp(fd->fd_Function+len-7,"TagList") == 0) {
    fd->fd_Function[len-7] = '\0';
    if(strcmp(fd->fd_Function,"OpenWindow") == 0 ||
       strcmp(fd->fd_Function,"OpenScreen") == 0) return(FALSE);
  }
  else {
    strcat(fd->fd_Function,"TagList");
  }
  return(TRUE);
}

void InitFD(BPTR fdfile,struct fd *fd)

{
  fd->fd_Input = fdfile;
  fd->fd_State = FD_PARSING|FD_PUBLIC;
  fd->fd_Offset = 0;
  fd->fd_NumParams = 0;
  fd->fd_BaseName[0] = 0;
  fd->fd_Function[0] = 0;
  fd->fd_IsTagFunc = FALSE;
}

#define BUFFLEN 1023

static UBYTE buff[BUFFLEN+1];

#define isstart(c) (((c)>='A'&&(c)<='Z')||((c)>='a'&&(c)<='z')||(c)=='_')
#define isdigit(c) ((c)>='0'&&(c)<='9')
#define iscont(c)  (isstart(c)||isdigit(c))

int keyword(struct fd *fd)

{
  int i = 0;
  int j = 0;

  while(buff[i] && buff[i] != ' ' && buff[i] != '\t' && i < IDLEN) {
    fd->fd_Function[i] = buff[i];
    i++;
  }
  fd->fd_Function[i] = 0;
  
  if(strcmp(fd->fd_Function,"base") == 0) {
    if(fd->fd_BaseName[0]) {
      strcpy(fd->fd_Function,"Library base name already defined !");
      return(0);
    }
    while(buff[i] == ' ' || buff[i] == '\t') i++;
    if(!isstart(buff[i])) {
      strcpy(fd->fd_Function,"Illegal library base name !");
      return(0);
    }
    do fd->fd_BaseName[j++] = buff[i++]; 
    while(j < IDLEN && iscont(buff[i]));
    fd->fd_BaseName[j] = 0; 

    if(j == IDLEN) {
      strcpy(fd->fd_Function,"Library base name too long !");
      return(0);
    }

    while(buff[i] == ' ' || buff[i] == '\t') i++;

    if(buff[i]) {
      strcpy(fd->fd_Function,"Syntax error in base name definition !");
      return(0);
    }
    return(!0);
  }

  if(strcmp(fd->fd_Function,"end") == 0) {

    if(!(fd->fd_BaseName[0])) {
      strcpy(fd->fd_Function,"Unexpected end of fd-file !");
      return(0);
    }
    fd->fd_State |= FD_READY;
    return(!0);
  }

  if(strcmp(fd->fd_Function,"bias") == 0) {
    while(buff[i] == ' ' || buff[i] == '\t') i++;
    fd->fd_Offset = 0;
    while(isdigit(buff[i])) 
      fd->fd_Offset = 10 * fd->fd_Offset - (buff[i++] - '0');
    while(buff[i] == ' ' || buff[i] == '\t') i++;
    if(buff[i] || fd->fd_Offset == 0) {
      strcpy(fd->fd_Function,"Illegal bias value !");
      return(0);
    }
    fd->fd_State |= FD_BIAS;
    return(!0);
   }

  if(strcmp(fd->fd_Function,"public") == 0) {
    while(buff[i] == ' ' || buff[i] == '\t') i++;
    if(buff[i]) {
      strcpy(fd->fd_Function,"Syntax error in ##public keyword !");
      return(0);
    }
    fd->fd_State &= ~FD_PRIVATE;
    return(!0);
  }

  if(strcmp(fd->fd_Function,"private") == 0) {
    while(buff[i] == ' ' || buff[i] == '\t') i++;
    if(buff[i]) {
      strcpy(fd->fd_Function,"Syntax error in ##private keyword !");
      return(0);
    }
    fd->fd_State |= FD_PRIVATE;
    return(!0);
  }

  strcpy(fd->fd_Function,"Unknown keyword !");
  return(0);
}

#define isdreg(c) ((c)>='0'&&(c)<='7')
#define isareg(c) ((c)>='0'&&(c)<='5')

static BOOL IsTagFunc(struct fd *fd,STRPTR lastparm,LONG len)

{
  LONG l;

  if(strnicmp(lastparm,"tags",len) == 0 ||
     strnicmp(lastparm,"taglist",len) == 0) return(TRUE);

  if(strcmp(fd->fd_Function,"CachePreDMA") == 0 ||
     strcmp(fd->fd_Function,"CachePostDMA") == 0) return(FALSE);

  l = strlen(fd->fd_Function);

  if((l > 1 && fd->fd_Function[l-1] == 'A') ||
     (l > 7 && stricmp(fd->fd_Function+l-7,"TagList")  == 0)) return(TRUE);

  if(strcmp(fd->fd_Function,"VFWritef") == 0 ||
     strcmp(fd->fd_Function,"VFPrintf") == 0 ||
     strcmp(fd->fd_Function,"VPrintf") == 0) return(TRUE);

  return(FALSE);
}

int function(struct fd *fd)

{
  int i = 0;
  int j = 0;
  UWORD regs = 0;
  UBYTE numargs;

  if(!isstart(buff[0])) {
    strcpy(fd->fd_Function,"Illegal function name !");
    return(0);
  }

  do fd->fd_Function[j++] = buff[i++]; 
  while(j < IDLEN && iscont(buff[i]));
  fd->fd_Function[j] = 0; 

  if(j == IDLEN) {
    strcpy(fd->fd_Function,"Function name too long !");
    return(0);
  }

  if(buff[i++] != '(') {
    strcpy(fd->fd_Function,"Syntax error in function definition !");
    return(0);
  }

  j = i;

  numargs = buff[i] != ')' ? 1 : 0;

  while(buff[i] && buff[i] != ')') {
    if(buff[i] == ',') {
      j = ++i;
      numargs++;
    }
    else i++;
  }
  
  if(numargs)
    fd->fd_IsTagFunc = IsTagFunc(fd,buff+j,i-j);
  else
    fd->fd_IsTagFunc = FALSE;

  i++;

  if(buff[i++] != '(') {
    strcpy(fd->fd_Function,"Syntax error in function definition !");
    return(0);
  }

  if(buff[i] == ')') {
    fd->fd_NumParams = 0;
    i++;
  }
  else {
    for(j = 0;j < 14;j++) {
      switch(buff[i++]) {
        case 'D':
        case 'd':
          if(!isdreg(buff[i])) {
            strcpy(fd->fd_Function,"Syntax error in function definition !");
            return(0);
          }
          fd->fd_Parameter[j] = REG_D(buff[i]-'0');
          break;
        case 'A':
        case 'a':
          if(!isareg(buff[i])) {
            strcpy(fd->fd_Function,"Syntax error in function definition !");
            return(0);
          }
          fd->fd_Parameter[j] = REG_A(buff[i]-'0');
          break;  
        default:
          strcpy(fd->fd_Function,"Syntax error in function definition !");
          return(0);
      } 
  
      if(regs & (1 << fd->fd_Parameter[j])) {
        strcpy(fd->fd_Function,"Register used twice in function definition !");
        return(0);
      } 
 
      regs |= (1 << fd->fd_Parameter[j]);

      i++;

      switch(buff[i++]) {
        case ',':
        case '/':
          break;
        case ')':
          goto ct;
        default:
          strcpy(fd->fd_Function,"Syntax error in function definition !");
          return(0);
      }
    }

ct:
    if(j == 14) {
      strcpy(fd->fd_Function,"Function has too many arguments !");
      return(0);
    }

    fd->fd_NumParams = j + 1;
    if(fd->fd_NumParams != numargs) {
      strcpy(fd->fd_Function,"Wrong number of registers specified !");
      return(0);
    }
  }

  while(buff[i] == ' ' || buff[i] == '\t') i++;

  if(buff[i]) {
    strcpy(fd->fd_Function,"Syntax error in function definition !");
    return(0);
  }

  if(fd->fd_State & FD_BIAS) fd->fd_State &= ~FD_BIAS;
  else fd->fd_Offset -= 6;

  return(!0);
}

int ParseFD(struct fd *fd)

{
  int c,i;

  for(;;) {
    c = FGetC(fd->fd_Input);

    switch(c) {
      case '*':
        i = 0;
        do {
          fd->fd_Function[i++] = c;
          c = FGetC(fd->fd_Input);
        } while(i < IDLEN-1 && c != '\n' && c != EOF);
        if(c == EOF) {
          strcpy(fd->fd_Function,"Unexpected end of fd-file !");
          return(FD_ERROR);
        }
        if(c != '\n') {
          strcpy(fd->fd_Function,"Comment too long !");
          return(FD_ERROR);
        }
        fd->fd_Function[i] = '\0';
        return(FD_COMMENT);
      case ' ':
      case '\t':
        while((c = FGetC(fd->fd_Input)) == ' ' || c == '\t');
        if(c != '\n') {
          strcpy(fd->fd_Function,"Syntax error in fd-file !");
          return(FD_ERROR);
        }
      case '\n':
        break;
      case EOF:
        strcpy(fd->fd_Function,"Unexpected end of fd-file !");
        return(FD_ERROR);
      case '#':
        c = FGetC(fd->fd_Input);
        if(c != '#') {
          strcpy(fd->fd_Function,"Syntax error in keyword !");
          return(FD_ERROR);
        }
        i = 0;
        while((c = FGetC(fd->fd_Input)) != EOF && c != '\n' && i < BUFFLEN) 
          buff[i++] = c;
        buff[i] = 0;
        if(!keyword(fd)) return(FD_ERROR);
        if(c == EOF && 
           (!(fd->fd_State&FD_READY) || !(fd->fd_BaseName[0]))) {
          strcpy(fd->fd_Function,"Unexpected end of fd-file !");
          return(FD_ERROR);
        }
        return(FD_KEYWORD);
      default:
        if(c < 32) {     
          strcpy(fd->fd_Function,"Illegal character in fd-file !");
          return(FD_ERROR);
        }
        buff[0] = c;
        i = 1;
        while((c = FGetC(fd->fd_Input)) != EOF && c != '\n' && i < BUFFLEN)
          buff[i++] = c;
        buff[i] = 0;
        if(c == EOF) {
          strcpy(fd->fd_Function,"Unexpected end of fd-file !");
          return(FD_ERROR);
        }
        if(!function(fd)) return(FD_ERROR);
        return(FD_FUNCTION);
    }
  }
}
