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
#define CLASS_ERROR_PRE "io"

io::io(char* in, char* out, bool testing=false)
{
  file_open=false;
  first_init=true;
  init(in,out,testing);
};

io::io()
{
  file_open=false;
  first_init=true;
  ready=false; // We didn't init a file, so we're not ready
};

io::~io() // Done, just take care of the files
{
  i.close();
  o.close();
};

// Initialize variables and set everything up for a new file
void io::init(char* in, char* out, bool testing=false)
{
  if(file_open) // dumbo didn't call done()
    done(testing);

  ready=true; // we are ready unless otherwise changed

  // (re)init variables
  for(int x=0; x<BUF_LENGTH; x++)
    buf[x]='\0';
  for(int x=0; x<FILE_NAME_LENGTH; x++)
  { o_name[x]='\0'; i_name[x]='\0'; }
  for(int x=0; x<LAST_WRITTEN_LENGTH; x++)
  { last_written[x]='\0'; }
  icounter=0.0; ocounter=0.0;
  if(first_init) // only on first init set global_counter to 0.0
  {
    first_init=false;
    iglobal_counter=0.0;
    oglobal_counter=0.0;
  }
  last_read='\0'; input_line=0; input_column=0;
  output_line=0; output_column=0;

  if(!input_from_stdin)
  {
    i.open(in);
    if(!i)
    {
      ready=false;
      cerr << "Could not open (input) [" << in << "]" << endl;
    }
#ifdef DEBUG
    else
      cerr << CLASS_ERROR_PRE << "::init() Opened (input) ["
	   << in << "]" << endl;
#endif
  }
  else
    input_from_stdin=true;

  if(!output_to_stdout)
  {
    if(!strcmp(out,in))
    {
      o.open(DEFAULT_MANGLED_POSTFIX);
      strcpy(o_name,DEFAULT_MANGLED_POSTFIX);
      write_over_original=true;
    }
    else
      write_over_original=false;

    if(!write_over_original)
      o.open(out);
    if(!o)
    {
      ready=false;
      cerr << CLASS_ERROR_PRE << "::init() Could not open (output) \""
	   << out << "\"" << endl;
    }
  }
  else
    output_to_stdout=true;

  strcpy(i_name,in);
  if(output_to_stdout)
    strcpy(o_name,"");
  else
    strcpy(o_name,out);

  file_open=true;
};

void io::done(bool testing=false)
{
  if(!file_open) // your calling me without a open file?
    return;

  if(write_over_original && !testing && !output_to_stdout) // we need to write over the orig
  {
#ifdef DEBUG
    cerr << CLASS_ERROR_PRE << "::init() Writing over original." << endl;
#endif

    if(!move(o_name,i_name))
#ifdef DEBUG
      cerr << CLASS_ERROR_PRE << "::init() Error writing over original." << endl
#endif
      ;
  }

  // close the files
  if(!input_from_stdin)
    i.close();
  if(!output_to_stdout)
    o.close();
  file_open=false;
}

int io::get_input_line()
{
  return input_line;
}

int io::get_input_column()
{
  return input_column;
}

int io::get_output_line()
{
  return output_line;
}

int io::get_output_column()
{
  return output_column;
}

// Get data
int io::in()
{
  last_read=buf[0];
  buf[0]=buf[1];
  buf[1]=buf[2];

  if(!input_from_stdin)
  {
    if(!i.eof())
      i.get(buf[2]); // get the next char
    if(i.eof())
      buf[2]='\0';
  }
  else
    cin.get(buf[2]);

#ifdef IODEBUG
    if(!i.eof())
      cout << i_name << " >> \"" << buf[2] << "\"" << endl;
    else
      cout << CLASS_ERROR_PRE << "::in() " << i_name << " [EOF] " << buf[2] << endl;
#endif

  if(buf[0]=='\n' || buf[0]=='\r')
  {
    input_column=0;
    input_line++;
  }
  else
    input_column++;

  if(buf[2]!='\0')
  {
    icounter++;
    iglobal_counter++;
  }

  return 1;
};

// Output data
void io::out(char c='\0')
{
  if(!c) // replace '\0' with the value of buf[0]
    c=buf[0];
  if(c) // Make sure we have something to spit
  {
    if(output_to_stdout)
      cout << c;
    else
      o << c;
  }

#ifdef IODEBUG
    cout << o_name << " << \"" << c << "\"" << endl;
#endif

  if(c=='\n' || c=='\r') // new line, return column to 0
  {
    output_line++;
    output_column=0;
  }
  else
    output_column++;

  if(c!='\0')
  {
    // keep track of sizes
    ocounter++; // this file
    oglobal_counter++; // all the files
  }

  last_written[0]=last_written[1];
  last_written[1]=last_written[2];
  last_written[2]=c;
};

bool io::ok()
{
  return (ready ? true : false);
};

double io::input_bytes()
{
  return icounter;
};

double io::output_bytes()
{
  return ocounter;
};

double io::global_input_bytes()
{
  return iglobal_counter;
};

double io::global_output_bytes()
{
  return oglobal_counter;
};
