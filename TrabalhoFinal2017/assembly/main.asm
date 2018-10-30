
.kdata
exibindo_dinheiro: .asciiz "Seu Dinheiro atual -> $"
quebra_de_linha: .asciiz "\n"

dinheiro_insuficiente1: .asciiz "Você ainda não tem dinheiro para melhorar sua loja \n Melhoria 1 = $80 \n Melhoria 2 = $180 \n Melhoria 3 = $400"
dinheiro_insuficiente2: .asciiz "Você ainda não tem dinheiro para melhorar seu pastel \n Melhoria 1 = $30 \n Melhoria 2 = $100 \n Melhoria 3 = $300"
messageIni:         .asciiz "Cappastel\nBem-Vindo jovem pasteleiro!\nConstrua sua vida no ramo do pastel \nate você ser um sucesso!!!"
instrucao:  .asciiz "Instruções\nAperte:\n Espaço: ganha mais dinheiro\nA: Melhora a pastelaria\nS: Melhora o pastel"
venceu:  .asciiz "Você conquistou o mundo!!!"

incremento_inicial: 	.word 1

dinheiro_inicial:	.word 0

preco_pastel2:		.word 30

preco_pastel3:		.word 100

preco_pastel4:		.word 300

preco_cenario2:		.word 80

preco_cenario3:		.word 180

preco_cenario4:		.word 400

.globl main

.text


#----------------------------------------------------------------------------------------------------#
#--------------------------------------- Conta 30 milisegundos --------------------------------------#
#----------------------------------------------------------------------------------------------------#
pausa:
	li $v0, 32	
	li $a0, 500	#1000 = 1 seg
	syscall
	
	jr $ra
#----------------------------------------------------------------------------------------------------#


#----------------------------------------------------------------------------------------------------#
#------------------------------------------ Conta 2 segundos -----------------------------------------#
#----------------------------------------------------------------------------------------------------#
pausa2seg:
	li $v0, 32	
	li $a0, 2000	#1000 = 1 seg
	syscall
	
	jr $ra
#----------------------------------------------------------------------------------------------------#

#----------------------------------------------------------------------------------------------------#
#---------------------------------------- Upgrade Fundo ---------------------------------------------#
#----------------------------------------------------------------------------------------------------#
c2_1:			# Cenário 2 + pastel 1, padrao se repete
	jal cenario2
	nop
	jal pastel1
	nop

	j continua1
c2_2:
	jal cenario2
	nop
	jal pastel2
	nop

	j continua1
c2_3:
	jal cenario2
	nop
	jal pastel3
	nop
	
	j continua1
c2_4:
	jal cenario2
	nop
	jal pastel4
	nop
	
	j continua1
c3_1:
	jal cenario3
	nop
	jal pastel1
	nop

	j continua1
c3_2:
	jal cenario3
	nop
	jal pastel2
	nop

	j continua1
c3_3:
	jal cenario3
	nop
	jal pastel3
	nop
	
	j continua1
c3_4:
	jal cenario3
	nop
	jal pastel4
	nop
	
	j continua1
c4_1:
	jal cenario4
	jal pastel1

	j continua1
c4_2:
	jal cenario4
	nop
	jal pastel2
	nop

	j continua1
c4_3:
	jal cenario4
	jal pastel3
	
	j continua1
c4_4:
	jal cenario4
	nop
	jal pastel4
	nop
	
	la $a0, venceu   # Imprime mensagem Final
	li $a1, 2
	li $v0, 55
	syscall
	
	j continua1
	
fundo2:		# Faz o upgrade para o cenário 2
	lw $s2, preco_cenario2		# Carrega o preco no registrador $s2

	li $s4, 0
	slt $s4, $s0, $s2       	# Compara o dinheiro atual com o preco da melhoria, se o preco for maior que o dinheiro $s4 recebe 1
	beq $s4, 1, pouco_dinheiro1
	nop

	li $s3, 2
	add $s1, $s1, $s3

	sub $s0, $s0, $s2		# Subtrai o preco do dinheiro total
	
	beq $t6, 1, c2_1		# Caso o pastel 1 esteja ativo
	nop
	beq $t6, 2, c2_2		# Caso o pastel 2 esteja ativo
	nop
	beq $t6, 3, c2_3		# Caso o pastel 3 esteja ativo
	nop
	beq $t6, 4, c2_4		# Caso o pastel 4 esteja ativo
	nop
	
