%{
#include <stdlib.h>
#include <stdio.h>
#include <ctype.h> 
#include <string.h>

#ifndef YYSTYPE
#define YYSTYPE double
#endif

int yylex();
extern int yyparse();
struct symtab* search_sym(char *s);
void yyerror(const char* s);
int count = 0;
FILE* yyin;
%}
%token ADD      
%token SUB
%token MUL
%token DIV
%token LPAREN  RPAREN
%token NUMBER
%token UMINUS

%left ADD  SUB
%left MUL  DIV
%right UMINUS
%%
lines	:	lines expr ';'	{ printf("%f\n", $2);count=0; }
		| 	lines ';'
		|
		;

expr	: 	expr ADD expr { $$ = $1 + $3; }
		| 	expr SUB expr { $$ = $1 - $3; }
		| 	expr MUL expr { $$ = $1 * $3; }
		| 	expr DIV expr { $$ = $1 / $3; }
		| 	LPAREN expr RPAREN { $$ = $2; }
		| 	UMINUS NUMBER { $$ = -$2; }
		| 	NUMBER { $$ = $1; }
		;
%%
int yylex()
{
	int ch;
	while (1)
	{
		ch = getchar();
		if(ch==' ' || ch=='\t'||ch=='\n')
		    ;
		else if (isdigit(ch))
		{
			yylval = 0;
			while (isdigit(ch))
			{
				yylval = yylval * 10 + ch - '0';
				ch = getchar();
			}
			ungetc(ch, stdin);
            		count = 1;
			return NUMBER;
		}
		else
		{	
			
			if(ch=='-'){
			    if(count==0)
			    {
			    	return UMINUS;
			    }
			    else
			    {
			    	count = 0;
			    	return SUB;
			    }
			}
			else if (ch == '+')
			{
            			count = 0;
				return ADD;
			} 
			else if (ch == '*') 
			{
            			count = 0;
				return MUL;
			} 
			else if (ch == '/') 
			{
            			count = 0;
				return DIV;
			} 
			else if (ch == '(') 
				return LPAREN;
			else if (ch == ')') 
				return RPAREN;
			else 
				return ch;
		}
	}
}
int main()
{
	yyin = stdin;
	do {
		yyparse();
	} while (!feof(yyin));
	return 0;
}
void yyerror(const char* s) {
	fprintf(stderr, "error: %s\n", s);
	exit(1);
}
