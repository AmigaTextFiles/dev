/*
** This script replaces if needed (in fact according
** to the user preferences) the icon default tools
** in RAM: and SD0:, WHITHOUT changing the user prefe-
** rences.
** It's intended to be used for temporary storage
** places (like RAM: and SD0:) whithout making the
** user touch his settings.
*/

options results
address 'DEFT_II.1'

'number_paths'

number_paths = result

DO i = 1 TO number_paths

	'get_path 0'
	path.i = result
	'delete_path 0'

END

	/*
	** Change these 2 lines to suit your needs, ie put
	** here some lines like :
	** 'add_path VOL:'
	** where VOL: is one of your temporary storage places.
	*/
'add_path RAM:'
'add_path SD0:'

'go'

	/*
	** Put here as many 'delete_path 0' lines as you have
	** put 'add_path VOL:' lines above.
	*/
'delete_path 0'
'delete_path 0'

DO i = 1 TO number_paths

	'add_path' path.i

END

'loose_modifications'
