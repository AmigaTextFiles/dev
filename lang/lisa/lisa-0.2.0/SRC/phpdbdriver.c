#include "phpdbdriver.h"

#include <stdio.h>



// writeMySQLdriver
//	This function will create the dbsupport file for MySQL
//	database engine. The previous file will be overwritten.
void writeMySQLdriver( char *hostname, char *dbname, char *username, char *password )
{
	FILE *f;

	// create the file, overwritting the existing...
	f = fopen( "dbsupport.php", "w" );
	if ( !f )
		error( "Cannot create database driver file." );

	fprintf( f, "<?\n" );
	fprintf( f, "function _close_()\n" );
	fprintf( f, "{\n" );
	fprintf( f, "\tglobal $_link_;\n" );
	fprintf( f, "\tmysql_close( $_link_ );\n" );
	fprintf( f, "}//_close_\n" );
	fprintf( f, "\n" );
	fprintf( f, "\n" );
	fprintf( f, "\n" );
	fprintf( f, "function _commit_()\n" );
	fprintf( f, "{\n" );
	fprintf( f, "}//_commit_\n" );
	fprintf( f, "\n" );
	fprintf( f, "\n" );
	fprintf( f, "\n" );
	fprintf( f, "function _database_()\n" );
	fprintf( f, "{\n" );
	fprintf( f, "\tglobal $_link_;\n" );
	fprintf( f, "\t$_link_ = mysql_connect( '%s', '%s', '%s' );\n", hostname, username, password );
	fprintf( f, "\tmysql_select_db( '%s', $_link_ );\n", dbname );
	fprintf( f, "}//_database_\n" );
	fprintf( f, "\n" );
	fprintf( f, "\n" );
	fprintf( f, "\n" );
	fprintf( f, "function _fetch_( $result )\n" );
	fprintf( f, "{\n" );
	fprintf( f, "\treturn mysql_fetch_array( $result );\n" );
	fprintf( f, "}//_fetch_\n" );
	fprintf( f, "\n" );
	fprintf( f, "\n" );
	fprintf( f, "\n" );
	fprintf( f, "function _foreach_( $result )\n" );
	fprintf( f, "{\n" );
	fprintf( f, "\treturn mysql_num_rows( $result );\n" );
	fprintf( f, "}//_foreach_\n" );
	fprintf( f, "\n" );
	fprintf( f, "\n" );
	fprintf( f, "\n" );
	fprintf( f, "function _scan_( $id )\n" );
	fprintf( f, "{\n" );
	fprintf( f, "\tglobal $_array_;\n" );
	fprintf( f, "\treturn $_array_[ $id ];\n" );
	fprintf( f, "}//_scan_\n" );
	fprintf( f, "\n" );
	fprintf( f, "\n" );
	fprintf( f, "\n" );
	fprintf( f, "function _transaction_()\n" );
	fprintf( f, "{\n" );
	fprintf( f, "}//_transaction_\n" );
	fprintf( f, "\n" );
	fprintf( f, "\n" );
	fprintf( f, "\n" );
	fprintf( f, "function _dbEmpty( $result )\n" );
	fprintf( f, "{\n" );
	fprintf( f, "\treturn ( !$result ? true : mysql_num_rows( $result ) == 0 );\n" );
	fprintf( f, "}//dbEmpty()\n" );
	fprintf( f, "\n" );
	fprintf( f, "\n" );
	fprintf( f, "\n" );
	fprintf( f, "function _dbQuery( $command )\n" );
	fprintf( f, "{\n" );
	fprintf( f, "\tglobal $_link_;\n" );
	fprintf( f, "\t// mysql query should not end with a semicolon...\n" );
	fprintf( f, "\t$command = trim( $command );\n" );
	fprintf( f, "\tif ( substr( $command, -1 ) == ';' )\n" );
	fprintf( f, "\t{\n" );
	fprintf( f, "\t\t$command = substr( $command, 0, strlen( $command ) - 1 );\n" );
	fprintf( f, "\t}\n" );
	fprintf( f, "\t$result = mysql_query( $command, $_link_ ) or die( 'Error while SQL query: ' . $command );\n" );
	fprintf( f, "\treturn $result;\n" );
	fprintf( f, "}//dbQuery\n" );
	fprintf( f, "\n" );
	fprintf( f, "\n" );
	fprintf( f, "\n" );
	fprintf( f, "function _dbSql( $command )\n" );
	fprintf( f, "{\n" );
	fprintf( f, "\tglobal $_link_;\n" );
	fprintf( f, "\t// mysql query should not end with a semicolon...\n" );
	fprintf( f, "\t$command = trim( $command );\n" );
	fprintf( f, "\tif ( substr( $command, -1 ) == ';' )\n" );
	fprintf( f, "\t{\n" );
	fprintf( f, "\t\t$command = substr( $command, 0, strlen( $command ) - 1 );\n" );
	fprintf( f, "\t}\n" );
	fprintf( f, "\tmysql_query( $command, $_link_ ) or die( 'Error while SQL command: ' . $command );\n" );
	fprintf( f, "}//dbSql\n" );
	fprintf( f, "?>\n" );

	// all done...
	fclose( f );
}//writeMySQLdriver

