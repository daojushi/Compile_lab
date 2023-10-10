
%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<ctype.h>

#ifndef YYSTYPE
#define YYSTYPE char*
#endif
int yylex();
extern int yyparse();
void yyerror(const char* s);
char numStr[101];
FILE* yyin;
int count = 0;
%}
%token ADD SUB 
%token MUL DIV
%token LPAREN RPAREN
%token NUMBER
%token UMINUS

%left ADD SUB
%left MUL DIV
%right UMINUS   

%%
line  :    line expr ';' { printf("%s\n", $2);count=0;} 
      |    line ';'
      |   
      ;
expr  :    expr ADD expr  { 
        $$ = (char*)malloc(100*sizeof(char)); 
        strcpy($$,$1);
        strcat($$,$3); 
        strcat($$,"+ "); 
    }
      |    expr SUB expr  { 
            $$ = (char*)malloc(100*sizeof(char)); 
            strcpy($$,$1); 
            strcat($$,$3); 
            strcat($$,"- "); 
        }
      |    expr MUL expr  { 
            $$ = (char*)malloc(100*sizeof(char)); 
            strcpy($$,$1); 
            strcat($$,$3); 
            strcat($$,"* "); 
        }
      |    expr DIV expr  { 
            $$ = (char*)malloc(100*sizeof(char)); 
            strcpy($$,$1); 
            strcat($$,$3);
            strcat($$,"/ "); 
        }
      |    LPAREN expr RPAREN   { $$ = $2; }
      |    UMINUS NUMBER  {
            $$ = (char*)malloc(50*sizeof(char)); 
            strcpy($$,"-"); 
            strcat($$,$2); 
            strcat($$," "); 
         }
      |    NUMBER         { 
            $$ = (char*)malloc(100*sizeof(char)); 
            strcpy($$,$1); 
            strcat($$," "); 
        }
      ;
%%

int yylex() 
{
    int ch;
    while(1){
        ch=getchar();
        if(ch==' ' || ch=='\t'||ch=='\n')
            ;
        else if (isdigit(ch)){
            int i=0;
            while(isdigit(ch)){
                numStr[i++]=ch;
                ch=getchar();
            }
            numStr[i]='\0';
            yylval=numStr;
            ungetc(ch,stdin);
            count = 1;
            return NUMBER;
        }
        else if(ch=='-'){
            if(count==0) {
            	return UMINUS;
            }
            else {
            	count = 0;
            	return SUB;
            }
        }
        else if(ch=='+') {
            	count = 0;
            return ADD;  
        }
        else if(ch=='*'){
            	count = 0;
            return MUL;
        }
        else if(ch=='/'){
            	count = 0;
            return DIV;
        }
        else if(ch=='('){
            return LPAREN;
        }
        else if(ch==')'){
            return RPAREN;
        }
        else {
            return ch;
        }
    }
}

int main(void)
{
    yyin = stdin;
    do{
        yyparse();
    } while(!feof(yyin));
    return 0;
}
void yyerror(const char* s){
    fprintf(stderr, "error: %s\n", s);
    exit(1);
}

