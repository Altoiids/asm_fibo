;valid till 17 terms because int to string conversion valid till 3 digit number

section .text          
   global _start

	 
_start: 
   ;user prompt             
   mov rax, 4
   mov rbx, 1
   mov rcx, userMsg       
   mov rdx, lenUserMsg
   int 80h

   ;read and store the user input
   mov rax, 3
   mov rbx, 2
   mov rcx, memory  
   mov rdx, 8         
   int 80h
   mov rdx, memory

   ;convert string to int
   call atoi_input
   mov rdi,rax

   ;function containing logic to print fibonacci series
   call print_fibo
    
   ;exit sys_call 
    call exit


print_fibo: 
    ;check whether input is valid
    cmp rdi,1
    jl end

    ;first term assigned value 0
    mov rsi, '0'         
    mov [memory], rsi

    ;first term printed   
    mov rax, 4
    mov rbx, 1
    mov rcx, memory     
    mov rdx, 8
    int 80h
    
    ;first term moved to register
    mov r8,[memory]
    
    ;check if input is 1 (as we need not print comma in that case)
    cmp rdi,1
    je series_complete

    ;comma print  
    mov rax, 4
    mov rbx, 1
    mov rcx, comma    
    mov rdx, cLength
    int 80h
  
    ;value of counter decreased
    sub rdi, 0x1         
    cmp	rdi, 0
    jg print_t2

    call exit


print_t2 : 
    ;second term assigned value
    mov rsi, '1'         
    mov [memory], rsi
         
    ;second term printed
    mov rax, 4
    mov rbx, 1
    mov rcx, memory
    mov rdx, 8
    int 80h

    ;second term moved to register
    mov r9,[memory]

    ;counter decreased
    sub rdi, 0x1
    cmp rdi, 0
    jg print_nextterm

    call exit


print_nextterm:
    ;values of register reset
    xor rax,rax
    xor rbx,rbx
    xor rcx,rcx
    xor rdx,rdx

    ;comma print  
    mov rax, 4
    mov rbx, 1
    mov rcx, comma    
    mov rdx, cLength
    int 80h    

    ;calculation of next term
    xor rdx,rdx

    ;first term converted to integer
    mov [memory],r8
    mov rdx, memory
    call atoi
    xor rbx,rbx
    mov rbx,rax

    ;second term converted to integer
    xor rdx,rdx
    mov [memory],r9
    mov rdx, memory
    call atoi
    xor rdx,rdx
    mov rcx,rax

    ;next term calculated
    add rbx,rcx
    mov rax,rbx
            
    ;next term converted to string and printed
    call itoa

    ;terms updated
    mov r8,r9
    mov r9, [rcx]
          
    ;counter decreases
    sub rdi, 0x1
    cmp	rdi, 0
    jg print_nextterm  ;loop
    ret


;ascii to integer conversion function for input data
atoi_input:
    mov rax, 0
    mov rsi, 0

    converttoint:
    ;get the current character
    movzx rsi, byte [rdx]

    ;check for string end   
    cmp byte [rdx + 1], 0   
    je conversion_complete
       
    ;anything less than 0 is invalid
    cmp rsi, '0'            
    jl error1

    ;anything greater than 9 is invalid
    cmp rsi, '9'            
    jg error1
     
    ;convert from ASCII to decimal 
    sub rsi, '0'

    ;multiply total by 10             
    imul rax, 10            
   
    ;add current digit to total
    add rax, rsi            
    
    ;get the address of the next character
    inc rdx                 
    jmp converttoint

    error1:
    ;return -1 on error
    mov rax, -1             
 
    conversion_complete:
    ret


;integer to ascii conversion function
itoa:
    xor rsi,rsi
    ;last index of string
    lea rsi, [string + 0x9]  
    
    loop:
    ;divide
    xor rdx, rdx
    xor rcx,rcx
    mov rcx, 0xa
    div rcx        

    ;convert remainder to ASCII and store
    add dl, 0x30
    mov [rsi-1],dl
    dec rsi

    ;if quotient is zero, done.
    cmp rax, 0
    je print

    ;traversed through entire string
    cmp rsi,string
    je print
    
    ; repeat.
    jmp loop

    ;print next term procedure
    print:
    mov rax,4
    mov rbx,1
    lea rcx,[string]

    ;finding where string generation starts
    sub rsi, string
    add rcx,rsi

    ;finding the final length of string
    mov rdx, len
    sub rdx,rsi
    
    int 0x80
    ret


;ASCII(string) to integer conversion function for non input strings
atoi:
    mov rax, 0
    mov rsi, 0

    convert:
    ;get the current character
    movzx rsi, byte [rdx]
    ;check for \0   
    test rsi,rsi            
    je done  

    ;anything less than 0 is invalid
    cmp rsi, '0'            
    jl error
    
    ;anything greater than 9 is invalid
    cmp rsi, '9'            
    jg error
     
    ;convert from ASCII to decimal
    sub rsi, '0'

    ;multiply total by 10             
    imul rax, 10            
   
    ;add current digit to total
    add rax, rsi            
    
    ;get the address of the next character
    inc rdx                 
    jmp convert

    error:
    ;return -1 on error
    mov rax, -1             
 
    done:
    ret


end:
    mov rax, 4
    mov rbx, 1
    mov rcx, errorMsg     
    mov rdx, lenEM
    int 80h

    call exit


exit:
    ;exit code
    mov rax, 1
    mov rbx, 0
    int 80h


series_complete:
    call exit


;data segment
section .data                                   
    userMsg db 'Enter the number of terms: ' 
    ;the length of the message    
    lenUserMsg equ $-userMsg                     
    comma db ','
    cLength equ $ - comma
    string dd "         "  
    len equ $ - string
    errorMsg db "Invalid input"
    lenEM equ $-errorMsg


;uninitialized data               
section .bss           
    memory resb 8
    
    
  



