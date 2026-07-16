# Guion del video — Laboratorio 1

**Nombre:** Nery Molina

**Carné:** 23218

Duración aproximada: 5 a 7 minutos.

## 1. Presentación — 0:00 a 0:25

**Mostrar:** La portada del `README.md`.

**Decir:** “Hola, soy Nery Molina, carné 23218. En este video presentaré el Laboratorio 1 de Compiladores, una introducción a ANTLR. El objetivo es generar un lexer y un parser, y comprobar entradas correctas e incorrectas.”

## 2. Estructura del repositorio — 0:25 a 0:50

**Mostrar:** El explorador de archivos del repositorio.

**Decir:** “En la raíz están Dockerfile, la documentación, los requisitos y los comandos auxiliares. En `program` están la gramática `MiniLang.g4`, el driver de Python y tres entradas de prueba. Los archivos generados no se guardan en Git porque pueden reconstruirse.”

## 3. Explicación de Docker — 0:50 a 1:15

**Mostrar:** `Dockerfile` y `requirements.txt`.

**Decir:** “Docker crea un entorno reproducible con Java 17, Python, soporte para entornos virtuales y el JAR de ANTLR 4.13.2. El runtime de Python también está fijado en 4.13.2 para evitar incompatibilidades.”

## 4. Explicación de la gramática — 1:15 a 2:05

**Mostrar:** `program/MiniLang.g4`, recorriendo `prog`, `stat`, `expr` y los tokens.

**Decir:** “Esta es una gramática combinada: contiene reglas de parser en minúscula y reglas de lexer en mayúscula. `prog` exige una o más instrucciones. `stat` permite expresiones, asignaciones o líneas vacías. `expr` reconoce suma, resta, multiplicación, división, enteros, identificadores y paréntesis. `NEWLINE` termina cada instrucción y `WS` descarta espacios y tabulaciones con `skip`. Multiplicación y división aparecen antes que suma y resta, por lo que tienen mayor precedencia.”

## 5. Explicación de `#` — 2:05 a 2:25

**Mostrar:** Las etiquetas `# printExpr`, `# assign` y las de `expr`.

**Decir:** “El numeral no es un comentario. En ANTLR etiqueta una alternativa de una regla y genera un contexto específico, por ejemplo `PrintExprContext`. Eso será útil cuando más adelante se recorra el árbol.”

## 6. Diferencia entre lexer y parser — 2:25 a 2:50

**Mostrar:** El diagrama de flujo de `ANALISIS.md`.

**Decir:** “El lexer lee caracteres y forma tokens, como identificadores, enteros y operadores. El parser recibe esos tokens y verifica si están organizados según la gramática. El resultado es un árbol sintáctico.”

## 7. Explicación de `Driver.py` — 2:50 a 3:30

**Mostrar:** `program/Driver.py`.

**Decir:** “El driver recibe la ruta, valida que exista y la abre con `FileStream`. Luego crea el lexer, `CommonTokenStream` y el parser. La llamada `parser.prog()` inicia el análisis. ANTLR conserva sus mensajes con línea y columna, mientras el contador permite devolver un código de error. El árbol se construye, pero el driver no calcula expresiones ni hace análisis semántico.”

## 8. Construcción de la imagen — 3:30 a 4:00

**Mostrar:** Una terminal en la raíz y ejecutar:

```bash
docker build --no-cache --rm . -t lab1-image
```

**Decir:** “Construyo la imagen desde la raíz. Docker instala todas las dependencias con las versiones documentadas.”

## 9. Generación de lexer y parser — 4:00 a 4:20

**Mostrar:** En la terminal de la computadora, ejecutar:

```bash
docker run --rm -v "$(pwd)/program":/program lab1-image \
  antlr -Dlanguage=Python3 MiniLang.g4
```

Opcionalmente mostrar los archivos:

```bash
ls program/MiniLang*
```

**Decir:** “Este comando monta `program` en el contenedor, lee la gramática y genera las clases Python del lexer, parser y Listener. Debe ejecutarse antes del driver y después de cada cambio de la gramática.”

Después, abrir una terminal para las pruebas:

```bash
docker run --rm -ti -v "$(pwd)/program":/program lab1-image
```

**Decir:** “Inicio el contenedor con el mismo volumen. Ahora estoy en `/program` y puedo ejecutar el driver.”

## 10. Ejecución del archivo válido — 4:20 a 4:45

**Mostrar:** `programa_valido.txt` y ejecutar:

```bash
python3 Driver.py programa_valido.txt
echo $?
```

**Decir:** “La entrada incluye asignaciones, operaciones y paréntesis. Como es correcta, ANTLR completa el análisis sin errores y el código de salida es cero.”

## 11. Ejecución del archivo inválido — 4:45 a 5:10

**Mostrar:** `programa_invalido.txt` y ejecutar:

```bash
python3 Driver.py programa_invalido.txt
echo $?
```

**Decir:** “Ahora pruebo una entrada incorrecta. El driver cuenta por separado errores léxicos y sintácticos. El código de salida es uno, de modo que el error también puede detectarse desde un script.”

## 12. Explicación de los errores — 5:10 a 5:40

**Mostrar:** La salida de ANTLR junto al archivo inválido.

**Decir:** “ANTLR muestra la línea, la columna y el tipo de problema. Aquí hay un operador sin operando, una asignación incompleta, un paréntesis sin cerrar y un igual adicional. El driver añade el resumen final, pero no oculta el diagnóstico original.”

## 13. Cierre — 5:40 a 6:05

**Mostrar:** `ANALISIS.md` o el `README.md`.

**Decir:** “En conclusión, el laboratorio genera correctamente el lexer y el parser, acepta una entrada válida y detecta errores en una inválida. Por ahora solo valida sintaxis: no calcula resultados. Los Visitors, Listeners de árbol y el análisis semántico se estudiarán más adelante. Gracias.”
