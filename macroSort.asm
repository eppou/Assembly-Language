.macro quicksort(%array, %size)

 main:
    la $t0, %array       # Move o endereço de array para o registrador $t0.
    addi $a0, $t0, 0    # Define o argumento 1 como o array.
    addi $a1, $zero, 0  # Define o argumento 2 como (low = 0)
    addi $a2, $zero, %size   # Define o argumento 3 como (high = último índice no array)
    jal quicksort        # Chama o quicksort
    j end

swap:                   # Método swap

    addi $sp, $sp, -12  # Faz espaço na pilha para três valores

    sw $a0, 0($sp)      # Armazena a0
    sw $a1, 4($sp)      # Armazena a1
    sw $a2, 8($sp)      # Armazena a2
 
    sll $t1, $a1, 2     # t1 = 4 * a
    add $t1, $a0, $t1   # t1 = arr + 4 * a
    lw $s3, 0($t1)      # s3 = t = array[a]

    sll $t2, $a2, 2     # t2 = 4 * b
    add $t2, $a0, $t2   # t2 = arr + 4 * b
    lw $s4, 0($t2)      # s4 = arr[b]

    sw $s4, 0($t1)      # arr[a] = arr[b]
    sw $s3, 0($t2)      # arr[b] = t

    addi $sp, $sp, 12   # Restaurando o tamanho da pilha
    jr $ra              # Salta de volta para o chamador


partition:              # Método partition

    addi $sp, $sp, -16  # Faz espaço para 5 valores na pilha

    sw $a0, 0($sp)      # Armazena a0
    sw $a1, 4($sp)      # Armazena a1
    sw $a2, 8($sp)      # Armazena a2
    sw $ra, 12($sp)     # Armazena o endereço de retorno

    move $s1, $a1       # s1 = low
    move $s2, $a2       # s2 = high

    sll $t1, $s2, 2     # t1 = 4 * high
    add $t1, $a0, $t1   # t1 = arr + 4 * high
    lw $t2, 0($t1)      # t2 = arr[high] (pivô)

    addi $t3, $s1, -1   # t3, i = low - 1
    move $t4, $s1       # t4, j = low
    addi $t5, $s2, -1   # t5 = high - 1

    forloop:
        slt $t6, $t5, $t4   # t6 = 1 se j > high - 1, t6 = 0 se j <= high - 1
        bne $t6, $zero, endfor   # Se t6 = 1, salta para endfor

        sll $t1, $t4, 2     # t1 = j * 4
        add $t1, $t1, $a0   # t1 = arr + 4 * j
        lw $t7, 0($t1)      # t7 = arr[j]

        slt $t8, $t2, $t7   # t8 = 1 se pivot < arr[j], 0 se arr[j] <= pivot
        bne $t8, $zero, endfif   # Se t8 = 1, salta para endfif
        addi $t3, $t3, 1   # i = i + 1

        move $a1, $t3       # a1 = i
        move $a2, $t4       # a2 = j
        jal swap           # swap(arr, i, j)

        addi $t4, $t4, 1   # j++
        j forloop

        endfif:
        addi $t4, $t4, 1   # j++
        j forloop           # Salta de volta para forloop

    endfor:
        addi $a1, $t3, 1   # a1 = i + 1
        move $a2, $s2      # a2 = high
        add $v0, $zero, $a1   # v0 = i + 1 (retorno)
        jal swap            # swap(arr, i + 1, high)

        lw $ra, 12($sp)      # endereço de retorno
        addi $sp, $sp, 16   # Restaura o tamanho da pilha
        jr $ra              # Salta de volta para o chamador


quicksort:               # Método quicksort

    addi $sp, $sp, -16    # Faz espaço para 4 valores na pilha

    sw $a0, 0($sp)        # a0
    sw $a1, 4($sp)        # low
    sw $a2, 8($sp)        # high
    sw $ra, 12($sp)       # endereço de retorno

    move $t0, $a2         # salvando high em t0

    slt $t1, $a1, $t0     # t1 = 1 se low < high, caso contrário, 0
    beq $t1, $zero, endif   # Se low >= high, salta para endif

    jal partition         # Chama o partition
    move $s0, $v0         # pivot, s0 = v0

    lw $a1, 4($sp)        # a1 = low
    addi $a2, $s0, -1     # a2 = pi - 1
    jal quicksort         # Chama o quicksort

    addi $a1, $s0, 1     # a1 = pi + 1
    lw $a2, 8($sp)       # a2 = high
    jal quicksort        # Chama o quicksort

