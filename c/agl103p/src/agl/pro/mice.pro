/* mice.c */
long start_gameport(void);
void stop_gameport(void);
void send_read_request(void);
void set_trigger_conditions(void);
long set_controller_type(BYTE type);
void free_gameport(void);
void flush_buffer(void);
long gameport_event(long *device,short *state,short *dx,short *dy);

