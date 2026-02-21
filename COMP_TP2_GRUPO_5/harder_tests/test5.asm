.data
newline: .asciiz "\n"

.text
.globl main

main:
  # Prólogo: setup stack frame
  addi $sp, $sp, -100  # Reservar 100 bytes na stack

  li $t0, 7
  move $t1, $t0
  sw $t1, 0($sp)
  li $t2, 1
  move $t3, $t2
  sw $t3, 4($sp)
L_while_start_0:
  lw $t4, 4($sp)
  li $t5, 10
  sle $t6, $t4, $t5
  seq $t7, $t6, $zero
  bnez $t7, L_while_end_1
  lw $t0, 0($sp)
  lw $t1, 4($sp)
  mul $t2, $t0, $t1
  move $t3, $t2
  sw $t3, 8($sp)
  lw $t4, 8($sp)
  # print_int
  move $a0, $t4
  li $v0, 1
  syscall
  # print newline
  li $v0, 4
  la $a0, newline
  syscall
  lw $t5, 4($sp)
  li $t6, 1
  add $t7, $t5, $t6
  move $t3, $t7
  sw $t3, 4($sp)
  j L_while_start_0
L_while_end_1:

  # Epílogo: exit
  li $v0, 10          # syscall 10 = exit
  syscall
