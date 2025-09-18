/* A Bison parser, made by GNU Bison 3.5.1.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2020 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Undocumented macros, especially those whose name start with YY_,
   are private implementation details.  Do not rely on them.  */

#ifndef YY_YY_PARSER_TAB_H_INCLUDED
# define YY_YY_PARSER_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    TK_ID = 258,
    TK_INT = 259,
    TK_REAL = 260,
    TK_CONSTRING = 261,
    TK_LINECOMMENTS = 262,
    KW_IF = 263,
    KW_ELSE = 264,
    KW_DEF = 265,
    KW_MAIN = 266,
    KW_ENDDEF = 267,
    KW_INTEGER = 268,
    KW_SCALAR = 269,
    KW_STR = 270,
    KW_BOOLEAN = 271,
    KW_RETURN = 272,
    KW_COMP = 273,
    KW_ENDCOMP = 274,
    KW_AND = 275,
    KW_OR = 276,
    KW_NOT = 277,
    KW_LESSE = 278,
    KW_GREATERE = 279,
    KW_E = 280,
    KW_TRUE = 281,
    KW_FALSE = 282,
    KW_NOTE = 283,
    KW_PLUSE = 284,
    KW_MINUSE = 285,
    KW_MULTE = 286,
    KW_DIVE = 287,
    KW_MODE = 288,
    KW_DE = 289,
    KW_P = 290,
    KW_ENDIF = 291,
    KW_FOR = 292,
    KW_ENDFOR = 293,
    KW_IN = 294,
    KW_WHILE = 295,
    KW_ENDWHILE = 296,
    KW_BREAK = 297,
    KW_CONTINUE = 298,
    KW_OF = 299,
    KW_CONST = 300
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 18 "parser.y"

	char* str;

#line 107 "parser.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_PARSER_TAB_H_INCLUDED  */
