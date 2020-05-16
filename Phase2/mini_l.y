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
program: 		functions {printf("program->functions\n");}

functions: 		/*epsilon*/ {printf("functions->epsilon\n");}
				| function functions {printf("functions->function functions\n");}

function: 		FUNCTION IDENT SEMICOLON BEGIN_PARAMS declarations END_PARAMS BEGIN_LOCALS declarations END_LOCALS BEGIN_BODY statement SEMICOLON END_BODY
				{printf("function->FUNCTION IDENT %s SEMICOLON BEGIN_PARAMS declarations END_PARAMS BEGIN_LOCALS declarations END_LOCALS BEGIN_BODY statement SEMICOLON END_BODY\n", $2);}
			
declarations:	/*epsilon*/ {printf("declarations->epsilon\n");}
				| declaration SEMICOLON declarations {printf("declarations->declaration SEMICOLON declorations\n");}
				
declaration:	IDENT COLON INTEGER {printf("IDENT %s COMMA COLON INTEGER\n"), $1;}
			
statement:		var ASSIGN expression {printf("statement->var ASSIGN expression");}

var:			IDENT
				{printf("var->IDENT %s\n", $1);}
				
expression:		/*epsilon*/ {printf("expression->epsilon\n");}
				
			
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
