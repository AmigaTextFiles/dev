// DISPLAY_DY=256      ; alle Zeilen
// SCROLL_DY=100       ; Bereich des Scrolltextes 
// SCROLL_Y=(DISPLAY_DY-SCROLL_DY)>>1    // (256-100)/2=78
// SCROLL_Y = 78

// SCROLL_AMPLITUDE=SCROLL_DY-16                 // 84
// add.w #SCROLL_Y+(SCROLL_AMPLITUDE>>1),d1      // 78+(84/2)=120    ; Mitte des Scrolltextes

// Ergebnis die Werte liegen zwischen 0 und 42 für 0° bis 90°
// Ergebnis die Werte liegen zwischen 42 und 0 für 90° bis 180°
// Ergebnis die Werte liegen zwischen 0 und -42 für 180° bis 270°
// Ergebnis die Werte liegen zwischen -42 und 0 für 270° bis 360°

// add.w #SCROLL_Y+(SCROLL_AMPLITUDE>>1),d1  ;  = 4b08.007F
// [0,42,0,-42,0]
// zeile = (120 + 42) = 162 // tiefste Zeile
// Zeile = (120 - 42) = 78  // höchste Zeile

// d1 = (DISPLAY_DX>>3)*d1 = 40*d1 = (32*d1)+(8*d1) = (2^5*d1)+(2^3*d1)
//  Zeile*40; //--> Zeile (1 Zeile hat 40 bytes)
//  add.w d6,d1                  ; d6=0 Byte in der Zeile
//  lea (a2,d1.w),a4             ; Word in bitplane

int Amplitude=84/2;              // =42   />>1  =/2 bedeutet Spitze-Spitze Bereich
float winkel_bogenmass;
int zeile=120;
int i=0;
int zeile_vorg;

void setup() {
  size(320, 256);
  background(255);

  for (int i=0; i<360; i++) {
    winkel_bogenmass=sin((2*PI/360)*i);                // Winkel in Bogenmass (Gleitpunktzahl)
    int Ausschlag = int(Amplitude*winkel_bogenmass);
    println(i+"\t"+nf(winkel_bogenmass, 0, 5)+"\t"+Ausschlag);   //
  }

}

void draw() {
  noFill();  
  stroke(255); line(10, zeile, 310, zeile);          // reinigen
    
  if (i>359) i=0;
  winkel_bogenmass=sin((2*PI/360)*i);                // Winkel in Bogenmass (Gleitpunktzahl)
  int Ausschlag = int(Amplitude*winkel_bogenmass);
  zeile = 120+ Ausschlag;
  i++;
    
  stroke(0);  line(10, zeile, 310, zeile);           // zeichnen
}
