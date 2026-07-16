import sys
from pathlib import Path

from antlr4 import CommonTokenStream, FileStream
from antlr4.error.ErrorListener import ErrorListener

from MiniLangLexer import MiniLangLexer
from MiniLangParser import MiniLangParser


class ErrorCounter(ErrorListener):
    """Cuenta errores sin reemplazar los mensajes normales de ANTLR."""

    def __init__(self):
        super().__init__()
        self.count = 0

    def syntaxError(self, recognizer, offendingSymbol, line, column, msg, e):
        self.count += 1


def main(argv: list[str]) -> int:
    if len(argv) != 2:
        print(f"Uso: python3 {Path(argv[0]).name} <archivo>", file=sys.stderr)
        return 2

    input_path = Path(argv[1])
    if not input_path.is_file():
        print(f"Error: el archivo no existe: {input_path}", file=sys.stderr)
        return 2

    error_counter = ErrorCounter()

    try:
        input_stream = FileStream(str(input_path), encoding="utf-8")
        lexer = MiniLangLexer(input_stream)
        lexer.addErrorListener(error_counter)

        token_stream = CommonTokenStream(lexer)
        parser = MiniLangParser(token_stream)
        parser.addErrorListener(error_counter)
        parser.prog()
    except OSError as error:
        print(f"Error al leer el archivo: {error}", file=sys.stderr)
        return 2

    if error_counter.count:
        print("El archivo contiene errores sintácticos.", file=sys.stderr)
        return 1

    print("Análisis sintáctico completado sin errores.")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
