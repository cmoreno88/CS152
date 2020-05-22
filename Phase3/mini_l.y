/* 
 * Christopher Moreno
 * CS152 Project_Phase_2
 * Description: Parser for the Mini-L language 
 *    
 *
 * Below is the basic file layout:
 * DEFINTIONS
 * %%
 * GRAMMAR
 * %%
 * USER CODE
 */
%{
 #include <stdio.h>
 #include <stdlib.h>
 void yyerror(const char *msg);		/*declaration given by TA*/
 //extern char * identVal;
 extern int cur_line;
 extern int cur_pos;
 FILE * yyin;
%}

/*Used to give tokens a type*/
%union{
  char * cVal;
  int iVal;
}

/*tokens, bison makes these constant variables*/
%token <cVal> IDENT
%token <iVal> NUMBER
%token FUNCTION SEMICOLON TRUE FALSE RETURN
%token BEGIN_PARAMS END_PARAMS BEGIN_LOCALS
%token END_LOCALS BEGIN_BODY END_BODY INTEGER
%token ARRAY OF IF THEN ENDIF ELSE WHILE DO FOR
%token BEGINLOOP ENDLOOP CONTINUE READ WRITE
%token COLON COMMA 

%left L_PAREN R_PAREN AND OR
%left L_SQUARE_BRACKET R_SQUARE_BRACKET
%left MULT DIV MOD ADD SUB LT LTE GT GTE EQ NEQ 

%right ASSIGN NOT

%error-verbose
%start program

/*GRAMMAR
Some productions from the chart need 
to be split up into terminal and 
Non-Terminal versions like function
Psuedo variables:
$$ : $1 $2 $3 etc
THIS is an example of calling yyerror
exp:		NUMBER                { $$ = $1; }
			| exp PLUS exp        { $$ = $1 + $3; }
			| exp MINUS exp       { $$ = $1 - $3; }
			| exp MULT exp        { $$ = $1 * $3; }
			| exp DIV exp         { if ($3==0) yyerror("divide by zero"); else $$ = $1 / $3; }
			| MINUS exp %prec UMINUS { $$ = -$2; }
			| L_PAREN exp R_PAREN { $$ = $2; }
			;
For EPSILON in one of the production rules we can handle it the
same way we did with program->functions->function
*/

%%
program:	 			functions {printf("program-> functions\n");}

functions: 				/*epsilon*/ {printf("functions-> epsilon\n");}
						| function functions {printf("functions-> function functions\n");}

function: 				FUNCTION identifier SEMICOLON BEGIN_PARAMS declarations END_PARAMS BEGIN_LOCALS declarations END_LOCALS BEGIN_BODY statements END_BODY
						{printf("function-> FUNCTION identifier SEMICOLON BEGIN_PARAMS declarations END_PARAMS BEGIN_LOCALS declarations END_LOCALS BEGIN_BODY statements END_BODY\n");}
			
declarations:			/*epsilon*/ {printf("declarations-> epsilon\n");}
						| declaration SEMICOLON declarations {printf("declarations-> declaration SEMICOLON declorations\n");}
				
declaration:			identifier COLON INTEGER {printf("declaration-> identifier COLON INTEGER\n");}
						| identifier COLON ARRAY L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET OF INTEGER 
						{printf("declaration-> identifier COLON ARRAY L_SQUARE_BRACKET NUMBER %d R_SQUARE_BRACKET OF INTEGER\n", $5);}
						| identifier COLON ARRAY L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET OF INTEGER 
						{printf("declaration-> identifier COLON ARRAY L_SQUARE_BRACKET NUMBER %d R_SQUARE_BRACKET L_SQUARE_BRACKET NUMBER %d R_SQUARE_BRACKET OF INTEGER\n", $5, $8);}
				

statements:				/*epsilon*/ {printf("statements-> epsilon\n");}
						| statement SEMICOLON statements {printf("statements-> statement SEMICOLON statements\n");}
						/*| statement SEMICOLON {printf("statements-> statement SEMICOLON\n");}*/



statement:				vars ASSIGN expressions {printf("statement-> var ASSIGN expressions\n");}
						| IF bool-expr THEN statements ENDIF {printf("statement-> IF bool-expr THEN statements ENDIF\n");}
						| IF bool-expr THEN statements ELSE statements ENDIF {printf("statement-> IF bool-expr THEN statements ELSE statements ENDIF\n");}
						| WHILE bool-expr BEGINLOOP statements ENDLOOP {printf("statement-> WHILE bool-expr BEGINLOOP statements ENDLOOP\n");}
						| DO BEGINLOOP statements ENDLOOP WHILE bool-expr {printf("statement-> DO BEGINLOOP statements ENDLOOP WHILE bool-expr\n");}
						| FOR vars ASSIGN NUMBER SEMICOLON bool-expr SEMICOLON vars ASSIGN expressions BEGINLOOP statements ENDLOOP {printf("statements-> FOR vars ASSIGN NUMBER SEMICOLON bool-expr SEMICOLON vars ASSIGN expressions BEGINLOOP statements ENDLOOP\n");}
						| READ vars {printf("statement-> READ vars\n");}
						| WRITE vars {printf("statement-> WRITE vars\n");}
						| CONTINUE {printf("statement-> CONTINUE\n");}
						| RETURN expressions {printf("statement-> RETURN expressions\n");}

