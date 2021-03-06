%{
%}

%skeleton "lalr1.cc"
%require "3.0.4"
%defines
%define api.token.constructor
%define api.value.type variant
%define parse.error verbose
%locations

%code requires
{
/* you may need these header files, add more header file if you need more*/
#include <list>
#include <fstream>
#include <string>
#include <cstring>
#include <functional>
using namespace std;
	
/* define the sturctures using as types for non-terminals */
struct gen_type {
	string code;
	string place;
	list <string> ids;
	};
/* end the structures for non-terminal types */
}


%code
{
	#include "parser.tab.hh"

	/* you may need these header files 
	 * add more header file if you need more
	 */
	#include <sstream>
	#include <map>
	#include <regex>
	#include <set> 
	yy::parser::symbol_type yylex();
	void yyerror(const char *msg);		/*declaration given by TA*/
	bool no_error = true;				// Set when an error occurs
	string pgmName;				// Holds function name
	int num_temps = 0;
	string empty = "";

		/* define your symbol table, global variables,
		* list of keywords or any function you may need here */
	
		/* end of your code */

	//temporary labels for generating code
	string make_temps(){
		string ret = "_temp_" + to_string(num_temps);
		num_temps++;
		return ret;
	}
//	map <string, int> symbol_table;
}


/*Used to give tokens a type*/
/* specify tokens, type of non-terminals and terminals here
*  end of token specifications, tokens, bison makes these constant variables
*/


%token END 0 "end of file";

%token FUNCTION SEMICOLON TRUE FALSE RETURN
%token BEGIN_PARAMS END_PARAMS BEGIN_LOCALS
%token END_LOCALS BEGIN_BODY END_BODY INTEGER
%token ARRAY OF IF THEN ENDIF ELSE WHILE DO FOR
%token BEGINLOOP ENDLOOP CONTINUE READ WRITE
%token COLON COMMA 
%right ASSIGN
%left OR
%left AND
%right NOT
%left LT LTE GT GTE EQ NEQ 
%left ADD SUB
%left MULT DIV MOD 
%right UMINUS
%left L_SQUARE_BRACKET R_SQUARE_BRACKET
%left L_PAREN R_PAREN

%token <string> IDENT
%token <int> NUMBER

%start start_func
%type <string> functions function LT LTE GT GTE EQ NEQ comp SUB ADD MULT DIV MOD
%type <gen_type> identifier statements declarations declaration expressions expression var vars statement term multiplicative-expr relation-and-expr relation-expr

%%

start_func:				functions 
						{
							if (no_error)
							{
								ofstream out_Handler;
								out_Handler.open(pgmName.c_str(), fstream::out);
								out_Handler << $1;
								out_Handler.close();
							}
						}
						/*Your input from *.min and output to *.mil happen here*/
						
functions: 				/*epsilon*/ {$$ = "";}
						| function functions {$$ = $1 + "\n" + $2;}

function: 				FUNCTION identifier SEMICOLON BEGIN_PARAMS declarations END_PARAMS BEGIN_LOCALS declarations END_LOCALS BEGIN_BODY statements END_BODY
						{	
							pgmName.append($2.code);
							pgmName.append(".mil");
							$$ = "func " + $2.code + "\n";
							$$ += $5.code + "\n";
							$$ += $8.code + "\n";
							$$ += $11.code + "\n";
							$$ += "endfunc";
						}
			
declarations:			/*epsilon*/ {$$.code = "";}
						| declaration SEMICOLON declarations 
						{
							$$.code = $1.code + "\n";
							$$.code += $3.code + "\n";
						}
				
declaration:			identifier COLON INTEGER 
						{
							$$.code = "." + $1.code + "\n";
						}
						| identifier COLON ARRAY L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET OF INTEGER 
						{
							$$.code = ".[] " + $1.code.append(", ") + to_string($5);
						}
						| identifier COLON ARRAY L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET OF INTEGER 
						{
							$$.code = ".[] " + $1.code.append(", ") + to_string($5) + "[] " + to_string($8);
						}
				

statements:				statement SEMICOLON statements
						{
							printf("statements-> statement SEMICOLON statements\n");
						}
						| statement SEMICOLON
						{
							printf("statements-> statement SEMICOLON\n");
						}


statement:				vars ASSIGN expressions
						{
							printf("statement-> var ASSIGN expressions\n");
						}
						| IF bool-expr THEN statements ENDIF
						{
							printf("statement-> IF bool-expr THEN statements ENDIF\n");
						}
						| IF bool-expr THEN statements ELSE statements ENDIF
						{
							printf("statement-> IF bool-expr THEN statements ELSE statements ENDIF\n");
						}
						| WHILE bool-expr BEGINLOOP statements ENDLOOP
						{
							printf("statement-> WHILE bool-expr BEGINLOOP statements ENDLOOP\n");
						}
						| DO BEGINLOOP statements ENDLOOP WHILE bool-expr
						{
							printf("statement-> DO BEGINLOOP statements ENDLOOP WHILE bool-expr\n");
						}
						| FOR vars ASSIGN NUMBER SEMICOLON bool-expr SEMICOLON vars ASSIGN expressions BEGINLOOP statements ENDLOOP
						{
							printf("statements-> FOR vars ASSIGN NUMBER SEMICOLON bool-expr SEMICOLON vars ASSIGN expressions BEGINLOOP statements ENDLOOP\n");
						}
						| READ vars 
						{
							printf("statement-> READ vars\n");
						}
						| WRITE vars
						{
							printf("statement-> WRITE vars\n");
						}
						| CONTINUE
						{
							printf("statement-> CONTINUE\n");
						}
						| RETURN expressions
						{
							printf("statement-> RETURN expressions\n");
						}

