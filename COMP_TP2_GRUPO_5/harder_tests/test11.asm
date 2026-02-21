.data
newline: .asciiz "\n"

.text
.globl main

main:
  # Prólogo: setup stack frame
  addi $sp, $sp, -100  # Reservar 100 bytes na stack

  li $t0, 2
  move $t1, $t0
  sw $t1, 0($sp)
  li $t2, 10
  move $t3, $t2
  sw $t3, 4($sp)
  li $t4, 1
  move $t5, $t4
  sw $t5, 8($sp)
  li $t6, 0
  move $t7, $t6
  sw $t7, 12($sp)
L_while_start_0:
  lw $t0, 12($sp)
  lw $t1, 4($sp)
  slt $t2, $t0, $t1
  seq $t3, $t2, $zero
  bnez $t3, L_while_end_1
  lw $t4, 8($sp)
  lw $t5, 0($sp)
  mul $t6, $t4, $t5
  move $t5, $t6
  sw $t5, 8($sp)
  lw $t7, 12($sp)
  li $t0, 1
  add $t1, $t7, $t0
  move $t7, $t1
  sw $t7, 12($sp)
  j L_while_start_0
L_while_end_1:
  lw $t2, 8($sp)
  # print_int
  move $a0, $t2
  li $v0, 1
  syscall
  # print newline
  li $v0, 4
  la $a0, newline
  syscall

  # Epílogo: exit
  li $v0, 10          # syscall 10 = exit
  syscall