vars:					var COMMA vars {printf("vars-> var COMMA vars\n");}
						| var {printf("vars-> var\n");}

var:					identifier {printf("var-> identifier\n");}
						| identifier L_SQUARE_BRACKET expressions R_SQUARE_BRACKET {printf("var-> identifier L_SQUARE_BRACKET expressions R_SQUARE_BRACKET\n");}
						| identifier L_SQUARE_BRACKET expressions R_SQUARE_BRACKET L_SQUARE_BRACKET expressions R_SQUARE_BRACKET {printf("var-> identifier L_SQUARE_BRACKET expressions R_SQUARE_BRACKET L_SQUARE_BRACKET expressions R_SQUARE_BRACKET\n");}

comp:					EQ {printf("comp-> EQ\n");}
						| NEQ {printf("comp-> NEQ\n");}
						| LT {printf("comp-> LT\n");}
						| GT {printf("comp-> GT\n");}
						| LTE {printf("comp-> LTE\n");}
						| GTE {printf("comp-> GTE\n");}

expressions:			/*epsilon*/ {printf("expressions-> epsilon\n");}
						| expression {printf("expressions-> expression\n");}
						| expression COMMA expressions {printf("expressions-> expression COMMA expressions\n");} 
				
expression:				multiplicative-expr {printf("expression-> multiplicative-expr\n");}
						| multiplicative-expr ADD expression {printf("expression-> multiplicative-expr ADD expression\n");}
						| multiplicative-expr SUB expression {printf("expression-> multiplicative-expr SUB expression\n");}

				
bool-expr:				relation-and-expr {printf("bool-expr-> relation-and-expr\n");}
						| relation-and-expr OR bool-expr {printf("bool-expr-> relation-and-expr OR bool-expr\n");}

relation-and-expr:		relation-expr {printf("relation-and-expr-> relation-expr\n");}
						|relation-expr AND relation-and-expr {printf("relation-and-expr-> relation-expr AND relation-and-expr\n");}

relation-expr:			expression comp expression {printf("realtion-expr-> expression comp expression\n");}
						| TRUE {printf("realtion-expr-> TRUE\n");}
						| FALSE {printf("realtion-expr-> FALSE\n");}
						| identifier L_PAREN bool-expr R_PAREN {printf("realtion-expr-> identifier L_PAREN bool-expr R_PAREN\n");}
						| NOT expression comp expression {printf("realtion-expr-> NOT expression comp expression\n");}
						| NOT TRUE {printf("realtion-expr-> NOT TRUE\n");}
						| NOT FALSE {printf("realtion-expr-> NOT FALSE\n");}
						| NOT identifier L_PAREN bool-expr R_PAREN {printf("realtion-expr-> NOT identifier L_PAREN bool-expr R_PAREN\n");}


multiplicative-expr:	term {printf("multiplicative-expr-> term\n");}
						| term MULT multiplicative-expr {printf("multiplicative-expr-> term MULT multiplicative-expr\n");}
						| term DIV multiplicative-expr {printf("multiplicative-expr-> term DIV multiplicative-expr\n");}
						| term MOD multiplicative-expr {printf("multiplicative-expr-> term MOD multiplicative-expr\n");}

term:					var {printf("term->vars\n");}
						| SUB var {printf("term-> SUB vars\n");}
						| NUMBER {printf("term-> NUMBER %d\n", $1);}
						| SUB NUMBER {printf("term-> SUB NUMBER %d\n", $2);}
						| L_PAREN expression R_PAREN{printf("term-> L_PAREN expression R_PAREN\n");}
						| SUB L_PAREN expression R_PAREN {printf("term-> SUB L_PAREN expression R_PAREN\n");}
						| identifier L_PAREN expressions R_PAREN {printf("term-> identifier L_PAREN expressions R_PAREN\n");}
						
identifier:				IDENT {printf("identifier-> IDENT %s\n", $1);}
						| IDENT COMMA identifier {printf("identifier-> IDENT %s COMMA identifier\n", $1);}
			
%%


/* %d is for digit in C*/

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
	yyparse();			// calls yylex()
	
	return 1;
}

void yyerror(const char *msg) {
   printf("** Line %d, position %d: %s\n", cur_line, cur_pos, msg);
}
