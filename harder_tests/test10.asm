.data
newline: .asciiz "\n"

.text
.globl main

main:
  # Prólogo: setup stack frame
  addi $sp, $sp, -100  # Reservar 100 bytes na stack

  li $t0, 12345
  move $t1, $t0
  sw $t1, 0($sp)
  li $t2, 0
  move $t3, $t2
  sw $t3, 4($sp)
L_while_start_0:
  lw $t4, 0($sp)
  li $t5, 0
  sgt $t6, $t4, $t5
  seq $t7, $t6, $zero
  bnez $t7, L_while_end_1
  lw $t0, 0($sp)
  lw $t1, 0($sp)
  li $t2, 10
  div $t1, $t2
  mflo $t3
  li $t4, 10
  mul $t5, $t3, $t4
  sub $t6, $t0, $t5
  move $t7, $t6
  sw $t7, 8($sp)
  lw $t0, 4($sp)
  lw $t1, 8($sp)
  add $t2, $t0, $t1
  move $t3, $t2
  sw $t3, 4($sp)
  lw $t3, 0($sp)
  li $t4, 10
  div $t3, $t4
  mflo $t5
  move $t1, $t5
  sw $t1, 0($sp)
  j L_while_start_0
L_while_end_1:
  lw $t6, 4($sp)
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
