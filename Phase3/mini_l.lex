/* 
 * Christopher Moreno
 * CS152 Project_Phase_3
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
#include<iostream>
#define YY_DECL yy::parser::symbol_type yylex()
#include <string>
#include "parser.tab.hh"

int cur_line = 1;
int cur_pos = 1;
//char * identVal;

static yy::location loc;
%}

%option noyywrap

%{
#define YY_USER_ACTION loc.columns(yyleng);
%}

DIGIT	[0-9]
LETTER	[a-zA-Z]


/*Reserved Words*/
%%

%{
loc.step();
%}

"function"			{cur_pos += yyleng; return yy::parser::make_FUNCTION(loc);}
"beginparams"		{cur_pos += yyleng; return yy::parser::make_BEGIN_PARAMS(loc);}
"endparams"			{cur_pos += yyleng; return yy::parser::make_END_PARAMS(loc);}
"beginlocals"		{cur_pos += yyleng; return yy::parser::make_BEGIN_LOCALS(loc);}
"endlocals"			{cur_pos += yyleng; return yy::parser::make_END_LOCALS(loc);}
"beginbody"			{cur_pos += yyleng; return yy::parser::make_BEGIN_BODY(loc);}
"endbody"			{cur_pos += yyleng; return yy::parser::make_END_BODY(loc);}
"integer"			{cur_pos += yyleng; return yy::parser::make_INTEGER(loc);}
"array"				{cur_pos += yyleng; return yy::parser::make_ARRAY(loc);}
"of"				{cur_pos += yyleng; return yy::parser::make_OF(loc);}
"if"				{cur_pos += yyleng; return yy::parser::make_IF(loc);}
"then"				{cur_pos += yyleng; return yy::parser::make_THEN(loc);}
"endif"				{cur_pos += yyleng; return yy::parser::make_ENDIF(loc);}
"else"				{cur_pos += yyleng; return yy::parser::make_ELSE(loc);}
"while"				{cur_pos += yyleng; return yy::parser::make_WHILE(loc);}
"do"				{cur_pos += yyleng; return yy::parser::make_DO(loc);}
"for"				{cur_pos += yyleng; return yy::parser::make_FOR(loc);}
"beginloop"			{cur_pos += yyleng; return yy::parser::make_BEGINLOOP(loc);}
"endloop"			{cur_pos += yyleng; return yy::parser::make_ENDLOOP(loc);}
"continue"			{cur_pos += yyleng; return yy::parser::make_CONTINUE(loc);}
"read"				{cur_pos += yyleng; return yy::parser::make_READ(loc);}
"write"				{cur_pos += yyleng; return yy::parser::make_WRITE(loc);}
"and"				{cur_pos += yyleng; return yy::parser::make_AND(loc);}
"or"				{cur_pos += yyleng; return yy::parser::make_OR(loc);}
"not"				{cur_pos += yyleng; return yy::parser::make_NOT(loc);}
"true"				{cur_pos += yyleng; return yy::parser::make_TRUE(loc);}
"false"				{cur_pos += yyleng; return yy::parser::make_FALSE(loc);}
"return"			{cur_pos += yyleng; return yy::parser::make_RETURN(loc);}

"-"					{cur_pos += yyleng; return yy::parser::make_SUB(loc);}
"+"					{cur_pos += yyleng; return yy::parser::make_ADD(loc);}
"*"					{cur_pos += yyleng; return yy::parser::make_MULT(loc);}
"/"					{cur_pos += yyleng; return yy::parser::make_DIV(loc);}
"%"					{cur_pos += yyleng; return yy::parser::make_MOD(loc);}
"=="				{cur_pos += yyleng; return yy::parser::make_EQ(loc);}
"<>"				{cur_pos += yyleng; return yy::parser::make_NEQ(loc);}
"<"					{cur_pos += yyleng; return yy::parser::make_LT(loc);}
">"					{cur_pos += yyleng; return yy::parser::make_GT(loc);}
"<="				{cur_pos += yyleng; return yy::parser::make_LTE(loc);}
">="				{cur_pos += yyleng; return yy::parser::make_GTE(loc);}
";"					{cur_pos += yyleng; return yy::parser::make_SEMICOLON(loc);}
":"					{cur_pos += yyleng; return yy::parser::make_COLON(loc);}
","					{cur_pos += yyleng; return yy::parser::make_COMMA(loc);}
"("					{cur_pos += yyleng; return yy::parser::make_L_PAREN(loc);}
")"					{cur_pos += yyleng; return yy::parser::make_R_PAREN(loc);}
"["					{cur_pos += yyleng; return yy::parser::make_L_SQUARE_BRACKET(loc);}
"]"					{cur_pos += yyleng; return yy::parser::make_R_SQUARE_BRACKET(loc);}
":="				{cur_pos += yyleng; return yy::parser::make_ASSIGN(loc);}

({LETTER}({LETTER}|{DIGIT}|"_")*({LETTER}|{DIGIT}))|({LETTER})	{cur_pos += yyleng; return yy::parser::make_IDENT(yytext, loc);}

{DIGIT}+			{cur_pos += yyleng; return yy::parser::make_NUMBER(atoi(yytext), loc);}

"##".*				{cur_pos += yyleng;}

[ \t]+				{cur_pos += yyleng;}

"\n"				{cur_line++; cur_pos = 1;}

.					{printf("Error at line %d, column %d: unrecognized symbol \"%s\"\n",
					cur_line, cur_pos, yytext); exit(0);}

({DIGIT}|"_")({LETTER}|{DIGIT}|"_")*				{printf("Error at line %d, column %d: identifier \"%s\" must begin with a letter\n",
													cur_line, cur_pos, yytext); exit(0);}

{LETTER}({LETTER}|{DIGIT}|"_")*"_"					{printf("Error at line %d, column %d: identifier \"%s\" cannot end with an underscore\n",
													cur_line, cur_pos, yytext); exit(0);}

<<EOF>>				{return yy::parser::make_END(loc);}

%%