endif:

    lw $a0, 0($sp)       # restaura a0
    lw $a1, 4($sp)       # restaura a1
    lw $a2, 8($sp)       # restaura a2
    lw $ra, 12($sp)      # restaura o endereço de retorno
    addi $sp, $sp, 16    # Restaura o tamanho da pilha
    jr $ra               # Retorna ao chamador

end:

    	
.end_macro

.macro insertionsort(%array, %fim, %inicio)
	
    saida_loop:
        add $t1, $zero, $zero
        la $a0,(%array)     #a0 recebe o começo do vetor
        la $t8,(%fim)    #t8 recebe fim do vetor
        la $t9, (%inicio) #t9 recebe inicio do vetor

    funciona_loop:
        lw  $t2, 0($a0)         #pega 1 elemento n do vetor
        lw  $t3, 4($a0)         #pega 1 elemento n+1 do vetor
        sgt $t5, $t3, $t2       #t5 recebe 1 se o elemento n+1 for > que o elemento n,else t5==0
        bne $t5, $zero, continua #se elemento ja estiverem ordenados manda continuar

        sw  $t2, 4($a0)                     # Trocar
        sw  $t3, 0($a0)                      # Trocar
       	bne $a0, $t9, swap		    #olha os elementos anteriores
    
    swap:
    	la $a2, 0($a0)
    	 			          #carrega o endereço atual
      s:
    	beq $a2, $t9, continua             #verifica se o atual elemento é o primeiro do vetor
    	lw $t2, 0($a2)			  #passa esse elemento pra t2
    	lw   $t3, -4($a2)		  #éga o elemento anterior
    	slt  $t6, $t3, $t2                #se t3 < t2, t6 = 1
    	bne $t6, $zero, s2                #vai para fazer a troca 
    	j continua                        
      s2:
      	sw $t2, -4($a2)                  #carrega valores no vetor
      	sw $t3, 0($a2)
      	addi $a2, $a2, -4                #reduz o endereço
      	j s  

    continua:
        addi $a0, $a0, 4            #pula para o endereço do proximo elemento do vetor
        addi $a1, $a0, 4         #pula para o elemento de maior posição que sera utilizado no proximo loop para ver se ja chegou no fim do vetor
        bne  $a1, $t8, funciona_loop    # Se o proximo elemento nao for o final, volta para o loop
		
.end_macro

.macro bubblesort(%inicio_vetor, %fim_vetor, %vector_size)

    saida_loop:
        add $t1, $zero, $zero
        la $a0,(%inicio_vetor)     #a0 recebe o começo do vetor
        la $t8,(%fim_vetor)    #t8 recebe fim do vetor

    funciona_loop:
        lw  $t2, 0($a0)         #pega 1 elemento n do vetor
        lw  $t3, 4($a0)         #pega 1 elemento n+1 do vetor
        sgt $t5, $t3, $t2       #t5 recebe 1 se o elemento n+1 for > que o elemento n,else t5==0
        bne $t5, $zero, continua #se elemento ja estiverem ordenados manda continuar

        add $t1, $zero, 1                      # Checar novamente
        sw  $t2, 4($a0)                     # Trocar
        sw  $t3, 0($a0)                      # Trocar

    continua:
        addi $a0, $a0, 4            #pula para o endereço do proximo elemento do vetor
        addi $a1, $a0, 4         #pula para o elemento de maior posição que sera utilizado no proximo loop para ver se ja chegou no fim do vetor
        bne  $a1, $t8, funciona_loop    # Se o proximo elemento nao for o final, volta para o loop
        bne  $t1, $zero, saida_loop    # Se $t1 = 1, volte para o out_loop para checar novamente porque houve uma troca de valores

.end_macro
