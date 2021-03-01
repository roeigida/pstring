#   322225897   Roei    Gida
    .data
	.section	.rodata
        case50_print_format:    .string "first pstring length: %d, second pstring length: %d\n"
        case52_print_format:    .string "old char: %c, new char: %c, first string: %s, second string: %s\n"
        case53_print_format:    .string "length: %d, string: %s\n"
        case54_print_format:    .string "length: %d, string: %s\n"
        case55_print_format:    .string "compare result: %d\n"
        invalid_case_format:    .string "invalid option!\n"
        sacnf_two_char_format:  .string " %c %c"
        scanf_int:   .string " %d"



    .align 8    # Align the address to be multiple of 8
.case:
.quad    .case_50    # case 50
.quad    .invalid    # case 51 - invalid
.quad    .case_52    # case 52
.quad    .case_53    # case 53
.quad    .case_54    # case 54
.quad    .case_55    # case 55
.quad    .invalid    # case 56 - invalid 
.quad    .invalid    # case 57 - invalid
.quad    .invalid    # case 58 - invalid
.quad    .invalid    # case 59 - invalid
.quad    .case_50    # case 60
# rdi rsi rdx rcx r8
    .text                # code
.globl    run_func
    .type    run_func, @function    # beginning of run_func
run_func: # manage the jump cases
    pushq   %rbp                               # save old %rbp
    movq    %rsp,                      %rbp    # set the new frame
    cmpq    $60,                       %rdi    # Compare rsi to 60
    ja      .invalid                           # if > 60, goto invalid-case
    cmpq    $50,                       %rdi    # Compare rsi to 60
    jb      .invalid                           # if 50 > , goto invalid-case
    leaq    -50(%rdi),                 %r8     # compute %r8 = x-50
    jmp     *.case(,%r8,8)                     # Goto the suitable cases.

.case_50:     
    movq    %rsi,                      %rdi    # save the first string in %rdi to send as argument to pstrlen.
    call    pstrlen   
    movq    %rax,                      %rsi    # save the first psrting len as a second argument to the printf
    movq    %rdx,                      %rdi    # save the second string in %rdi to send as argument to pstrlen.     
    call    pstrlen               
    movq    %rax,                      %rdx    # save the second psrting len as a third argument to the printf
    movq    $case50_print_format,      %rdi    # set the print format as rhe first argument
    movq    $0,                        %rax    # set %rax to zero before print
    call    printf
    jmp     .case_finisher

.case_52:
    # scanf the new and old chars.
    movq    %rsi,                      %r12    # save the address of the first string.     
    movq    %rdx,                      %r13    # save the address of the second string.     
    subq    $1,                        %rsp    # open a space of one byte to the first char
    movq    %rsp,                      %rsi    # save the adress as second argument to the scanf.
    subq    $1,                        %rsp    # open a space of one byte to the second char
    movq    %rsp,                      %rdx    #  # save the adress as second argument to the scanf.
    movq	$sacnf_two_char_format,    %rdi    # set the scanf format of two chars as a first param to scanf
    movq    $0,                        %rax    # set %rax to 0 before scanf
    call    scanf
    leaq    1(%rsp),                   %r14    # set the address of the first char to %r14
	movq    %rsp,                      %r15    # set the address of the first char to %r15
    # send the first string to replace char func
    movq    %r12,                      %rdi    # set the first pstring  
    movq    (%r14),                    %rsi    # set the old char as second argument
    movq    (%r15),                    %rdx    # set the new char as third argument  
    call    replaceChar 
    movq    %rax,                      %r12    # set the return value (pstring) to %r12
    addq    $1,                        %r12    # set %r12 to point the start of the string in pstring

    movq    %r13,                      %rdi    # set the second pstring  
    movq    (%r14),                    %rsi    # test
    movq    (%r15),                    %rdx    # set the new char as third argument  
    call    replaceChar
    movq    %rax,                      %r13    # set the return value (pstring) to %r12
    addq    $1,                        %r13    # set %r12 to point the start of the string in pstring
    # printing the strings in the requested format. 
    movq    $case52_print_format,      %rdi    # set the print format to %rdi
    movq    (%r14),                    %rsi    # set %rdx as the old char
    movq    (%r15),                    %rdx    # set %rsi as the new char
    movq    %r12,                      %rcx    # set %rcx as the first pstring
    movq    %r13,                      %r8     # set %r8 as the second pstring
    movq    $0,                        %rax    # zero the %rax before print   
    call    printf
    addq    $2,                        %rsp    # delete the space that allocated to the chars
    jmp    .case_finisher

