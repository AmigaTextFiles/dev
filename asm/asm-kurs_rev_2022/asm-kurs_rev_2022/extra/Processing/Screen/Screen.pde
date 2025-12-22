int DIWSTRT = 0x2c81;  //  dc.w  $8E,$2c81  ; DiwStrt    dc.w  $8E,vvhh
int DIWSTOP = 0x2cc1;  //  dc.w  $90,$2cc1  ; DiwStop    dc.w  $90,vvhh

//int DIWSTRT= 0x0581; int DIWSTOP= 0x40c1;  // Hand
//int DIWSTRT= 0x2c81; int DIWSTOP= 0xf4c1;
 
int oben_links_x; int oben_links_y;
int unten_rechts_x; int unten_rechts_y; 
int breite_x; int hoehe_y;
//-------------------------------------------------------------------
int but1ax = 10; int but2ax = 10;  int but3ax = 10; int but4ax = 10;
int but1bx = 14; int but2bx = 14;  int but3bx = 14;  int but4bx = 14;
int but1cx = 20; int but2cx = 20;  int but3cx = 20;  int but4cx = 20;


int but1ay = 442; int but2ay = 462;  int but3ay = 482; int but4ay = 502;
int but1by = 449; int but2by = 469;  int but3by = 489; int but4by = 509;
int but1cy = 444; int but2cy = 464;  int but3cy = 484; int but4cy = 504;

int breite1 = 270; int breite2 = 263; int breite3 = 10;
int hoehe1 = 20 ;  int hoehe2 = 6 ;  int hoehe3 = 16;

int diffx1; int diffy1; int diffx2; int diffy2; int diffx3; int diffy3; int diffx4; int diffy4;
int flag1;  int flag2;   int flag3; int flag4;
int value1; int value2;  int value3; int value4; int flag5;
 //-------------------------------------------------------------------
int PixelproZeile=320;    
int DDFSTRT=0;
int DDFSTOP=0;

/*  
  $000~$05B hard blank (*)
  $05c~$080 left soft blank // border_left
  $081~$1c0 (320px)
  $1c1~$1d3 right soft blank
  grand total: ($1d4-$05c=376px) max overscan 468-92=376      
    
  $000~$019 hard blank (on $019 you get first DMA sprite fetches)
  $01a~$02b upper soft blank
  $02c~$12b (256py)
  $12c~$137 lower soft blank
  $138 LOF last line (A1000 usable, other systems only COLOR00)
  grand total: ($138-$01a=286px) max overscan  
*/

void setup() {  
  size(600,550);    
  screen_berechnung();
  size_select();
  screen_draw();
  //screen_in_ecken();  
}

//-------------------------------------------------------------------
// 
//-------------------------------------------------------------------
void draw(){
    if (mousePressed)
  {
   schieber(); 
   screen_berechnung();   
   screen_draw(); 
  }  
}

//-------------------------------------------------------------------
// 
//-------------------------------------------------------------------
void mouseReleased()
 {
   flag1=0; flag2=0; flag3=0; flag4=0; 
 } 
 
//-------------------------------------------------------------------
// 
//-------------------------------------------------------------------
void screen_draw(){
  stroke(0,0,255);  fill(10);   rect(0x00,0x00,600,400); 
  stroke(0,0,255);  fill(10);   rect(0x00,0x00,0x5b,0x138); // hard blank horizontal
  stroke(0,0,255);  fill(10);   rect(0x00,0x00,0x1d3,0x19); // hard blank horizontal
  stroke(0,255,0);  fill(100);  rect(0x5c,0x1a,375,286);    // black border  (soft blank)
//-------------------------------------------------------------------------------------------  
  stroke(255,0,0);  fill(255);  rect(0x81,0x2c,320,256);    // lowres-screen  DIWSTART $2c81   
  gitter_show();
  if(hoehe_y <0) fill(80); else fill(220);
  rect(oben_links_x,oben_links_y,breite_x,hoehe_y);
}

