; Se citeste de la tastatura un sir de caractere (litere mici si litere mari, cifre, caractere speciale, etc). Sa se formeze un sir nou doar cu literele mici si un sir nou doar cu literele mari. Sa se afiseze cele 2 siruri rezultate pe ecran.
; S: 'a', 'A', 'b', 'B', '2', '%', 'x'
; D1: 'a', 'b', 'x'
; D2: 'A', 'B'

bits 32
global start

extern exit, printf, scanf
import exit msvcrt.dll  
import printf msvcrt.dll
import scanf msvcrt.dll

segment data use32 class=data
    size equ 32
    s times size db 0
    msg1 db "uppercase: "
    d1 times size db 0
    msg2 db "lowercase: "
    d2 times size db 0
    
segment code use32 class=code
start:
    mov ECX, [size]
    jecxz final 
    
    mov ESI, 0
    mov EDI, 0 ; for d1
    mov EBX, 0 ; for d2
    
repeta:
    mov AL, [s+ESI]
    
    cmp AL, 'A'
    jl not_uppercase ;Jump if below A
    
    cmp AL, 'Z'
    jg not_uppercase ;Jump if greater than Z
    
    mov [d1+EDI], AL
    inc EDI
    jmp next_char
    
not_uppercase:
    cmp AL, 'a'
    jl not_letter
    
    cmp AL, 'z'
    jg not_letter
    
    mov [d2+EBX], AL
    inc EBX
    jmp next_char
    
not_letter:
    jmp next_char
    
next_char:   
    inc ESI
    loop repeta

final:

    push dword 0 
    call [exit]
    
    
    
    
; ; Se da un sir de octeti reprezentand un text (succesiune de cuvinte separate de spatii). Sa se identifice cuvintele de tip palindrom (ale caror oglindiri sunt similare cu cele de plecare): "cojoc", "capac" etc.

bits 32
global start

 extern exit 
import exit msvcrt.dll  

segment data use32 class=data

s db "ana are capac"
ls equ $-s
d times ls db 0
    

segment code use32 class=code
start:

    mov ECX, ls
    mov ESI, 0
    mov EDI, 0
    
    mov EAX, 0
    push EAX ; inceputul cuvantului

    repeat:
    mov EAX, ESI ; daca urmatoarea pozitie este finalul sirului, verificam daca e palindrom
    add EAX, 1
    cmp EAX, ls
    je verif_pali
    
    mov DL, ' ' ; sau daca pe urmatoarea pozitie se afla un spatiu, verificam daca e palindrom
    cmp [s+EAX], DL
    je verif_pali
    
    jmp end ; in caz contrar, trecem la urmatoarea pozitie
    
    verif_pali:
    pop EBX ; inceputul cuvantului
    
    cmp EAX, EBX ; daca lungimea cuvantului = 0
    je end ; trecem la urmatoarea pozitie
    
    add EAX, 1 
    push EAX ; punem pe stack urmatorul inceput de cuvant
    sub EAX, 1 ; revenim la finalul cuvantului curent
    
    push ECX
    push ESI
    
    mov ESI, EBX ; mutam inceputul cuvantului in ESI
    mov ECX, EAX ; mutam finalul cuvantului in ECX
    sub ECX, EBX  ; scadem inceputul cuvantului din ECX
    ; obtinem nr de litere in ECX - (nr de iteratii ale buclei)

    loop_verif_pali: ; bucla care verifica daca cuvantul delimitat de EBX si EAX este palindrom
    sub EAX, 1 ; pornim de la sfarsitul cuvantului si mergem spre inceput cu EAX
    mov DL, [s+ESI] ; mutam in DL litera comparata
    cmp DL, [s+EAX] ; comparam cu litera din pozitia oglinda
    jne set_not_pali ; daca literele nu sunt egale, setam 0 in d
    
    inc ESI ; ESI - pozitia in cuvant
    loop loop_verif_pali 
    ; la finalul buclei, setam 1 in d
    mov [d+EDI], byte 1
    jmp end_verif_pali
    
    set_not_pali:
    mov [d+EDI], byte 0
    jmp end_verif_pali
    
    end_verif_pali:
    inc EDI ; crestem pozitia in sirul d
    
    pop ESI
    pop ECX
    
    end: ; finalul buclei care itereaza peste literele din tot sirul
    inc ESI
    loop repeat
    

    push dword 0 
    call [exit]
    
    
    
    
