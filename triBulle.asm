#Ming-Xia Delvas 20104038
#Antoine Leblanc 20162393
#Gabriel Emond 20107030

#segment de la mémoire contenant les données globales
.data 

#tampon résérvé pour le tableau
buffer: .space 400

#messages à afficher
msg: .asciiz "Entrez votre nombre:"
tab: .asciiz "    "
retour: .asciiz "\n"
depassement: .asciiz "ERREUR: Depassement de la memoire"

#segment de la mémoire contenant le code
.text	

#s5 adresse memoire
#s4 longueur
main :
	#ajout parametre
	la $s5, buffer
	add $a0,$0, $s5 #adresse memoire tableau
	addi $a1, $0, 100 #nbr max element
	jal saisir 
	add $s4, $0, $v0 #longueur tableau
	add $a1, $0, $s4
	add $a0, $0, $s5 #adresse tableau
	jal afficher
	add $a1 $0 $s4 #longeur tableau
	add $a0 $0 $s5
	jal trier
	add $a1 $0 $s4
	add $a0 $0 $s5
	jal afficher
	addi $s1, $0, 0
	li $v0, 10 #fin programme
	syscall 
	
saisir:
	#$t7 est critere arret
	#$s0 adresse tableau
	#$t0 adresse actuel
	#$s1 iterateur
	#s7 longeueur
	#t6 donne entre
	addi $t7, $0, -1 #critere arrete
	add $s0, $0, $a0 #adresse tableau
	subi $s7, $s7, 1 #diminue de 1 sinon longeur depasse de 1
loop:	
	addi $s1, $0, 0 
	#itere i de 1 et change ladresse memoire de 4 =adresse suivante
	sll  $t0, $s1, 2        
	add  $t0, $t0, $s0
	
	#print demande
	li $v0, 4
	la $a0, msg
	syscall
	
	#prend entre
	li $v0, 5
	syscall 
	add $t6, $v0, $0
	addi $s1, $s1, 1 #i+=1
	add $s7, $s7, $s1 #augmente longeur tableau
	bne $t6, $t7, entre
	add $v0, $0, $s7 #retourne longeur
	jr $ra
entre:
	#entre la donne 
	slt $t1, $s7, $a1
	beq $t1, $0, erreur #verifie si nest pas trop grande
	sw  $t6, 0($t0) #met dans la memoire
	addi $s0, $s0,4
	j loop #refait la loop
erreur:
	li $v0, 4
	la $a0, depassement #si depasse le nombre delement
	syscall
	addi $v0, $0, -1 
	#retourne -1
	jr $ra
	
afficher:
	#s0 adresse tableau
	#s1 variale iteration
	#t0 adresse actuel
	#t1 valeur 
	add $s0, $0, $a0
	addi $s1, $zero, 0
	add $s7, $0, $a1
boucle:
	#si i<longeur
	slt $t0, $s1, $s7      
	beq $t0, $0, fini #itere i et ladresse actuel dans le tableau
	sll $t0, $s1, 2        
	add $t0, $t0, $s0
	lw $t1, 0($t0) #va chcrcher dans la memoire
	li $v0, 1
	move $a0, $t1
	syscall #print donne
	li $v0, 4
	la $a0, tab
	syscall #pritn la tab
	addi $s1, $s1, 1
	j boucle #retourne debut boucle
fini:	
	li $v0, 4
	la $a0, retour #print retour a la ligne
	syscall
	jr $ra
	
trier:
	#s0 adresse tableau
	#t0 adresse actuel
	#t5 echange 1=true
	#s6 length-1
	#t2-t3 donne n et n+1
	#s1 iterateur
	addi $t5, $0, 1
	add $s0, $0, $a0
	add $s7, $0, $a1 #met la longeur
	subi $s6, $s7, 1 #longeur-1
while:
	addi $s1,$zero,0
	addi $t5, $0, 0
for:
	slt $t0, $s1, $s6      
	beq $t0, $0, premifini #si ieration est fini
	sll $t0, $s1, 2        
	add $t0, $t0, $s0
	lw $t2, 0($t0) #va chercher les donnes i et i+1
	lw $t3, 4($t0)
	slt $t1, $t3, $t2
	beq $t1, $0, endif #si plus grand
	sw $t3, 0($t0) #swap
	sw $t2, 4($t0)
	addi $t5, $0, 1 #remet echange true
endif:	
	addi $s1, $s1, 1
	j for
premifini:
	addi $s3, $0, 1
	beq $t5, $s3, while #lorsque fini boucle while
	jr $ra
