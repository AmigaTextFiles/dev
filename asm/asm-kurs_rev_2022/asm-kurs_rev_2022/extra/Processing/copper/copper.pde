String[] textFileZeilen = loadStrings("copperlist.txt");
String text;  String[] teile;  char delimiter = ' ';
//------------------------------------------------------------------------------------      
println("copperlist:");
for (int j= 0; j < textFileZeilen.length; j++) {
  text =  textFileZeilen[j].substring(9, 48);
  teile = split(text, delimiter);
  for (int i = 0; i < teile.length-1; i++)                 teile[i]="$"+teile[i]+", ";
  for (int i = teile.length-1; i < teile.length; i++)      teile[i]="$"+teile[i]; 
  print("dc.w ");     for (int i = 0; i < teile.length; i++)     print(teile[i]);   
  println();
}