; ; Se da un nume de fisier (definit in segmentul de date). Sa se creeze un fisier cu numele dat, apoi sa se citeasca de la tastatura cuvinte si sa 
; se scrie in fisier cuvintele citite pana cand se citeste de la tastatura caracterul '$'.

bits 32
global start

extern exit, fopen, fclose, fprintf, scanf           
import exit msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll    
import fprintf msvcrt.dll    
import scanf msvcrt.dll

segment data use32 class=data
    nume_fisier db "tema.txt", 0
    mod_acces db "w", 0
    descriptor_fis dd -1 
    format_cuvant db "%s", 0
    buffer resb 100
    format_spatiu db "%s ", 0
   
    
segment code use32 class=code
start:
    push dword mod_acces     
    push dword nume_fisier
    call [fopen]
    add ESP, 4 * 2
    
    mov [descriptor_fis], EAX
    
    cmp EAX, 0
    je fail
    
    citeste_cuvant:
        push dword buffer 
        push dword format_cuvant
        call [scanf]
        add ESP, 4 * 2
        
        cmp byte [buffer], '$'
        je final
        
        push dword buffer
        push dword format_spatiu 
        push dword [descriptor_fis]
        call [fprintf]
        add ESP, 4 * 2
    
        jmp citeste_cuvant
        
final:
    push dword [descriptor_fis]
    call [fclose]
    add ESP, 4

fail:
    push dword 0 
    call [exit]
    
    
    


; ; Sa se citeasca de la tastatura in baza 16 doua numere a si b de tip dword si sa se afiseze suma partilor low si diferenta partilor high. 
; a = 00101A35h, b = 00023219h
; suma = 4C4Eh
; diferenta = Eh

bits 32
global start

extern exit, printf, scanf            
import exit msvcrt.dll    
import printf msvcrt.dll    
import scanf msvcrt.dll

segment data use32 class=data
    a dd 0
    b dd 0
    format db "%x", 0 
    format_sum db "suma = %Xh", 10, 0
    format_dif db "diferenta = %Xh", 10, 0
    message_a db "a = ", 0
    message_b db "b = ", 0
   
    
segment code use32 class=code
start:
   
    push dword message_a
    call [printf]
    add esp, 4 * 1

    push dword a      ; punem parametrii pe stiva de la dreapta la stanga
	push dword format
	call [scanf]       ; apelam functia scanf pentru citire
	add esp, 4 * 2

    push dword message_b
    call [printf]
    add esp, 4 * 1
    
    push dword b       ; punem parametrii pe stiva de la dreapta la stanga
    push dword format
    call [scanf]       ; apelam functia scanf pentru citire
    add esp, 4 * 2 
    
    mov EAX, [a]
    mov EBX, [b]
    add AX, BX
    mov ECX, 0
    mov CX, AX
    push ECX
    push format_sum
    call [printf]
    add ESP, 4 * 2
    
    mov EAX, [a]
    mov EBX, [b]
    shr EAX, 16
    shr EBX, 16
    sub AX, BX
    mov ECX, 0
    mov CX, AX
    push ECX
    push format_dif
    call [printf]
    
    push dword 0      ; punem pe stiva parametrul pentru exit
    call [exit]
    
    
    
    
    
; ; 19. Sa se citeasca de la tastatura un numar n, apoi sa se citeasca mai multe cuvinte, pana cand se citeste cuvantul/caracterul "#". Sa se scrie intr-un fisier text toate cuvintele citite care incep si se termina cu aceeasi litera si au cel putin n litere.
bits 32
global start

extern exit, fopen, fclose, fprintf, scanf, printf          
import exit msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll    
import fprintf msvcrt.dll    
import scanf msvcrt.dll
import printf msvcrt.dll

segment data use32 class=data
    n dd 0
    nume_fisier db "cuvinte.txt", 0
    mod_acces db "w", 0
    descriptor_fis dd -1
    format_numar db "%d", 0
    msg db "n = ", 0
    format_cuvant db "%s", 0
    msg_cuv db "cuvant = ", 0
    buffer resb 100
    format_spatiu db "%s ", 0
    
