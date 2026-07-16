# Laboratorio 1: Introducción a ANTLR

**Estudiante:** Nery Molina  
**Carné:** 23218  
**Modalidad:** Individual

## Descripción

Este laboratorio usa ANTLR 4.13.2 para generar un lexer y un parser de un lenguaje pequeño de expresiones matemáticas y asignaciones. El programa valida la sintaxis de archivos de entrada; no calcula expresiones ni realiza análisis semántico.

## Requisitos

- Docker Desktop, Docker Engine o una alternativa compatible.
- Una terminal capaz de ejecutar los comandos de Docker.

No es necesario instalar Java, Python o ANTLR en el equipo anfitrión, porque la imagen contiene esas herramientas.

## Estructura

```text
.
├── Dockerfile
├── README.md
├── ANALISIS.md
├── GUION_VIDEO.md
├── requirements.txt
├── python-venv.sh
├── commands/
│   ├── antlr
│   └── grun
└── program/
    ├── MiniLang.g4
    ├── Driver.py
    ├── program_test.txt
    ├── programa_valido.txt
    └── programa_invalido.txt
```

Los archivos Python que genera ANTLR no se guardan en Git porque pueden reconstruirse desde `MiniLang.g4`.

## Construcción y ejecución con Docker

Desde la raíz del repositorio, construir la imagen:

```bash
docker build --no-cache --rm . -t lab1-image
```

Generar directamente el lexer, el parser y las clases auxiliares:

```bash
docker run --rm -v "$(pwd)/program":/program lab1-image \
  antlr -Dlanguage=Python3 MiniLang.g4
```

Este paso debe repetirse cuando cambie la gramática. Después, abrir una terminal dentro del contenedor con la misma carpeta montada:

```bash
docker run --rm -ti -v "$(pwd)/program":/program lab1-image
```

Los siguientes comandos de prueba se ejecutan dentro del contenedor.

## Pruebas

Entrada válida:

```bash
python3 Driver.py programa_valido.txt
echo $?
```

Resultado esperado:

```text
Análisis sintáctico completado sin errores.
0
```

Entrada inválida:

```bash
python3 Driver.py programa_invalido.txt
echo $?
```

ANTLR muestra errores con línea y columna. Al final, el driver muestra la cantidad de errores léxicos y sintácticos y devuelve el código `1`.

También puede probarse el archivo original:

```bash
python3 Driver.py program_test.txt
```

El driver crea el árbol sintáctico, pero no lo recorre ni evalúa las operaciones. Los Visitors, Listeners de árbol y el análisis semántico quedan fuera del alcance de este laboratorio.

### Resumen de pruebas

| Prueba | Archivo | Resultado esperado |
|---|---|---|
| Entrada válida | `programa_valido.txt` | Sin errores |
| Entrada inválida | `programa_invalido.txt` | Errores con línea y columna |
| Entrada original | `program_test.txt` | Sin errores |
| Archivo inexistente | No aplica | Mensaje de error |

## Códigos de salida

- `0`: análisis completado sin errores.
- `1`: ANTLR detectó errores léxicos o sintácticos.
- `2`: uso incorrecto, archivo inexistente o error de lectura.

## Problemas comunes

### `ModuleNotFoundError: No module named 'MiniLangLexer'`

Faltan los archivos generados. Dentro de `/program`, ejecutar:

```bash
antlr -Dlanguage=Python3 MiniLang.g4
```

### Error al montar el volumen

Ejecutar `docker run` desde la raíz del laboratorio y confirmar que existe la carpeta `program`. En PowerShell puede ser necesario sustituir `$(pwd)` por `${PWD}`.

### Error al final del archivo

La gramática exige un token `NEWLINE` al terminar cada instrucción. Comprobar que el archivo de entrada termine con un salto de línea.

### Versiones incompatibles

El JAR generador y `antlr4-python3-runtime` deben coincidir. Este proyecto usa la versión 4.13.2 para ambos.

### Permiso denegado en un script

Restaurar el permiso de ejecución con:

```bash
chmod +x commands/antlr commands/grun python-venv.sh
```

## Video

Enlace de YouTube: [Agregar enlace después de subir el video]
