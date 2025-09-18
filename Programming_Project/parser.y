%{
	#include <stdio.h>
    #include "cgen.h"
	#include <string.h>
	extern int yylex(void);

	//flag to check if we are in a struct
	//flag = 0 -- not in a struct
	//flag = 1 -- in a  struct 
	//we use it for printing function deferrently 
	int flag_struct = 0; 

	char bufferName[600]; 
	char bufferCode[600];
	FILE *pointer;
%}

%union {
	char* str;
}

%token <str> TK_ID
%token <str> TK_INT 
%token <str> TK_REAL 
%token <str> TK_CONSTRING
%token <str> TK_LINECOMMENTS;

%token KW_IF   
%token KW_ELSE 
%token KW_DEF
%token KW_MAIN
%token KW_ENDDEF
%token KW_INTEGER
%token KW_SCALAR 
%token KW_STR
%token KW_BOOLEAN
%token KW_RETURN
%token KW_COMP
%token KW_ENDCOMP
%token KW_AND
%token KW_OR
%token KW_NOT
%token KW_LESSE;
%token KW_GREATERE;
%token KW_E;
%token KW_TRUE;
%token KW_FALSE;
%token KW_NOTE;
%token KW_PLUSE;
%token KW_MINUSE;
%token KW_MULTE;
%token KW_DIVE;
%token KW_MODE;
%token KW_DE;
%token KW_P;
%token KW_ENDIF;
%token KW_FOR;
%token KW_ENDFOR;
%token KW_IN;
%token KW_WHILE;
%token KW_ENDWHILE;
%token KW_BREAK;
%token KW_CONTINUE;
%token KW_OF;
%token KW_CONST;

%start program

%type <str> header
%type <str> main
%type <str> code 
%type <str> instr
%type <str> empty
%type <str> continue
%type <str> comp
%type <str> loops
%type <str> new_table_from_table
%type <str> return 
%type <str> if
%type <str> break
%type <str> function
%type <str> ex
%type <str> parameters
%type <str> parameter
%type <str> exList
%type <str> decl
%type <str> types
%type <str> ex_instr
%type <str> comments

%left '[' ']' '.' '(' ')' 
%left KW_P '+' '-'
%left '*' '/' '%'
%left '<' KW_LESSE
%left '>' KW_GREATERE
%left KW_E KW_NOTE
%left KW_NOT
%left KW_AND
%left KW_OR
%left '='
%left KW_MULTE KW_PLUSE KW_DIVE KW_MINUSE   KW_MODE KW_DE

%%
program:
 header code main  { fprintf(pointer,"%s %s %s\n", $1, $2, $3); }
 |header main  { fprintf(pointer,"%s %s\n", $1, $2); }
;

header:
	 %empty
{ $$ = template("#include <stdio.h>\n#include \"kappalib.h\"\n"); }
;

main:
	KW_DEF KW_MAIN '(' ')' ':'code KW_ENDDEF ';' { $$= template("\tint main(){\n%s\n}\n", $6); }
;

code:
	instr
	|code instr { $$ = template("%s %s", $1, $2); }
;

//all the instructions of our code 
instr:
	ex_instr	
	|break 
	|decl 	
	|return  
	|if 
	|comp 
	|loops
	|continue 
	|empty	
	|new_table_from_table
	|comments
;


//skip personal belief we shouldnt carry comments
comments:
	TK_LINECOMMENTS { $$ = template(""); }
;

ex_instr:
 ex ';'	{ $$ = template("%s;\n", $1); }
;

function:
    KW_DEF TK_ID '(' parameters ')' '-' '>' types ':' code KW_ENDDEF 
    {if(flag_struct == 0){
    $$ = template("%s %s(%s){%s}", $8, $2, $4, $10);
    }
    else{
    strcat(bufferName, template(".%s=%s ,", $2, $2));
    strcat(bufferCode, template("%s %s(SELF,%s){%s\n}", $8, $2, $4, $10));
    $$ = template("%s %s(%s){}", $8, $2, $4);
    }}
    |KW_DEF TK_ID '(' parameters ')' ':' code KW_ENDDEF 
    {if(flag_struct == 0){
    $$ = template("void %s(%s){%s}", $2, $4, $7);
    }
    else{
    strcat(bufferCode, template("void %s(SELF,%s){%s\n}", $2, $4, $7));
    strcat(bufferName, template(".%s=%s ,", $2, $2));
    $$ = template("void %s(%s){}", $2, $4);
    } }
    |KW_DEF TK_ID '(' ')' '-' '>' types ':' code KW_ENDDEF 
    {if(flag_struct == 0){
    $$ = template("%s %s(){%s}", $7, $2, $9); }
    else{
    strcat(bufferCode, template("%s %s(SELF){%s\n}", $7, $2, $9));
    strcat(bufferName, template(".%s=%s ,",$2,$2));
    $$ = template("%s %s(){}", $7, $2);
    }}
    |KW_DEF TK_ID '(' ')' ':' code KW_ENDDEF 
    {if(flag_struct == 0){
    $$ = template("void  %s(){%s}", $2, $6);
    }
    else{
	 strcat(bufferCode, template("void %s(SELF){%s\n}",$2,$6));
    strcat(bufferName, template(".%s=%s ,",$2,$2));
    $$ = template("void  %s(){}", $2);
    }}
    |KW_DEF TK_ID '(' ')' ':' KW_ENDDEF 
    {if(flag_struct == 0){
    $$ = template("void  %s(){}", $2);
    }
    else{
    strcat(bufferCode, template("void %s(SELF){}", $2));
    strcat(bufferName, template(".%s=%s ,", $2, $2));
    $$ = template("void  %s(){}", $2);
    }}
