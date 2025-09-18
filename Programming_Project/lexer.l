%{
  #include <string.h>
  #include "cgen.h"	
  #include "parser.tab.h"
  
  int line_num = 1;
%}


ID      [a-zA-Z_][0-9a-zA-Z_]*
DIGIT   [0-9]
NUMBER  {DIGIT}{DIGIT}*
DECIMAL ("."{NUMBER})|({NUMBER}("."{NUMBER}?)?)
REAL    {DECIMAL}([eE][+-]?{NUMBER})?


non_print [^"\\"^"\'"^"\""^"\n"]
con_char ("\'")(({Escape_Sequence}|{Non_print}))("\'")
esc_seq  ("\\n"|"\\t"|"\\r"|"\\\\"|"\\\'"|"\\\"")
con_str  \"[^'\n]*\"
%%

if          return KW_IF;
else		return KW_ELSE;
endif		return KW_ENDIF;
def  		return KW_DEF;
main  		return KW_MAIN;
enddef  	return KW_ENDDEF;
integer 	return KW_INTEGER;
str  		return KW_STR;
scalar      return KW_SCALAR;
boolean 	return KW_BOOLEAN;
return 		return KW_RETURN;
comp 		return KW_COMP;
endcomp		return KW_ENDCOMP;
not 		return KW_NOT;
and 		return KW_AND;
or    		return KW_OR;
True 		return KW_TRUE;
False 		return KW_FALSE;
for 		return KW_FOR;
endfor   	return KW_ENDFOR;
in 			return KW_IN;
while      	return KW_WHILE;
endwhile 	return KW_ENDWHILE;
break   	return KW_BREAK;
continue 	return KW_CONTINUE;
of    		return KW_OF;
const 		return KW_CONST;

{ID}        { yylval.str = strdup(yytext); return TK_ID; }
{NUMBER}    { yylval.str = strdup(yytext); return TK_INT; }
{REAL}      { yylval.str = strdup(yytext); return TK_REAL; }
{con_str}  {yylval.str = strdup(yytext); return TK_CONSTRING;}

"-="   		return KW_MINUSE;
"*="		return KW_MULTE;
"/="		return KW_DIVE;
"%="		return KW_MODE;
":="		return KW_DE;
"**"   		return KW_P;
"==" 		return KW_E;
"<="		return KW_LESSE;
">="		return KW_GREATERE;
"!="		return KW_NOTE;
"+="   		return KW_PLUSE;

"+"         return '+';
"("			return '(';
")"			return ')';
";"			return ';';
","			return ',';
":"			return ':';
"["			return '[';
"]"			return ']';
">"			return '>';
"<"			return '<';
"#"			return '#';
"*"         return '*';
"/"         return '/';
"-"         return '-';
"."			return '.';
"="			return '=';
"%"			return '%';

 ("--").* {yylval.str = strdup(yytext); return TK_LINECOMMENTS;}
[ \r\t]+		/* eat whitespace */
\n 					 ++line_num;

<<EOF>> 	return EOF;
.         { 
						yyerror("lexical error: unrecognized literal '%s'\n", yytext);
					}

%%

