/* 
 * Christopher Moreno
 * CS152 LAB_1
 * Description: Lexical Analyzer for the Mini-L language 
 *              
 * Usage: (1) $ flex lab1.lex
 *        (2) $ gcc -o lab1 lex.yy.c -lfl
 *        (3) $ ./lab1
 *            stdin> whatever you like
 *	      	  stdin> Ctrl-D
 *
 *
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
	int numInts = 0;
	int numOps = 0;
	int numParens = 0;
	int numEquals = 0;
%}

DIGIT	[0-9]

%%

"-"		{printf("MINUS\n"); cur_pos += yyleng; numOps++;}
"+"		{printf("PLUS\n"); cur_pos += yyleng; numOps++;}
"*"		{printf("MULT\n"); cur_pos += yyleng; numOps++;}
"/"		{printf("DIV\n"); cur_pos += yyleng; numOps++;}
"="		{printf("EQUAL\n"); cur_pos += yyleng; numEquals++;}
"("		{printf("L_PAREN\n"); cur_pos += yyleng; numParens++;}
")"		{printf("R_PAREN\n"); cur_pos += yyleng; numParens++;}

(\.{DIGIT}+)|({DIGIT}+(\.{DIGIT}*)?([eE][+-]?[0-9]+)?)	{printf("NUMBER %s\n", yytext); cur_pos += yyleng; numInts++;}

[ \t]+		{/* ignore spaces */ cur_pos += yyleng;}

"\n"		{cur_line++; cur_pos = 1;}

.			{printf("Error at line %d, column %d: unrecognized symbol \"%s\"\n",
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
	
	printf("Number of Integers: %d\n", numInts);
	printf("Number of Opertors: %d\n", numOps);
	printf("Number of Parenthesis: %d\n", numParens);
	printf("Number of Equals: %d\n", numEquals);
}
