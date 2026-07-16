# Análisis del Laboratorio 1

## ¿Qué es ANTLR?

ANTLR, cuyo nombre significa *Another Tool for Language Recognition*, es una herramienta que genera analizadores léxicos y sintácticos a partir de una gramática. En este laboratorio genera código Python para reconocer un lenguaje sencillo.

## ¿Qué es un archivo `.g4`?

Un archivo `.g4` contiene la definición de una gramática de ANTLR. `MiniLang.g4` es una gramática combinada porque incluye reglas del parser y reglas del lexer en el mismo archivo.

## Partes de `MiniLang.g4`

- `grammar MiniLang;` declara el nombre de la gramática. También determina nombres como `MiniLangLexer` y `MiniLangParser`.
- `prog` es la regla inicial. Usa `stat+`, por lo que exige una o más instrucciones.
- `stat` representa una expresión, una asignación o una línea vacía. Cada expresión o asignación debe terminar con `NEWLINE`.
- `expr` reconoce enteros, identificadores, expresiones entre paréntesis y las cuatro operaciones aritméticas.
- `MUL`, `DIV`, `ADD` y `SUB` reconocen `*`, `/`, `+` y `-`.
- `ID` reconoce identificadores formados por una o más letras.
- `INT` reconoce números enteros formados por uno o más dígitos.
- `NEWLINE` reconoce un salto de línea de Linux/macOS (`\n`) o de Windows (`\r\n`).
- `WS` reconoce espacios y tabulaciones. La acción `-> skip` indica que deben descartarse y no llegar al parser.
- El operador `|` separa alternativas posibles.
- El operador `+` de repetición significa “una o más veces”. No debe confundirse con el token `ADD`.
- Los paréntesis de la gramática agrupan alternativas, como `(MUL | DIV)`. Los literales `'('` y `')'` reconocen paréntesis de la entrada.
- `//` inicia un comentario de una línea en la gramática.

## Uso de `#` en ANTLR

El símbolo `#` etiqueta una alternativa de una regla del parser; no es un comentario. Por ejemplo:

```antlr
expr NEWLINE # printExpr
```

La etiqueta permite que ANTLR genere un contexto específico para esa alternativa, como `PrintExprContext`. Esto sería útil más adelante para distinguir casos al recorrer el árbol.

## Reglas del parser

Las reglas del parser normalmente comienzan con letra minúscula. Describen cómo se organizan los tokens para formar expresiones e instrucciones. En esta gramática son `prog`, `stat` y `expr`.

## Reglas del lexer

Las reglas del lexer normalmente comienzan con letra mayúscula. Reconocen elementos básicos directamente desde los caracteres de entrada. Algunos ejemplos son `ID`, `INT` y `NEWLINE`.

## Recursividad izquierda y precedencia

ANTLR 4 permite recursividad izquierda directa. `expr` aparece al inicio de sus propias alternativas para reconocer operaciones encadenadas. Como multiplicación y división están antes que suma y resta, ANTLR les asigna mayor precedencia. Los paréntesis permiten cambiar el orden de agrupación.

## Funcionamiento de `Driver.py`

1. Importa el runtime de ANTLR y las clases generadas.
2. Valida el argumento y comprueba que el archivo exista.
3. `FileStream` abre la entrada como texto UTF-8.
4. `MiniLangLexer` convierte los caracteres en tokens.
5. `CommonTokenStream` almacena esos tokens.
6. `MiniLangParser` recibe el flujo de tokens.
7. `parser.prog()` inicia el análisis desde la regla principal y construye el árbol.
8. ANTLR conserva sus mensajes normales con línea, columna y descripción del error.
9. Un contador registra los errores del lexer y `parser.getNumberOfSyntaxErrors()` informa los errores del parser. Así se puede decidir el código de salida sin recorrer ni interpretar el árbol.

El árbol sintáctico se construye, pero todavía no se recorre ni se evalúan las expresiones.

## Flujo completo

```text
Archivo de entrada
        ↓
MiniLangLexer
        ↓
Tokens
        ↓
CommonTokenStream
        ↓
MiniLangParser
        ↓
Árbol sintáctico
```

## Diferencia entre análisis léxico y sintáctico

El análisis léxico agrupa caracteres en tokens, por ejemplo `resultado`, `=`, `5` y `NEWLINE`. El análisis sintáctico comprueba que esos tokens respeten estructuras permitidas por la gramática, por ejemplo una asignación con identificador, signo igual y expresión.

## Resultados de las pruebas

`programa_valido.txt` contiene operaciones, identificadores, asignaciones y paréntesis bien formados, por lo que el análisis termina sin errores. `program_test.txt`, incluido en la base, también es válido.

`programa_invalido.txt` contiene, entre otros problemas, un operador sin operando, asignaciones incompletas, un paréntesis sin cerrar y un signo igual adicional. ANTLR informa los problemas indicando línea y columna, y el driver devuelve un código de error.

Este laboratorio solamente valida la forma de la entrada. No guarda valores de variables ni calcula el resultado de las operaciones; esas tareas pertenecen a etapas posteriores, como el análisis semántico y el recorrido del árbol.
