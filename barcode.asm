dane1 segment

	napis		db	    25,0,27 dup('$')
	barpattern  db      2,1,2,2,2,2,2,2,2,1,2,2,2,2,2,2,2,1,1,2,1,2,2,3,1,2,1,3,2,2,1,3,1,2,2,2,1,2,2,2,1,3,1,2,2,3,1,2,1,3,2,2,1,2,2,2,1,2,1,3,2,2,1,3,1,2,2,3,1,2,1,2,1,1,2,2,3,2,1,2,2,1,3,2,1,2,2,2,3,1,1,1,3,2,2,2,1,2,3,1,2,2,1,2,3,2,2,1,2,2,3,2,1,1,2,2,1,1,3,2,2,2,1,2,3,1,2,1,3,2,1,2,2,2,3,1,1,2,3,1,2,1,3,1,3,1,1,2,2,2,3,2,1,1,2,2,3,2,1,2,2,1,3,1,2,2,1,2,3,2,2,1,1,2,3,2,2,2,1,1,2,1,2,1,2,3,2,1,2,3,2,1,2,3,2,1,2,1,1,1,1,3,2,3,1,3,1,1,2,3,1,3,1,3,2,1,1,1,2,3,1,3,1,3,2,1,1,3,1,3,2,3,1,1,2,1,1,3,1,3,2,3,1,1,1,3,2,3,1,3,1,1,1,1,2,1,3,3,1,1,2,3,3,1,1,3,2,1,3,1,1,1,3,1,2,3,1,1,3,3,2,1,1,3,3,1,2,1,3,1,3,1,2,1,2,1,1,3,3,1,2,3,1,1,3,1,2,1,3,1,1,3,2,1,3,3,1,1,2,1,3,1
	            db      3,1,3,1,1,1,2,3,3,1,1,3,2,1,3,3,1,1,2,1,3,1,2,1,1,3,3,1,2,3,1,1,3,3,2,1,1,1,3,1,4,1,1,1,2,2,1,4,1,1,4,3,1,1,1,1,1,1,1,2,2,4,1,1,1,4,2,2,1,2,1,1,2,4,1,2,1,4,2,1,1,4,1,1,2,2,1,4,1,2,2,1,1,1,2,2,1,4,1,1,2,4,1,2,1,2,2,1,1,4,1,2,2,4,1,1,1,4,2,1,1,2,1,4,2,2,1,1,2,4,1,2,1,1,2,2,1,1,1,4,4,1,3,1,1,1,2,4,1,1,1,2,1,3,4,1,1,1,1,1,1,2,4,2,1,2,1,1,4,2,1,2,1,2,4,1,1,1,4,2,1,2,1,2,4,1,1,2,1,2,4,2,1,1,4,1,1,2,1,2,4,2,1,1,1,2,4,2,1,2,1,1,2,1,2,1,4,1,2,1,4,1,2,1,4,1,2,1,2,1,1,1,1,1,4,3,1,1,1,3,4,1,1,3,1,1,4,1,1,1,4,1,1,3,1,1,4,3,1,1,4,1,1,1,1,3,4,1,1,3,1,1,1,1,3,1,4,1,1,1,4,1,3,1,3,1,1,1,4,1,4,1,1,1,3,1,2,1,1,4,1,2,2,1,1,2,1,4,2,1,1,2,3,2,2,3,3,1,1,1,2
	
	polozenie   dw      0
	kolor       dw      0      ;0 -czarny  15 -bialy
	znak_kontrolny db   0
	
	
		
	n_dane      db      "Podaj tekst do zakodowania (do 24 znakow):",10,13,'$'
	n_error     db      "Nieprawidlowe dane!",10,10,13,13,'$'
	n_koniec    db      "ESC - Zakoncz$"

dane1 ends