.case_53:
    movq    %rsi,                      %r12    # set the first pstring to %r12 
    movq    %rdx,                      %r13    # set the second pstring to %r13
    leaq    -4(%rsp),                  %rsp    # open space in the stack of 4 bytes.
    movq    %rsp,                      %rsi    # set %rsi to the 4 byte space in stack.
    movq    $scanf_int,                %rdi    # set the scanf format.
    movq    $0,                        %rax
    call    scanf
    leaq    -4(%rsp),                  %rsp    # open space in the stack of 4 bytes.
    movq    %rsp,                      %rsi    # set %rsi to the 4 byte space in stack.
    movq    $scanf_int,                %rdi    # set the scanf format.
    movq    $0,                        %rax     
    call    scanf
  
    movq    %r13,                      %rsi     # set second pstring as second argument
    movq    %r12,                      %rdi     # set first pstring as first argument
    movzbq    4(%rsp),                 %rdx     # set i as third argument
    movzbq    (%rsp),                  %rcx     # set j as the fourth argument 
    call    pstrijcpy  
    movzbq    (%rax),                  %rsi     # set the pstring length as second argumet to print
    leaq    1(%rax),                   %rdx     # set the new pstring as third argumet to print
    movq    $case53_print_format,      %rdi     # set the print format       
    movq    $0,                        %rax     
    call    printf
    movzbq  (%r13),                    %rsi     # set the pstring length as second argumet to print
    leaq    1(%r13),                   %rdx     # set the new pstring as third argumet to print
    movq    $case53_print_format,      %rdi     # set the print format       
    movq    $0,                        %rax     
    call printf
    leaq    -8(%rsp),                  %rsp     # free the space been allocated. 
    jmp    .case_finisher


.case_54:
    movq    %rsi,                      %r12     # set %r12 to point pstring1
    movq    %rdx,                      %r13     # set %r13 to point pstring2
    movq    %r12,                      %rdi     # set %rdi to point pstring1
    call    swapCase      
    movq    $case54_print_format,      %rdi     # set the print format
    movzbq  (%rax),                    %rsi     # set the length of the string in pstring1 to %rsi
    leaq    1(%rax),                   %rdx     # set %rdx to point the string in pstring1
    movq    $0,                        %rax     
    call printf
    movq    %r13,                      %rdi     # set %rdi to point pstring2
    call    swapCase      
    movq    $case54_print_format,      %rdi     # set the print format
    movzbq    (%rax),                  %rsi     # set the length of the string in pstring2 to %rsi
    leaq    1(%rax),                   %rdx     # set %rdx to point the string in pstring2
    movq    $0,                        %rax     
    call printf
    jmp    .case_finisher


.case_55:
    movq    %rsi,                      %r12    # set the first pstring to %r12 
    movq    %rdx,                      %r13    # set the second pstring to %r13
    leaq    -4(%rsp),                  %rsp    # open space in the stack of 4 bytes.
    movq    %rsp,                      %rsi    # set %rsi to the 4 byte space in stack.
    movq    $scanf_int,                %rdi    # set the scanf format.
    movq    $0,                        %rax
    call    scanf
    leaq    -4(%rsp),                  %rsp    # open space in the stack of 4 bytes.
    movq    %rsp,                      %rsi    # set %rsi to the 4 byte space in stack.
    movq    $scanf_int,                %rdi    # set the scanf format.
    movq    $0,                        %rax     
    call    scanf
  
    movq    %r13,                      %rsi    # set second pstring as second argument
    movq    %r12,                      %rdi    # set first pstring as first argument
    movzbq    4(%rsp),                 %rdx    # set i as third argument
    movzbq    (%rsp),                  %rcx    # set j as the fourth argument 
    call    pstrijcmp
    movq    %rax,                      %rsi    # set the pstring length as second argumet to print
    movq    $case55_print_format,      %rdi    # set the print format       
    movq    $0,                        %rax     
    call printf
    movq    $0,                        %rax
    call printf
    jmp    .case_finisher


.invalid:
    movq    $invalid_case_format,      %rdi    # set the invalid format string
    movq    $0,                        %rax    # set %rax to 0 before the print
    call printf
    xor    %rax,                       %rax    # set %rax to 0 

.case_finisher:
    xor    %rax,                       %rax    # set %rax to 0 
    movq   %rbp,                       %rsp    # set %rsp to the old stack poitner
    popq   %rbp                                # set %rbp to the old %rbp
    ret
