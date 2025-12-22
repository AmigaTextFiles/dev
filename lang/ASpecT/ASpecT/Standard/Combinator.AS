{
 ==
 == Combinators
 == Version 2.0 (18.12.1992, JvH)
 ==
}

SPEC Combinator =

  Combinator1 +  { id, cond, if_then_else, fixp                }
  Combinator2 +  { k, ck, w, y, const                          }
  Combinator3 +  { b, c, s, (*), (;), curry, uncurry, converse }
  Combinator4 +  { c_, b_, s_, (**)                            }


END.
