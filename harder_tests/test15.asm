.data
newline: .asciiz "\n"

.text
.globl main

main:
  # Prólogo: setup stack frame
  addi $sp, $sp, -100  # Reservar 100 bytes na stack

  li $t0, 20
  move $t1, $t0
  sw $t1, 0($sp)
  li $t2, 0
  move $t3, $t2
  sw $t3, 4($sp)
  li $t4, 1
  move $t5, $t4
  sw $t5, 8($sp)
L_while_start_0:
  lw $t6, 8($sp)
  lw $t7, 0($sp)
  sle $t0, $t6, $t7
  seq $t1, $t0, $zero
  bnez $t1, L_while_end_1
  lw $t2, 8($sp)
  lw $t3, 8($sp)
  li $t4, 2
  div $t3, $t4
  mflo $t5
  li $t6, 2
  mul $t7, $t5, $t6
  sub $t0, $t2, $t7
  move $t1, $t0
  sw $t1, 12($sp)
  lw $t2, 12($sp)
  li $t3, 0
  seq $t4, $t2, $t3
  seq $t5, $t4, $zero
  bnez $t5, L_end_if_2
  lw $t6, 4($sp)
  li $t7, 1
  add $t0, $t6, $t7
  move $t3, $t0
  sw $t3, 4($sp)
  lw $t1, 8($sp)
  # print_int
  move $a0, $t1
  li $v0, 1
  syscall
  # print newline
  li $v0, 4
  la $a0, newline
  syscall
L_end_if_2:
  lw $t2, 8($sp)
  li $t3, 1
  add $t4, $t2, $t3
  move $t5, $t4
  sw $t5, 8($sp)
  j L_while_start_0
L_while_end_1:
  lw $t5, 4($sp)
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
