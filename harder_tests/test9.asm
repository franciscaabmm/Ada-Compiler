.data
newline: .asciiz "\n"

.text
.globl main

main:
  # Prólogo: setup stack frame
  addi $sp, $sp, -100  # Reservar 100 bytes na stack

  li $t0, 48
  move $t1, $t0
  sw $t1, 0($sp)
  li $t2, 18
  move $t3, $t2
  sw $t3, 4($sp)
L_while_start_0:
  lw $t4, 4($sp)
  li $t5, 0
  sne $t6, $t4, $t5
  seq $t7, $t6, $zero
  bnez $t7, L_while_end_1
  lw $t0, 4($sp)
  move $t1, $t0
  sw $t1, 8($sp)
  lw $t2, 0($sp)
  lw $t3, 0($sp)
  lw $t4, 4($sp)
  div $t3, $t4
  mflo $t5
  lw $t6, 4($sp)
  mul $t7, $t5, $t6
  sub $t0, $t2, $t7
  move $t3, $t0
  sw $t3, 4($sp)
  lw $t1, 8($sp)
  sw $t1, 0($sp)
  j L_while_start_0
L_while_end_1:
  lw $t2, 0($sp)
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
