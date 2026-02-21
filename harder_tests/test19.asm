.data
newline: .asciiz "\n"

.text
.globl main

main:
  # Prólogo: setup stack frame
  addi $sp, $sp, -100  # Reservar 100 bytes na stack

  li $t0, 85
  move $t1, $t0
  sw $t1, 0($sp)
  lw $t2, 0($sp)
  li $t3, 90
  sge $t4, $t2, $t3
  seq $t5, $t4, $zero
  bnez $t5, L_else_0
  li $t6, 5
  move $t7, $t6
  sw $t7, 4($sp)
  j L_end_if_1
L_else_0:
  lw $t0, 0($sp)
  li $t1, 80
  sge $t2, $t0, $t1
  seq $t3, $t2, $zero
  bnez $t3, L_else_2
  li $t4, 4
  move $t7, $t4
  sw $t7, 4($sp)
  j L_end_if_3
L_else_2:
  lw $t5, 0($sp)
  li $t6, 70
  sge $t7, $t5, $t6
  seq $t0, $t7, $zero
  bnez $t0, L_else_4
  li $t1, 3
  move $t7, $t1
  sw $t7, 4($sp)
  j L_end_if_5
L_else_4:
  lw $t2, 0($sp)
  li $t3, 60
  sge $t4, $t2, $t3
  seq $t5, $t4, $zero
  bnez $t5, L_else_6
  li $t6, 2
  move $t7, $t6
  sw $t7, 4($sp)
  j L_end_if_7
L_else_6:
  li $t7, 1
  sw $t7, 4($sp)
L_end_if_7:
L_end_if_5:
L_end_if_3:
L_end_if_1:
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
