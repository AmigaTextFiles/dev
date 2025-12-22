/*
 * gensymtab-0.1
 * by megacz
 *
 * Proper  input file can be  generated  with  'nm' that is a part of
 * 'binutils'. To generate compatible input file type this:
 *
 *    nm -f bsd -C libmylib.a >libmylib.nm
 *       ^^^^^^^^^
 *       a must-be
 *
 *
 * Then to  generate  symbol table that can be used through the 'qdev'
 * debugging facility(that depends on 'gcc') type this:
 *
 *    gensymtab libmylib libmylib.nm -n -s                           \
 *              "-e __gnu_compiled_c,gcc2_compiled.,txt_debugprintf, \
 *                                txt_vcbpsnprintf,___mem_dbfindsym, \
 *                __cyg_profile_func_enter, __cyg_profile_func_exit" \
 *                                                       >libmylib.h
 *              ^^^^^^^^
 *              name
 *              of the
 *              table
 *
 *
 * A structure like this(defined in 'qdev' header) is needed to do ops
 * on the table:
 *
 *    struct qdevdbsymtab
 *    {
 *      void *st_addr;             // Symbol address
 *      char *st_name;             // Symbol name
 *      char *st_file;             // Symbol file
 *    };
 *
 *
 * This  program  does  not output any error messages, only the return
 * code is being set.
 *
 * Drawbacks? Just one. All the objects in the library will link ;-] .
 *
 * 10-05-2011: Note! This program is now obsolete as  'qdev'  does not
 * need to lookup function names anymore.
 *
*/

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "qdev.h"
#include "qversion.h"

#define GST_READBUF     256
#define GST_NOFILE      "<unresolved>"

#define GST_F_NOSTATIC  0x00000001
#define GST_F_TABSTATIC 0x00000002



static const UBYTE ___version[] =
          "\0$VER: gensymtab 0.1 (20/06/2010) " _QV_STRING "\0";



void dumpsymbols_cb_externs(long flags,
                          FILE *output, struct qdevdbsymtab *st)
{
  if (!(flags & GST_F_NOSTATIC))
  {
    fprintf(output, "extern int %s(void);\n", st->st_name);
  }
}

void dumpsymbols_cb_struct(long flags,
                          FILE *output, struct qdevdbsymtab *st)
{
  if (!(flags & GST_F_NOSTATIC))
  {
    fprintf(output, "  {(void *)%s, \"%s\", \"%s\"},\n",
                 (char *)st->st_addr, st->st_name, st->st_file);
  }
}

