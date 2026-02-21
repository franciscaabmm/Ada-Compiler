.data
newline: .asciiz "\n"

.text
.globl main

main:
  # Prólogo: setup stack frame
  addi $sp, $sp, -100  # Reservar 100 bytes na stack

  li $t0, 17
  move $t1, $t0
  sw $t1, 0($sp)
  li $t2, 1
  move $t3, $t2
  sw $t3, 4($sp)
  li $t4, 2
  move $t5, $t4
  sw $t5, 8($sp)
  lw $t6, 0($sp)
  li $t7, 1
  sle $t0, $t6, $t7
  seq $t1, $t0, $zero
  bnez $t1, L_else_0
  li $t2, 0
  move $t3, $t2
  sw $t3, 4($sp)
  j L_end_if_1
L_else_0:
L_while_start_2:
  lw $t3, 8($sp)
  lw $t4, 8($sp)
  mul $t5, $t3, $t4
  lw $t6, 0($sp)
  sle $t7, $t5, $t6
  seq $t0, $t7, $zero
  bnez $t0, L_while_end_3
  lw $t1, 0($sp)
  lw $t2, 0($sp)
  lw $t3, 8($sp)
  div $t2, $t3
  mflo $t4
  lw $t5, 8($sp)
  mul $t6, $t4, $t5
  sub $t7, $t1, $t6
  move $t0, $t7
  sw $t0, 12($sp)
  lw $t1, 12($sp)
  li $t2, 0
  seq $t3, $t1, $t2
  seq $t4, $t3, $zero
  bnez $t4, L_end_if_4
  li $t5, 0
  move $t3, $t5
  sw $t3, 4($sp)
L_end_if_4:
  lw $t6, 8($sp)
  li $t7, 1
  add $t0, $t6, $t7
  move $t5, $t0
  sw $t5, 8($sp)
  j L_while_start_2
L_while_end_3:
L_end_if_1:
  lw $t1, 4($sp)
  # print_int
  move $a0, $t1
  li $v0, 1
  syscall
  # print newline
  li $v0, 4
  la $a0, newline
  syscall

  # Epílogo: exit
  li $v0, 10          # syscall 10 = exit
  syscall
