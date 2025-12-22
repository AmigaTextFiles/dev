#if 0
void ao_initialize(void);
void ao_shutdown(void);

/* device setup/playback/teardown */
int ao_append_option(ao_option **options, const char *key, 
		     const char *value);
void ao_free_options(ao_option *options);
ao_device* ao_open_live(int driver_id, ao_sample_format *format,
				ao_option *option);
ao_device* ao_open_file(int driver_id, const char *filename, int overwrite,
			ao_sample_format *format, ao_option *option);

int ao_play(ao_device *device, char *output_samples, uint_32 num_bytes);
int ao_close(ao_device *device);

/* driver information */
int ao_driver_id(const char *short_name);
int ao_default_driver_id();
ao_info *ao_driver_info(int driver_id);
ao_info **ao_driver_info_list(int *driver_count);

/* miscellaneous */
int ao_is_big_endian(void);
#endif