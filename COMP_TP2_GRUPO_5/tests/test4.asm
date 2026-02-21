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
  lw $t2, 0($sp)
  li $t3, 10
  sgt $t4, $t2, $t3
  seq $t5, $t4, $zero
  bnez $t5, L_else_0
  li $t6, 1
  # print_int
  move $a0, $t6
  li $v0, 1
  syscall
  # print newline
  li $v0, 4
  la $a0, newline
  syscall
  j L_end_if_1
L_else_0:
  li $t7, 0
  # print_int
  move $a0, $t7
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
