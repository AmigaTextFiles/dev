/*
 * mangle.cpp - Removes ALL comments and/or formatting from C/C++ code while
 *              keeping what is needed so that the program still operates
 *              the same exact way as before the conversion.
 *
 * This program has been vigourously tested, if you find any logic errors
 * where something should have been taken out that wasn't, please email me
 * - jnewman@oplnk.net
 *
 */

#include "main.h"
#define CLASS_ERROR_PRE "dformat"

dformat::dformat(int a, char** av)
{
  ready=true; // We're ok unless otherwise changed
  current_arg=1; // Start at argument 1
  current_file=0;
  argc=a; argv=av;


  if(!load_arguments("-x")) cerr << "Programmer goofed, you should not see this. Error clearing out arguments." << endl;
  test_args=true; // Lets make sure the arg syntax is good first
  while(next()) ;

#ifdef DEBUG
  cerr << CLASS_ERROR_PRE << "::dformat() argument syntax ok." << endl;
#endif

  current_arg=1;
  io.done(test_args);
  test_args=false;
  // Clear out the settings
  if(!load_arguments("-x")) cerr << "Programmer goofed, you should not see this. Error clearing out arguments." << endl;
};

dformat::~dformat() {};

bool dformat::next()
{
  char temp[FILE_NAME_LENGTH]={"\0"};

  if(!ready) // Can't work if I'm not ready.
    return false;

#ifdef DEBUG
  if(test_args)
    cerr << CLASS_ERROR_PRE << "::next() testing argument ["
	 << argv[current_arg] << "]" << endl;
#endif

  if(current_arg<argc)
  {
    if(argv[current_arg][0]=='-') // we have args waiting
    {
      if((current_arg+1)<argc || argv[current_arg][1]=='v')
      {
	// load args and move to next
	if(!load_arguments(argv[current_arg++]))
	{
	  usage();
	  return false;
	}
      }
      else
      {
#ifdef DEBUG
	cerr << CLASS_ERROR_PRE << "::next() Argument included without a file." << endl;
#endif
	ready=false;
	usage();
	return false;
      }
    }

    io.done(test_args); // Finish it off if needed.

    if(io.write_over_original==true)
      io.init(argv[current_arg],argv[current_arg]);
    else
    {
      strcpy(temp,argv[current_arg]);
      strcat(temp,DEFAULT_MANGLED_POSTFIX);
      io.init(argv[current_arg],temp);
    }
    if(!io.ok())
    {
      cerr << CLASS_ERROR_PRE << "::next() io object not ok." << endl;
      ready=false;
      return false;
    }
    current_arg++; // Done messing with this one, move to next
  }
  else if(argc==1) // tisk tisk...you need atleast 2 arguments
  {
    usage();
    ready=false;
    return false;
  }
  else
    return false;

  if(!test_args)
    current_file++;

  return true; // all is good
};

void dformat::done()
{
  if(append_newline)
    io.out('\n');

  if(!tabular_result)
  {
    cerr << "[" << current_file << "] \"" << io.i_name << "\" (" << io.input_bytes() << "b) ";
    if(io.write_over_original)
      cerr << "<< " << io.output_bytes() << "b (" << (100.0-(100.0*(io.output_bytes()/io.input_bytes()))) << "% reduced)";
    else
      cerr << ">> \"" << io.o_name << "\" (" << io.output_bytes() << "b) (" << (100.0-(100.0*(io.output_bytes()/io.input_bytes()))) << "% reduced)";
    cerr << endl;
  }
  else // print in tabular form
    cerr << current_file
         << "\t" << io.i_name
         << "\t" << io.o_name
         << "\t" << io.input_bytes()
         << "\t" << io.output_bytes()
         << "\t" << (100.0-(100.0*(io.output_bytes()/io.input_bytes())))
         << endl;

  io.done();
};

void dformat::usage()
{
  cerr << "Usage: " << NAME << " <options> [file1] <options> <file2> <etc>"
       << endl << "       -r            Leave CR/LF's"
       << endl << "       -c            Remove only comments (negates all others)"
       << endl << "       -o            output to STDOUT"
       << endl << "       -n            Append newline"
       << endl << "       -x            Null out options"
       << endl << "       -d            Leave in preprocessor whitespace"
       << endl << "       -w            Write over original"
//       << endl << "       -i            input from STDIN"
       << endl << "       -l            Do no mangling"
       << endl << "       -t            Print summary in tabular form"
       << endl << "       -v            Print version"
       << endl;
}

bool dformat::ok()
{
  return (ready ? true : false);
};

bool dformat::load_arguments(char* str)
{
  if(strlen(str)==0)
    return false;

  for(int x=1; x<strlen(str); x++)
  {
    switch(str[x])
    {
      case 'x':
	io.write_over_original=false;
	io.input_from_stdin=false;
	io.output_to_stdout=false;
        append_newline=false;
        comments_only=false;
        keep_preprocessor_whitespace=false;
        tabular_result=false;
        leave_newline=false;
        no_modify=false;
	break;

      case 'w':
	io.write_over_original=true;
	break;

      case 'n':
        append_newline=true;
        break;

      case 'r':
        leave_newline=true;
        break;

      case 'c':
        keep_preprocessor_whitespace=false;
        leave_newline=false;
        no_modify=false;
        comments_only=true;
        break;

      case 'd':
        keep_preprocessor_whitespace=true;
        break;

      case 't':
        tabular_result=true;
        break;

      case 'v':
        version();
        exit(0);
        break;

      case 'l':
        no_modify=true;
        break;

      case 'o':
        io.output_to_stdout=true;
        break;

//      case 'i':
//        io.input_from_stdin=true;
//        break;

      default: // Unknown option
	usage();
	return false;
	break;
    }
  }
  return true;
};

