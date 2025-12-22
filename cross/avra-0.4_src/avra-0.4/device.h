
/* Device flags */
#define DF_NO_MUL 0x00000001

struct device
	{
	char *name;
	int flash_size;
	int ram_size;
	int eeprom_size;
	int flag;
	};

/* device.c */
struct device *get_device(char *name);