fundo3:		# Faz o upgrade para o cenário 3
	lw $s2, preco_cenario3	# Carrega o preco no registrador $t7

	li $s4, 0
	slt $s4, $s0, $s2       	
	beq $s4, 1, pouco_dinheiro1
	nop

	li $s3, 4
	add $s1, $s1, $s3

	sub $s0, $s0, $s2		# Subtrai o preco do dinheiro total
	
	beq $t6, 1, c3_1
	nop
	beq $t6, 2, c3_2
	nop
	beq $t6, 3, c3_3
	nop
	beq $t6, 4, c3_4
	nop
	
fundo4:		# Faz o upgrade para o cenário 4
	lw $s2, preco_cenario4	# Carrega o preco no registrador $t7

	li $s4, 0
	slt $s4, $s0, $s2       	# Compara $f5 com $f7, se $f5 for menor ou igual que $f7, o bc1t funciona, se nao, nao funciona
	beq $s4, 1, pouco_dinheiro1
	nop

	li $s3, 8
	add $s1, $s1, $s3

	sub $s0, $s0, $s2
	
	beq $t6, 1, c4_1
	nop
	beq $t6, 2, c4_2
	nop
	beq $t6, 3, c4_3
	nop
	beq $t6, 4, c4_4
	nop
	
upgrade_fundo:
	li $t7, 0
	
	addi $t5, $t5, 1 		# Parametro que determina qual fundo utizar
	
	beq $t5, 2, fundo2		# Exibe cenario 2 
	nop
	beq $t5, 3, fundo3		# Exibe cenario 3
	nop
	beq $t5, 4, fundo4		# Exibe cenario 4
	nop
	
	j continua1			# Volta para o codigo no main
	
pouco_dinheiro1:	# Nao realiza o upgrade porque o jogador nao tem dinheiro suficiente
	
	# Exibe mensagem informando que nao ha dinheiro suficiente 	
	la $a0, dinheiro_insuficiente1   # Imprime mensagem Inicial
	li $a1, 2
	li $v0, 55
	syscall
	
	subi $t5, $t5, 1
	
	j continua1	# Retorna a main
	
#----------------------------------------------------------------------------------------------------#


#----------------------------------------------------------------------------------------------------#
#---------------------------------------- Upgrade Pastel --------------------------------------------#
#----------------------------------------------------------------------------------------------------#
p1_2:			# Cenario 1, pastel 2, padrao se repete
	jal cenario1
	nop
	jal pastel2
	nop
	jal zoonose
	nop

	j continua1
p2_2:
	jal cenario2
	nop
	jal pastel2
	nop
	jal zoonose
	nop

	j continua1
p3_2:
	jal cenario3
	nop
	jal pastel2
	nop
	jal zoonose
	nop
	
	j continua1
p4_2:
	jal cenario4
	nop
	jal pastel2
	nop
	jal zoonose
	nop
	
	j continua1
p1_3:
	jal cenario1
	nop
	jal pastel3
	nop
	jal batpastel
	nop
	
	j continua1
p2_3:
	jal cenario2
	nop
	jal pastel3
	nop
	jal batpastel
	nop
	
	j continua1
p3_3:
	jal cenario3
	nop
	jal pastel3
	nop
	jal batpastel
	nop
	
	j continua1
p4_3:
	jal cenario4
	nop
	jal pastel3
	nop
	jal batpastel
	nop
	
	j continua1
p1_4:
	jal cenario1
	nop
	jal pastel4
	nop
	jal milhoes
	nop
	
	j continua1
p2_4:
	jal cenario2
	nop
	jal pastel4
	nop
	jal milhoes
	nop
	
	j continua1
