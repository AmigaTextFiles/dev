@x
@<Internal functions@>@;
@y
@<Prototypes@>@;
@<Internal functions@>@;
@z

@x
void get_line(i)
	file_index i;
@y
void get_line(
	file_index i)
@z

@x
void err_loc(i) /* prints location of error */
        int i;
@y
void err_loc( /* prints location of error */
        int i)
@z

@x
boolean lines_dont_match(i,j) 
	file_index i,j;
@y
boolean lines_dont_match(
	file_index i,file_index j)
@z

@x
void init_change_file(i,b)
	file_index i; boolean b;
@y
void init_change_file(
	file_index i, boolean b)
@z

@x
void put_line(j)
	file_index j;
@y
void put_line(
	file_index j)
@z

@x
boolean e_of_ch_module(i)
	file_index i;
@y
boolean e_of_ch_module(
	file_index i)
@z

@x
boolean e_of_ch_preamble(i)
	file_index i;
@y
boolean e_of_ch_preamble(
	file_index i)
@z

@x
void usage()
@y
void usage(void)
@z

@x
main(argc,argv)
        int argc; string *argv;
@y
void main(
        int argc, char **argv)
@z

@x
@* Index.
@y
@ @<Proto...@>=
void get_line(file_index);
void err_loc(int);
boolean lines_dont_match(file_index,file_index);
void init_change_file(file_index,boolean);
void put_line(file_index);
boolean e_of_ch_module(file_index);
boolean e_of_ch_preamble(file_index);
void usage(void);
void main(int,char **);

@* Index.
@z
