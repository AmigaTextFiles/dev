This is the change file for CWEB's mCOMMON on the Amiga
(Contributed by Thomas Öllinger, April 1996)

With SAS 6.0 and up, use compilation switches
Code=far Data=far def=CWEBINPUTS=<input_dir>

@x
@<Other...@>= int phase; /* which phase are we in? */
@y
@<Other...@>= int phase; /* which phase are we in? */
extern int __buffsize = 8192;     /* Buffer size for level 2 I/O operations on Amiga */
@z

@x section 69
An omitted change file argument means that |"/dev/null"| should be used,
@y
An omitted change file argument means that |"nil:"| should be used,
@z

@x section 70
  if (found_change<=0) strcpy(change_file_name,"/dev/null");
@y
  if (found_change<=0) strcpy(change_file_name,"nil:");
@z
