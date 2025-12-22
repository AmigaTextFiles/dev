{
 ==
 == special StreamIO (user defined inStream)
 == Version 1.0 (27.12.1992, JvH)
 ==
}

SPEC SpecStreamIO =

 FORMAL

  SORTS data.


 GLOBAL

  StreamIO +

{ == A special user-definable operation can be converted into an inStream }
{ == It has the general form 'data -> (boolean,char,data)'. An initial    }
{ == value is given and the function is called successively while the     }
{ == inStream is read (note: no memoizing takes place in this version!)   }
{ == Refer e.g. RandomStream to see a typical usage of such a stream.     }

  OPNS EXTERN special_stream :: data -> (data -> (boolean,char,data))
                             -> inStream.


END.