int dumpsymbols(
             char *exsym, long flags, FILE *input, FILE *output,
                void (*cb)(long, FILE *, struct qdevdbsymtab *))
{
  struct qdevdbsymtab st;
  char buf[GST_READBUF];
  char fbuf[GST_READBUF];
  char *token;
  char *dtoken;
  char *cptr;
  char *endptr;
  char *excopy;
  long iflags;
  int pass;
  int type;
  int rc = 0;


  if ((excopy = malloc(strlen(exsym) + 1)))
  {
    fbuf[0] = '\0';

    strcpy(fbuf, GST_NOFILE);

    /*
     * Read the file line by line to the bottom.
    */
    while (fgets(buf, GST_READBUF, input))
    {
      iflags = 0;

      /*
       * Obtain first token, which may be an object name or an
       * address or type of object.
      */
      if ((token = strtok(buf, " ")))
      {
        /*
         * Hunt for the colon, and if found that means we have
         * object name.
        */
        if ((cptr = strchr(token, ':')))
        {
          *cptr = '\0';

          fbuf[0] = '\0';

          strcpy(fbuf, token);
        }
        else
        {
          /*
           * Check if that is a hexadecimal address.
          */
          strtol(token, &endptr, 16);

          if (!(*endptr))
          {
            /*
             * Yep, that is the address, so move to object type.
            */
            if ((token = strtok(NULL, " ")))
            {
              /*
               * K. We are interested in global symbols that are 
               * contained in the object only, but we will allow
               * statics too as stubs.
              */
              type = *token;

              if ((type == 'T') || (type == 't'))
              {
                if ((token = strtok(NULL, " ")))
                {
                  if ((cptr = strchr(token, '\n')))
                  {
                    *cptr = '\0';
                  }

                  /*
                   * Check against symbols who should be skipped.
                  */
                  pass = 1;

                  if (exsym)
                  {
                    strcpy(excopy, exsym);

                    if ((dtoken = strtok(excopy, ", ")))
                    {
                      while (dtoken)
                      {
                        if (strcmp(dtoken, token) == 0)
                        {
                          pass = 0;

                          break;
                        }

                        dtoken = strtok(NULL, ", ");
                      }
                    }
                  }

                  if (pass)
                  {
                    if (type == 'T')
                    {
                      st.st_addr = token;
                    }
                    else
                    {
                      /*
                       * This symbol is defined as static, so make
                       * a stub.
                      */
                      st.st_addr = "0xFFFFFFFF";

                      if (flags & GST_F_NOSTATIC)
                      {
                        iflags |= GST_F_NOSTATIC;
                      }
                    }

                    st.st_name = token;

                    st.st_file = fbuf;

                    cb(iflags, output, &st);

                    rc++;
                  }
                }
              }
            }
          }
        }
      }
    }

    free(excopy);
  }

  return rc;
}

int main(int argc, char **argv)
{
  char *exsym = NULL;
  FILE *file;
  int cnt;
  long flags = 0;
  int rc = 5;


  /*
   * We require two arguments one is table name and the other
   * filename. 
  */
  if (argc >= 3)
  {
    for(cnt = 3; cnt < argc; cnt++)
    {
      if(argv[cnt][0] == '-')
      {
        switch(argv[cnt][1])
        {
          /*
           * '-e' option takes an argument of comma separated
           * symbols to be discarded.
           * It can be passed after the two first arguments!
          */
          case 'e':
          {
            if ((argv[cnt][2] == ' ')  ||
                (argv[cnt][2] == '='))
            {
              exsym = &argv[cnt][3];
            }
            else
            {
              exsym = &argv[cnt][2];
            }

            break;
          }

          /*
           * '-n' option allows to eliminate static references.
           * It can be passed after the two first arguments!
          */
          case 'n':
          {
            flags |= GST_F_NOSTATIC;

            break;
          }

          /*
           * '-s' option allows to define this table as static.
           * It can be passed after the two first arguments!
          */
          case 's':
          {
            flags |= GST_F_TABSTATIC;

            break;
          }

          default:

          ;
        }
      }
    }

    if ((file = fopen(argv[2], "r")))
    {
      fprintf(stdout, 
             "/*\n"
             " * This file was generated using 'gensymtab'.\n"
             "*/\n\n"
             "#ifndef ___%s_H_INCLUDED___\n"
             "#define ___%s_H_INCLUDED___\n\n",
             argv[1], argv[1]);

      /*
       * Create external references.
      */
      rc = dumpsymbols(
            exsym, flags, file, stdout, dumpsymbols_cb_externs); 

      fprintf(stdout,
             "\n%sstruct qdevdbsymtab %s[] =\n"
             "{\n", (flags & GST_F_TABSTATIC) ? "static " : "",
             argv[1]);

      fseek(file, 0, SEEK_SET);

      /*
       * Create symbol table.
      */
      dumpsymbols(
             exsym, flags, file, stdout, dumpsymbols_cb_struct); 

      fprintf(stdout,
             "  {NULL, NULL, NULL}\n"
             "};\n\n"
             "#endif /* ___%s_H_INCLUDED___ */\n",
             argv[1]);

      fclose(file);

      rc = !rc;
    }
  }

  return rc;
}
