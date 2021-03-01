#   322225897   Roei    Gida
.data
    .section	.rodata
    int_scanf:	.string	"%hhd"
	string_scanf:	.string	"%s"
    test:   .string "%s"
.globl    run_main
    .type    run_main,@function
run_main:
    pushq   %rbp    # save old %rbp
    movq    %rsp,           %rbp    # set the new frame

    # generate the firs pstring
    leaq    -1(%rsp),       %rsp    # open space of one byte
    movq    %rsp,           %rsi    # set the soace that allocated in %rsi (second argument to scanf)
    movq    $int_scanf,     %rdi    # set the scanf format to %rdi
    movq    $0,             %rax
    call    scanf
    movzbq  (%rsp),         %r12    # set the scanned value in %r12
    movb    $0,             (%rsp)  # set \0 as value in %rsp
    subq    %r12,           %rsp    # decrease the pointer of %rsp in the given length 
    movq    %rsp,           %rsi    # set it in %rdi as second arg to scanf
    movq    $string_scanf,  %rdi    # set %rdx as the scanf string format
    movq    $0, %rax
    call    scanf


    leaq    -1(%rsp),       %rsp    # open space of one byte to the length
    movb    %r12b,          (%rsp)  # set the length as value in the one byte space in %rsp  
    movq    %rsp,           %r12    # set the address of the first pstring in %r12

    # generate the second pstring
    leaq    -1(%rsp),       %rsp    # open space of one byte
    movq    %rsp,           %rsi    # set the soace that allocated in %rsi (second argument to scanf)
    movq    $int_scanf,     %rdi    # set the scanf format to %rdi
    movq    $0,             %rax
    call    scanf
    movzbq  (%rsp),         %r13    # set the scanned value in %r13
    movb    $0,             (%rsp)  # set \0 as value in %rsp
    subq    %r13,           %rsp    # decrease the pointer of %rsp in the given length 
    movq    %rsp,           %rsi    # set it in %rdi as second arg to scanf
    movq    $string_scanf,  %rdi    # set %rdx as the scanf string format
    movq    $0,             %rax
    call    scanf
    leaq    -1(%rsp),       %rsp    # open space of one byte to the length
    movb    %r13b,          (%rsp)  # set the length as value in the one byte space in %rsp  
    movq    %rsp,           %r13    # set the address of the first pstring in %r13
    # sacn the case
    leaq    -1(%rsp),       %rsp    # open space of one byte to scanf the case number.
    movq    %rsp,           %rsi    # set %rsi to point to the allocated space.
    movq    $int_scanf,     %rdi    # set %rdi as the scan format.
    movq    $0, %rax
    call    scanf
    movzbq  (%rsp),         %rdi    # %rdi = case number
    movq    %r12,           %rsi    # aet %rsi to point the first pstring
    movq    %r13,           %rdx    # set %rdx to point the second pstring

    call    run_func
    xor     %rax,           %rax    # set %rax to 0 
    movq    %rbp,           %rsp    # set %rsp to the old stack poitner
    popq    %rbp                    # set %rbp to the old %rbp
    ret
