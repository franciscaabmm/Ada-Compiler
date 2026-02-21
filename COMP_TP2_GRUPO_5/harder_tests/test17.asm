.data
newline: .asciiz "\n"

.text
.globl main

main:
  # Prólogo: setup stack frame
  addi $sp, $sp, -100  # Reservar 100 bytes na stack

  li $t0, 30
  move $t1, $t0
  sw $t1, 0($sp)
  li $t2, 10
  move $t3, $t2
  sw $t3, 4($sp)
  li $t4, 20
  move $t5, $t4
  sw $t5, 8($sp)
  lw $t6, 0($sp)
  lw $t7, 4($sp)
  sgt $t0, $t6, $t7
  seq $t1, $t0, $zero
  bnez $t1, L_end_if_0
  lw $t2, 0($sp)
  move $t3, $t2
  sw $t3, 12($sp)
  lw $t4, 4($sp)
  move $t1, $t4
  sw $t1, 0($sp)
  lw $t5, 12($sp)
  move $t3, $t5
  sw $t3, 4($sp)
L_end_if_0:
  lw $t6, 4($sp)
  lw $t7, 8($sp)
  sgt $t0, $t6, $t7
  seq $t1, $t0, $zero
  bnez $t1, L_end_if_1
  lw $t2, 4($sp)
  move $t3, $t2
  sw $t3, 12($sp)
  lw $t3, 8($sp)
  sw $t3, 4($sp)
  lw $t4, 12($sp)
  move $t5, $t4
  sw $t5, 8($sp)
L_end_if_1:
  lw $t5, 0($sp)
  lw $t6, 4($sp)
  sgt $t7, $t5, $t6
  seq $t0, $t7, $zero
  bnez $t0, L_end_if_2
  lw $t1, 0($sp)
  move $t3, $t1
  sw $t3, 12($sp)
  lw $t2, 4($sp)
  move $t1, $t2
  sw $t1, 0($sp)
  lw $t3, 12($sp)
  sw $t3, 4($sp)
L_end_if_2:
  lw $t4, 0($sp)
  # print_int
  move $a0, $t4
  li $v0, 1
  syscall
  # print newline
  li $v0, 4
  la $a0, newline
  syscall
  lw $t5, 4($sp)
  # print_int
  move $a0, $t5
  li $v0, 1
  syscall
  # print newline
  li $v0, 4
  la $a0, newline
  syscall
  lw $t6, 8($sp)
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
