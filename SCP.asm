; Ege Özkan
; Source code for SCP: After the Masqurade project.

format MZ

stdin equ 0
stdout equ 1
stderr equ 2

cr equ 0dh ; Carriage return
lf equ 0ah ; Line feed

main: ; our main function

        push	cs
	pop	ds

main_menu:
        lea ax, [introduction]
        call print
        lea ax, [about]
        lea cx, [exit]
        jmp choose

about:
        lea ax, [about_msg]
        call print
        jmp main_menu


exit:
        lea ax, [exit_message]
        call print
        mov ah, 4CH
        int 21H

choose:
        push ax ; Store ax temporarily since DOS call.
        push bx
        push cx
        push dx




        lea dx, [input] ; Print the input message
        mov ah, 9 ; The print system call.
        int 21h 
        
        mov ah, 01h ; Keybard IO
        int 21h ; Read character
        cmp al, 50 ; Compare if [al] == 2

        mov dl, lf
        mov ah, 2
        int 21h ; Add a new line and carriage return.
        
        pop dx ; Return the
        pop cx ; Original values
        pop bx ; of the
        pop ax ; registers

        jl short jump_to_one
        jg short jump_to_three
        jmp bx

jump_to_one:
        jmp ax

jump_to_three:
        jmp cx

print: ; Prints data
        mov dx, ax
        mov ah, 9 ; Print system call.
        int 21H

        mov dl, lf
        mov ah, 2
        int 21H

        ret


introduction    db      "Welcome to Izmir2046!", lf, "(1) About", lf, "(2) Start Game", lf, "(3) Quit", "$"
error_message   db      "No such option!", '$'
exit_message    db      "Thanks for playing Izmir2046!", "$"
input   db      "Your choice: ", "$"
about_msg       db      "The year is 2046, fifteen years have barelly passed since the Event. World is shattered, Izmir is no different. Though a long time has passed, the city is yet to recover. When an occultic murder occurs, with a note left by the killer implying more is yet to come, Detective Constable Alev Azulay is faced with the hardest case of his life...", "$"