//-------------------------------------------------------------------
// 
//-------------------------------------------------------------------
void screen_in_ecken(){
// grand total: ($1d4-$05c=376px) and ($138-$01a=286px) max overscan max overscan
  
 //-------------------------------------------------------------------------------------------
 //  DIWSTRT($5c1a)  DIWSTRT upper left corner
 //  DIWSTRT($5c37)  DIWSTRT lower left corner  y=$138-256 =$38 (56)     56+255=311 = $137
 //  DIWSTRT($931a)  DIWSTRT upper right corner x=$1d4-320 =$94 (148)    148+320= 468 = $1d4
 //  DIWSTRT($9337)  DIWSTRT lower right corner 
stroke(255,0,0);  fill(0,100,0);  rect(0x5c,0x1a,320,256);    // lowres-screen  DIWSTART $1a5c
//stroke(255,0,0);  fill(0,100,0);  rect(0x5c,0x38,320,256);    // lowres-screen  DIWSTART $385c
//stroke(255,0,0);  fill(0,100,0);  rect(0x94,0x1a,320,256);    // lowres-screen  DIWSTART $1a94
//stroke(255,0,0);  fill(0,100,0);  rect(0x94,0x38,320,256);    // lowres-screen  DIWSTART $1a94
}

//-------------------------------------------------------------------
// Screengröße
//-------------------------------------------------------------------
void screen_berechnung(){
  println("\n"+"SCREENBERECHNUNG");
// V7=0 --> V8=1
// 1.0000.0000 bis 1.0111.1111  = 256 bis 511   --> $00 bis $7F
//                  --> resultierend: $100 bis $17F 
     // unten_rechts_y = (DIWSTOP>>8) >> 7;
   //if (unten_rechts_y == 0) {unten_rechts_y = (DIWSTOP>>8)+0x100;} else {unten_rechts_y = (DIWSTOP>>8)+0x80;}
   if ((DIWSTOP>>8)>=0x80) { unten_rechts_y = (DIWSTOP>>8)-0x80;} else
   {unten_rechts_y = (DIWSTOP>>8)+0x100;}   
//-------------------------------------------------------------------------------------------
   oben_links_y = (DIWSTRT>>8); 
   oben_links_x = (DIWSTRT & 0x00FF);
   unten_rechts_x = (DIWSTOP & 0x00FF)+0x100;        // Horizontal H8=1, +0x100
   
   print("oben_links_y ="+hex(oben_links_y,4)+"\t   ");       println("oben_links_y ="+oben_links_y);
   print("oben_links_x ="+hex(oben_links_x,4)+"\t   ");       println("oben_links_x ="+oben_links_x);
   print("unten_rechts_y ="+hex(unten_rechts_y,4)+"\t   ");   println("unten_rechts_y ="+unten_rechts_y);        
   print("unten_rechts_x ="+hex(unten_rechts_x,4)+"\t   ");   println("unten_rechts_x ="+unten_rechts_x);
//-------------------------------------------------------------------------------------------
   breite_x=unten_rechts_x-oben_links_x; hoehe_y=unten_rechts_y-oben_links_y; 
   println("Breite "+breite_x+  " Hoehe "+hoehe_y);
//-------------------------------------------------------------------------------------------  
   println("Screengröße "+(breite_x*hoehe_y)/8+" Bytes");
}

//-------------------------------------------------------------------
// Slider positionieren
//-------------------------------------------------------------------
void size_select(){
//Schieber 1
   fill (180,180,180);   rect(but1ax,but1ay,breite1,hoehe1);
   fill (120,120,120);   rect(but1bx,but1by,breite2,hoehe2);
                         rect(but1cx,but1cy,breite3,hoehe3); 
// Schieber 2
   fill (180,180,180);   rect(but2ax,but2ay,breite1,hoehe1);
   fill (120,120,120);   rect(but2bx,but2by,breite2,hoehe2);
                         rect(but2cx,but2cy,breite3,hoehe3);
// Schieber 3
   fill (180,180,180);   rect(but3ax,but3ay,breite1,hoehe1); 
   fill (120,120,120);   rect(but3bx,but3by,breite2,hoehe2);
                         rect(but3cx,but3cy,breite3,hoehe3);                           
// Schieber 4
   fill (180,180,180);   rect(but4ax,but4ay,breite1,hoehe1); 
   fill (120,120,120);   rect(but4bx,but4by,breite2,hoehe2);
                         rect(but4cx,but4cy,breite3,hoehe3);                         
// Color
   fill(255,255,255);    rect(285,but1ay, 30,20);    fill(0,0,0);    text("00",290,but1ay+16);
   fill(255,255,255);    rect(285,but2ay, 30,20);    fill(0,0,0);    text("00",290,but2ay+16); 
   fill(255,255,255);    rect(285,but3ay, 30,20);    fill(0,0,0);    text("00",290,but3ay+16);
   fill(255,255,255);    rect(285,but4ay, 30,20);    fill(0,0,0);    text("00",290,but4ay+16);

   fill(255,255,255);    rect(320,but1ay, 30,20);    fill(0,0,0);    text("00",325,but1ay+16);
   fill(255,255,255);    rect(320,but2ay, 30,20);    fill(0,0,0);    text("00",325,but2ay+16); 
   fill(255,255,255);    rect(320,but3ay, 30,20);    fill(0,0,0);    text("00",325,but3ay+16);
   fill(255,255,255);    rect(320,but4ay, 30,20);    fill(0,0,0);    text("00",325,but4ay+16);

   fill(255,255,255);    rect(360,but1ay, 65,20);    fill(0,0,0);    text("DIWSTRT",365,but1ay+16);
   fill(255,255,255);    rect(360,but3ay, 65,20);    fill(0,0,0);    text("DIWSTOP",365,but3ay+16);

   fill(255,255,255);    rect(430,but1ay, 37,20);    fill(0,0,0);    text("2c81",435,but1ay+16);
   fill(255,255,255);    rect(430,but3ay, 37,20);    fill(0,0,0);    text("2cc1",435,but3ay+16);
   
   fill(255,255,255);    rect(470,but1ay, 65,20);    fill(0,0,0);    text("DDFSTRT",475,but1ay+16);
   fill(255,255,255);    rect(470,but3ay, 65,20);    fill(0,0,0);    text("DDFSTOP",475,but3ay+16);

   fill(255,255,255);    rect(540,but1ay, 37,20);    fill(0,0,0);    text("0038",545,but1ay+16);
   fill(255,255,255);    rect(540,but3ay, 37,20);    fill(0,0,0);    text("00d0",545,but3ay+16);   
}

