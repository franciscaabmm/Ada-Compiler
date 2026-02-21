.data
newline: .asciiz "\n"

.text
.globl main

main:
  # Prólogo: setup stack frame
  addi $sp, $sp, -100  # Reservar 100 bytes na stack

  li $t0, 12321
  move $t1, $t0
  sw $t1, 0($sp)
  lw $t2, 0($sp)
  move $t3, $t2
  sw $t3, 4($sp)
  li $t4, 0
  move $t5, $t4
  sw $t5, 8($sp)
L_while_start_0:
  lw $t6, 4($sp)
  li $t7, 0
  sgt $t0, $t6, $t7
  seq $t1, $t0, $zero
  bnez $t1, L_while_end_1
  lw $t2, 4($sp)
  lw $t3, 4($sp)
  li $t4, 10
  div $t3, $t4
  mflo $t5
  li $t6, 10
  mul $t7, $t5, $t6
  sub $t0, $t2, $t7
  move $t1, $t0
  sw $t1, 12($sp)
  lw $t2, 8($sp)
  li $t3, 10
  mul $t4, $t2, $t3
  lw $t5, 12($sp)
  add $t6, $t4, $t5
  move $t5, $t6
  sw $t5, 8($sp)
  lw $t7, 4($sp)
  li $t0, 10
  div $t7, $t0
  mflo $t1
  move $t3, $t1
  sw $t3, 4($sp)
  j L_while_start_0
L_while_end_1:
  lw $t2, 0($sp)
  lw $t3, 8($sp)
  seq $t4, $t2, $t3
  seq $t5, $t4, $zero
  bnez $t5, L_else_2
  li $t6, 1
  # print_int
  move $a0, $t6
  li $v0, 1
  syscall
  # print newline
  li $v0, 4
  la $a0, newline
  syscall
  j L_end_if_3
L_else_2:
  li $t7, 0
  # print_int
  move $a0, $t7
  li $v0, 1
  syscall
  # print newline
  li $v0, 4
  la $a0, newline
  syscall
L_end_if_3:

  # Epílogo: exit
  li $v0, 10          # syscall 10 = exit
  syscall