vars:					var COMMA vars
						{
							$$.code = $1.code + $3.code;
						}
						| var
						{
							$$.code = $1.code;
						}

var:					identifier
						{
							$$.code = $1.code;
						}
						| identifier L_SQUARE_BRACKET expressions R_SQUARE_BRACKET 
						{
							$$.code = $1.code + "[" + $3.code + "]";
						}
						| identifier L_SQUARE_BRACKET expressions R_SQUARE_BRACKET L_SQUARE_BRACKET expressions R_SQUARE_BRACKET
						{
							$$.code = $1.code + "[" + $3.code + "][" + $6.code + "]";
						}

comp:					EQ {$$ = $1;}
						| NEQ {$$ = $1;}
						| LT {$$ = $1;}
						| GT {$$ = $1;}
						| LTE {$$ = $1;}
						| GTE {$$ = $1;}

expressions:			/*epsilon*/ {$$.code = "";}
						| expression 
						{
							$$.code = $1.code;
						}
						| expression COMMA expressions
						{
							$$.code = $1.code;
							$$.code += $3.code;
						} 
				
expression:				multiplicative-expr
						{
							$$.code = $1.code;
						}
						| multiplicative-expr ADD expression
						{
							$$.code = $1.code + $2 + $3.code;
						}
						| multiplicative-expr SUB expression
						{
							$$.code = $1.code + $2 + $3.code;
						}

				
bool-expr:				relation-and-expr
						{
							printf("bool-expr-> relation-and-expr\n");
						}
						| relation-and-expr OR bool-expr
						{
							printf("bool-expr-> relation-and-expr OR bool-expr\n");
						}

relation-and-expr:		relation-expr
						{
							printf("relation-and-expr-> relation-expr\n");
						}
						|relation-expr AND relation-and-expr
						{
							printf("relation-and-expr-> relation-expr AND relation-and-expr\n");
						}

relation-expr:			expression comp expression
						{
							printf("realtion-expr-> expression comp expression\n");
						}
						| TRUE
						{
							printf("realtion-expr-> TRUE\n");
						}
						| FALSE
						{
							printf("realtion-expr-> FALSE\n");
						}
						| identifier L_PAREN bool-expr R_PAREN
						{
							printf("realtion-expr-> identifier L_PAREN bool-expr R_PAREN\n");
						}
						| NOT expression comp expression
						{
							printf("realtion-expr-> NOT expression comp expression\n");
						}
						| NOT TRUE
						{
							printf("realtion-expr-> NOT TRUE\n");
						}
						| NOT FALSE 
						{
							printf("realtion-expr-> NOT FALSE\n");
						}
						| NOT identifier L_PAREN bool-expr R_PAREN
						{
							printf("realtion-expr-> NOT identifier L_PAREN bool-expr R_PAREN\n");
						}


multiplicative-expr:	term
						{
							$$.code = $1.code;
						}
						| term MULT multiplicative-expr
						{
							$$.code = $1.code + $2 + $3.code;
						}
						| term DIV multiplicative-expr
						{
							$$.code = $1.code + $2 + $3.code;
						}
						| term MOD multiplicative-expr
						{
							$$.code = $1.code + $2 + $3.code;
						}

term:					var
						{
							$$.code = $1.code;
						}
						| SUB var
						{
							$$.code = $1 + $2.code;
						}
						| NUMBER
						{
							$$.code = to_string($1);
						}
						| SUB NUMBER
						{
							$$.code = $1 + to_string($2);
						}
						| L_PAREN expression R_PAREN
						{
							$$.code = "(" + $2.code + ")";
						}
						| SUB L_PAREN expression R_PAREN 
						{
							$$.code = $1 + "(" + $3.code + ")";
						}
						| identifier L_PAREN expressions R_PAREN
						{
							$$.code = $1.code + "(" + $3.code + ")";
						}
						
identifier:				IDENT {$$.code = $1;}	//{$$.code.assign($1);}assign() sets the IDENT string value
						| IDENT COMMA identifier 
						{
							$$.code = $1 + $3.code;
						}		

%%

int main(int argc, char *argv[])
{
	yy::parser p;
	return p.parse();
}

void yy::parser::error(const yy::location& l, const std::string& m)
{
	std::cerr << l << ": " << m << std::endl;
}
