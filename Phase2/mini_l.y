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

function: 				FUNCTION IDENT SEMICOLON BEGIN_PARAMS declarations END_PARAMS BEGIN_LOCALS declarations END_LOCALS BEGIN_BODY statements END_BODY
						{printf("function-> FUNCTION IDENT %s SEMICOLON BEGIN_PARAMS declarations END_PARAMS BEGIN_LOCALS declarations END_LOCALS BEGIN_BODY statements END_BODY\n", $2);}
			
declarations:			/*epsilon*/ {printf("declarations-> epsilon\n");}
						| declaration SEMICOLON declarations {printf("declarations-> declaration SEMICOLON declorations\n");}
				
declaration:			identifier COLON INTEGER {printf("declaration-> identifier COLON INTEGER\n");}
						| identifier COLON ARRAY L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET OF INTEGER 
						{printf("declaration-> identifier COLON ARRAY L_SQUARE_BRACKET NUMBER %d R_SQUARE_BRACKET OF INTEGER\n", $5);}
						| identifier COLON ARRAY L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET OF INTEGER 
						{printf("declaration-> identifier COLON ARRAY L_SQUARE_BRACKET NUMBER %d R_SQUARE_BRACKET L_SQUARE_BRACKET NUMBER %d R_SQUARE_BRACKET OF INTEGER\n", $5, $8);}
				

statements:				statement SEMICOLON statements {printf("statements-> statement SEMICOLON statements\n");}
						| statement SEMICOLON {printf("statements-> statement SEMICOLON\n");}



statement:				var ASSIGN expression {printf("statement-> var ASSIGN expression"\n);}
						| IF bool-expr THEN statements ENDIF {printf("statement-> IF bool-expr THEN statements ENDIF\n");}
						| IF bool-expr THEN statements ELSE statements ENDIF {printf("statement-> IF bool-expr THEN statements ELSE statements ENDIF\n");}
						| WHILE bool-expr BEGINLOOP statements ENDLOOP {printf("statement->WHILE bool-expr BEGINLOOP statements ENDLOOP\n");}
						| DO BEGINLOOP statements ENDLOOP WHILE bool-expr {printf("statement->DO BEGINLOOP statements ENDLOOP WHILE bool-expr");}
						| FOR var ASSIGN NUMBER SEMICOLON bool-expr SEMICOLON var ASSIGN expression BEGINLOOP statements ENDLOOP {printf("statements-> FOR var ASSIGN NUMBER SEMICOLON bool-expr SEMICOLON var ASSIGN expression BEGINLOOP statements ENDLOOP");}
/*PICK UP HEREXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX*/
						| READ var


var:					IDENT
						{printf("var->IDENT %s\n", $1);}
				
expression:				/*epsilon*/ {printf("expression->epsilon\n");}
				
bool-expr:				

relation-and-expr:		

relation-expr:			

comp:					

multiplicative-expr:	

term:					
				
identifier:				IDENT {printf("identifier->IDENT %s\n", $1);}
						| IDENT COMMA identifier {printf("identifier->IDENT %s COMMA identifier", $1);}
			
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