;
empty:
	';' { $$ = template(";\n"); }
;

continue:
	KW_CONTINUE ';'{ $$ = template("continue;\n"); }
;

comp:
	KW_COMP TK_ID ':' {flag_struct=1;} code {flag_struct=0;} KW_ENDCOMP ';'  {
	$$ = template("typedef struct %s{\n%s\n}%s;\n%s\nconst %s ctor_%s={%s};\n\n", $2, $5, $2, bufferCode, $2, $2, bufferName);
	memset(bufferCode, 0, sizeof(bufferCode));
	memset(bufferName, 0, sizeof(bufferName)); }
;

loops:
	KW_FOR TK_ID KW_IN '[' TK_INT ':' ex ']' ':' code KW_ENDFOR ';' { $$ = template("for(int i=0; i<%s; i++){\n%s}", $7, $10); }
	|KW_FOR TK_ID KW_IN '[' TK_INT ':' ex ':' TK_INT']' ':' code KW_ENDFOR ';' { $$ = template("for(int %s=%s; %s<%s; %s+=%s){\n%s\n}", $2, $5, $2, $7, $2, $9, $12); }
	|KW_WHILE '(' ex ')' ':' code KW_ENDWHILE ';' { $$ = template("while( %s ){\n%s\n}", $3, $6); }
;




new_table_from_table:
	TK_ID KW_DE '[' ex KW_FOR TK_ID ':' TK_INT ']' ':' types ';'
	{ $$ = template("%s* %s=(%s*) malloc(%s*sizeof(%s));\nfor(int %s=0;%s<%s;++%s;){\n%s[%s]=%s;\n}", $11, $1, $11, $8, $11, $6, $6, $8, $6, $1, $6, $4); }
	|TK_ID KW_DE '[' ex KW_FOR TK_ID ':' types KW_IN TK_ID KW_OF TK_INT ']' ':' types ';' {
	//take tokens seperated by spaces
	char* token = strtok($4," ");
	char* pointerTemp;

	char* pointerAfter = (char *)malloc(1000);

	while(token!=NULL){
		//check the token 
		//if token is $6 change it with $10 else keep it 
		if(strcmp(token,$6)){
			pointerTemp = (char *)malloc(sizeof(token));
			strcpy(pointerTemp,token);
		}else{
			pointerTemp = (char *)malloc(sizeof(template("%s[%s_i]",$10,$10)));
			strcpy(pointerTemp,template("%s[%s_i]",$10,$10));
		}
		//if pointer is empty take the first token else
		//add the new token to end String
		if(pointerAfter == NULL){
			strcpy(pointerAfter,pointerTemp);
		}else{
			strcat(pointerAfter,pointerTemp);
		}

	   token = strtok(NULL," ");
	}
	//print the results
	$$ = template("%s* %s =(%s*)malloc(%s*sizeof(%s));\nfor(int %s_i=0;%s_i<%s;++%s_i){\n%s[%s_i] = %s;\n}",$15,$1,$15,$12,$15,$10,$10,$12,$10,$1,$10,pointerAfter);
	free(pointerAfter);
	}


return :
	KW_RETURN ';'{ $$ = template("return ;\n"); }
	|KW_RETURN ex  ';'{ $$ = template("return %s;\n", $2); }

;

if:
	KW_IF '(' ex ')' ':' code KW_ENDIF ';'	{ $$ = template("if( %s ){\n%s\n}", $3, $6); }
	|KW_IF '(' ex ')' ':' code KW_ELSE ':' code KW_ENDIF ';'{ $$ = template("if(%s){\n%s\n}else{\n%s\n}", $3, $6, $9); }
;

break:
	KW_BREAK ';' { $$ = template("break;\n"); }
;

