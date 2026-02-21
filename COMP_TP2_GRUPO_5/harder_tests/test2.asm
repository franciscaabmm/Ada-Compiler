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
  li $t4, 15
  move $t5, $t4
  sw $t5, 8($sp)
  lw $t6, 0($sp)
  lw $t7, 4($sp)
  slt $t0, $t6, $t7
  move $t1, $t0
  sw $t1, 12($sp)
  lw $t2, 12($sp)
  # print_int
  move $a0, $t2
  li $v0, 1
  syscall
  # print newline
  li $v0, 4
  la $a0, newline
  syscall
  lw $t3, 0($sp)
  lw $t4, 8($sp)
  sge $t5, $t3, $t4
  move $t6, $t5
  sw $t6, 16($sp)
  lw $t7, 16($sp)
  # print_int
  move $a0, $t7
  li $v0, 1
  syscall
  # print newline
  li $v0, 4
  la $a0, newline
  syscall
  lw $t0, 0($sp)
  lw $t1, 4($sp)
  slt $t2, $t0, $t1
  lw $t3, 4($sp)
  lw $t4, 8($sp)
  sgt $t5, $t3, $t4
  and $t6, $t2, $t5
  move $t7, $t6
  sw $t7, 20($sp)
  lw $t0, 20($sp)
  # print_int
  move $a0, $t0
  li $v0, 1
  syscall
  # print newline
  li $v0, 4
  la $a0, newline
  syscall
  lw $t1, 0($sp)
  li $t2, 10
  seq $t3, $t1, $t2
  lw $t4, 4($sp)
  li $t5, 20
  sne $t6, $t4, $t5
  or $t7, $t3, $t6
  move $t0, $t7
  sw $t0, 24($sp)
  lw $t1, 24($sp)
  # print_int
  move $a0, $t1
  li $v0, 1
  syscall
  # print newline
  li $v0, 4
  la $a0, newline
  syscall
  lw $t2, 0($sp)
  lw $t3, 4($sp)
  sgt $t4, $t2, $t3
  seq $t5, $t4, $zero
  move $t6, $t5
  sw $t6, 28($sp)
  lw $t7, 28($sp)
  # print_int
  move $a0, $t7
  li $v0, 1
  syscall
  # print newline
  li $v0, 4
  la $a0, newline
  syscall
  lw $t0, 0($sp)
  lw $t1, 4($sp)
  slt $t2, $t0, $t1
  lw $t3, 8($sp)
  lw $t4, 4($sp)
  sle $t5, $t3, $t4
  and $t6, $t2, $t5
  lw $t7, 0($sp)
  lw $t0, 8($sp)
  sge $t1, $t7, $t0
  seq $t2, $t1, $zero
  or $t3, $t6, $t2
  move $t4, $t3
  sw $t4, 32($sp)
  lw $t5, 32($sp)
  # print_int
  move $a0, $t5
  li $v0, 1
  syscall
  # print newline
  li $v0, 4
  la $a0, newline
  syscall

  # Epílogo: exit
  li $v0, 10          # syscall 10 = exit
  syscall
