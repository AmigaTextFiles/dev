#include <stdio.h>

#ifndef ENABLE_NLS
  #ifdef DEUTSCH
    #define LANGUAGE_STRING "DEUTSCH"
    #undef DEUTSCH
    #define DEUTSCH 1
  #endif
  #ifdef ENGLISH
    #define LANGUAGE_STRING "ENGLISH"
    #undef ENGLISH
    #define ENGLISH 1
  #endif
  #ifdef FRANCAIS
    #define LANGUAGE_STRING "FRANCAIS"
    #undef FRANCAIS
    #define FRANCAIS
  #endif
  #if (DEUTSCH+ENGLISH+FRANCAIS  == 1)
    #define LANGUAGE_STATIC
  #endif
#endif

/* 
# States (waiting means printing too)
# 0:  copying until newline
# 1:  copying spaces until / state=2 or newline state=0
# 2:  check for second /, else print "/", ch, and state=0
# 3:  check for #, else print "//", ch, and state=0
# 4:  eating until non-space
# 5:  read until space into language string
# 6:  eating spaces until "
# 7:  read until " (unless previous character was \)
# 8:  print string if non-NLS and update #line, else print newline
# 9:  #endif `e' or #line `l'
# 10: #endif `n'
# 11: #endif `d'
# 12: #endif 'i'
# 13: #endif 'f'
# 14: print #endif, swallow rest of line and update #line
# 15: #line `i'
# 16: #line `n'
# 17: #line `e'
# 18: reset line number
*/

int line_no;

int getch()
{
  int ch;
  ch=getchar();
  if (ch=='\n') line_no++;
  return ch;
}

int main()
{
  int state = 1;
  int ch,last_ch='\n';
  int language_string_pos = -1;
  int message_string_pos = -1;
  int number_string_pos = -1;
  int msg_line_no = -1;
  char language_string[20];
  char message_string[1024];

  line_no=1;
  for (;(ch=getch())!=EOF;last_ch=ch)
    {
      switch(state)
        {
        case 0:
          if (ch=='\n')
            state=1;
          putchar(ch);
          break;
        case 1:
          switch (ch)
            {
            case '/':
              msg_line_no=line_no;
              state=2;
              break;
#if !defined(ENABLE_NLS) && !defined(LANGUAGE_STATIC)
            case '#':
              state=9;
              break;
#endif
            default:
              putchar(ch);
              if (ch!=' ' && ch!='\n')
                state=0;
            }
          break;
        case 2:
          if (ch=='/')
            state=3;
          else
            {
              putchar('/');
              putchar(ch);
              state=0;
            }
          break;
        case 3:
          if (ch==':')
            state=4;
          else
            {
              putchar('/');
              putchar('/');
              putchar(ch);
              state=0;
            }
          break;
        case 4:
          if (ch != ' ')
            {
              state=5;
              language_string[0]=ch;
              language_string_pos=1;
            }
          break;
        case 5:
          if (ch != ' ')
            language_string[language_string_pos++]=ch;
          else
            state=6;
          break;
        case 6:
          if (ch == '"')
            {
              state=7;
              language_string[language_string_pos]='\0';
              message_string_pos=0;
            }
          break;
        case 7:
          if (ch == '"' && last_ch != '\\')
            state=8;
          else
            message_string[message_string_pos++]=ch;
          break;
        case 8:
          #ifdef ENABLE_NLS
          putchar('\n');
          #else
            #ifdef LANGUAGE_STATIC
            if (strcmp(language_string,LANGUAGE_STRING)==0)
            #endif
              {
                message_string[message_string_pos]='\0';
                printf("#undef %s_MSG\n",language_string);
                printf("#define %s_MSG \"%s\"\n",
                       language_string,message_string);
                #ifndef LANGUAGE_STATIC
                printf("#line %d\n",msg_line_no);
                #else 
                putchar('\n');
                #endif
              }
            #ifdef LANGUAGE_STATIC
            else fputs("\n\n\n",stdout);
            #endif
          #endif
          do
            {
              if (ch=='\n') break;
            } while((ch=getch())!=EOF);
          state=1;
          break;
        #if !defined(ENABLE_NLS) && !defined(LANGUAGE_STATIC)
        case 9:
          switch (ch)
            {
            case 'e':
              state=10;
              break;
            case 'l':
              state=15;
              break;
            default:
              putchar('#');
              putchar(ch);
              state=0;
            }
          break;
        case 10:
          if (ch=='n')
            state=11;
          else
            {
              putchar('#'); putchar('e');
              putchar(ch);
              state=0;
            }
          break;
        case 11:
          if (ch=='d')
            state=12;
          else
            { 
              fputs("#en",stdout);
              putchar(ch);
              state=0;
            }
          break;
        case 12:
          if (ch=='i')
            state=13;
          else
            {
              fputs("#end",stdout);
              putchar(ch);
              state=0;
            }
          break;
        case 13:
          if (ch=='f')
            state=14;
          else
            {
              fputs("#endi",stdout);
              putchar(ch);
              state=0;
            }
          break;
        case 14:
          fputs("#endif",stdout);
          if (ch == '\n' || ch==' ')
            {
              do
                {
                  putchar(ch);
                  if (ch=='\n') break;
                } while((ch=getch())!=EOF);
              printf("#line %d\n",line_no-1);
              state=1;
            }
          else state=0;
          break;
        case 15:
          if (ch=='i')
            state=16;
          else
            {
              fputs("#l",stdout);
              putchar(ch);
              state=0;
            }
          break;
        case 16:
          if (ch == 'n')
            state=17;
          else
            {
              fputs("#li",stdout);
              putchar(ch);
              state=0;
            }
          break;
        case 17:
          if (ch == 'e')
            state=18;
          else
            {
              fputs("#lin",stdout);
              putchar(ch);
              state=0;
            }
          break;
        case 18:
          while (ch == ' ' && ch != EOF) { ch=getch(); }
          { 
            int val=0;
            while (ch >= '0' && ch <= '9' && ch != EOF)
              { 
                val*=10;
                val+=(ch - '0');
                ch=getch();
              }
            while (ch == ' ' && ch != '\n' && ch != EOF) ch=getch();
            if (ch == '"')
              { char filename[80];
                int filename_pos=0;
                while ((ch=getch())!=EOF)
                  {
                    if (ch == '"') break;
                    filename[filename_pos++]=ch;
                  }
                filename[filename_pos]='\0';
                printf("#line %d \"%s\"\n",val,filename);
              }
            while (ch != '\n' && ch != EOF) ch=getch();
            line_no = val;
            state=1;
          }
          break;
        #endif
        }
    }
  exit(0);
}