segment code use32 class=code
start:
    push dword mod_acces     
    push dword nume_fisier
    call [fopen]
    add ESP, 4 * 2
    
    mov [descriptor_fis], EAX
    
    cmp EAX, 0
    je fail
    
    push dword msg
    call [printf]
    add ESP, 4 * 1
    
    push dword n
    push dword format_numar
    call [scanf]
    add ESP, 4 * 2
    
    
citeste_cuvant:
    push dword msg_cuv
    call [printf]
    add ESP, 4 * 1
    
    push dword buffer
    push dword format_cuvant
    call [scanf]
    add ESP, 4 * 2
    
    cmp byte [buffer], '#'
    je final
    
    mov ESI, 0
    
loop_check_end:
    cmp byte[buffer + ESI], 0
    je word_end
    inc ESI
    jmp loop_check_end
    
word_end:
    cmp ESI, [n]
    jl citeste_cuvant

    mov CL, byte[buffer + ESI - 1]
    cmp [buffer], CL
    je scrie_cuvant
    jmp citeste_cuvant

    
scrie_cuvant:
    push dword buffer
    push dword format_cuvant
    push dword [descriptor_fis]
    call [fprintf]
    add ESP, 4 * 3
    
    jmp citeste_cuvant
    
final:
    push dword [descriptor_fis]
    call [fclose]
    add ESP, 4 * 1
    
fail:

    push dword 0
    call [exit]
    
    
    
    
; Se dă un șir de caractere s. Să se copieze elementele șirului s într-un alt șir de caractere d, folosind instrucțiuni pe șiruri.
bits 32
global start

extern exit
import exit msvcrt.dll

segment data use32 class=data
    s db 'a', 'b', 'c', 'd', 'e', 'f'
    len equ $-s         ; numarul de elemente ale sirului s (in octeti)
    d times len db 0 
segment code use32 class=code
    start:
        mov ecx, len        ; ciclul se executa de len ori
        jecxz final         ; prevenim intrarea intr-un ciclu infinit
        ; pregatim executia intructiunilor LODSB si STOSB
        cld                 ; DF = 0
        mov esi, s          ; ESI = offset-ul primului element al sirului s
        mov edi, d          ; EDI = offset-ul primului element al sirului d
    repeta:
        lodsb               ; AL <- <DS:ESI> si inc ESI
        stosb               ; <ES:EDI> <- AL si inc EDI
        loop repeta
    final:
        push dword 0
        call [exit]
        
        
        
        
; 2. Se dă un șir de caractere s format din litere mici. Să se construiască un șir de caractere d care să conțină literele
; din șirul inițial transformate în majuscule, folosind instrucțiuni pe șiruri.
bits 32
global start

extern exit
import exit msvcrt.dll

segment data use32 class=data
    s db 'a', 'b', 'c', 'd', 'e', 'f'
    len equ $-s         ; numarul de elemente ale sirului s (in octeti)
    d times len db 0
segment code use32 class=code
    start:
        mov ecx, len        ; ciclul se executa de len ori
        jecxz final         ; prevenim intrarea intr-un ciclu infinit
        ; pregatim executia intructiunilor pe siruri
        cld                 ; DF = 0
        mov esi, s          ; ESI = offset-ul primului element al sirului s
        mov edi, d          ; EDI = offset-ul primului element al sirului d
    repeta:
        ; citim litera mica
        lodsb               ; AL <- <DS:ESI> si inc ESI
        
        ; transformam litera mica in majuscula
        mov bl, 'a'-'A'     ; BL = diferenta dintre codurile ASCII ale literelor a si A
        sub al, bl          ; AL = codul ASCII al majusculei corespunzatoare
        
        ; stocam codul ASCII din AL in sirul d
        stosb               ; <ES:EDI> <- AL si inc EDI
        loop repeta
    
    final:
        push dword 0
        call [exit]
        
        
        
        
; 3. Se dă un șir de octeți s. Să se construiască șirul de octeți d, care conține pe fiecare poziție numărul de biți care au valoarea 1 din octetul de pe poziția corespunzătoare din s.

bits 32
global start

extern exit
import exit msvcrt.dll

segment data use32 class=data
    s db 5, 25, 55, 127
    len equ $-s         ; numarul de elemente ale sirului s (in octeti)
    d times len db 0
