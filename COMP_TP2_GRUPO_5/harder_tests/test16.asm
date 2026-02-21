.data
newline: .asciiz "\n"

.text
.globl main

main:
  # Prólogo: setup stack frame
  addi $sp, $sp, -100  # Reservar 100 bytes na stack

  li $t0, 27
  move $t1, $t0
  sw $t1, 0($sp)
  li $t2, 0
  move $t3, $t2
  sw $t3, 4($sp)
  lw $t4, 0($sp)
  # print_int
  move $a0, $t4
  li $v0, 1
  syscall
  # print newline
  li $v0, 4
  la $a0, newline
  syscall
L_while_start_0:
  lw $t5, 0($sp)
  li $t6, 1
  sne $t7, $t5, $t6
  seq $t0, $t7, $zero
  bnez $t0, L_while_end_1
  lw $t1, 0($sp)
  lw $t2, 0($sp)
  li $t3, 2
  div $t2, $t3
  mflo $t4
  li $t5, 2
  mul $t6, $t4, $t5
  sub $t7, $t1, $t6
  move $t0, $t7
  sw $t0, 8($sp)
  lw $t1, 8($sp)
  li $t2, 0
  seq $t3, $t1, $t2
  seq $t4, $t3, $zero
  bnez $t4, L_else_2
  lw $t5, 0($sp)
  li $t6, 2
  div $t5, $t6
  mflo $t7
  move $t1, $t7
  sw $t1, 0($sp)
  j L_end_if_3
L_else_2:
  li $t0, 3
  lw $t1, 0($sp)
  mul $t2, $t0, $t1
  li $t3, 1
  add $t4, $t2, $t3
  move $t1, $t4
  sw $t1, 0($sp)
L_end_if_3:
  lw $t5, 0($sp)
  # print_int
  move $a0, $t5
  li $v0, 1
  syscall
  # print newline
  li $v0, 4
  la $a0, newline
  syscall
  lw $t6, 4($sp)
  li $t7, 1
  add $t0, $t6, $t7
  move $t3, $t0
  sw $t3, 4($sp)
  j L_while_start_0
L_while_end_1:
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
