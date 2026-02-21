.data
newline: .asciiz "\n"

.text
.globl main

main:
  # Prólogo: setup stack frame
  addi $sp, $sp, -100  # Reservar 100 bytes na stack

  li $t0, 5
  move $t1, $t0
  sw $t1, 0($sp)
  li $t2, 1
  move $t3, $t2
  sw $t3, 4($sp)
  lw $t4, 0($sp)
  move $t5, $t4
  sw $t5, 8($sp)
L_while_start_0:
  lw $t6, 8($sp)
  li $t7, 0
  sgt $t0, $t6, $t7
  seq $t1, $t0, $zero
  bnez $t1, L_while_end_1
  lw $t2, 4($sp)
  lw $t3, 8($sp)
  mul $t4, $t2, $t3
  move $t3, $t4
  sw $t3, 4($sp)
  lw $t5, 8($sp)
  li $t6, 1
  sub $t7, $t5, $t6
  move $t5, $t7
  sw $t5, 8($sp)
  j L_while_start_0
L_while_end_1:
  lw $t0, 4($sp)
  # print_int
  move $a0, $t0
  li $v0, 1
  syscall
  # print newline
  li $v0, 4
  la $a0, newline
  syscall

  # Epílogo: exit
  li $v0, 10          # syscall 10 = exit
  syscall
