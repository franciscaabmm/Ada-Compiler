.data
newline: .asciiz "\n"

.text
.globl main

main:
  # Prólogo: setup stack frame
  addi $sp, $sp, -100  # Reservar 100 bytes na stack

  li $t0, 10
  move $t1, $t0
  sw $t1, 0($sp)
  li $t2, 20
  move $t3, $t2
  sw $t3, 4($sp)
  lw $t4, 0($sp)
  lw $t5, 4($sp)
  slt $t6, $t4, $t5
  move $t7, $t6
  sw $t7, 8($sp)
  lw $t0, 8($sp)
  seq $t1, $t0, $zero
  bnez $t1, L_else_0
  li $t2, 1
  # print_int
  move $a0, $t2
  li $v0, 1
  syscall
  # print newline
  li $v0, 4
  la $a0, newline
  syscall
  j L_end_if_1
L_else_0:
  li $t3, 0
  # print_int
  move $a0, $t3
  li $v0, 1
  syscall
  # print newline
  li $v0, 4
  la $a0, newline
  syscall
L_end_if_1:

  # Epílogo: exit
  li $v0, 10          # syscall 10 = exit
  syscall
