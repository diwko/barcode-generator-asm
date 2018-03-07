# Barcode-generator
Assembler 8086

Compiler MASM

Run with DOSBOX

#### Screenshot:
![screenshot](https://github.com/diwko/barcode-generator-asm/blob/master/screenshot.png  "screenshot")

## Treść zadania:
### Assembler 
#### Program 2 
**Opis:**
* Napisać program rysujący na ekranie w trybie graficznym VGA: 320x200 256-kolorów kod kreskowy (barcode), kodujący wprowadzony przez użytkownika z klawiatury ciąg znaków ASCII.
* Kodowanie powinno być zrealizowane w standardzie CODE128 (EAN-128). Należy uwzględniać kody znaków ASCII od 0 do 127 (zgodnie z ISO/IEC 646). Program powinien wyliczać sumę kontrolną wprowadzonego ciągu znaków i uwzględniać ją w kodzie kreskowym.
* Do zapalania punktów na ekranie graficznym nie wolno używać przerwań (procedur) systemu operacyjnego. Należy bezpośrednio wykorzystywać pamięć obrazu karty VGA.
* Po narysowaniu pełnego kodu kreskowego program powinien czekać na wciśnięcie klawisza ESC i dopiero wtedy powinien się zakończyć.