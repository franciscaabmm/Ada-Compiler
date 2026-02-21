.data
newline: .asciiz "\n"

.text
.globl main

main:
  # Prólogo: setup stack frame
  addi $sp, $sp, -100  # Reservar 100 bytes na stack

  # read_int
  li $v0, 5
  syscall
  move $t0, $v0
  move $t1, $t0
  sw $t1, 0($sp)
  # read_int
  li $v0, 5
  syscall
  move $t2, $v0
  move $t3, $t2
  sw $t3, 4($sp)
  lw $t4, 0($sp)
  lw $t5, 4($sp)
  add $t6, $t4, $t5
  move $t7, $t6
  sw $t7, 8($sp)
  lw $t0, 0($sp)
  lw $t1, 4($sp)
  sub $t2, $t0, $t1
  move $t3, $t2
  sw $t3, 12($sp)
  lw $t4, 0($sp)
  lw $t5, 4($sp)
  mul $t6, $t4, $t5
  move $t7, $t6
  sw $t7, 16($sp)
  lw $t0, 8($sp)
  # print_int
  move $a0, $t0
  li $v0, 1
  syscall
  # print newline
  li $v0, 4
  la $a0, newline
  syscall
  lw $t1, 12($sp)
  # print_int
  move $a0, $t1
  li $v0, 1
  syscall
  # print newline
  li $v0, 4
  la $a0, newline
  syscall
  lw $t2, 16($sp)
  # print_int
  move $a0, $t2
  li $v0, 1
  syscall
  # print newline
  li $v0, 4
  la $a0, newline
  syscall
  lw $t3, 4($sp)
  li $t4, 0
  sne $t5, $t3, $t4
  seq $t6, $t5, $zero
  bnez $t6, L_else_0
  lw $t7, 0($sp)
  lw $t0, 4($sp)
  div $t7, $t0
  mflo $t1
  move $t2, $t1
  sw $t2, 20($sp)
  lw $t3, 20($sp)
  # print_int
  move $a0, $t3
  li $v0, 1
  syscall
  # print newline
  li $v0, 4
  la $a0, newline
  syscall
  j L_end_if_1
L_else_0:
  li $t4, 0
  # print_int
  move $a0, $t4
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
