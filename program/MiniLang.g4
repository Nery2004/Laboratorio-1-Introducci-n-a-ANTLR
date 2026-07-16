grammar MiniLang;

// Un programa contiene una o más instrucciones.
prog
    : stat+
    ;

// Cada instrucción termina con un salto de línea.
stat
    : expr NEWLINE          # printExpr
    | ID '=' expr NEWLINE   # assign
    | NEWLINE               # blank
    ;

// El orden de las alternativas establece la precedencia de operadores.
expr
    : expr (MUL | DIV) expr # MulDiv
    | expr (ADD | SUB) expr # AddSub
    | INT                   # int
    | ID                    # id
    | '(' expr ')'          # parens
    ;

MUL     : '*';
DIV     : '/';
ADD     : '+';
SUB     : '-';
ID      : [a-zA-Z]+;
INT     : [0-9]+;
NEWLINE : '\r'? '\n';
WS      : [ \t]+ -> skip;
