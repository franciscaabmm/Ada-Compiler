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
  li $t2, 0
  move $t3, $t2
  sw $t3, 4($sp)
  li $t4, 0
  move $t5, $t4
  sw $t5, 8($sp)
L_while_start_0:
  lw $t6, 8($sp)
  lw $t7, 0($sp)
  slt $t0, $t6, $t7
  seq $t1, $t0, $zero
  bnez $t1, L_while_end_1
  # read_int
  li $v0, 5
  syscall
  move $t2, $v0
  move $t3, $t2
  sw $t3, 12($sp)
  lw $t4, 4($sp)
  lw $t5, 12($sp)
  add $t6, $t4, $t5
  move $t3, $t6
  sw $t3, 4($sp)
  lw $t7, 8($sp)
  li $t0, 1
  add $t1, $t7, $t0
  move $t5, $t1
  sw $t5, 8($sp)
  j L_while_start_0
L_while_end_1:
  lw $t2, 4($sp)
  lw $t3, 0($sp)
  div $t2, $t3
  mflo $t4
  move $t5, $t4
  sw $t5, 16($sp)
  lw $t6, 16($sp)
  # print_int
  move $a0, $t6
  li $v0, 1
  syscall
  # print newline
  li $v0, 4
  la $a0, newline
  syscall

  # Epílogo: exit
  li $v0, 10          # syscall 10 = exit
  syscall