//-------------------------------------------------------------------
// Slider einstellen 
//-------------------------------------------------------------------
void schieber(){
  stroke(0,0,0);
// Schieber 1 #############################################################
    if((mouseX > but1cx) &  (mouseX < (but1cx+breite3)) & 
       (mouseY > but1cy) &  (mouseY < (but1cy+hoehe3)& flag1==0)){
         diffx1=  mouseX - but1cx; flag1=1;  
       }
    
      if(mouseX > (but1ax +10) & mouseX < (but1ax + breite1-10)& flag1==1){
         fill (180,180,180);     rect(but1ax, but1ay,breite1,hoehe1,2);
         fill (120,120,120);     rect(but1bx, but1by,breite2,hoehe2);
         but1cx= mouseX-diffx1;  rect(mouseX-diffx1, but1cy, breite3, hoehe3,2);  
         value1= but1cx-but1ax;
       
         value1=int(map(value1,2, 258, 0, 255));
         //println("value1= "+value1);
         fill(255,255,255);    rect(285,but1ay, 30,20);  fill(0,0,0);  text(value1,290,but1ay+16);
         fill(255,255,255);    rect(320,but1ay, 30,20);  fill(0,0,0);  text(hex(value1,2),325,but1ay+16); 
         fill(255,255,255);    rect(430,but1ay, 37,20);  fill(0,0,0);  text(hex(value1,2)+hex(value2,2),435,but1ay+16);
         flag5=1;
      }
      
// Schieber 2 #############################################################
    if((mouseX > but2cx) & (mouseX < (but2cx+breite3)) & 
       (mouseY > but2cy) & (mouseY < (but2cy+hoehe3)& flag2==0)){
        diffx2=  mouseX - but2cx; flag2=1;  
       } 
     
      if(mouseX > (but2ax +10) & mouseX < (but2ax + breite1-10)& flag2==1){
        fill (180,180,180);    rect(but2ax, but2ay,breite1,hoehe1,2);
        fill (120,120,120);    rect(but2bx, but2by,breite2,hoehe2);
        but2cx= mouseX-diffx2; rect(mouseX-diffx2, but2cy, breite3, hoehe3,2);  
        value2= but2cx-but2ax;

         value2=int(map(value2,2, 258, 0, 255));
         //println("value2= "+value2);
         fill(255,255,255);    rect(285,but2ay, 30,20);  fill(0,0,0);  text(value2,290,but2ay+16);
         fill(255,255,255);    rect(320,but2ay, 30,20);  fill(0,0,0);  text(hex(value2,2),325,but2ay+16);     
         fill(255,255,255);    rect(430,but1ay, 37,20);  fill(0,0,0);  text(hex(value1,2)+hex(value2,2),435,but1ay+16);
         flag5=1;
         
         if ((value2-1)%16 == 0) {
         fill(0,255,0);    rect(285,but2ay, 30,20);  fill(0,0,0);  text(value2,290,but2ay+16);
        }
      }
      
 // Schieber 3 #############################################################
    if((mouseX > but3cx) & (mouseX < (but3cx+breite3)) &
       (mouseY > but3cy) & (mouseY < (but3cy+hoehe3)& flag3==0)){     
        diffx3=  mouseX - but3cx; flag3=1; 
   } 
    
      if(mouseX > (but3ax +10) & mouseX < (but3ax + breite1-10)& flag3==1){
        fill (180,180,180);    rect(but3ax, but3ay,breite1,hoehe1,2);
        fill (120,120,120);    rect(but3bx, but3by,breite2,hoehe2); 
        but3cx= mouseX-diffx3; rect(mouseX-diffx3, but3cy, breite3, hoehe3,2);  
        value3= but3cx-but3ax;

         value3=int(map(value3,2, 258, 0, 255));
         //println("value3= "+value3);
         fill(255,255,255);    rect(285,but3ay, 30,20);  fill(0,0,0);  text(value3,290,but3ay+16);
         fill(255,255,255);    rect(320,but3ay, 30,20);  fill(0,0,0);  text(hex(value3,2),325,but3ay+16);    
         fill(255,255,255);    rect(430,but3ay, 37,20);  fill(0,0,0);  text(hex(value3,2)+hex(value4,2),435,but3ay+16);         
         flag5=1;
      }
 
// Schieber 4 #############################################################
    if((mouseX > but4cx) & (mouseX < (but4cx+breite3)) &
       (mouseY > but4cy) & (mouseY < (but4cy+hoehe3)& flag4==0)){     
        diffx4=  mouseX - but4cx; flag4=1; 
   } 
    
      if(mouseX > (but4ax +10) & mouseX < (but4ax + breite1-10)& flag4==1){
        fill (180,180,180);    rect(but4ax, but4ay,breite1,hoehe1,2);
        fill (120,120,120);    rect(but4bx, but4by,breite2,hoehe2); 
        but4cx= mouseX-diffx4; rect(mouseX-diffx4, but4cy, breite3, hoehe3,2);  
        value4= but4cx-but4ax;


         value4=int(map(value4,2, 258, 0, 255));
         //println("value4= "+value4);
         fill(255,255,255);    rect(285,but4ay, 30,20);  fill(0,0,0);  text(value4,290,but4ay+16);
         fill(255,255,255);    rect(320,but4ay, 30,20);  fill(0,0,0);  text(hex(value4,2),325,but4ay+16);    
         fill(255,255,255);    rect(430,but3ay, 37,20);  fill(0,0,0);  text(hex(value3,2)+hex(value4,2),435,but3ay+16);
         flag5=1;
      }
      
      DIWSTRT=(value1<<8)+value2;      //println("DIWSTRT "+hex(DIWSTRT,4));
      DIWSTOP=(value3<<8)+value4;      //println("DIWSTOP "+hex(DIWSTOP,4)); 
   
      DDFSTRT=(((value2*10/2)-85)/10)& 0xF8;             //DDFSTRT=(((DIWSTRT*10/2)-85)/10)& 0xF8;
      DDFSTOP=(((((value4+0x100)*10/2)-85)/10)& 0xF8)-8;     
         
      //println("DIWSTRT "+hex(DIWSTRT,4)+"  DDFSTRT = "+hex(int(DDFSTRT),4));
      //println("DIWSTOP "+hex(DIWSTOP,4)+"  DDFSTOP = "+hex(int(DDFSTOP),4));
            
     if ((DDFSTRT<=0x10)||(DDFSTRT>=0xd8)){ fill(255,0,0);   } else {fill(255,255,255);  }  
       rect(540,but1ay, 37,20);   fill(0,0,0); text(hex(DDFSTRT,4),545,but1ay+16);
     
     if (DDFSTOP >0xD8) { fill(255,0,0);   } else {fill(255,255,255);  }    
     rect(540,but3ay, 37,20);    fill(0,0,0);    text(hex(DDFSTOP,4),545,but3ay+16);
}

//-------------------------------------------------------------------
// Gitter 16x16 Pixelraster
//-------------------------------------------------------------------
void gitter_show() {
  int kastenbreite=8;
  int kastenhoehe=8;

  for (int n=0; n<18; n++) {
    for (int m=0; m<23; m++) {   
      fill(color(200, 200, 200));      
      rect(0x61+(2*kastenbreite)*m, 0x1a+(2*kastenhoehe)*n, (2*kastenbreite), (2*kastenhoehe)); 
    }
  }
}
