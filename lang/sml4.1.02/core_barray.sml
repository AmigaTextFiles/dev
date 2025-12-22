(* RJG - for loading into smlcore *)

 (* Diags *)
(*    local val {StdOut, ...} = CurrentState()
    in    fun PStr str = Writestream(StdOut, str)
          fun PInt int = PStr((makestring:int->string) int)
    end
*)
    exception Range

local
   nonfix bytearray_create 160 1;
   nonfix store_byte 230 3;
   nonfix fetch_byte 226 2;
   nonfix extract_ 101 3; 
in
    abstype bytearray = BA of string
    with

local
    type ba_repr = string		(* the representation *)
    fun bytearray_create(n: int): ba_repr = bytearray_create(n);
    fun store_byte(x:int,y:ba_repr,z:int):unit = store_byte(x,y,z)
    fun fetch_byte(x:int,y:ba_repr):int = fetch_byte(x,y)
    fun extract_(x: ba_repr, y: int, z: int) = extract_(x, y, z)
in
    fun bArray(size, initval): bytearray =
      if initval < 0 orelse initval > 255 then raise Range
      else if size < 0 then raise Subscript
      else let val newarr = bytearray_create(size) 
            fun initarr index = 
              if index >= size then newarr
              else ( store_byte(initval,newarr,index); initarr(index+1) ) 
         in BA(initarr 0) end

    fun bUpdate(BA ba: bytearray, pos: int, value: int): unit =
      if pos < 0 orelse pos >= (size ba) then raise Subscript
      else if value < 0 orelse value > 255 then raise Range
      else store_byte(value,ba,pos);

    fun bLength(BA ba) = size ba

    infix bSub
    fun (BA ba) bSub (pos: int): int =
      if pos < 0 orelse pos >= (size ba) then raise Subscript
      else fetch_byte(pos,ba)

(*    fun extract(BA x,y,z) =
       extract_(x,y+1,z) handle Substring => raise Subscript*)

    fun bApp f (BA ba) = 
      let val len = size ba
          fun app'(i) = 
            if i >= len then ()
            else (f(fetch_byte(i,ba)); app'(i+1))
       in app'(0) end;

    fun bRevapp f (BA ba) = 
      let fun revapp'(i) = 
            if i < 0 then ()
            else (f(fetch_byte(i,ba)); revapp'(i-1))
       in revapp'(size ba-1) end;

    fun bFold f (BA ba) x =
      let fun fold'(i,x) = 
          if i < 0 then x else fold'(i-1,f(fetch_byte(i,ba),x))
       in fold'(size ba-1, x) end;

    fun bRevfold f (BA ba) x = 
      let val len = size ba
          fun revfold'(i,x) =
            if i >= len then x else revfold'(i+1,f(fetch_byte(i,ba),x))
       in revfold'(0,x) end
    end (*local*)
   end   (* abstype *)
end; (* local *)