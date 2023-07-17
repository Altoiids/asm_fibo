;valid till 17 terms because int to string conversion valid till 3 digit number

section .text          
   global _start
	 
_start:   
   ;User prompt             
   mov eax, 4
   mov ebx, 1
   mov ecx, userMsg       
   mov edx, lenUserMsg
   int 80h

   ;Read and store the user input
   mov eax, 3
   mov ebx, 2
   mov ecx, num  
   mov edx, 4         
   int 80h
   mov edx, num

   ;convert string to int
   call atoi1
   mov edi,eax
   call f

   ; Exit code
   mov eax, 1
   mov ebx, 0
   int 80h

   f:   
      cmp edi,1
      jl end

      ;first term assigned value 0
      mov esi, '0'
      mov [first], esi 

      ;first term printed   
      mov eax, 4
      mov ebx, 1
      mov ecx, first     
      mov edx, 1
      int 80h

      ;comma print  
      mov eax, 4
      mov ebx, 1
      mov ecx, comma    
      mov edx, c_length
      int 80h
  
      ;value of counter decreased
      sub edi, 0x1         
      CMP	edi, 0
      JG next1

      ;exit sys_call
      mov eax,1             
      xor ebx,ebx
      int 0x80              

      next1 : 
         ;second term assigned value
         mov esi, '1'         
         mov [second], esi
         
         ;second term printed
         mov eax, 4
         mov ebx, 1
         mov ecx, second
         mov edx, 1
         int 80h

         ;counter decreased
         sub edi, 0x1
         CMP	edi, 0
         JG next

         ;exit sys_call
         mov eax,1             
         xor ebx,ebx
         int 0x80          

            next:
               ;values of register reset
               xor eax,eax
               xor ebx,ebx
               xor ecx,ecx
               xor edx,edx

               ;comma print  
               mov eax, 4
               mov ebx, 1
               mov ecx, comma    
               mov edx, c_length
               int 80h    

               ;calculation of next term
               xor edx,edx

               ;first term converted to integer
               mov edx, first
               call atoi
               xor ebx,ebx
               mov ebx,eax

               ;second term converted to integer
               xor edx,edx
               mov edx, second
               call atoi
               xor edx,edx
               mov ecx,eax

               ;next term calculated
               add ebx,ecx
               xor esi,esi
               mov eax,ebx
            
               ;next term converted to string and printed
               call itoa
              
               xor edx,edx

               ;terms updated
               mov edx, [second]
               mov [first], edx
               xor edx,edx
               mov edx, [ecx]
               mov [second], edx
               
               ;counter decreases
               sub edi, 0x1
               CMP	edi, 0
               JG next   ;loop
               ret

;ascii to integer conversion function for input data
atoi1:
    mov eax, 0
    mov esi, 0
convert1:


    movzx esi, byte [edx]   ; Get the current character
    cmp byte [edx + 1], 0   ; Check for string end
    je done1    

    cmp esi, '0'            ; Anything less than 0 is invalid
    jl error1
    
    cmp esi, '9'            ; Anything greater than 9 is invalid
    jg error1
     
    sub esi, '0'            ; Convert from ASCII to decimal 
    imul eax, 10            ; Multiply total by 10
   
    add eax, esi            ; Add current digit to total
    
    inc edx                 ; Get the address of the next character
    jmp convert1

error1:
    mov eax, -1             ; Return -1 on error
 
done1:
    ret


;integer to ascii conversion function

itoa:
    xor esi,esi
    lea esi, [string + 0x5]  ;last index of string
    
loop:
    ; divide
    xor edx, edx
    xor ecx,ecx
    mov ecx, 0xa
    div ecx        

    ; convert remainder to ASCII and store
    add dl, 0x30
    mov [esi-1],dl
    dec esi

    ; if quotient is zero, done.
    cmp eax, 0
    je print

    ;traversed through entire string
    cmp esi,string
    je print
    
    ; repeat.
    jmp loop

    print:
    mov eax,4
    mov ebx,1
    lea ecx,[string]
    ;finding where string generation starts
    sub esi, string
    add ecx,esi

    ;finding the final length of string
    mov edx, len
    sub edx,esi
   
    
    int 0x80
    ret

;ascii to integer conversion function for non input strings
atoi:
    mov eax, 0
    mov esi, 0

convert:

    movzx esi, byte [edx]   ; Get the current character
    test esi,esi            ; Check for \0
    je done    

    cmp esi, '0'            ; Anything less than 0 is invalid
    jl error
    
    cmp esi, '9'            ; Anything greater than 9 is invalid
    jg error
     
    sub esi, '0'            ; Convert from ASCII to decimal 
    imul eax, 10            ; Multiply total by 10
   
    add eax, esi            ; Add current digit to total
    
    inc edx                 ; Get the address of the next character
    jmp convert

error:
    mov eax, -1             ; Return -1 on error
 
done:
    ret

end:
      mov eax, 4
      mov ebx, 1
      mov ecx, errormsg     
      mov edx, lenem
      int 80h

      mov eax,1
      xor ebx,ebx
      int 80h


section .data                                   ;Data segment
   userMsg db 'Enter the number of terms: '     ;Ask the user to enter a number
   lenUserMsg equ $-userMsg                     ;The length of the message
   comma db ','
   c_length equ $ - comma
   string dd "     "  
   len equ $ - string
   errormsg db "invalid input"
   lenem equ $-errormsg
                  
section .bss           ;Uninitialized data
   num resb 4
   first resb 4
   second resb 4
   third resb 4



