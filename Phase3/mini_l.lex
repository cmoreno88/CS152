/* 
 * Christopher Moreno
 * CS152 Project_Phase_2
 * Description: Lexical Analyzer for the Mini-L language 
 *              
 * Usage: (1) $ flex mini_l.lex
 *        (2) $ gcc -o lexer lex.yy.c -lfl
 *        (3) $ ./lexer
 *            stdin> whatever you like
 *	      	  stdin> Ctrl-D
 *
 * Below is the basic file layout:
 * DEFINTIONS
 * %%
 * RULES
 * %%
 * USER CODE
 */

%{
#include "y.tab.h"
	int cur_line = 1;
	int cur_pos = 1;
	//char * identVal;
%}

DIGIT	[0-9]
LETTER	[a-zA-Z]

/*Reserved Words*/
%%

"function"			{cur_pos += yyleng; return FUNCTION;}
"beginparams"		{cur_pos += yyleng; return BEGIN_PARAMS;}
"endparams"			{cur_pos += yyleng; return END_PARAMS;}
"beginlocals"		{cur_pos += yyleng; return BEGIN_LOCALS;}
"endlocals"			{cur_pos += yyleng; return END_LOCALS;}
"beginbody"			{cur_pos += yyleng; return BEGIN_BODY;}
"endbody"			{cur_pos += yyleng; return END_BODY;}
"integer"			{cur_pos += yyleng; return INTEGER;}
"array"				{cur_pos += yyleng; return ARRAY;}
"of"				{cur_pos += yyleng; return OF;}
"if"				{cur_pos += yyleng; return IF;}
"then"				{cur_pos += yyleng; return THEN;}
"endif"				{cur_pos += yyleng; return ENDIF;}
"else"				{cur_pos += yyleng; return ELSE;}
"while"				{cur_pos += yyleng; return WHILE;}
"do"				{cur_pos += yyleng; return DO;}
"for"				{cur_pos += yyleng; return FOR;}
"beginloop"			{cur_pos += yyleng; return BEGINLOOP;}
"endloop"			{cur_pos += yyleng; return ENDLOOP;}
"continue"			{cur_pos += yyleng; return CONTINUE;}
"read"				{cur_pos += yyleng; return READ;}
"write"				{cur_pos += yyleng; return WRITE;}
"and"				{cur_pos += yyleng; return AND;}
"or"				{cur_pos += yyleng; return OR;}
"not"				{cur_pos += yyleng; return NOT;}
"true"				{cur_pos += yyleng; return TRUE;}
"false"				{cur_pos += yyleng; return FALSE;}
"return"			{cur_pos += yyleng; return RETURN;}

"-"					{cur_pos += yyleng; return SUB;}
"+"					{cur_pos += yyleng; return ADD;}
"*"					{cur_pos += yyleng; return MULT;}
"/"					{cur_pos += yyleng; return DIV;}
"%"					{cur_pos += yyleng; return MOD;}
"=="				{cur_pos += yyleng; return EQ;}
"<>"				{cur_pos += yyleng; return NEQ;}
"<"					{cur_pos += yyleng; return LT;}
">"					{cur_pos += yyleng; return GT;}
"<="				{cur_pos += yyleng; return LTE;}
">="				{cur_pos += yyleng; return GTE;}
";"					{cur_pos += yyleng; return SEMICOLON;}
":"					{cur_pos += yyleng; return COLON;}
","					{cur_pos += yyleng; return COMMA;}
"("					{cur_pos += yyleng; return L_PAREN;}
")"					{cur_pos += yyleng; return R_PAREN;}
"["					{cur_pos += yyleng; return L_SQUARE_BRACKET;}
"]"					{cur_pos += yyleng; return R_SQUARE_BRACKET;}
":="				{cur_pos += yyleng; return ASSIGN;}

({LETTER}({LETTER}|{DIGIT}|"_")*({LETTER}|{DIGIT}))|({LETTER})	{cur_pos += yyleng; yylval.cVal=yytext; return IDENT;}

{DIGIT}+			{cur_pos += yyleng; yylval.iVal=atoi(yytext); return NUMBER;}

"##".*				{cur_pos += yyleng;}

[ \t]+				{cur_pos += yyleng;}

"\n"				{cur_line++; cur_pos = 1;}

.					{printf("Error at line %d, column %d: unrecognized symbol \"%s\"\n",
					cur_line, cur_pos, yytext); exit(0);}

({DIGIT}|"_")({LETTER}|{DIGIT}|"_")*				{printf("Error at line %d, column %d: identifier \"%s\" must begin with a letter\n",
													cur_line, cur_pos, yytext); exit(0);}

{LETTER}({LETTER}|{DIGIT}|"_")*"_"					{printf("Error at line %d, column %d: identifier \"%s\" cannot end with an underscore\n",
													cur_line, cur_pos, yytext); exit(0);}
%%