segment code use32 class=code
    start:
        mov ecx, len        ; ciclul se executa de len ori
        jecxz final         ; prevenim intrarea intr-un ciclu infinit
        ; pregatim executia intructiunilor pe siruri
        cld                 ; DF = 0
        mov esi, s          ; ESI = offset-ul primului element al sirului s
        mov edi, d          ; EDI = offset-ul primului element al sirului d
    repeta:
        push ecx            ; salvam ECX pe stiva
        
        ; citim octetul curent
        lodsb               ; AL <- <DS:ESI> si inc ESI
        
        ; numaram bitii de 1 din octetul curent
        mov ecx, 8          ; vom repeta ciclul de 8 ori (un OCTET = 8 biti)
        mov bl, 0           ; vom numara bitii de 1 in registrul BL
    numara:
        shl al, 1           ; bitul care iese e retinut in CF (daca bitul a fost 1, atunci CF=1, altfel CF=0)
        adc bl, 0           ; BL = BL + CF (daca CF=1 => BL = BL+1, daca CF=0 => nu modificam valoarea lui BL)
        loop numara
    
        ; stocam numarul de biti de 1
        mov al, bl          ; AL = numarul de biti de 1 din octetul curent
        stosb               ; <ES:EDI> <- AL si inc EDI
        
        pop ecx             ; refacem ECX de pe stiva
        loop repeta
    
    final:
        push dword 0
        call [exit]
        
        
     
     
; Se dă un șir de cuvinte s. Să se construiască două șiruri de octeți:
; - b1 care are ca elemente partea superioară a cuvintelor din s
; - b2 care are ca elemente partea inferioară a cuvintelor din s

bits 32
global start

extern exit
import exit msvcrt.dll

segment data use32 class=data
	s dw 1122h, 3344h, 5566h, 7788h
    len equ ($-s)/2         ; numarul de elemente ale sirului s (in cuvinte)
    b1 times len db 0
    b2 times len db 0
segment code use32 class=code
    start:
        mov ecx, len        ; ciclul se executa de len ori
        jecxz final         ; prevenim intrarea intr-un ciclu infinit
        ; pregatim executia intructiunilor pe siruri
        cld                 ; DF = 0
        mov esi, s          ; ESI = offset-ul primului element al sirului s
        mov ebx, b1         ; EBX = offset-ul primului element al sirului b1
        mov edi, b2         ; EDI = offset-ul primului element al sirului b2
    repeta:
        lodsw               ; AX = (cuvantul din s) si ESI = ESI + 2
        stosb               ; stocam partea inferioara din AL in sirul b2 si inc EDI
        
        ; Varianta 1
        ; mov [b1+ebx], ah    ; stocam partea superioara din AH in sirul b1
        ; inc ebx
        
        ; Varianta 2: folosind instructiuni pe siruri
        push edi            ; salvam EDI pe stiva (pentru ca il vom modifica)
        mov edi, ebx        ; EDI = offset-ul curent din sirul b1
        ror ax, 8           ; mutam partea superioara din AH in AL
        stosb               ; stocam partea superioara din AL in sirul b1 si inc EDI
        mov ebx, edi        ; stocam offset-ul curent din sirul b1
        pop edi             ; refacem EDI de pe stiva
        loop repeta
        
    final:
        push dword 0
        call [exit]
        
        
        
        
; Se dau două șiruri de octeți s1 și s2 de lungimi egale.
; Să se determine poziția p în care elementele ambelor șiruri sunt egale.

    start:
    ; -----------------------------------------------------------
        ;  Varianta 1: fara instructiuni pe siruri
        mov ecx, len            ; ciclul se executa de len ori
        jecxz final             ; prevenim intrarea intr-un ciclu infinit
        mov esi, 0              ; i = 0
    cauta:
        ; ; citim elementele
        mov al, [s1+esi]        ; AL = s1[i]
        mov dl, [s2+esi]        ; DL = s2[i]
        
        ; ; comparam elementele
        cmp al, dl              ; comparam s1[i] cu s2[i]
        je gasit                ; sunt egale (ZF=1), sari la eticheta 'gasit'
        
        ; ; nu sunt egale, continuam cautarea
        inc esi                 ; i++
        loop cauta
    
        ; ; afisam la consola pozitia p determinata
    gasit:
        push dword esi          ; pozitia p
        push dword format
        call [printf]
        add esp, 4*2
    final:
    
    
    
   
; 6. Se dă un șir de octeți s. Să se ordoneze crescător elementele șirului s.
bits 32
global start

extern exit
import exit msvcrt.dll

