org 100h

.data ; variables

    bin db 5 dup('0')   ; variable to store the 4-Bit Binary Value
    
    inp db 0ah, 0dh, "Enter a 4-Bit Binary Number: $"
    err db 0ah, 0dh, "Invalid Binary Number. Please enter a 4-bit binary number.$"
    
    lmf db 0ah, 0dh, "Left Motor : Forward $"
    lmr db 0ah, 0dh, "Left Motor : Reverse $"
    
    rmf db 0ah, 0dh, "Right Motor: Forward $"
    rmr db 0ah, 0dh, "Right Motor: Reverse $"
    
    ins db 0ah, 0dh, "Enter the state of switch (1/0): $"
    lm  db 0ah, 0dh, "Left Motor : Stops $"
    rm  db 0ah, 0dh, "Right Motor: Stops $"

.code ; code

 main proc ; main program start 
  
  start:   
    
    mov ax, @data      ; moving the variables to ax
    mov ds, ax         ; moving the values from ax to ds
    
    ; Program to implement switch
    
    lea dx, ins        ; moving the address of variable ins to dx
    mov ah, 9          ; moving 9 to ah
    int 21h            ; adding interupt
    
    mov ah, 01h        ; getting a char as input from the user
    int 21h            ; adding interupt            
    
    mov bl, al         ; moving values from al to bl
    
    cmp bl, '1'        ; comparing value in bl with '1'
    jne flag           ; juming to label 'flag' if not equal;
    
    ; Program to input a 4-bit Binary Value
    
    lea dx, inp        ; moving the address of inp to dx
    mov ah, 9          ; moving 9 to ah
    int 21h            ; adding interupt
    
 get_Bin:              ; label to define program for getting binary inputs (4- bit)
    
    mov cx, 4          ; Moving value 4 to cx
    mov di, offset bin ; Moving the address of bin to di
    
 get:                  ; label to define program to get input from the user
 
    mov ah, 01h        ; getting a char as input from the user
    int 21h            ; adding interupt
    
    mov dl, al         ; moving the values from al to dl
    
    cmp dl, '0'        ; comparing dl with '0'
    je valid           ; jump to label 'valid' if equal
    
    cmp dl, '1'        ; comparing dl with '1'
    je valid           ; jump to label 'valid' if equal
    
 invalid:              ; program executes if the entered char is not of either 0 or 1
 
    lea dx, err        ; moving the variable err's address to dx
    mov ah, 9          ; moving value 9 to ah
    int 21h            ; adding interupt
    
    jmp get_Bin        ; jump to get_Bin label

 valid:                ; if entered char is either 0 / 1
 
    stosb              ; storing the char
    
    loop get           ; loop get label until si reaches 4 (cx value)
    
    mov byte ptr [di], '$'    ; moving '$' to [di]
    
    ; Program to compare the inputs
    
compare:               

  xor ax, ax                  ; using xor of ax , ax to empty the ax (ax = 0)
  xor bx, bx                  ; using xor of bx , bx to empty the bx (bx = 0)
  
  mov al, byte ptr [bin]      ; moving value of [bin] to al
  sub ax, '0'                 ; subtracting ax by '0' so that we can obtain decimal value at ax
  add bx, ax                  ; adding ax to bx
  
  mov al, byte ptr [bin+1]    ; moving value of [bin+1] to al
  sub ax, '0'                 ; subtracting ax by '0' so that we can obtain decimal value at ax
  add bx, ax                  ; adding ax to bx
  
  xor cx, cx                  ; using xor of cx , cx to empty the cx (cx = 0)
                              
  mov al, byte ptr [bin+2]    ; moving value of [bin+2] to al
  sub ax, '0'                 ; subtracting ax by '0' so that we can obtain decimal value at ax
  add cx, ax                  ; adding ax to cx
  
  mov al, byte ptr [bin+3]    ; moving value of [bin+3] to al
  sub ax, '0'                 ; subtracting ax by '0' so that we can obtain decimal value at ax
  add cx, ax                  ; adding ax to cx
  
  cmp bx, cx                  ; comparing bx with cx
  je allZero_One              ; jumping to label allZero_One if equal
  jg lineAtLeft               ; jumping to lineAtLeft if greater
  jl lineAtRight              ; jumping to lineAtRight if lesser
   
looping:
   
  loop start
  
   ; Program to end the process
   
endcode:                      

  ret                         ; using ret to return 

    
main endp                     ; ending the main program

; Program to be executed if switch's state is low

flag:                 ; label flag 

  lea dx, lm          ; moves the address of variable lm to dx
  mov ah, 9           ; moves value 9 to ah
  int 21h             ; adding interupt
  
  lea dx, rm          ; moves the address of variable rm to dx
  mov ah, 9           ; moves value 9 to ah
  int 21h             ; adding interupt
  
  call endcode        ; calling label endcode
  
  ret                 ; return

; Program to be executed if input has equal number of 1's or 0's

allZero_One:          ; label allZero_One

  lea dx, lmf         ; moves the address of variable lmf to dx
  mov ah, 9           ; moves value 9 to ah
  int 21h             ; adding interupt
  
  lea dx, rmf         ; moves the address of variable rmf to dx
  mov ah, 9           ; moves value 9 to ah
  int 21h             ; adding interupt
  
  ret                 ; return

; Program to be executed if the 1st 2 byte has more number of 1's than last 2 byte
          
lineAtLeft:           ; label lineAtLeft

  lea dx, lmr         ; moves the address of variable lmr to dx
  mov ah, 9           ; moves value 9 to ah
  int 21h             ; adding interupt
  
  lea dx, rmf         ; moves the address of variable rmf to dx
  mov ah, 9           ; moves value 9 to ah
  int 21h             ; adding interupt
  
  ret                 ; return

; Program to be executed if the 1st 2 byte has less number of 1's than last 2 byte        
        
lineAtRight:          ; label lineAtRight

  lea dx, lmf         ; moves the address of variable lmf to dx
  mov ah, 9           ; moves value 9 to ah
  int 21h             ; adding interupt
        
  lea dx, rmr         ; moves the address of variable rmr to dx
  mov ah, 9           ; moves value 9 to ah
  int 21h             ; adding interupt
  
  ret                 ; return
        
    
end                   ; ending the whole program
