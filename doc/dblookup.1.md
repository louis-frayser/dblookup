% MKDB(1) DBLOOKUP(1)
% Louis Frayser
% June 2023

# NAME

mkdb – create a locate database

# SYNOPSIS

**mkdb** [**-h**] [**-d**] *DB_NAME*] [*SEARCH_PATH* ...]

# DESCRIPTION

**mkdb** search in search paths collecting names of file-system objects, saving them in a database referenced by DB_NAME.

**dblookup** searches in database, DB_NAME,and returns the object names found by **mkdb**.

# GENERAL OPTIONS

**-h**, **--help**
:   Display a friendly help message.

#FILES

*/var/dblookup/*PATH*/\*.db  Database files that make up the databases.
*/var/dblookup/dblookup.ht*  A dictionary that shows which dbfiles belong to which database.

# SEE ALSO
locate(1) plocate(1) mlocate(1)

