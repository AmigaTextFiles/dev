This is the change file for mCWEB's mCWEAVE on the Amiga
(Contributed by Thomas Öllinger, April 1996)

With SAS 6.0, use compilation switches Code=far Data=far.

@x
extern int strcmp(); /* compare strings lexicographically */
@y
extern int strcmp(); /* compare strings lexicographically */
extern int stricmp();
@z

@x
@<Global...@>=
boolean change_exists; /* has any section changed? */
@y
@<Global...@>=
char *version_tag="\0$VER: mCWEAVE 1.1 (4.10.98)";
boolean change_exists; /* has any section changed? */
@z

@x
  return(a);
@y
  return((eight_bits)a);
@z

@x
      if(*ref->book_name && strcmp(ref->book_name,book_name)) {
@y
      if(*ref->book_name && stricmp(ref->book_name,book_name)) {
@z

@x
@d is_absolute_path(file_name) (*(file_name)==file_name_separator)
@y
@d is_absolute_path(file_name) (strchr(file_name,':'))
@z

@x
@d include_dir_separator ':'
@y
@d include_dir_separator ','
@z

@x
  strcpy(change_file_name,"/dev/null");
@y
  strcpy(change_file_name,"nil:");
@z
