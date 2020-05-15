/* 
 * Christopher Moreno
 * CS152 Project_Phase_1
 * Description: Lexical Analyzer for the Mini-L language 
 *              
 * Usage: (1) $ flex mini_l.lex
 *        (2) $ gcc -o lexer lex.yy.c -lfl
 *        (3) $ ./lexer
 *            stdin> whatever you like
 *	      	  stdin> Ctrl-D
 *
 *
 * Below is the basic file layout:
 * DEFINTIONS
 * %%
 * RULES
 * %%
 * USER CODE
 */

%{
	int cur_line = 1;
	int cur_pos = 1;
%}

DIGIT	[0-9]
LETTER	[a-zA-Z]

%%
/*Reserved Words*/

"function"			{cur_pos += yyleng; return FUNCTION;}
"beginparams"		{printf("BEGIN_PARAMS\n"); cur_pos += yyleng;}
"endparams"			{printf("END_PARAMS\n"); cur_pos += yyleng;}
"beginlocals"		{printf("BEGIN_LOCALS\n"); cur_pos += yyleng;}
"endlocals"			{printf("END_LOCALS\n"); cur_pos += yyleng;}
"beginbody"			{printf("BEGIN_BODY\n"); cur_pos += yyleng;}
"endbody"			{printf("END_BODY\n"); cur_pos += yyleng;}
"integer"			{printf("INTEGER\n"); cur_pos += yyleng;}
"array"				{printf("ARRAY\n"); cur_pos += yyleng;}
"of"				{printf("OF\n"); cur_pos += yyleng;}
"if"				{printf("IF\n"); cur_pos += yyleng;}
"then"				{printf("THEN\n"); cur_pos += yyleng;}
"endif"				{printf("ENDIF\n"); cur_pos += yyleng;}
"else"				{printf("ELSE\n"); cur_pos += yyleng;}
"while"				{printf("WHILE\n"); cur_pos += yyleng;}
"do"				{printf("DO\n"); cur_pos += yyleng;}
"for"				{printf("FOR\n"); cur_pos += yyleng;}
"beginloop"			{printf("BEGINLOOP\n"); cur_pos += yyleng;}
"endloop"			{printf("ENDLOOP\n"); cur_pos += yyleng;}
"continue"			{printf("CONTINUE\n"); cur_pos += yyleng;}
"read"				{printf("READ\n"); cur_pos += yyleng;}
"write"				{printf("WRITE\n"); cur_pos += yyleng;}
"and"				{printf("AND\n"); cur_pos += yyleng;}
"or"				{printf("OR\n"); cur_pos += yyleng;}
"not"				{printf("NOT\n"); cur_pos += yyleng;}
"true"				{printf("TRUE\n"); cur_pos += yyleng;}
"false"				{printf("FALSE\n"); cur_pos += yyleng;}
"return"			{printf("RETURN\n"); cur_pos += yyleng;}

"-"					{printf("SUB\n"); cur_pos += yyleng;}
"+"					{printf("ADD\n"); cur_pos += yyleng;}
"*"					{printf("MULT\n"); cur_pos += yyleng;}
"/"					{printf("DIV\n"); cur_pos += yyleng;}
"%"					{printf("MOD\n"); cur_pos += yyleng;}
"=="				{printf("EQ\n"); cur_pos += yyleng;}
"<>"				{printf("NEQ\n"); cur_pos += yyleng;}
"<"					{printf("LT\n"); cur_pos += yyleng;}
">"					{printf("GT\n"); cur_pos += yyleng;}
"<="				{printf("LTE\n"); cur_pos += yyleng;}
">="				{printf("GTE\n"); cur_pos += yyleng;}
";"					{printf("SEMICOLON\n"); cur_pos += yyleng;}
":"					{printf("COLON\n"); cur_pos += yyleng;}
","					{printf("COMMA\n"); cur_pos += yyleng;}
"("					{printf("L_PAREN\n"); cur_pos += yyleng;}
")"					{printf("R_PAREN\n"); cur_pos += yyleng;}
"["					{printf("L_SQUARE_BRACKET\n"); cur_pos += yyleng;}
"]"					{printf("R_SQUARE_BRACKET\n"); cur_pos += yyleng;}
":="				{printf("ASSIGN\n"); cur_pos += yyleng;}

({LETTER}({LETTER}|{DIGIT}|"_")*({LETTER}|{DIGIT}))|({LETTER})	{printf("IDENT %s\n", yytext); cur_pos += yyleng;}

{DIGIT}+			{printf("NUMBER %s\n", yytext); cur_pos += yyleng;}

"##".*				{cur_pos += yyleng;}

[ \t]+				{/* ignore spaces */ cur_pos += yyleng;}

"\n"				{cur_line++; cur_pos = 1;}

.					{printf("Error at line %d, column %d: unrecognized symbol \"%s\"\n",
					cur_line, cur_pos, yytext); exit(0);}
					
({DIGIT}|"_")({LETTER}|{DIGIT}|"_")*				{printf("Error at line %d, column %d: identifier \"%s\" must begin with a letter\n",
													cur_line, cur_pos, yytext); exit(0);}

{LETTER}({LETTER}|{DIGIT}|"_")*"_"					{printf("Error at line %d, column %d: identifier \"%s\" cannot end with an underscore\n",
													cur_line, cur_pos, yytext); exit(0);}

%%

int main(int argc, char ** argv)
{
	if(argc >= 2)
	{
		yyin = fopen(argv[1], "r");
		if(yyin == NULL)
		{
			yyin = stdin;
		}
	}
	else
	{
		yyin = stdin;
	}
	yylex();
}
