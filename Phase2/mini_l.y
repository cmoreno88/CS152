%{
 #include <stdio.h>
 #include <stdlib.h>
 #INCLUDE <string.h>
 void yyerror(const char *msg);
 extern int currLine;
 extern int currPos;
 FILE * yyin;
%}

%union yylval{
	char* str
  double dval;
  int ival;
}

%token FUNCTION BEGIN_PARAMS END_PARAMS BEGIN_LOCALS END_LOCALS
%token BEGIN_BODY END_BODY INTEGER ARRAY OF IF THEN ENDIF ELSE
%token WHILE DO FOR BEGINLOOP ENDLOOP CONTINUE READ WRITE AND OR
%token NOT TRUE FALSE RETURN
%token ADD SUB MULT
%token LTE GTE IDENTIFIER NUMBER ASSIGN FALSE ERRTOK


%% 
input:	
			| input line
			;

line:		exp EQUAL END         { printf("\t%f\n", $1);}
			;

exp:		NUMBER                { $$ = $1; }
			| exp PLUS exp        { $$ = $1 + $3; }
			| exp MINUS exp       { $$ = $1 - $3; }
			| exp MULT exp        { $$ = $1 * $3; }
			| exp DIV exp         { if ($3==0) yyerror("divide by zero"); else $$ = $1 / $3; }
			| MINUS exp %prec UMINUS { $$ = -$2; }
			| L_PAREN exp R_PAREN { $$ = $2; }
			;
%%

int main(int argc, char **argv) {
   if (argc > 1) {
      yyin = fopen(argv[1], "r");
      if (yyin == NULL){
         printf("syntax: %s filename\n", argv[0]);
      }//end if
   }//end if
   yyparse(); // Calls yylex() for tokens.
   return 0;
}

void yyerror(const char *msg) {
   printf("** Line %d, position %d: %s\n", currLine, currPos, msg);
}
