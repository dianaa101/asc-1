; Ne propunem ca programul de mai jos sa citeasca de la tastatura un numar si sa afiseze pe ecran valoarea numarului citit impreuna cu un mesaj.
bits 32
global start        

; declararea functiilor externe folosite de program
extern exit, printf, scanf  ; adaugam printf si scanf ca functii externe           
import exit msvcrt.dll     
import printf msvcrt.dll     ; indicam asamblorului ca functia printf se gaseste in libraria msvcrt.dll
import scanf msvcrt.dll      ; similar pentru scanf
                          
segment  data use32 class=data
	n db 0       ; in aceasta variabila se va stoca valoarea citita de la tastatura
	message  db "Numarul citit este n= %d", 0  
	format  db "%d", 0  ; %d <=> un numar decimal (baza 10)
    
segment  code use32 class=code
    start:
                                               
        ; vom apela scanf(format, n) => se va citi un numar in variabila n
        ; punem parametrii pe stiva de la dreapta la stanga
        push  dword n       ; ! adresa lui n, nu valoarea
        push  dword format
        call  [scanf]       ; apelam functia scanf pentru citire
        add  esp, 4 * 2     ; eliberam parametrii de pe stiva; 4 = dimensiunea unui dword; 2 = nr de parametri
        
        ;convertim n la dword pentru a pune valoarea pe stiva 
        mov  eax,0
        mov  al,[n]
        
        ;afisam mesajul si valoarea lui n
        push  eax
        push  dword message 
        call  [printf]
        add  esp,4*2 
        
        ; exit(0)
        push  dword 0     ; punem pe stiva parametrul pentru exit
        call  [exit]       ; apelam exit pentru a incheia programul
        
        
        
        
        
        
; Codul de mai jos va afisa mesajul "Ana are 17 mere"
bits 32
global start        

; declararea functiilor externe folosite de program
extern exit, printf         ; adaugam printf ca functie externa            
import exit msvcrt.dll    
import printf msvcrt.dll    ; indicam asamblorului ca functia printf se gaseste in libraria msvcrt.dll
                          
segment data use32 class=data
; sirurile de caractere sunt de tip byte
format db "Ana are %d mere", 0  ; %d va fi inlocuit cu un numar
				; sirurile de caractere pt functiile C trebuie terminate cu valoarea 0
segment  code use32 class=code
    start:
        mov eax, 17
        
        ; vom apela printf(format, 17) => se va afisa: „Ana are 17 mere”
        ; punem parametrii pe stiva de la dreapta la stanga
        push dword eax
        push dword format ; ! pe stiva se pune adresa string-ului, nu valoarea
        call [printf]      ; apelam functia printf pentru afisare
        add esp, 4 * 2     ; eliberam parametrii de pe stiva; 4 = dimensiunea unui dword; 2 = nr de parametri

        ; exit(0)
        push dword 0      ; punem pe stiva parametrul pentru exit
        call [exit]       ; apelam exit pentru a incheia programul
        
        
        
        
        
; Afisarea unui qword
segment data use32 class=data
a dq  300765694775808
format db '%lld',0

segment code use32 class=code
start:

push dword [a+4]
push dword [a]
push dword format
call [printf]
add esp,4*3

push    dword 0      
call    [exit]




; Codul de mai jos va afisa mesajul ”n=”, apoi va citi de la tastatura valoarea numarului n.
bits 32

global start        

; declararea functiilor externe folosite de program
extern exit, printf, scanf ; adaugam printf si scanf ca functii externa            
import exit msvcrt.dll    
import printf msvcrt.dll    ; indicam asamblorului ca functia printf se gaseste in libraria msvcrt.dll
import scanf msvcrt.dll     ; similar pentru scanf
                          
segment data use32 class=data
	n dd  0       ; in aceasta variabila se va stoca valoarea citita de la tastatura
    ; sirurile de caractere sunt de tip byte
	message  db "n=", 0  ; sirurile de caractere pentru functiile C trebuie sa se termine cu valoarea 0 (nu caracterul)
	format  db "%d", 0  ; %d <=> un numar decimal (baza 10)
    
