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
  li $t2, 0
  move $t3, $t2
  sw $t3, 4($sp)
  li $t4, 1
  move $t5, $t4
  sw $t5, 8($sp)
  li $t6, 0
  move $t7, $t6
  sw $t7, 12($sp)
  lw $t0, 4($sp)
  # print_int
  move $a0, $t0
  li $v0, 1
  syscall
  # print newline
  li $v0, 4
  la $a0, newline
  syscall
  lw $t1, 8($sp)
  # print_int
  move $a0, $t1
  li $v0, 1
  syscall
  # print newline
  li $v0, 4
  la $a0, newline
  syscall
L_while_start_0:
  lw $t2, 12($sp)
  lw $t3, 0($sp)
  slt $t4, $t2, $t3
  seq $t5, $t4, $zero
  bnez $t5, L_while_end_1
  lw $t6, 4($sp)
  lw $t7, 8($sp)
  add $t0, $t6, $t7
  move $t1, $t0
  sw $t1, 16($sp)
  lw $t2, 16($sp)
  # print_int
  move $a0, $t2
  li $v0, 1
  syscall
  # print newline
  li $v0, 4
  la $a0, newline
  syscall
  lw $t3, 8($sp)
  sw $t3, 4($sp)
  lw $t4, 16($sp)
  move $t5, $t4
  sw $t5, 8($sp)
  lw $t5, 12($sp)
  li $t6, 1
  add $t7, $t5, $t6
  sw $t7, 12($sp)
  j L_while_start_0
L_while_end_1:

  # Epílogo: exit
  li $v0, 10          # syscall 10 = exit
  syscall
