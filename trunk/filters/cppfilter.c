/**
 * Translate preprocessor spew from from GNU CPP ... 
 * Get line numbers straight and remove '#' junk.
**/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

/**
 * List of extensions that this will ALLOW to bugger the line count 
 * Emit a warning to output if the line count will not be correct.
 * Lets us include code and data into .as3 file 
**/
const char* szzExtensions[] = 
{
	".inc",		/* #include some template file */
	".temp",	/* #include some template file */
	".as",		/* #include some further as code */
	".as3",		/* #include some further as3 code */
	".xml",		/* #include some further xml code */
	NULL
};

/**
 * Return 1 if sz matches szzExtensions; 0 if not.
**/
int MatchesExtension( const char* sz )
{
	const char** szz = szzExtensions;
	const char* extension = sz + strlen(sz)-1;
	while( *extension != '.' && extension > sz  )
		extension--;
	while( *szz )
	{
		const char* sz1 = extension;
		const char* sz2 = *szz;
		while( tolower(*sz1) == tolower(*sz2) && 0 != *sz2 )
		{
			sz1++;
			sz2++;
		}
		if( '\"' == *sz1 && 0 == *sz2 )
		{ // Matched
			return 1;
		}
		szz++;
	}
	// Nothing matched
	return 0;
}

int main( int argc, const char** argv )
{
	const char* lineDirective = "#";
	size_t lineDirectiveLen = 1;
	if( argc > 1 )
	{
		if( 0 == strcmp(argv[1],"-gcc") || 0 == strcmp(argv[1],"-GCC") )
		{
			lineDirective = "#";
			lineDirectiveLen = 1;
		}
		else if( 0 == strcmp(argv[1],"-msvc") || 0 == strcmp(argv[1],"-MSVC") )
		{
			lineDirective = "#line";
			lineDirectiveLen = 5;
		}
		else
		{
			printf( 
				"Translate preprocessor spew from C preprocessor\n"
				"Get line numbers straight and remove '#' junk.\n\n"
				"Usage:\n"
				"\tcppfilter [-gcc|-msvc] <input >output \n"
				"\tcpp | cppfilter [-gcc|-msvc] >output \n"
				);
			return 2;
		}
	}
	// Parse stdin
	{
		static char buff[32768];
		char* pFirstLineFile = NULL;
		size_t lenFirstLineFile;
		char* p = buff;
		int bMyFile = 0;
		FILE* fp = stdin;
		{
			// Read off first # line, which should have THIS file's path
			p = fgets( buff, sizeof(buff), fp );
			if( 0 == strncmp(p,lineDirective,lineDirectiveLen) )
			{
				int lineTemp = strtol( p+lineDirectiveLen, &p, 10 );
				while( isspace(*p) )
					p++;
#if defined(_MSC_VER) && (_MSC_VER >= 1400)
				p = pFirstLineFile = _strdup(p);	// Microsoft's new make-believe 'POSIX conformance' - deprecate strdup for no particular reason.
#else
				p = pFirstLineFile = strdup(p);
#endif
				p = p + strlen(p)-1;
				while( *p != '\"' )  // Find end quote
					*p-- = 0;
				lenFirstLineFile = strlen(pFirstLineFile);
				bMyFile = 0;
			}
			else
			{
				fprintf( stderr, "Not expected cpp output: %s\n", *argv );
				return 2;
			}
		}
		// Read remaining lines
		{
			int linesWritten = 1;
			int lineCurr = 1;
			while( !feof(fp) )
			{
				p = fgets( buff, sizeof(buff), fp );
				if( NULL == p )
					break;
				// See if this is a line directive
				if( 0 == strncmp(p,lineDirective,lineDirectiveLen) )
				{
					int lineTemp = strtol( p+lineDirectiveLen, &p, 10 );
					while( isspace(*p) )
						p++;
					if( 0 == strncmp( p, pFirstLineFile, lenFirstLineFile ) )
					{
						lineCurr = lineTemp;
						bMyFile = 1;
					}
					else if( MatchesExtension( p ) )
					{
						printf("/* WARNING: Invalidated line count. */" );
						lineCurr = lineTemp;
						bMyFile = 1;
					}
					else
					{
						bMyFile = 0;
					}
				}
				else if( bMyFile )
				{
					while( linesWritten < lineCurr )
					{
						//printf("%d +\n", linesWritten);
						printf("\n");
						++linesWritten;
					}
					//printf("%d %s",linesWritten,buff);
					printf("%s",buff);
					++linesWritten;
				}
			}
		}
		if( NULL != pFirstLineFile )
		{
			free( pFirstLineFile );
		}
	}
	return 0;
}

