/* Using the Arduino as a DEMO single channel ADC for WinUAE. */
/* This idea is copyright, (C)2008, B.Walker, G0LCU. */
/* For use with AF2005 or greater. This is just demonstration code */
/* only and shows that I/O is possible through WinUAE by other means. */

/* Set up a variable 1 byte in size for basic analogue input. */
int analogue0 = 0;

void setup() {
  /* open the serial port at 1200 bps. This rate is used for purely */
  /* for simplicity only. */
  Serial.begin(1200);

  /* Set the analogue voltage reference, DEFAULT is 5V in this case. */
  analogReference(DEFAULT);
}

void loop() {
  /* Read the 10 bit analogue voltage on analogue input 0. */
  analogue0 = analogRead(0);
  /* Convert to a byte value by dividing by 4. */
  analogue0 = analogue0/4;

  /* Send to the Serial Port the byte value. */
  Serial.print(analogue0, BYTE);
  
  /* Delay 500 milliseconds before taking the next reading. */
  delay(500);
}