function:
	TK_ID '(' ')' { $$ = template("%s()", $1); }	
	| TK_ID'(' exList ')' { $$ = template("%s(%s)", $1, $3); }
	| '#' TK_ID '(' ')' { $$ = template("%s", $2); }
	| '#' TK_ID '(' exList ')' { $$ = template("%s(%s)", $2, $4); }
;

ex:
	TK_INT
	| '-' TK_INT { $$ = template("-%s", $2);}
	| TK_REAL 
	| '-' TK_REAL {  $$ = template("-%s", $2);}
	| KW_TRUE      { $$ = template("1"); }
	| KW_FALSE		{ $$ = template("0"); }
	| TK_ID
	| '-' TK_ID { $$ = template("-%s", $2);}
	| '#' TK_ID { $$ = template("%s", $2); }
	| '-' '#' TK_ID { $$ = template("-%s", $3); }
	| '#' TK_ID '[' ex ']' { $$ = template("%s[%s]", $2, $4); }
 	| '#' TK_ID '['  ']'{ $$ = template("%s[]", $2); }
	| TK_ID '[' ex ']' { $$ = template("%s[%s]", $1, $3); }
	| TK_ID '[' ']' { $$ = template("%s[]", $1); } 
	| TK_CONSTRING
	|	ex '.' ex { $$ = template("%s . %s", $1, $3); }
	| ex '/' ex { $$ = template("%s / %s", $1, $3); }
	| ex '=' ex { $$ = template("%s = %s", $1, $3); }	
	| ex '+' ex { $$ = template("%s + %s", $1, $3); }
	| ex '-' ex { $$ = template("%s - %s", $1, $3); }
	| ex '*' ex { $$ = template("%s * %s", $1, $3); }
	| ex '%' ex { $$ = template("%s %% %s", $1, $3); }
	| ex '>' ex	{ $$ = template("%s > %s", $1, $3); }
	| ex '<' ex 	{ $$ = template("%s < %s", $1, $3); }
	| ex KW_E ex { $$ = template("%s == %s", $1, $3); }
	| ex KW_AND ex { $$ = template("%s && %s", $1, $3); }
	| ex KW_OR ex { $$ = template("%s || %s", $1, $3); }
	| ex KW_NOT ex { $$ = template("%s !( %s )", $1, $3); }	
	| ex KW_LESSE ex { $$ = template("%s <= %s", $1, $3); }
	| ex KW_GREATERE ex { $$ = template("%s >= %s", $1, $3); }
	| ex KW_NOTE ex { $$ = template("%s != %s", $1, $3); }
	| ex KW_P ex { $$ = template("%s ^ %s", $1, $3); }
	| KW_NOT ex { $$ = template("not %s", $2); }
	| ex KW_PLUSE ex 	{ $$ = template("%s += %s", $1, $3); }
	| ex KW_MINUSE ex 	{ $$ = template("%s -= %s", $1, $3); }
	| ex KW_DIVE ex 	{ $$ = template("%s /= %s", $1, $3); }
	| ex KW_MULTE ex 	{ $$ = template("%s *= %s", $1, $3); }
	| ex KW_MODE ex 	{ $$ = template("%s %= %s", $1, $3); }
	| ex KW_DE ex 	{ $$ = template("%s := %s", $1, $3); }
	| '[' ex ']' { $$ = template("[%s]", $2); }
	| '(' ex ')' { $$ = template("(%s)", $2); }
	|function

;

parameters:
	parameter
	|parameters ',' parameter { $$ = template("%s , %s", $1, $3); }
;

parameter:
	TK_ID ':' types { $$ = template("%s %s", $3, $1); }
	|TK_ID '[' TK_INT ']' ':' types { $$ = template("%s %s[%s]", $6, $1, $3); }
	|TK_ID '[' ']' ':' types { $$ = template("%s %s[]", $5, $1); }
;

decl:
	exList ':' types ';'{ $$ = template("%s %s;\n", $3, $1); }
	| KW_CONST TK_ID '=' ex ':' types ';'{ $$ = template("const  %s  %s=%s;\n", $6, $2, $4); }
;	

exList:
	ex
	|exList ',' ex { $$ = template("%s , %s", $1, $3); }
;

types:
	KW_INTEGER	{ $$ = template("int "); }
	|KW_STR		{ $$ = template("char * "); }
	|KW_BOOLEAN	{ $$ = template("int "); }
	|KW_SCALAR	{ $$ = template("double "); }
	|TK_ID
;
%%
int main ()
{
	
	pointer = fopen("new_program_in_c.c", "w");
	if(pointer == NULL){
		printf("ERROR!\n");
		return -1;
	}
   if ( yyparse() == 0 ){
		printf("\nAccepted!\n");
   }
	else{
		printf("Rejected!\n");
	}
   fclose(pointer);

}