code1 segment                              

	start:          			 		    
				mov		ax,seg w_stosu			;inicjalizacja stosu
				mov		ss,ax
				mov     sp,offset w_stosu
				
				call    clear_screen               
                call    wczytaj_dane
                
                mov     ax,seg napis            ;ustawienie segmentu danych
				mov     ds,ax  
							
                
                mov 	al,13h                  ;tryb graf 320x200 pk   256 kol
		        mov 	ah,0                    ;zmiana trybu graficznego
		        int     10h
	            
		        mov     ax,0a000h               ;ustawienie es
		        mov     es,ax       
	            
	            
		        call    rysuj_cicha_strefa
		        call    rysuj_znak_start
		        call    rysuj_napis
                call    rysuj_znak_kontrolny
                call    rysuj_znak_stop
                call    rysuj_cicha_strefa 
                
                call    napisy_koniec 
                
         czekaj_esc:       
                mov     ah,8                    ;czekaj na klawisz
                int     21h                
                cmp     al,27                   ;27 = esc 
                jne     czekaj_esc                
	            
		        mov	al,3                    	;tryb tekstowy 80 zn w lini
		        mov 	ah,0                    ;zmiana trybu graficznego
		        int     10h
                
				mov	    ax,04c00h  		   		;koniec programu i powrot do DOS
				int	    21h

;..............................

clear_screen:                                   ;czysci ekran
                push    ax
                mov     ah,00h                   
                mov     al,03                   
                int     10h
                pop     ax
                ret
;..............................
;in dx                                          wypisuje tekst z dx zakonczony '$'

wypisz_string:
                push    ax
                mov     ah,9
                int     21h
                pop     ax
                ret    
;..............................

wczytaj_string:
                push    ax                
                mov     ah,0ah
                int     21h
                pop     ax
                ret                
;..............................
;in dh-wiersz,dl-kolumna,bx-strona 

ustaw_kursor:
                push    ax
                push    bx
                xor     bx,bx
                mov     ah,2
                int     10h
                pop     bx                
                pop     ax
                ret
;..............................
;sprawdza argument wywolania programu

wczytaj_dane:
                push    ax
                push    cx
                push    dx
                push    di
                push    si
                   
                mov     ax,seg napis              ;ds na poczatku programu ustawioiny tam gdzie jest argument
				mov     es,ax
				mov     si,082h
				mov     di,offset napis
				xor     cx,cx
				mov     cl,byte ptr ds:[080h]   ;cx-ilosc znakow
										
				cmp     cx,0
				je      wczytaj_w_programie
				dec     cl   
				mov     byte ptr es:[napis+1],cl
				cmp     cx,24
				ja      wczytaj_z_e
				
	    	wczytaj_argument:
				push    cx
				mov     al,byte ptr ds:[si]
				mov     byte ptr es:[2+di],al
				inc     si
				inc     di
				pop     cx
                loop    wczytaj_argument 
                
                jmp     wczytano_argument
            
            wczytaj_z_e:
                mov     dx,seg napis
                mov     ds,dx
                mov     dx,offset n_error
                call    wypisz_string
                    
            wczytaj_w_programie: 
                mov     dx,seg napis
                mov     ds,dx
                mov     dx,offset n_dane
                call    wypisz_string
                mov     dx,offset napis
                call    wczytaj_string
                
                mov     dl,byte ptr [napis + 1]
                cmp     dl,0
                je      wczytaj_z_e
                
            wczytano_argument:
                pop     si
                pop     di
                pop     dx
                pop     cx
                pop     ax
                ret
;..............................
;in ax - kolor
;   di - poczatek (x)
;   dx - szerokosc

rysuj_pasek:   
                push    cx
                
                cld                                 ;kierunek poruszania w prawo
                mov     cx,100                      ;wysokosc paska
                
            rysuj_wiersz:   
                push    cx
                mov     cx,dx
                rep stosb                           ;es:di <- al ,rysowanie kolumn
                add     di,320                       
                sub     di,dx                       ;przesuwanie do nowego wiersza
                pop     cx
                loop    rysuj_wiersz
                
                pop     cx    
                ret

;..............................
;ax znak ASCII

