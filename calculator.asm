org 100h

jmp start       ; jump over data declaration

msg1:    db      0dh,0ah,"1-Add",0dh,0ah,"2-Multiply",0dh,0ah,"3-Subtract",0dh,0ah,"4-Divide", 0Dh,0Ah, '$'
msg2:    db      0dh,0ah,"Enter First No : $"
msg3:    db      0dh,0ah,"Enter Second No : $"
msg4:    db      0dh,0ah,"Choice Error $" 
msg5:    db      0dh,0ah,"Result : $" 

start:  mov ah,09h
        mov dx, offset msg1          ;first message from which to choose the operation using int 21h
        int 21h
        mov ah,00h                       
        int 16h                      ;int 16h to read a key press and store ASCII in AL, to know the operation chosen
        cmp al,31h                   ;31h = ASCII of 1
        je Addition
        cmp al,32h                   ;32h = ASCII of 2
        je MultiplIcation
        cmp al,33h
        je Subtraction               ;33h = ASCII of 3
        cmp al,34h
        je Division                  ;34h = ASCII of 4
        mov ah,09h
        mov dx, offset msg4
        int 21h
        mov ah,0
        int 16h
        jmp start
        
Addition:   mov ah,09h              
            mov dx,offset msg2      ;message to enter first number
            int 21h
            mov cx,0                ;counter to store a number containing multiple digits
            call InputNo            ;function to take input from the user
            push dx                 ;push first number on stack
            mov ah,9
            mov dx, offset msg3     ;message to enter second number
            int 21h 
            mov cx,0                ;counter to store a number containing multiple digits
            call InputNo
            pop bx                  ;pop first number from stack onto bx
            add dx,bx               ;add the numbers and store in dx
            push dx                 ;to keep result unaffected
            mov ah,9
            mov dx, offset msg5     ;message to display the result
            int 21h
            mov cx,10000            ;maximum limit of the calculator
            pop dx
            call Result 
            jmp start 

InputNo:    mov ah,0
            int 16h               ;to take the first number as input from the user     
            mov dx,0  
            mov bx,1 
            cmp al,0dh            ;the keypress will be stored in al, so we comapre it to 0d which is keycode for the enter key, to check if the user has entered the first number 
            je FormNo             ;to form the complete number using digits stored in the stack, after the enter key is pressed
            sub ax,30h            ;to convert the value of key press from ASCII to decimal
            call ViewNo           ;to view the key pressed on the screen
            mov ah,0              ;move 0 to ah before we push ax to the stack because we only need the value in al
            push ax               ;push the contents of ax to the stack to later form complete number
            inc cx                ;increment counter
            jmp InputNo           ;jump back to InputNo to either take another number or press enter       

ViewNo:    push ax                
           push dx                ;push ax and dx to the stack because their values will be changed while viewing
           mov dx,ax              ;move the value of al(key pressed) to dx, as int 21h expects that the output is stored in dx
           add dl,30h             ;add 30 to its value to convert it back to ascii
           mov ah,2
           int 21h                ;to display the entered digit on the screen
           pop dx  
           pop ax
           ret 
                                   
FormNo:     pop ax                ;pop digits into ax starting from unit's place
            push dx      
            mul bx
            pop dx
            add dx,ax
            mov ax,bx       
            mov bx,10
            push dx
            mul bx
            pop dx
            mov bx,ax
            dec cx
            cmp cx,0
            jne FormNo
            ret   

Result:     mov ax,dx
            mov dx,0
            div cx 
            call ViewNo
            push dx 
            mov dx,0
            mov ax,cx 
            mov cx,10
            div cx
            pop dx 
            mov cx,ax
            cmp ax,0
            jne Result
            ret

Multiplication:   mov ah,09h
                  mov dx, offset msg2
                  int 21h
                  mov cx,0
                  call InputNo
                  push dx
                  mov ah,9
                  mov dx, offset msg3
                  int 21h 
                  mov cx,0
                  call InputNo
                  pop bx
                  mov ax,dx
                  mul bx 
                  mov dx,ax
                  push dx 
                  mov ah,9
            mov dx, offset msg5
            int 21h
            mov cx,10000
            pop dx
            call Result 
            jmp start


Subtraction:   mov ah,09h
            mov dx, offset msg2
            int 21h
            mov cx,0
            call InputNo
            push dx
            mov ah,9
            mov dx, offset msg3
            int 21h 
            mov cx,0
            call InputNo
            pop bx
            sub bx,dx
            mov dx,bx
            push dx 
            mov ah,9
            mov dx, offset msg5
            int 21h
            mov cx,10000
            pop dx
            call Result 
            jmp start 
    
            
Division:   mov ah,09h
            mov dx, offset msg2
            int 21h
            mov cx,0
            call InputNo
            push dx
            mov ah,9
            mov dx, offset msg3
            int 21h 
            mov cx,0
            call InputNo
            pop bx
            mov ax,bx
            mov cx,dx
            mov dx,0
            mov bx,0
            div cx
            mov bx,dx
            mov dx,ax
            push bx 
            push dx 
            mov ah,9
            mov dx, offset msg5
            int 21h
            mov cx,10000
            pop dx
            call Result
            jmp start                         