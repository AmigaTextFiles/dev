$lname = $ARGV[1];

@lst = <STDIN>;
chop(@lst);

printf "__shared_textdata_start_lib$lname = ___shared_lib_ptr + 1000;
___shared_lib_ptr = __shared_textdata_start_lib$lname;
__shared_datadata_start_lib$lname = ___shared_lib_ptr + 2;
___shared_lib_ptr = __shared_datadata_start_lib$lname;\n";

$lasthex = "0x0" . substr($lst[0], 3, 5);
for ($i = 0; $i < @lst; $i++) {
  $name = substr($lst[$i], 11);
  $hex = "0x0" . substr($lst[$i], 3, 5);
  printf "$name = ___shared_lib_ptr + $hex - $lasthex + 10;
___shared_lib_ptr = $name;\n";
  $lasthex = $hex;
}

printf "
__shared_textdata_end_lib$lname = ___shared_lib_ptr + 0x0$ARGV[0] - $lasthex + 10;
___shared_lib_ptr = __shared_textdata_end_lib$lname;
__shared_datadata_end_lib$lname = ___shared_lib_ptr;\n";