segment data use32 class=data
    s db 4, 2, 7, 1, 9, 8, 3, 5, 6
    len equ $-s     ; numarul de elemente ale sirului s (in octeti) 
segment code use32 class=code
    start:
        mov ecx, len                ; ECX = numarul de elemente ale lui s
        jecxz final
        dec ecx                     ; 0 <= i < len-1
        mov esi, 0                  ; i = 0
    loop_1:
        mov al, [s+esi]             ; AL = s[i]
        
        mov ebx, esi
        inc ebx                     ; i+1 <= j < len
        loop_2:
            mov dl, [s+ebx]         ; DL = s[j]
            
            cmp al, dl
            jb no_swap
            
            ; daca s[i] >= s[j], interschimb elementele
            mov [s+ebx], al
            mov [s+esi], dl
            mov al, dl
            
            ; daca s[i] < s[j], nu interschimb elementele
        no_swap:
            inc ebx                 ; j++
            cmp ebx, len            ; verific daca am ajuns la ultimul element
            jb loop_2               ; daca j < len, reiau ciclul

    next:
        inc esi                     ; i++
        loop loop_1
    
    final:
        push dword 0
        call [exit]
        
        
        
        
; bits 32
global start

extern exit, scanf, printf
import exit msvcrt.dll
import scanf msvcrt.dll
import printf msvcrt.dll

segment data use32 class=data
	a dd 0
    mesaj db 'Dati un intreg: ', 0
    format db "%d", 0
    
    biti times 32 db 0, 0
    format_afisare db "%d: %s", 13, 10, 0
    
; 1. Scrieți un program care citește de la tastatură un număr întreg și îl afișează în baza 2.
segment code use32 class=code
    start:
    repeta:
        ; afisez mesaj
        ; printf(mesaj)
        push dword mesaj
        call [printf]
        add esp, 1*4
        
        ; citesc numarul
        ; scanf(format, &a)
        push dword a
        push dword format
        call [scanf]
        add esp, 2*4
        ; verific daca s-a introdus valoarea 0
        mov edx, [a]
        cmp edx, 0
        je final
        
        ; obtin reprezentarea in baza 2
        mov ecx, 32
        cld
        mov edi, biti
        verifica:
            xor al, al
            shl edx, 1
            adc al, '0'
            stosb
            loop verifica
        
        ; afisez sirul de biti
        ; printf(format_afisare, a, biti)
        push dword biti
        push dword [a]
        push dword format_afisare
        call [printf]
        add esp, 3*4
    
        jmp repeta
    
    final:
        push dword 0
        call [exit]
        
        
        
        
; bits 32
global start

extern exit, scanf, printf
import exit msvcrt.dll
import scanf msvcrt.dll
import printf msvcrt.dll

segment data use32 class=data
	a dd 0
    mesaj db 'Dati un intreg: ', 0
    format db "%d", 0
    
    zece dd 10
    format_afisare db "Cifre: %d", 13, 10, 0
    
; 2. Scrieți un program care citește de la tastatură un număr întreg
; și afișează câte cifre are numărul citit în baza 10.
segment code use32 class=code
    start:
    repeta:
        ; afisez mesaj
        ; printf(mesaj)
        push dword mesaj
        call [printf]
        add esp, 1*4
        
        ; citesc numarul
        ; scanf(format, &a)
        push dword a
        push dword format
        call [scanf]
        add esp, 2*4
        
        ; verific daca s-a introdus valoarea 0
        mov edx, [a]
        cmp edx, 0
        je final
        
        ; verific daca numarul e pozitiv/negativ
        mov eax, [a]
        cmp eax, 0
        jg pozitiv
        
        neg eax         ; e negativ, il negam
        
    pozitiv:
        ; determin numarul de cifre in baza 10
        mov edx, 0      ; edx:eax = a
        mov ebx, 1      ; contor
    .repeta:
        div dword [zece]
        cmp eax, 0
        je afisare
        inc ebx
        mov edx, 0
        jmp .repeta
        
    afisare:
        ; afisez numarul de cifre
        ; printf(format_afisare, EBX)
        push dword ebx
        push dword format_afisare
        call [printf]
        add esp, 2*4
    
        jmp repeta

    final:
        push dword 0
        call [exit]
        
        
        
        
        
; bits 32
global start

extern exit, printf, fopen, fclose, fscanf
import exit msvcrt.dll
import printf msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll
import fscanf msvcrt.dll