p3_4:
	jal cenario3
	nop
	jal pastel4
	nop
	jal milhoes
	nop
	
	j continua1
p4_4:
	jal cenario4
	nop
	jal pastel4
	nop
	jal milhoes
	nop
	
	j continua1
	
past2:
	lw $s2, preco_pastel2		# Carrega o preco no registrador $t7

	li $s4, 0
	slt $s4, $s0, $s2       	
	beq $s4, 1, pouco_dinheiro2
	nop

	li $s3, 1
	add $s1, $s1, $s3

	sub $s0, $s0, $s2		# Retira o preco da melhoria do montante
	
	beq $t5, 1, p1_2		# Se cenario atual eh 1
	nop
	beq $t5, 2, p2_2		# Se cenario atual eh 2
	nop
	beq $t5, 3, p3_2		# Se cenario atual eh 3
	nop
	beq $t5, 4, p4_2		# Se cenario atual eh 4
	nop
	
past3:
	lw $s2, preco_pastel3		# Carrega o preco no registrador $t7

	li $s4, 0
	slt $s4, $s0, $s2       	
	beq $s4, 1, pouco_dinheiro2
	nop

	li $s3, 2
	add $s1, $s1, $s3

	sub $s0, $s0, $s2		# Retira o preco da melhoria do montante
	
	beq $t5, 1, p1_3
	nop
	beq $t5, 2, p2_3
	nop
	beq $t5, 3, p3_3
	nop
	beq $t5, 4, p4_3
	nop
	
past4:
	lw $s2, preco_pastel4		# Carrega o preco no registrador $t7

	li $s4, 0
	slt $s4, $s0, $s2       	# Compara $f5 com $f7, se $f5 for menor ou igual que $f7, o bc1t funciona, se nao, nao funciona
	beq $s4, 1, pouco_dinheiro2
	nop

	li $s3, 3
	add $s1, $s1, $s3

	sub $s0, $s0, $s2
	
	beq $t5, 1, p1_4
	nop
	beq $t5, 2, p2_4
	nop
	beq $t5, 3, p3_4
	nop
	beq $t5, 4, p4_4
	nop
	
upgrade_pastel:
	li $t7, 0
	
	addi $t6, $t6, 1 
	
	beq $t6, 2, past2
	nop
	beq $t6, 3, past3
	nop
	beq $t6, 4, past4
	nop

pouco_dinheiro2:	# Nao realiza o upgrade porque o jogador nao tem dinheiro suficiente
	
	# Exibe mensagem informando que nao ha dinheiro suficiente 		
	la $a0, dinheiro_insuficiente2   # Imprime mensagem Inicial
	li $a1, 2
	li $v0, 55
	syscall
	
	sub $t6, $t6, 1
	
	j continua1	# Retorna a main
#----------------------------------------------------------------------------------------------------#


#----------------------------------------------------------------------------------------------------#
#------------------------------------- Incremento dinheiro ------------------------------------------#
#----------------------------------------------------------------------------------------------------#
incrementa_exibe_dinheiro:
	add $s0, $s0, $s1	# Incrementa o montante de dinheiro armazenado em $f5, com a porcentagem +1 de $f6
	
	li $v0, 4		
	la $a0, exibindo_dinheiro
	syscall 
	
		# Exibe o montante de dinheiro atual
	li $v0, 1		
	addi $a0, $s0, 0 
	syscall 
	
	li $v0, 4		
	la $a0, quebra_de_linha
	syscall 
	
	jr $ra		# Retorna a main
#----------------------------------------------------------------------------------------------------#


#----------------------------------------------------------------------------------------------------#
#------------------------------------- Incremento pelo Jogador---------------------------------------#
#----------------------------------------------------------------------------------------------------#
incrementa_pelo_jogador:	
	addi $s0, $s0, 1	# Incrementa o montatnte de dinehiro com +1
	
	jr $ra		# Retorna a main
#----------------------------------------------------------------------------------------------------#

