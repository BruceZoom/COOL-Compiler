/* The scanner definition or COOL. */

%{
  
/*
 *  Stuff enclosed in %{ %} in the first section is copied verbatim to the
 *  output, so headers and global definitions are placed here to be visible
 *  to the code in the file.  Dont remove anything that was here initially
 */

#include <cool-parse.h>
#include <stringtab.h>
#include <utilities.h>
#include <stdint.h>

/* The compiler assumes these identifiers. */
#define yylval cool_yylval
#define yylex  cool_yylex

/* Max size of string constants */
#define MAX_STR_CONST 1025
#define YY_NO_UNPUT   /* keep g++ happy */

extern FILE *fin; /* we read from this file */

/* define YY_INPUT so we read from the FILE fin:
 * This change makes it possible to use this scanner in
 * the Cool compiler.
 */
#undef YY_INPUT
#define YY_INPUT(buf,result,max_size) \
	if ( (result = fread( (char*)buf, sizeof(char), max_size, fin)) < 0) \
		YY_FATAL_ERROR( "read() in flex scanner failed");

char string_buf[MAX_STR_CONST]; /* to assemble string constants */
char *string_buf_ptr;

extern int curr_lineno;
extern int verbose_flag;

extern YYSTYPE cool_yylval;

/*
 *  Add Your own definitions here
 */

int nested_comment_level = 0;

%}

%option noyywrap
%x LINE_COMMENT BLOCK_COMMENT

/* Multiple-character operators */
DARROW          =>


%%

 /*
  *  Nested comments
  */

"(\*"    {
    BEGIN BLOCK_COMMENT;
    printf("%d\n", nested_comment_level);
    nested_comment_level++;
    printf("block comment begin\n");
}

<BLOCK_COMMENT>\n { curr_lineno++; }
<BLOCK_COMMENT>"\*)" {
    printf("block comment end\n");
    nested_comment_level--;
    if (nested_comment_level == 0) BEGIN 0;
}
<BLOCK_COMMENT><<EOF>> {
    strcpy(cool_yylval.error_msg, "EOF in comment");
	  BEGIN 0;
    return (ERROR);
}

"\*)"    {
    strcpy(cool_yylval.error_msg, "Unmatched *)");
    return (ERROR);
}

<BLOCK_COMMENT>. {}

 /*
  *  The multiple-character operators.
  */
{DARROW}		{ return (DARROW); }

 /*
  * Keywords are case-insensitive except for the values true and false,
  * which must begin with a lower-case letter.
  */

(?i:CLASS)      { return (CLASS); }
(?i:ELSE)       { return (ELSE); }
(?i:FI)         { return (FI); }
(?i:IF)         { return (IF); }
(?i:IN)         { return (IN); }
(?i:INHERITS)   { return (INHERITS); }
(?i:ISVOID)     { return (ISVOID); }
(?i:LET)        { return (LET); }
(?i:LOOP)       { return (LOOP); }
(?i:POOL)       { return (POOL); }
(?i:THEN)       { return (THEN); }
(?i:WHILE)      { return (WHILE); }
(?i:CASE)       { return (CASE); }
(?i:ESAC)       { return (ESAC); }
(?i:NEW)        { return (NEW); }
(?i:OF)         { return (OF); }
(?i:NOT)        { return (NOT); }

 /*
  *  String constants (C syntax)
  *  Escape sequence \c is accepted for all characters c. Except for 
  *  \n \t \b \f, the result is c.
  *
  */

%%