segment code use32 class=code
    start:
       
        ; vom apela printf(message) => se va afisa "n="
        ; punem parametrii pe stiva
        push dword message ; ! pe stiva se pune adresa string-ului, nu valoarea
        call [printf]      ; apelam functia printf pentru afisare
        add esp, 4*1       ; eliberam parametrii de pe stiva ; 4 = dimensiunea unui dword; 1 = nr de parametri
                                                   
        ; vom apela scanf(format, n) => se va citi un numar in variabila n
        ; punem parametrii pe stiva de la dreapta la stanga
        push dword n       ; ! adresa lui n, nu valoarea
         push dword format
        call [scanf]       ; apelam functia scanf pentru citire
        add esp, 4 * 2     ; eliberam parametrii de pe stiva
                           ; 4 = dimensiunea unui dword; 2 = nr de parametri
        
        ; exit(0)
        push dword 0      ; punem pe stiva parametrul pentru exit
        call [exit]
        
        
        
        
; Codul de mai jos va calcula rezultatul unor operatii aritmetice in registrul EAX, va salva valoarea registrilor, apoi va afisa valoarea rezultatului si va restaura valoarea registrilor.
bits 32

global start        

; declararea functiilor externe folosite de program
extern exit, printf  ; adaugam printf ca functie externa            
import exit msvcrt.dll    
import printf msvcrt.dll    ; indicam asamblorului ca functia printf se gaseste in libraria msvcrt.dll
                          
segment data use32 class=data
	; sirurile de caractere sunt de tip byte
	format  db "%d", 0  ; %d <=> un numar decimal (baza 10)
	
segment code use32 class=code
	start:
		; vom calcula 20 + 123 + 7 in EAX
		mov eax, 20
		add eax, 123
		add eax, 7         ; eax = 150 (baza 10) sau 0x96 (baza 16)
		
		; salvam valoarea registrilor deoarece apelul functiei sistem printf va modifica valoarea acestora
		; folosim instructiunea PUSHAD care salveaza pe stiva valorile mai multor registrii, printre care EAX, ECX, EDX si EBX 
		; in acest exemplu este important sa salvam doar valoarea registrului EAX, dar instructiunea poate fi aplicata generic
		PUSHAD
	   
		; vom apela printf(format, eax) => vom afisa valoarea din eax
		; punem parametrii pe stiva de la dreapta la stanga
		push dword eax
		push dword format ; ! pe stiva se pune adresa string-ului, nu valoarea
		call [printf]      ; apelam functia printf pentru afisare
		add esp, 4*2       ; eliberam parametrii de pe stiva ; 4 = dimensiunea unui dword; 2 = nr de parametri
		
		; dupa apelul functiei printf registrul EAX are o valoare setata de aceasta functie (nu valoarea 150 pe care am calculat-o la inceputul programului)
		; restauram valoarea registrilor salvati pe stiva la apelul instructii PUSHAD folosind instructiunea POPAD
		; aceasta instructiune ia valori de pe stiva si le completeaza in mai multi registrii printre care EAX, ECX, EDX si EBX
		; este important ca inaintea unui apel al instructiunii POPAD sa ne asiguram ca exista suficiente valori 
		; pe stiva pentru a fi incarcate in registrii (de exemplu ca anterior a fost apelata instructiunea PUSHA)
		POPAD
		
		; acum valoarea registrului EAX a fost restaurata la valoarea de dinaintea apelului instructiunii PUSHAD (in acest caz valoarea 150)
		
		; exit(0)
		push dword 0      ; punem pe stiva parametrul pentru exit
		call [exit] 
        
        
        
        
        
; Codul de mai jos va crea un fisier gol, numit "ana.txt" in directorul curent.
; Programul va folosi functia fopen pentru deschiderea/crearea fisierului si functia fclose pentru inchiderea fisierului creat.
; Deoarece in apelul functiei fopen programul foloseste modul de acces "w", daca un fisier cu acelasi nume exista deja in directorul curent, continutul acelui fisier va fi sters. Detalii despre modurile de acces sunt prezentate in sectiunea "Suport teoretic"

bits 32 

global start        

