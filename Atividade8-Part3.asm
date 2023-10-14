
.include "macroSort.asm"

.data # Defines variable section of an assembly routine.
vetor: .word 12,15,10,5,7,3,2,1,22,31,9,8,54,90,78,13,46,21,23,36  #vetor para ir testando

.text 

.macro getLastAddressVetor(%endereço,%tamanho,%dest)

    .text
        main:
            move $t1, %endereço
            sll $t4, %tamanho, 2
            add %dest,$t4,$t1

.end_macro

.macro getFirstVetor(%endereço,%dest)

    .text
        main:
            li $t0, 0
            move $t1, %endereço
            lw $t9, 0($t1)
        loop:
            lw $t3,0($t1)
            move %dest, $t3

.end_macro

.macro printString(%string)
	.data
		string: .asciiz %string
	.text
		la $a0, string
		li $v0, 4
		syscall
.end_macro

.macro printInt(%int)
	.text
		move $a0, %int
		li $v0, 1
		syscall
.end_macro

.macro printIntVector(%address, %size)
    .text
        main:
            li $t0, 0
            move $t1, %address
        loop:
            lw $v0, ($t1) 
            printInt($v0)
            printString(" ")
            add $t0, $t0 1
            add $t1, $t1 4
            blt $t0, %size loop
        end:
.end_macro

.globl main

main:
#quicksort(vetor,19)
la $t9, vetor
li $t2, 20
getLastAddressVetor($t9,$t2,$s6)
getFirstVetor($t9,$s5)
la $t9, vetor
#insertionsort($t9,$s6,$s5)
bubblesort($t9,$s6,20)
printIntVector($t9,20)