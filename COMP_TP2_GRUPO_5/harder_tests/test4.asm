.data
newline: .asciiz "\n"

.text
.globl main

main:
  # Prólogo: setup stack frame
  addi $sp, $sp, -100  # Reservar 100 bytes na stack

  li $t0, 1
  move $t1, $t0
  sw $t1, 0($sp)
  li $t2, 0
  move $t3, $t2
  sw $t3, 4($sp)
L_while_start_0:
  lw $t4, 0($sp)
  li $t5, 5
  sle $t6, $t4, $t5
  seq $t7, $t6, $zero
  bnez $t7, L_while_end_1
  li $t0, 1
  move $t1, $t0
  sw $t1, 8($sp)
L_while_start_2:
  lw $t2, 8($sp)
  lw $t3, 0($sp)
  sle $t4, $t2, $t3
  seq $t5, $t4, $zero
  bnez $t5, L_while_end_3
  lw $t6, 4($sp)
  lw $t7, 8($sp)
  add $t0, $t6, $t7
  move $t3, $t0
  sw $t3, 4($sp)
  lw $t1, 8($sp)
  li $t2, 1
  add $t3, $t1, $t2
  move $t1, $t3
  sw $t1, 8($sp)
  j L_while_start_2
L_while_end_3:
  lw $t4, 0($sp)
  li $t5, 1
  add $t6, $t4, $t5
  move $t1, $t6
  sw $t1, 0($sp)
  j L_while_start_0
L_while_end_1:
  lw $t7, 4($sp)
  # print_int
  move $a0, $t7
  li $v0, 1
  syscall
  # print newline
  li $v0, 4
  la $a0, newline
  syscall

  # Epílogo: exit
  li $v0, 10          # syscall 10 = exit
  syscall