znak_na_kod:    
                push    bx
                push    cx
                push    dx
                push    di
                push    si
                
                sub     ax,32                       ;ax=ax-32 (0 kod to spacja (ascii 32) 
                mov     bx,6                        
                mul     bx                          ;ax=ax*6    ax-poczatek tabeli dla konkretnego znaku
                
                mov     si,ax
                mov     cx,6                
                
        rysuj_paski_znaku:                 
                mov     ax,word ptr [kolor]
                mov     di,word ptr [polozenie]
                mov     bx,offset barpattern
                mov     dl,byte ptr [bx + si]                
                
                call    rysuj_pasek
                
                inc     si
                xor     bx,bx
                mov     bl,dl     
                add     bx,word ptr [polozenie]
                mov     word ptr [polozenie],bx                  
                
                cmp     ax,0
                je      ustaw_kolor_bialy
                mov     ax,0
                mov     word ptr [kolor],ax
                jmp     nastepny_krok_petli
            
            ustaw_kolor_bialy:
                mov     ax,15
                mov     word ptr [kolor],ax  
                
            nastepny_krok_petli:
                 
                loop    rysuj_paski_znaku
                
                pop     si
                pop     di
                pop     dx
                pop     cx
                pop     bx
                                         
                ret
;.....................................

rysuj_napis:     
                push    ax
                push    cx
                push    si                
                
                xor     ax,ax
                xor     cx,cx
                mov     cl,byte ptr [napis + 1]
                xor     si,si
                             
        kolejne_znaki:  
                mov     al,byte ptr [napis + 2 + si]
                call    znak_na_kod
                                
                inc     si
                loop    kolejne_znaki 
                
                pop     si
                pop     cx
                pop     ax
                ret
;.....................................

rysuj_cicha_strefa:
                push    ax
                push    dx
                push    di
                
                mov     ax,15
                mov     di,word ptr [polozenie]                  
                mov     dx,10
                call    rysuj_pasek
                mov     di,word ptr [polozenie]
                add     di,dx
                mov     word ptr [polozenie],di
                
                pop     di
                pop     dx
                pop     ax                
                ret
;.....................................       

rysuj_znak_stop:
                push    ax
                push    dx
                push    di
                
                mov     ax,106+32
                call    znak_na_kod
                
                mov     ax,word ptr [kolor]
                mov     di,word ptr [polozenie]               
                mov     dx,2                   
                call    rysuj_pasek
                mov     di,word ptr [polozenie]
                add     di,2
                mov     word ptr [polozenie],di
                
                pop     di
                pop     dx
                pop     ax
                ret  
;...................................

rysuj_znak_start:
                push    ax
                mov     ax,104+32
                call    znak_na_kod
                pop     ax
                ret 
;...................................

oblicz_suma_kontrolna:
                push    ax
                push    bx
                push    dx
                push    si
                          
                xor     ax,ax
                xor     bx,bx
                mov     bl,byte ptr [napis + 1]          
                mov     dx,104                  ;104 kod start b
                mov     si,1
        kolejne_sumy: 
                xor     ax,ax
                mov     al,byte ptr [napis + 1 + si]
                sub     al,32
                push    dx
                xor     dx,dx 
                mul     si
                pop     dx
                add     dx,ax
                        
                inc     si                 
                cmp     si,bx
                jbe     kolejne_sumy
                
                mov     ax,dx
                xor     dx,dx
                mov     bx,103
                div     bx
                
                mov     byte ptr [znak_kontrolny],dl                  
                
                pop     si
                pop     dx
                pop     bx
                pop     ax
                ret               
;..................................

rysuj_znak_kontrolny:
                push    ax
                
                call    oblicz_suma_kontrolna
                
                xor     ax,ax
                mov     al,byte ptr [znak_kontrolny]
                add     al,32
                call    znak_na_kod
                
                pop     ax
                ret
;..................................

napisy_koniec: 
                push    ax
                push    bx
                push    dx  
                
                ;........                   wysrodkowanie napisu
                xor     ax,ax
                xor     dx,dx
                mov     al,byte ptr [napis+1]
                mov     bx,11
                mul     bx
                add     ax,55
                xor     dx,dx
                mov     bx,14              
                div     bx                
                push    ax
                
                xor     ax,ax
                xor     dx,dx
                mov     al,byte ptr [napis+1]
                mov     bx,7
                mul     bx
                xor     dx,dx
                mov     bx,14
                div     bx
                
                pop     bx
                sub     bx,ax 
                dec     bx
                ;..............
                
                
                mov     dh,13                       ;napis pod kodem
                mov     dl,bl
                call    ustaw_kursor
                
                mov     dx,offset napis + 2
                call    wypisz_string
                
                
                mov     dh,18                       ;napis esc
                mov     dl,0
                call    ustaw_kursor                
                
                mov     dx,offset n_koniec
                call    wypisz_string
                
                pop     dx
                pop     bx
                pop     ax
                ret   
;..................................                                                
                                
code1 ends

stos1 segment stack

				dw		200 dup(?)					;rezerwacje 0-399 bitow
	w_stosu		dw 		?							;rezerwacja 400 bitu na wierzcholek

stos1 ends

end start
