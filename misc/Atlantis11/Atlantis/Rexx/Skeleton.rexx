/* This is a skeleton rexx program for Atlantis. Start from this script when making
 * your own scripts.
 */

SIGNAL ON SYNTAX

OPTIONS RESULTS

IF ~SHOW('Ports', 'ATLANTIS') THEN
  DO
    SAY "Atlantis must be started first!"
    EXIT 10
  END

ADDRESS ATLANTIS

WANTVERSION = 1   /* This script is for version 1 */

VERSION           /* Get version */

IF (RESULT ~= WANTVERSION) THEN DO
  SAY 'Sorry, this script is for version' WANTVERSION
  SAY 'You are running version' RESULT
  EXIT
END

SLEEP

/* Do your stuff here */

WAKEUP

EXIT

syntax:
WakeUp
Say "Error in line : " sourceline(sigl)