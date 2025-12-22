float winkel_bogenmass;
int winkel_bogenmass_k; //=int(round(winkel_bogenmass*(pow(2,15))));
float winkel_bogenmass_ok;

void setup() { 
  //variante1();    // Variante mit 2^15
  variante2();     // Variante mit 2^14
}


void variante1() {  // Variante mit 2^15  
  /*
   sin(1)=0,0174  sin(1)*2^15  = 571,88 --> dc.w 572
   ...
   sin(90)=1      sin(90)*2^15 = 32768
   
   Wertebereich: short  -32768..32767  16 Bit
   d.h. sin(90)*2^15 = 32768 passt nicht in 16Bit Wert 
   wir verlieren Genauigkeit und bräuchten 17Bit
   */
  println("Winkel)"+"\t"+"Winkel"+"\t"+" Winkel");
  println("(Grad)"+"\t"+"(Bogenm.)"+"\t"+"sin(x)*2^15");
  for (int i=0; i<360; i++) {
    winkel_bogenmass=sin((2*PI/360)*i);  // Winkel in Bogenmass (Gleitpunktzahl)
    winkel_bogenmass_k=int(round(winkel_bogenmass*(pow(2, 15))));
    //winkel_bm_hex=hex(winkel_bogenmass_k,4)
    println(i+"\t"+nf(winkel_bogenmass, 0, 5)+"\t"+winkel_bogenmass_k+"\t"+hex(winkel_bogenmass_k, 4));   //
  }
}

void variante2() {   // Variante mit 2^14
  
  println("Winkel)"+"\t"+"Winkel"+"\t"+"Winkel"+"\t\t"+"als"+"\t"+"und wieder");
  println("(Grad)"+"\t"+"(Bogenm.)"+"\t"+"sin(x)*2^14"+"\t"+"hex"+"\t"+":2^14");
  for (int i=0; i<360; i++) {
    winkel_bogenmass=sin((2*PI/360)*i);  // Winkel in Bogenmass (Gleitpunktzahl)
    winkel_bogenmass_k=int(round(winkel_bogenmass*(pow(2, 14))));
    // swap entspricht / 2^16
    // rol.l entspricht * 2
    // resultierend >>16+<<2=>>14  /2^14
    winkel_bogenmass_ok = winkel_bogenmass_k/(pow(2, 14));
    
    println(i+"\t"+nf(winkel_bogenmass, 0, 5)+"\t"+winkel_bogenmass_k+"\t\t"+hex(winkel_bogenmass_k, 4)+"\t"+nf(winkel_bogenmass_ok,0,5));   //
  }
}
