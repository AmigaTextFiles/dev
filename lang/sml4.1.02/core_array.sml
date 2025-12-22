(* RJG - for loading into smlcore *)
    nonfix Array_array 103 2;
    infix  3 Array_sub 9 2;
    nonfix Array_update 25 3; 
    nonfix Array_length 104 1; 
    nonfix Array_arrayoflist 121 1;

    fun Array_array(n:int, init: '_weak): '_weak array = Array_array(n,init)

    fun (x: 'a array) Array_sub (y:int) = (x Array_sub y): 'a
    fun Array_update(x: 'a array, y:int, z: 'a):unit = Array_update(x,y,z)
    fun Array_arrayoflist(x: '_weak list): '_weak array = Array_arrayoflist(x);
    fun Array_length(x: 'a array):int = Array_length(x);