segment data use32 class=data
	nume_fisier db "numere.txt", 0
    mod_acces db "r", 0
    descriptor_fisier dd 0
    
    n dd 0
    format_citire db "%d", 0
    format_afisare db "Suma: %d", 0
    
; 5. Se dă un nume de fișier (definit în segmentul de date).
; Fișierul conține numerele întregi cu semn separate prin spații.
; Să se calculeze și să se afișeze suma numerelor din fișier.
segment code use32 class=code
    start:
        ; deschid fisierul
        ; EAX = fopen(nume_fisier, mod_acces)
        push dword mod_acces
        push dword nume_fisier
        call [fopen]
        add esp, 2*4
        
        ; verific daca fisierul a fost deschis
        cmp eax, 0
        je eroare
        mov [descriptor_fisier], eax
        
        ; citesc continutul fisierului
        xor ebx, ebx    ; suma = 0
    citire:
        ; citesc numarul
        ; EAX = fscanf(descriptor_fisier, format_citire, &n)
        push dword n
        push dword format_citire
        push dword [descriptor_fisier]
        call [fscanf]
        add esp, 3*4
        
        cmp eax, 1
        jne afisare
        ; adun numarul curent
        add ebx, [n]
        jmp citire
   
   afisare:
        ; printf(format_afisare, EBX)
        push dword ebx
        push dword format_afisare
        call [printf]
        add esp, 2*4
   
        ; inchid fisierul
        ; fclose(descriptor_fisier)
        push dword [descriptor_fisier]
        call [fclose]
        add esp, 1*4
        
    eroare:
        push dword 0
        call [exit]
        
        
        
        
; bits 32
global start

extern exit, fopen, fread, fwrite, fclose
import exit msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll
import fread msvcrt.dll
import fwrite msvcrt.dll

segment data use32 class=data
	nume_fisier db "cuvinte.txt", 0
    mod_acces db "r+", 0
    descriptor_fisier dd 0
    
    max equ 100
    buffer times max+1 db 0
    result times max+1 db 0
    len dd 0
    
    speciale db "!@#$%^&*()_+{}[]"
    len_s equ $-speciale
    
; 6. Se dă un nume de fișier (definit în segmentul de date).
; Fișierul conține litere mici, litere mari, cifre și caractere speciale.
; Să se înlocuiască toate caracterele speciale din fișier cu caracterul 'X'.
segment code use32 class=code
    start:
        ; deschid fisierul
        ; EAX = fopen(nume_fisier, mod_acces)
        push dword mod_acces
        push dword nume_fisier
        call [fopen]
        add esp, 2*4
        
        ; verific daca fisierul a fost deschis
        cmp eax, 0
        je eroare
        mov [descriptor_fisier], eax
        
        ; citesc continutul intregului fisier
        ; EAX = fread(void* buffer, int size, int count, FILE* stream)
        push dword [descriptor_fisier]
        push dword max
        push dword 1
        push dword buffer
        call [fread]
        add esp, 4*4

        mov ebx, 0
        mov esi, 0
    repeta:
        mov al, [buffer+esi]
        
        cmp al, 0
        je scrie
        
        mov byte [result+esi], al
        
        ; verific daca e caracter special
        call verifica
        cmp edx, 1
        jne nu_e_special
        
        ; inlocuiesc caracterul curent cu 'X'
        mov byte [result+esi], 'X'
        
    nu_e_special:
        inc ebx
        inc esi
        jmp repeta
        
    scrie:
        mov [len], ebx
        
        ; fwrite(void* buffer, int size, int count, FILE* stream)
        push dword [descriptor_fisier]
        push dword [len]
        push dword 1
        push dword result
        call [fwrite]
        add esp, 4*4
        
        ; inchid fisierul
        ; fclose(descriptor_fisier)
        push dword [descriptor_fisier]
        call [fclose]
        add esp, 1*4
        
    eroare:
        push dword 0
        call [exit]
    
        ; AL = caracterul curent
        ; verifica daca caracterul din AL e special
    verifica:
        push esi
        mov ecx, len_s
        mov esi, 0
    cauta:
        mov dl, [speciale+esi]
        
        cmp al, dl
        je e_special
        
        inc esi
        loop cauta
        
        mov edx, 0
        jmp nu_e
        
    e_special:
        mov edx, 1
        
    nu_e:
        pop esi
        ret

