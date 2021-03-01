#   322225897   Roei    Gida
    .section    .rodata
        invalid_input_format:    .string "invalid input!\n"
    .text #beginning of code
.globl    pstrlen
    .type    pstrlen,@function
pstrlen:        # pstring length is saved in the first byte.
    movzbq    (%rdi),   %rax    # take the first byte to the  
    ret

# rdi rsi rdx rcx r8
.globl    replaceChar
    .type    replaceChar,@function
replaceChar: # replace every aqurance of char to other char
    movq  %rdi,           %rax        # save the beginning of the string.
    addq  $1,             %rdi        # set to the next char in the string. 
    jmp   .isNeedToStop
    .isEqual:
    cmp   %sil,            (%rdi)      # compare between the old char to the current value of the string
    je    .replace                     # if equal go to replace the chars
    addq  $1,              %rdi        # set to the next char in the string. 
    jmp   .isNeedToStop                # check if equals to \0
.isNeedToStop:
    cmp   $0,              (%rdi)      # compare between the value in %rdi to \0
    jne   .isEqual                     # check if the old equal to the new char
    ret
.replace: # if the char in %rdi equals to old char then replace with the new char. 
    movb    %dl,           (%rdi)      # replace to old with the new
    addq    $1,            %rdi        # set to the next char in the string. 
    jmp    .isNeedToStop               # check if equals to \0

# rdi -pstring1 rsi-pstring2 rdx-i rcx-j
.globl    pstrijcpy
    .type    pstrijcpy,@function
pstrijcpy:
    pushq   %rbp                         # save old %rbp
    movq    %rsp,            %rbp        # set the new frame
    pushq   %rdi                         # save the address of the dst pstring
    cmpb    $0,              %dl         # compare i to 0
    jb      .invalid_input               # if i<0 it is invalid input
    cmpb    %dl,             %cl         # compare i to j
    jb      .invalid_input               # if i > j it is invalid input
    cmpb    %cl,             (%rdi)      # compare j to the second pstring length
    jbe     .invalid_input               # if j >= pstring1.length it is invalid input
     cmpb   %cl,             (%rsi)      # compare j to the first pstring length
    jbe     .invalid_input               # if j >= pstring2.length invalid

    leaq 1(%rdx,%rsi,1),     %rsi        # increase the pointer of pstring2 in i+1 (+1 because the length is in the first index) 
    leaq 1(%rdx,%rdi,1),     %rdi        # increase the pointer of pstring1 in i+1 (+1 because the length is in the first index)
 

.change:
    cmpq    %rdx,              %rcx    # compare i to j
    jb      .finish                    # if i > j  finish the loop
    movb    (%rsi),            %r8b    # save pstring2 char in r8
    movb    %r8b,              (%rdi)  # change pstring1 char with pstring2 saved char
    leaq    1(%rsi),           %rsi
    leaq    1(%rdi),           %rdi    # set the pstrings pointers to the next char
    inc     %rdx                       # increase i in 1
    jmp     .change                        # repeat the proccess       

.invalid_input:
    movq    $invalid_input_format,    %rdi    # set the invalid format string
    movq    $0,                       %rax    # set %rax to 0 before the print
    call    printf
    xor    %rax,                      %rax    # set %rax to 0 

.finish:
    popq   %rax
    movq   %rbp,   %rsp    # set %rsp to the old stack poitner
    popq   %rbp            # set %rbp to the old %rbp
	ret

.globl    swapCase
    .type    swapCase,@function
swapCase:
    movq    %rdi,            %rax   # save the pstring pinter in %rax (return value)
    leaq	1(%rdi),         %rdi	# move %rdi to point to the string.
	jmp 	.isSwapNeeded
.swapLetters:                       # check if uppercase letter
	cmpb	$65,             (%rdi)	# compare char in %rdi to uppercase A 
	jb	    .notUpper               # check if the char in %rsi (string) is less than uppercase A then its not uppercase
	cmpb	$90,             (%rdi)	# compare char in %rdi to uppercase  Z
	ja	    .notUpper               # check if the char in %rsi (string) is greater than uppercase Z then its not uppercase
	addq	$32,             (%rdi)	# increase the ascii value by 32 to change it to lower case char
	jmp	    .notLetter	            # skips the next char.
.notUpper:                          # check if lower case letter
	
	cmpb	$97,             (%rdi)	# compare char in %rdi to lowercase a 
	jb	    .notLetter              # check if the char in %rsi (string) is less than lowercase a then its not lowercase
	cmpb	$122,            (%rdi)	# compare char in %rdi to lowercase z 
	ja	    .notLetter              # check if the char in %rsi (string) is greater than lowercase z then its not lowercase
	addq	$-32,            (%rdi)	# decrease the ascii value by 32 to change it to upper case char
.notLetter: # skips the next char.
	addq	$1,              %rdi	# increase the pointer to the string by one
.isSwapNeeded:
	cmpb	$0,              (%rdi)	# check the current value in %rdi equals to '\0'
	jne	    .swapLetters            # if not equal go back to swap the letter.
	ret

.globl    pstrijcmp
    .type    pstrijcmp,@function
pstrijcmp:
    pushq   %rbp                           # save old %rbp
    movq    %rsp,                %rbp      # set the new frame
    cmpb    $0,                  %dl       # compare i to 0
    jb      .invalid_input1                # if i<0 it is invalid input
    cmpb    %dl,                 %cl       # compare i to j
    jb      .invalid_input1                # if i > j it is invalid input
    cmpb    %cl,                 (%rdi)    # compare j to the second pstring length
    jbe     .invalid_input1                # if j >= pstring1.length it is invalid input
     cmpb   %cl,                 (%rsi)    # compare j to the first pstring length
    jbe     .invalid_input1                # if j >= pstring2.length invalid
    
    leaq    1(%rdx,%rsi,1),      %rsi      # increase the pointer of pstring2 in i+1 (+1 because the length is in the first index) 
    leaq    1(%rdx,%rdi,1),      %rdi      # increase the pointer of pstring1 in i+1 (+1 because the length is in the first index)

.compare:
    cmpb    %dl,                  %cl   # compare i to j
    jb      .pstrings_equal             # if i > j  finish the loop
    movb    (%rdi),              %r8b   # set the char of pstring1 to %r8
    cmpb    %r8b,                (%rsi) # compare char in pstring1 to pstring2
    jb      .pstring1_bigger            # if char in pstring1 > char in pstring2
    ja      .pstring2_bigger            # if char in pstring1 < char in pstring2                
    leaq    1(%rsi),             %rsi
    leaq    1(%rdi),             %rdi   # set the pstrings pointers to the next char
    inc     %rdx                        # increase i in 1
    jmp     .compare                    # repeat the proccess       


.pstring2_bigger:
    movq    $-1,        %rax    # if pstring2 bigger set the return value to -1
    jmp     .finish1            # after setting the return value go to finish
    .pstring1_bigger:
    movq    $1,         %rax    # if pstring2 bigger set the return value to -1
    jmp     .finish1            # after setting the return value go to finish
    .pstrings_equal:
    movq    $0,         %rax    # if the pstrings are equal set the return value to 0.
    jmp     .finish1            # after setting the return value go to finish

.invalid_input1:
    movq    $invalid_input_format,    %rdi    # set the invalid format string
    movq    $0,                       %rax    # set %rax to 0 before the print
    call    printf
    movq    $-2,                      %rax    # set %rax to 0 

.finish1:
    movq   %rbp,   %rsp    # set %rsp to the old stack poitner
    popq   %rbp            # set %rbp to the old %rbp
	ret