; declare external functions needed by our program
extern exit, fopen, fclose
import exit msvcrt.dll  
import fopen msvcrt.dll  
import fclose msvcrt.dll

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    nume_fisier db "ana.txt", 0  ; numele fisierului care va fi creat
    mod_acces db "w", 0          ; modul de deschidere a fisierului - 
                                 ; w - pentru scriere. daca fiserul nu exista, se va crea                                   
    descriptor_fis dd -1         ; variabila in care vom salva descriptorul fisierului - necesar pentru a putea face referire la fisier
                                    
; our code starts here
segment code use32 class=code
    start:
        ; apelam fopen pentru a crea fisierul
        ; functia va returna in EAX descriptorul fisierului sau 0 in caz de eroare
        ; eax = fopen(nume_fisier, mod_acces)
        push dword mod_acces     
        push dword nume_fisier
        call [fopen]
        add esp, 4*2                ; eliberam parametrii de pe stiva

        mov [descriptor_fis], eax   ; salvam valoarea returnata de fopen in variabila descriptor_fis
        
        ; verificam daca functia fopen a creat cu succes fisierul (daca EAX != 0)
        cmp eax, 0
        je final
        
        ; apelam functia fclose pentru a inchide fisierul
        ; fclose(descriptor_fis)
        push dword [descriptor_fis]
        call [fclose]
        add esp, 4
        
      final:
        
        ; exit(0)
        push    dword 0      
        call    [exit]       
        
        
        
        
        
; Codul de mai jos va crea un fisier numit "ana.txt" in directorul curent si va scrie un text in acel fisier.
; Programul va folosi functia fopen pentru deschiderea/crearea fisierului, functia fprintf pentru scrierea in fisier si functia fclose pentru inchiderea fisierului creat.
; Deoarece in apelul functiei fopen programul foloseste modul de acces "w", daca un fisier cu acelasi nume exista deja in directorul curent, continutul acelui fisier va fi suprascris. Detalii despre modurile de acces sunt prezentate in sectiunea "Suport teoretic"

bits 32 

global start        

; declare external functions needed by our program
extern exit, fopen, fprintf, fclose
import exit msvcrt.dll  
import fopen msvcrt.dll  
import fprintf msvcrt.dll
import fclose msvcrt.dll

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    nume_fisier db "ana.txt", 0  ; numele fisierului care va fi creat
    mod_acces db "w", 0          ; modul de deschidere a fisierului - 
                                 ; w - pentru scriere. daca fiserul nu exista, se va crea      
    text db "Ana are mere.", 0    ; textul care va fi scris in fisier
                                    
    descriptor_fis dd -1         ; variabila in care vom salva descriptorul fisierului - necesar pentru a putea face referire la fisier
                                    
