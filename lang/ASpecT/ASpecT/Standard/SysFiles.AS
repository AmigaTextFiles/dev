{
 ==
 == Operations on files
 == Version 1.0 (3.1.1993, JvH)
 ==
}
SPEC SysFiles =

  String +


{ == removing a file                                                       }

  OPNS EXTERN deletefile :: string -> system -> (boolean,system).


{ == existence of a file                                                   }

  OPNS EXTERN existfile :: string -> system -> (boolean,system).


{ == examine a directory (special file) ...                                }

  SORTS EXTERN directory.


{ == which may contain the following kinds of files                        }

  SORTS filetype ::= unknown  | { something unknown  }
                     dir      | { another directory  }
                     file     | { some ordinary file }
                     blockdev | { a block device     }
                     chardev  | { a character device }
                     symlink  | { a symbolic link    }
                     socket.    { a socket           }

{ == load a directory with a given name (path)                             }

  OPNS EXTERN getdir :: system -> string -> (boolean, directory, system).


{ == get 'head' and 'tail' of a directory                                  }
{ ==  an entry is the name, the length and the filetype                    }

  OPNS EXTERN hd :: directory 
                 -> (boolean, (string, integer, filetype), directory).


END.
