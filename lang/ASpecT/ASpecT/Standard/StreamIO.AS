{
 ==
 == StreamIO (basic stream operations)
 == Version 1.0 (26.12.1992, JvH)
 ==
}

SPEC StreamIO =

 String +


{ == An inStream is a datastructure "containing" a sequence of characters }
{ == One can get these characters one after the other by an operation.    }
{ ==  A matching (e.g. as a list) is (currently) not possible.            }
{ == Such inStreams are typically used to read the contents of a file or  }
{ ==  get characters from the standard input (e.g. keyboard).             }
{ == The implementation of inStream makes it referential transparent      }
{ ==  which means that unlike 'system' an 'inStream' may be duplicated    }
{ ==  without problems and thus allowing backtracking.                    }

  SORTS EXTERN inStream.


{ == the standard input; this operation can only be called if there is no }
{ == previous stdin-inStream "in use"                                     }

  OPNS EXTERN stdin :: system -> (boolean,inStream,system).


{ == open a file (given by the name) for reading                          }

  OPNS EXTERN open :: string -> system -> (boolean,inStream,system).


{ == convert a string to an inStream                                      }

  OPNS EXTERN inStream :: string -> inStream.


{ == and vice versa                                                       }

  OPNS EXTERN string :: inStream -> string.


{ == the basic read operation on inStream; it delivers false (and '\0')   }
{ == if no more chars (e.g. EOF) can be read from inStream                }

  OPNS EXTERN char :: inStream -> (boolean,char,inStream).


{ == determine how many chars have been read until now                    }

  OPNS EXTERN chars :: inStream -> integer.


{ == An outStream is comparable to an inStream a datastructure on which   }
{ == characters an strings can be written and re-read if the outStream    }
{ == is converted to and inStream. Such streams are typically used to     }
{ == output data into a file or on the standard output (e.g. screen).     }
{ == There are two kinds of outStreams.                                   }

{ == The DIRECT outstream (doutStream) is a 'direct link' to the file the }
{ ==  output should go to. This is a more 'imperative' but on the other   }
{ ==  hand more efficient method. To have at least some control it is not }
{ ==  allowed to work with (write on) copies of doutStream. This would    }
{ ==  result in an fatal runtime error. A programmer should use this kind }
{ ==  of stream with great care; always having in mind that the surrounded}
{ ==  environment is assumed (compiler) to be referential transparent.    }

  SORTS EXTERN doutStream.


{ == an outStream which goes directly to stdout; this operation can only  }
{ == be called successfully (true) if there is no previous stdout         }
{ == doutStream "in use". Otherwise (false) it delivers an doutstream     }
{ == which has no effect at all.                                          }

  OPNS EXTERN stdout :: system -> (boolean,doutStream,system).


{ == an doutStream which goes directly to a new file (this will overwrite)}
{ == This operation may result in unpredictable problems if the same file }
{ == is accessed twice since we are not able to check this yet            }

  OPNS EXTERN create :: string -> system -> (boolean,doutStream,system).


{ == an doutStream which appends directly to a file (problems as create). }

  OPNS EXTERN append :: string -> system -> (boolean,doutStream,system).


{ == the basic write operations on doutStream; it delivers false if       }
{ == the writing fails (whatever reason)                                  }

  OPNS EXTERN out :: doutStream -> char   -> (boolean,doutStream).


  OPNS EXTERN out :: doutStream -> string -> (boolean,doutStream).


{ == two similar operation for convenience are defined - they ignore any  }
{ == error occuring.                                                      }

  OPNS doutStream + char :: doutStream.
  EQNS Out + (C::char) = doutStream (out Out C).


  OPNS doutStream + string :: doutStream.
  EQNS Out + (S::string) = doutStream (out Out S).


{ == determine how many chars have been written until now                 }

  OPNS EXTERN chars :: doutStream -> integer.


{ == In contrast to 'imperative' streams a 'closing' of a doutStream      }
{ == need not to be programmed - it is done automatically by the memory   }
{ == management system if the program has no more access to it. In some   }
{ == situations the compiler would optimize the program such that some    }
{ == wanted calls are not done. In such situations use the special        }
{ == k-combinator (>>) which enforces the evaluation (Combinator2).       }


{ == The 'SAFE' outstream (outStream) is the second kind of outstreams.   }
{ ==    In contrast to the other one the directing to a specific file or  }
{ ==    other 'medium' is not given at creation time but at time of       }
{ ==    finishing up - meaning that the data which is written must be     }
{ ==    buffered in the meantime. Therefore outstreams are referentially  }
{ ==    transparent while writing data - but not while doing the final    }
{ ==    action which may of course interfere with other operations and    }
{ ==    should therefore be planned with great care.                      }

  SORTS EXTERN outStream.


{ == some initial outstream without any destination and no interferings   }
{ == with any other data and therefore referentially transparent          }

  OPNS EXTERN mt :: outStream.


{ == append the outStream to stdout                                       }

  OPNS EXTERN stdout :: outStream -> system -> (boolean,system).


{ == write the outStream to a new file (this will overwrite).             }

  OPNS EXTERN create :: string -> outStream -> system -> (boolean,system).


{ == append the outStream to a file                                       }

  OPNS EXTERN append :: string -> outStream -> system -> (boolean,system).


{ == convert outStream to string                                          }

  OPNS EXTERN string :: outStream -> string.


{ == convert outStream to inStream reading it from scratch                }

  OPNS inStream :: outStream -> inStream.
  EQNS inStream S = inStream (string S).


{ == the basic write operations on outStream; it delivers false if        }
{ == the writing fails (whatever reason)                                  }

  OPNS EXTERN out :: outStream -> char   -> (boolean,outStream).


  OPNS EXTERN out :: outStream -> string -> (boolean,outStream).


{ == two similar operation for convenience are defined - they ignore any  }
{ == error occuring.                                                      }

  OPNS outStream + char :: outStream.
  EQNS Out + (C::char) = outStream (out Out C).


  OPNS outStream + string :: outStream.
  EQNS Out + (S::string) = outStream (out Out S).


{ == determine how many chars have been written until now                 }

  OPNS EXTERN chars :: outStream -> integer.


END.