; our code starts here
segment code use32 class=code
    start:
        ; apelam fopen pentru a crea fisierul
        ; functia va returna in EAX descriptorul fisierului sau 0 in caz de eroare
        ; eax = fopen(nume_fisier, mod_acces)
        push dword mod_acces     
        push dword nume_fisier
        call [fopen]
        add esp, 4*2                ; eliberam parametrii de pe stiva

        mov [descriptor_fis], eax   ; salvam valoarea returnata de fopen in variabila descriptor_fis
        
        ; verificam daca functia fopen a creat cu succes fisierul (daca EAX != 0)
        cmp eax, 0
        je final
        
        ; scriem textul in fisierul deschis folosind functia fprintf
        ; fprintf(descriptor_fis, text)
        push dword text
        push dword [descriptor_fis]
        call [fprintf]
        add esp, 4*2
        
        ; apelam functia fclose pentru a inchide fisierul
        ; fclose(descriptor_fis)
        push dword [descriptor_fis]
        call [fclose]
        add esp, 4
        
      final:
        
        ; exit(0)
        push    dword 0      
        call    [exit
        
        
        
        
        
; Codul de mai jos va deschide un fisier numit "ana.txt" in directorul curent si va adauga un text la finalul acelui fisier.
; Programul va folosi functia fopen pentru deschiderea/crearea fisierului, functia fprintf pentru scrierea in fisier si functia fclose pentru inchiderea fisierului creat.
; Deoarece in apelul functiei fopen programul foloseste modul de acces "a", daca un fisier cu numele exista deja in directorul curent, la continutul acelui fisier se va adauga un text. Daca fisierul cu numele dat nu exista, se va crea un fisier nou cu acel nume si se va scrie textul in fisier. Detalii despre modurile de acces sunt prezentate in sectiunea "Suport teoretic"

bits 32 

global start        

; declare external functions needed by our program
extern exit, fopen, fprintf, fclose
import exit msvcrt.dll  
import fopen msvcrt.dll  
import fprintf msvcrt.dll
import fclose msvcrt.dll

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    nume_fisier db "ana.txt", 0  ; numele fisierului care va fi creat
    mod_acces db "a", 0          ; modul de deschidere a fisierului - 
                                 ; a - pentru adaugare. daca fiserul nu exista, se va crea      
    text db "Ana are si pere.", 0 ; textul care va fi adaugat in fisier
                                    
    descriptor_fis dd -1         ; variabila in care vom salva descriptorul fisierului - necesar pentru a putea face referire la fisier
                                    
; our code starts here
segment code use32 class=code
    start:
        ; apelam fopen pentru a crea fisierul
        ; functia va returna in EAX descriptorul fisierului sau 0 in caz de eroare
        ; eax = fopen(nume_fisier, mod_acces)
        push dword mod_acces     
        push dword nume_fisier
        call [fopen]
        add esp, 4*2                ; eliberam parametrii de pe stiva

        mov [descriptor_fis], eax   ; salvam valoarea returnata de fopen in variabila descriptor_fis
        
        ; verificam daca functia fopen a creat cu succes fisierul (daca EAX != 0)
        cmp eax, 0
        je final
        
        ; adaugam/scriem textul in fisierul deschis folosind functia fprintf
        ; fprintf(descriptor_fis, text)
        push dword text
        push dword [descriptor_fis]
        call [fprintf]
        add esp, 4*2
        
        ; apelam functia fclose pentru a inchide fisierul
        ; fclose(descriptor_fis)
        push dword [descriptor_fis]
        call [fclose]
        add esp, 4
        
      final:
        
        ; exit(0)
        push    dword 0      
        call    [exit]
        
        
        
        
        
; Codul de mai jos va deschide un fisier numit "ana.txt" din directorul curent si va citi un text de maxim 100 de caractere din acel fisier.
; Programul va folosi functia fopen pentru deschiderea fisierului, functia fread pentru citirea din fisier si functia fclose pentru inchiderea fisierului deschis.
; Deoarece in apelul functiei fopen programul foloseste modul de acces "r", daca un fisier cu numele dat nu exista in directorul curent, apelul functiei fopen nu va reusi (eroare). Detalii despre modurile de acces sunt prezentate in sectiunea "Suport teoretic".

bits 32 

global start        

; declare external functions needed by our program
extern exit, fopen, fread, fclose
import exit msvcrt.dll  
import fopen msvcrt.dll  
import fread msvcrt.dll
import fclose msvcrt.dll

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    nume_fisier db "ana.txt", 0  ; numele fisierului care va fi deschis
    mod_acces db "r", 0          ; modul de deschidere a fisierului - 
                                 ; r - pentru scriere. fisierul trebuie sa existe 
    descriptor_fis dd -1         ; variabila in care vom salva descriptorul fisierului - necesar pentru a putea face referire la fisier
    len equ 100                  ; numarul maxim de elemente citite din fisier.                            
    text times len db 0          ; sirul in care se va citi textul din fisier  

; our code starts here
segment code use32 class=code
    start:
        ; apelam fopen pentru a deschide fisierul
        ; functia va returna in EAX descriptorul fisierului sau 0 in caz de eroare
        ; eax = fopen(nume_fisier, mod_acces)
        push dword mod_acces     
        push dword nume_fisier
        call [fopen]
        add esp, 4*2                ; eliberam parametrii de pe stiva

        mov [descriptor_fis], eax   ; salvam valoarea returnata de fopen in variabila descriptor_fis
        
        ; verificam daca functia fopen a creat cu succes fisierul (daca EAX != 0)
        cmp eax, 0
        je final
        
        ; citim textul in fisierul deschis folosind functia fread
        ; eax = fread(text, 1, len, descriptor_fis)
        push dword [descriptor_fis]
        push dword len
        push dword 1
        push dword text        
        call [fread]
        add esp, 4*4                 ; dupa apelul functiei fread EAX contine numarul de caractere citite din fisier
        
        ; apelam functia fclose pentru a inchide fisierul
        ; fclose(descriptor_fis)
        push dword [descriptor_fis]
        call [fclose]
        add esp, 4
        
      final:
        
        ; exit(0)
        push    dword 0      
        call    [exit]       
        
        
        
        

; Codul de mai jos va deschide un fisier numit "ana.txt" din directorul curent, va citi un text scurt din acel fisier, apoi va afisa  in consola numarul de caractere citite si textul citit din fisier.
; Programul va folosi functia fopen pentru deschiderea fisierului, functia fread pentru citirea din fisier si functia fclose pentru inchiderea fisierului creat.
; Deoarece in apelul functiei fopen programul foloseste modul de acces "r", daca un fisier numele dat nu exista in directorul curent,  apelul functiei fopen nu va reusi (eroare). Detalii despre modurile de acces sunt prezentate in sectiunea "Suport teoretic".

; In acest program sirul de caractere in care se va citi textul din fisier trebuie sa aiba o lungime cu 1 mai mare decat numarul maxim  de elemente care vor fi citite din fisier deoarece acest sir va fi afisat in consola folosind functia printf.
; Orice sir de caractere folosit de functia printf trebuie sa fie terminat in 0, altfel afisarea nu va fi corecta.
; Daca fisierul ar contine mai mult de <len> caractere si dimensiunea sirului destinatie era exact <len>, intregul sir ar fi fost completat cu valori citite din fisier, astfel sirul nu se mai termina cu valoarea 0.

bits 32 

global start        

; declare external functions needed by our program
extern exit, fopen, fread, fclose, printf
import exit msvcrt.dll  
import fopen msvcrt.dll  
import fread msvcrt.dll
import fclose msvcrt.dll
import printf msvcrt.dll

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    nume_fisier db "ana.txt", 0  ; numele fisierului care va fi creat
    mod_acces db "r", 0          ; modul de deschidere a fisierului - 
                                 ; r - pentru scriere. fisierul trebuie sa existe 
    len equ 100                  ; numarul maxim de elemente citite din fisier.                            
    text times (len+1) db 0      ; sirul in care se va citi textul din fisier (dimensiune len+1 explicata mai sus)
    descriptor_fis dd -1         ; variabila in care vom salva descriptorul fisierului - necesar pentru a putea face referire la fisier
    format db "Am citit %d caractere din fisier. Textul este: %s", 0  ; formatul - utilizat pentru afisarea textului citit din fisier
                                 ; %s reprezinta un sir de caractere

; our code starts here
segment code use32 class=code
    start:
        ; apelam fopen pentru a deschide fisierul
        ; functia va returna in EAX descriptorul fisierului sau 0 in caz de eroare
        ; eax = fopen(nume_fisier, mod_acces)
        push dword mod_acces     
        push dword nume_fisier
        call [fopen]
        add esp, 4*2                ; eliberam parametrii de pe stiva

        mov [descriptor_fis], eax   ; salvam valoarea returnata de fopen in variabila descriptor_fis
        
        ; verificam daca functia fopen a creat cu succes fisierul (daca EAX != 0)
        cmp eax, 0
        je final
        
        ; citim textul in fisierul deschis folosind functia fread
        ; eax = fread(text, 1, len, descriptor_fis)
        push dword [descriptor_fis]
        push dword len
        push dword 1
        push dword text        
        call [fread]
        add esp, 4*4                 ; dupa apelul functiei fread EAX contine numarul de caractere citite din fisier
        
        ; afisam numarul de caractere citite si textul citit
        ; printf(format, eax, text)
        push dword text
        push dword EAX
        push dword format
        call [printf]
        add esp, 4*3
        
        ; apelam functia fclose pentru a inchide fisierul
        ; fclose(descriptor_fis)
        push dword [descriptor_fis]
        call [fclose]
        add esp, 4
        
      final:
        
        ; exit(0)
        push    dword 0      
        call    [exit]  