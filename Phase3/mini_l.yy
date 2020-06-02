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
	/* you may need these header files 
	 * add more header file if you need more
	 */
#include <list>
#include <string>
#include <functional>
using namespace std;
	/* define the sturctures using as types for non-terminals */
struct dec_type {
	string code;
	list <string> ids;
}
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
bool no_error = true;
int num_temps = 0;

	/* define your symbol table, global variables,
	 * list of keywords or any function you may need here */
	
	/* end of your code */

string make_temps(){
	string ret = "_temp_" + itoa(num_temps);
	num_temps++;
}
	
map <string, int> symbol_table;
}


/*Used to give tokens a type*/
/* specify tokens, type of non-terminals and terminals here
* end of token specifications
* tokens, bison makes these constant variables
*/


%token END 0 "end of file";
%token <string> IDENT
%token <int> NUMBER
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

%start start_func
%type <string> functions function declarations declaration
%type <dec_type>

%%

start_func:				functions {if (no_error) cout << $1 << endl;}

functions: 				/*epsilon*/ {$$ = "";}
						| function functions {$$ = $1 + "\n" + $2;}

function: 				FUNCTION identifier SEMICOLON BEGIN_PARAMS declarations END_PARAMS BEGIN_LOCALS declarations END_LOCALS BEGIN_BODY statements END_BODY
						{$$ = "func " + $2 + "\n";
						 $$ = 
						 $$ += "endfunc" ; 
						}
			
declarations:			/*epsilon*/ {printf("declarations-> epsilon\n");}
						| declaration SEMICOLON declarations {printf("declarations-> declaration SEMICOLON declorations\n");}
				
declaration:			identifier COLON INTEGER {printf("declaration-> identifier COLON INTEGER\n");}
						| identifier COLON ARRAY L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET OF INTEGER 
						{printf("declaration-> identifier COLON ARRAY L_SQUARE_BRACKET NUMBER %d R_SQUARE_BRACKET OF INTEGER\n", $5);}
						| identifier COLON ARRAY L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET OF INTEGER 
						{printf("declaration-> identifier COLON ARRAY L_SQUARE_BRACKET NUMBER %d R_SQUARE_BRACKET L_SQUARE_BRACKET NUMBER %d R_SQUARE_BRACKET OF INTEGER\n", $5, $8);}
				

statements:				statement SEMICOLON statements {printf("statements-> statement SEMICOLON statements\n");}
						| statement SEMICOLON {printf("statements-> statement SEMICOLON\n");}



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
						
identifier:				IDENT {cout<< "identifier-> IDENT " << $1 << endl;}
						| IDENT COMMA identifier {cout << "identifier-> IDENT " << $1 << " COMMA identifier" << endl;}
			
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