main:
	lui $t4, 0xffff		#Codigo para inserir uma tecla
	
	li $t6, 1	
	li $t5, 1
	li $t7, 0
	
	lw $s0, dinheiro_inicial
	
	lw $s1, incremento_inicial
	
	lw   $t7, 4($t4)		# Reseta $t7 pra zero
	
hist1:
	jal historia1
	nop

	lw $t7, 0($t4)			# Copia o conteudo de $t4 para $t7 e registra a tecla pressionada em $t7
	beq $t7, $0, hist1 		# player ainda nao pressionou uma tecla
	nop
	lw $t7, 4($t4)			# Reseta $t7 pra zero

hist2:
	jal historia2
	nop

	lw $t7, 0($t4)			# Copia o conteudo de $t4 para $t7 e registra a tecla pressionada em $t7
	beq $t7, $0, hist2	 	# player ainda nao pressionou uma tecla
	nop
	lw $t7, 4($t4)			# Reseta $t7 pra zero

instr1:
	jal instrucao1
	nop

	lw $t7, 0($t4)			# Copia o conteudo de $t4 para $t7 e registra a tecla pressionada em $t7
	beq $t7, $0, instr1	 	# player ainda nao pressionou uma tecla
	nop
	lw $t7, 4($t4)			# Reseta $t7 pra zero

instr2:
	jal instrucao2
	nop

	lw $t7, 0($t4)			# Copia o conteudo de $t4 para $t7 e registra a tecla pressionada em $t7
	beq $t7, $0, instr2	 	# player ainda nao pressionou uma tecla
	nop
	lw $t7, 4($t4)			# Reseta $t7 pra zero

instr3:
	jal instrucao3
	nop

	lw $t7, 0($t4)			# Copia o conteudo de $t4 para $t7 e registra a tecla pressionada em $t7
	beq $t7, $0, instr3	 	# player ainda nao pressionou uma tecla
	nop
	lw $t7, 4($t4)			# Reseta $t7 pra zero

instr4:
	jal instrucao4
	nop

	lw $t7, 0($t4)			# Copia o conteudo de $t4 para $t7 e registra a tecla pressionada em $t7
	beq $t7, $0, instr4	 	# player ainda nao pressionou uma tecla
	nop
	lw $t7, 4($t4)			# Reseta $t7 pra zero
			
espera_inicio_jogo:
	jal inicio
	nop

	lw $t7, 0($t4)			# Copia o conteudo de $t4 para $t7 e registra a tecla pressionada em $t7
	beq $t7, $0, espera_inicio_jogo	 	# player ainda nao pressionou uma tecla
	nop
	lw $t7, 4($t4)			# Reseta $t7 pra zero
	
	jal cenario1			# Carrega o cenario inicial, exibe na tela de bitmap 
	nop
	jal pastel1			# Carrega o pastel inicial, exibe na tela de bitmap
	nop
		
jogo:	# Loop que mantem o jogo em funcionamento
	lw   $t7, 4($t4)		# Reseta $t7 pra zero
	
espera_de_comando:	# Aguarda que uma tecla seja pressionada 

	jal pausa	# Realiza pausa 
	nop
	jal incrementa_exibe_dinheiro	# Incrementa e exibe montante de dinheiro
	nop

	lw $t7, 0($t4)			# Copia o conteudo de $t4 para $t7 e registra a tecla pressionada em $t7
	beq $t7, $0, espera_de_comando	# player ainda nao pressionou uma tecla
	nop
	lw $t7, 4($t4)			# Reseta $t7 pra zero
	
	beq $t7, 97, upgrade_fundo	#Reconhece letra A -> Tenta realizar upgrade de cenario
	nop
	beq $t7, 115, upgrade_pastel	#Reconhece a letra S -> Tenta realizar upgrade de pastel
	nop
	beq $t7, 32, incrementa_pelo_jogador	#Reconhece o Espaço -> Incrementa +1 no dinheiro
	nop
	
continua1:

	j jogo	# Realiza loop do game
	nop

fim:	
	li $v0, 10
	syscall

