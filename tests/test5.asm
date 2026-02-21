.data
newline: .asciiz "\n"

.text
.globl main

main:
  # Prólogo: setup stack frame
  addi $sp, $sp, -100  # Reservar 100 bytes na stack

  li $t0, 0
  move $t1, $t0
  sw $t1, 0($sp)
L_while_start_0:
  lw $t2, 0($sp)
  li $t3, 3
  slt $t4, $t2, $t3
  seq $t5, $t4, $zero
  bnez $t5, L_while_end_1
  lw $t6, 0($sp)
  # print_int
  move $a0, $t6
  li $v0, 1
  syscall
  # print newline
  li $v0, 4
  la $a0, newline
  syscall
  lw $t7, 0($sp)
  li $t0, 1
  add $t1, $t7, $t0
  sw $t1, 0($sp)
  j L_while_start_0
L_while_end_1:

  # Epílogo: exit
  li $v0, 10          # syscall 10 = exit
  syscall