// And now...the meat and potatos
bool dformat::format()
{
#ifdef DEBUG
  cerr << CLASS_ERROR_PRE << "::format() Now formatting [" << io.i_name << "]"
       << endl;
#endif

// Reset the variables
in_single_quote=false; in_double_quote=false; in_line_comment=false;
in_star_comment=false; in_preprocessor=false;

// keep grabbing data as long as its there
while(io.in() && (io.buf[0]+io.buf[1]+io.buf[2]))
{
  if(no_modify)
  {
    io.out();
    continue;
  }

  switch(io.buf[0])
  {
    case '\'':
    case '\"':
      if(!in_line_comment && !in_star_comment)
      {
	if(!in_single_quote && !in_double_quote)
	{
	  if(io.buf[0]=='\'')
	    in_single_quote=true;
	  else if(io.buf[0]=='\"')
	    in_double_quote=true;
	}
	else if(in_single_quote || in_double_quote)
	{
	  if(io.last_written[2]=='\\' && io.last_written[1]!='\\') /*just an escaped quote*/;
	  else
	  {
	    if(io.buf[0]=='\'' && in_single_quote)
	      in_single_quote=false;
	    if(io.buf[0]=='\"' && in_double_quote)
	      in_double_quote=false;
	  }
	}
	io.out();
      }
      break;

    case '/':
      if(!in_single_quote && !in_double_quote)
      {
	if(io.buf[1]=='/' && !in_line_comment)
	  in_line_comment=true;
	else if(io.buf[1]=='*' && !in_star_comment)
	  in_star_comment=true;
	else if(!in_line_comment && !in_star_comment)
	  io.out();
      }
      else
	io.out();
      break;

    case '*':
      if(!in_single_quote && !in_double_quote)
      {
	if(io.buf[1]=='/' && in_star_comment)
	{
	  in_star_comment=false;
	  io.in(); // Jump ahead one, we dont want the '/' used
	  continue;
	}
	else if(!in_star_comment)
	  io.out();
      }
      else
	io.out();
      break;

    case '#':
      if(!in_line_comment && !in_star_comment)
      {
	if(!in_single_quote && !in_double_quote)
	  in_preprocessor=true;
	io.out();
      }
      break;

    case '\n':
    case '\r':
      if(!in_star_comment)
      {
	if((((is_letter(io.last_written[2]) || is_number(io.last_written[2]) || io.last_written[2]=='_') &&
	    (is_letter(io.buf[1]) || is_number(io.buf[1]) || io.buf[1]=='_'))
	   || in_preprocessor || io.buf[1]=='#') && !in_single_quote &&
              !in_double_quote && !comments_only)
	{
	  if(in_preprocessor)
	  {
	    if(io.last_written[2]!='\\') // make sure its not multi-line
	      in_preprocessor=false;
	    io.out();
	  }
	  else if(io.buf[1]=='#')
	  {
	    if(io.last_written[2]!='\0' && (io.last_written[2]!='\r' && io.last_written[2]!='\n'))
	      io.out();
	  }
	  else
	    io.out(' ');
	}
        else if(comments_only && !in_line_comment)
          io.out();
        else if(leave_newline)
          io.out();
        else if(in_single_quote || in_double_quote)
          io.out();

	if(in_line_comment)
        {
          if(comments_only && (io.last_written[2]!='\r' || io.last_written[2]!='\n'))
            io.out();
          in_line_comment=false;
        }
      }
      break;

    case ' ':
    case '\t':
      if(!in_line_comment && !in_star_comment)
      {
	if(in_single_quote || in_double_quote || comments_only) // the only cases where we always output all of them
	  io.out();
	else if(in_preprocessor)
	{
	  if((!is_whitespace(io.last_written[2]) && !is_whitespace(io.buf[1]))
             || keep_preprocessor_whitespace)
	    io.out();
	}
	else
	{
	  if((!is_whitespace(io.last_written[2]) && (is_letter(io.last_written[2])
		|| io.last_written[2]=='_') || is_number(io.last_written[2]))
	     &&
	     (!is_whitespace(io.buf[1]) && (is_letter(io.buf[1])
		|| io.buf[1]=='_') || is_number(io.buf[1])) )
	    io.out();
	}
      } 
      break;

    default:
      if(!in_line_comment && !in_star_comment)
      {
	if((in_single_quote || in_double_quote) && io.buf[0]=='\\' &&
	    (io.buf[1]=='\n' || io.buf[1]=='\r') && !comments_only)
	  io.in(); // skip over newline
	else
	  io.out();
      }
      break;
  }
}

return true;
}

void dformat::version()
{
  cerr << NAME << " v" << VERSION
#ifdef BETA
       << "b"
#endif
       << " by Jon Newman (jnewman@oplnk.net)" << endl
       << "Please report all bugs." << endl;
};
