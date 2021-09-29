.data
	#Cores usadas no projeto
	
	blue_clean:   .word 0x66ccff
	white:	  .word 0xFFFFFF
	green:    .word 0x6B8E23
	blue:	  .word 0x0000ff
	brown: 	  .word 0x734d26
	brown_clean: .word 0x86592d
	
	#vetor usado para armazenar a trajetoria do aspirador
	
	vetor: 	  .space 4096 
	
.text
	j main
	
	set_tela: #Inicia todos os valores para a tela
		addi $t0, $zero, 65536 #65536 = (512*512)/4 pixels
		add $t1, $t0, $zero #Adicionar a distribuição de pixels ao endereco
		lui $t1, 0x1004 #Endereco base da tela no heap, pode mudar se quiser
		add $t0, $zero, $t1
		addi $t2, $zero, 0
		loop: 
			sw $s4, ($t0) #Pinta o pixel na posicao $t0 com a cor de $s4
			addi $t0, $t0, 4 #Pulo +4 no pixel
			addi $t2, $t2, 1 #Contador +1
			beq $t2, 1024, exit
			j loop
		exit:
			jr $ra

	set_cores: #Salvar as cores em registradores
		lw $s1, brown
		lw $s3, blue_clean
		lw $s4, white
		lw $s5, blue
		lw $s7, green
		lw $s6, brown_clean
		jr $ra

	planta_baixa:
		add $t0, $zero, $t1
		addi $t2, $zero, 0
		loop_1: 
			sw $s5, ($t0) 
			addi $t0, $t0, 4 
			addi $t2, $t2, 1 #Contador +1
			beq $t2, 31, exit_1
			j loop_1
	exit_1:
		addi $t2, $zero, 0
		loop_2: 
			sw $s5, ($t0) 
			addi $t0, $t0, 128
			addi $t2, $t2, 1 #Contador +1
			beq $t2, 31, exit_2
			j loop_2
	exit_2:
		addi $t2, $zero, 0
		loop_3: 
			sw $s5, ($t0) 
			subi $t0, $t0, 4
			addi $t2, $t2, 1 #Contador +1
			beq $t2, 31, exit_3
			j loop_3
	exit_3:
		addi $t2, $zero, 0
		loop_4: 
			sw $s5, ($t0) 
			subi $t0, $t0, 128
			addi $t2, $t2, 1 #Contador +1
			beq $t2, 31, exit_4
			j loop_4
	exit_4:
		addi $t2, $zero, 0
		addi $t0,$t0,64
		loop_5: 
			sw $s5, ($t0) 
			addi $t0, $t0, 128
			addi $t2, $t2, 1 #Contador +1
			beq $t2, 8, exit_5
			j loop_5
	exit_5:
		addi $t2, $zero, 0
		addi $t0,$t0,128
		loop_6: 
			sw $s5, ($t0) 
			addi $t0, $t0, 128
			addi $t2, $t2, 1 #Contador +1
			beq $t2, 14, exit_6
			j loop_6
	exit_6:
		addi $t2, $zero, 0
		addi $t0,$t0,128
		loop_7: 
			sw $s5, ($t0) 
			addi $t0, $t0, 128
			addi $t2, $t2, 1 #Contador +1
			beq $t2, 7, exit_7
			j loop_7
	exit_7:
		addi $t2, $zero, 0
		subi $t0,$t0,1920
		loop_8: 
			sw $s5, ($t0) 
			addi $t0, $t0, 4
			addi $t2, $t2, 1 #Contador +1
			beq $t2, 15, exit_8
			j loop_8
		
	gerar_moveis:

		addi $t2,$zero, 0
		loop_9: 
			li $a1, 1024
			li $v0, 42
			syscall
			move $t0, $a0
			mul $t0,$t0,4
			add $t0, $t0, $t1
			lw $s2, ($t0)
			bne $s2, $s4, loop_9
			sw $s5, ($t0) 
			addi $t2, $t2, 1 #Contador +1
			beq $t2, 4, exit_8
			j loop_9 
			
	gerar_moveis_por_baixo:
	
		addi $t2,$zero, 0
		loop_10: 
			li $a1, 1024
			li $v0, 42
			syscall
			move $t0, $a0
			mul $t0,$t0,4
			add $t0, $t0, $t1
			lw $s2, ($t0)
			bne $s2, $s4, loop_10
			sw $s1, ($t0) 
			addi $t2, $t2, 1 #Contador +1
			beq $t2, 2, exit
			j loop_10
			
	gera_aspirador:
		
			addi $t2, $zero, 132
			add $t2, $t2, $t1
			sw $s7, ($t2)
			j exit_8
			
	check:
				
			sw $s7, ($t2)
			
	check_2:	
			li $v0, 32
			li $a0, 80
			
			syscall
			lw $s0, ($t2)
			beq $t9, 853, exit_8
			addi $t8, $t2, -128
			lw $s2, ($t8)
			beq $s2, $s1, anda_cima_por_baixo
			beq $s2, $s4, anda_cima
			addi $t8, $t2, 4
			lw $s2, ($t8)
			beq $s2, $s1, anda_direita_por_baixo
			beq $s2, $s4, anda_direita
			addi $t8, $t2, -4
			lw $s2, ($t8)
			beq $s2, $s1, anda_esquerda_por_baixo
			beq $s2, $s4, anda_esquerda
			addi $t8, $t2, 128
			lw $s2, ($t8)
			beq $s2, $s1, anda_baixo_por_baixo
			beq $s2, $s4, anda_baixo
			addi $t4, $t4, -4
			j acha_proximo
	anda_direita:
			lw $s2, ($t2)
			addi $t9, $t9, 1
			beq $s2, $s6, b4
			sw $s3, ($t2)
			sub $t2,$t2,$t1
			sw $t2, vetor($t7)
			addi $t7, $t7, 4
			addi $t5, $t7, -4
			addi $t4, $t5, 4
			add $t2,$t2,$t1
		b4:	addi $t2, $t2, 4
			j check
	anda_cima:	
			lw $s2, ($t2)
			addi $t9, $t9, 1
			beq $s2, $s6, b3
			sw $s3, ($t2)
			sub $t2,$t2,$t1
			sw $t2, vetor($t7)
			addi $t7, $t7, 4
			addi $t5, $t7, -4
			addi $t4, $t5, 4
			add $t2,$t2,$t1
		b3:	addi $t2, $t2, -128
			j check
	anda_esquerda:
			lw $s2, ($t2)
			addi $t9, $t9, 1
			beq $s2, $s6, b2
			sw $s3, ($t2)
			sub $t2,$t2,$t1
			sw $t2, vetor($t7)
			addi $t7, $t7, 4
			addi $t5, $t7, -4
			addi $t4, $t5, 4
			add $t2,$t2,$t1
		b2:	addi $t2, $t2, -4
			j check
	anda_baixo:
			lw $s2, ($t2)
			addi $t9, $t9, 1
			beq $s2, $s6, b1
			sw $s3, ($t2)
			sub $t2,$t2,$t1
			sw $t2, vetor($t7)
			addi $t7, $t7, 4
			addi $t5, $t7, -4
			addi $t4, $t5, 4
			add $t2,$t2,$t1
		b1:	addi $t2, $t2, 128
			j check
			
	anda_cima_por_baixo:
			addi $t9, $t9, 1
			sw $s3, ($t2)
			sub $t2,$t2,$t1
			sw $t2, vetor($t7)
			addi $t7, $t7, 4
			addi $t5, $t7, -4
			addi $t4, $t5, 4
			add $t2,$t2,$t1
			addi $t2, $t2, -128
			sw $s6, ($t2)
			j check_2
	anda_direita_por_baixo:
			addi $t9, $t9, 1
			sw $s3, ($t2)
			sub $t2,$t2,$t1
			sw $t2, vetor($t7)
			addi $t7, $t7, 4
			addi $t5, $t7, -4
			addi $t4, $t5, 4
			add $t2,$t2,$t1
			addi $t2, $t2, 4
			sw $s6, ($t2)
			j check_2
	anda_esquerda_por_baixo:
			addi $t9, $t9, 1
			sw $s3, ($t2)
			sub $t2,$t2,$t1
			sw $t2, vetor($t7)
			addi $t7, $t7, 4
			addi $t5, $t7, -4
			addi $t4, $t5, 4
			add $t2,$t2,$t1
			addi $t2, $t2, -4
			sw $s6, ($t2)
			j check_2
	anda_baixo_por_baixo:
			addi $t9, $t9, 1
			sw $s3, ($t2)
			sub $t2,$t2,$t1
			sw $t2, vetor($t7)
			addi $t7, $t7, 4
			addi $t5, $t7, -4
			addi $t4, $t5, 4
			add $t2,$t2,$t1
			addi $t2, $t2, 128
			sw $s6, ($t2)
			j check_2
			
	
	acha_proximo: 	
			#addi $t9, $t9, 1
			sw $s3, ($t2)
			lw $t2, vetor($t4)
			sw $t2, vetor($t7)
			addi $t7, $t7, 4
			addi $t5, $t7, -4
			add $t2, $t2, $t1
			j check
			
	anda_esquerda_proximo:
			addi $t9, $t9, 1
			sw $s3, ($t2)
			add $t7, $t2, $zero
			addi $t2, $t2, -4
			j check
	
	anda_cima_proximo:
			addi $t9, $t9, 1
			sw $s3, ($t2)
			add $t7, $t2, $zero
			addi $t2, $t2, -128
			j check
	
	anda_direita_proximo:
			addi $t9, $t9, 1
			sw $s3, ($t2)
			add $t7, $t2, $zero
			addi $t2, $t2, 4
			j check
	
	anda_baixo_proximo:
			addi $t9, $t9, 1
			sw $s3, ($t2)
			add $t7, $t2, $zero
			addi $t2, $t2, 128
			j check
			
	limpa_casa:
			beq $t2, 3964, exit_8
			j check
			
	exit_8:
		jr $ra
		

	main: 
		jal set_cores
		jal set_tela
		jal planta_baixa
		jal gerar_moveis
		jal gerar_moveis_por_baixo
		jal gera_aspirador
		addi $t9, $zero, 0
		jal limpa_casa
