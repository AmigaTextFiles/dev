#ifndef CLIB_MINISSC_PROTOS_H
#define CLIB_MINISSC_PROTOS_H

/*
**      $VER: minissc_protos.h (15.01.2000)
**      C prototypes.
**
**      Copyright © 2000 Janne Peräaho.
**            All Rights Reserved.
*/

int ssc_ServoStatus(register __d0 int servo);
int ssc_ControllerStatus(register __d0 int cntroller);
float ssc_ControllerRange(register __d0 int cntroller);
float ssc_ServoRange(register __d0 int servo);
int ssc_OccupyController(register __d0 int cntroller, register __d1 int commmode,register __d2 int ctrlmode);
int ssc_ChangeControllerSettings(register __d0 int cntroller, register __d1 int commmode, register __d2 int ctrlmode);
int ssc_ChangeServoSettings(register __d0 int servo, register __d1 float range);
int ssc_FreeController(register __d0 int cntroller);
int ssc_OccupyServo(register __d0 int servo,register __d1 float range);
int ssc_FreeServo(register __d0 int servo);
int ssc_Reset(register __d0 int servo);
void ssc_ResetAll(void);
int ssc_GetAPosition(register __d0 int servo);
float ssc_GetPosition(register __d0 int servo);
int ssc_SetAPosition(register __d0 int servo, register __d1 int position);
int ssc_SetPosition(register __d0 int servo, register __d1 float position);
int ssc_AMove(register __d0 int servo, register __d1 int displacement);
float ssc_Move(register __d0 int servo, register __d1 float displacement);

#endif /* CLIB_MINISSC_PROTOS_H */
