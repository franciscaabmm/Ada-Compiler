.data
newline: .asciiz "\n"

.text
.globl main

main:
  # Prólogo: setup stack frame
  addi $sp, $sp, -100  # Reservar 100 bytes na stack

  li $t0, 15
  move $t1, $t0
  sw $t1, 0($sp)
  li $t2, 20
  move $t3, $t2
  sw $t3, 4($sp)
  li $t4, 25
  move $t5, $t4
  sw $t5, 8($sp)
  lw $t6, 0($sp)
  lw $t7, 4($sp)
  slt $t0, $t6, $t7
  seq $t1, $t0, $zero
  bnez $t1, L_else_0
  lw $t2, 4($sp)
  lw $t3, 8($sp)
  slt $t4, $t2, $t3
  seq $t5, $t4, $zero
  bnez $t5, L_else_2
  lw $t6, 8($sp)
  move $t7, $t6
  sw $t7, 12($sp)
  lw $t0, 12($sp)
  # print_int
  move $a0, $t0
  li $v0, 1
  syscall
  # print newline
  li $v0, 4
  la $a0, newline
  syscall
  j L_end_if_3
L_else_2:
  lw $t1, 4($sp)
  move $t7, $t1
  sw $t7, 12($sp)
  lw $t2, 12($sp)
  # print_int
  move $a0, $t2
  li $v0, 1
  syscall
  # print newline
  li $v0, 4
  la $a0, newline
  syscall
L_end_if_3:
  j L_end_if_1
L_else_0:
  lw $t3, 0($sp)
  lw $t4, 8($sp)
  slt $t5, $t3, $t4
  seq $t6, $t5, $zero
  bnez $t6, L_else_4
  lw $t7, 8($sp)
  sw $t7, 12($sp)
  lw $t0, 12($sp)
  # print_int
  move $a0, $t0
  li $v0, 1
  syscall
  # print newline
  li $v0, 4
  la $a0, newline
  syscall
  j L_end_if_5
L_else_4:
  lw $t1, 0($sp)
  move $t7, $t1
  sw $t7, 12($sp)
  lw $t2, 12($sp)
  # print_int
  move $a0, $t2
  li $v0, 1
  syscall
  # print newline
  li $v0, 4
  la $a0, newline
  syscall
L_end_if_5:
L_end_if_1:
  lw $t3, 12($sp)
  # print_int
  move $a0, $t3
  li $v0, 1
  syscall
  # print newline
  li $v0, 4
  la $a0, newline
  syscall

  # Epílogo: exit
  li $v0, 10          # syscall 10 = exit
  syscall
