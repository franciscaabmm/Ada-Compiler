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
  lw $t4, 0($sp)
  lw $t5, 4($sp)
  add $t6, $t4, $t5
  li $t7, 2
  mul $t0, $t6, $t7
  li $t1, 5
  sub $t2, $t0, $t1
  move $t3, $t2
  sw $t3, 8($sp)
  lw $t4, 8($sp)
  # print_int
  move $a0, $t4
  li $v0, 1
  syscall
  # print newline
  li $v0, 4
  la $a0, newline
  syscall
  lw $t5, 0($sp)
  lw $t6, 4($sp)
  mul $t7, $t5, $t6
  li $t0, 2
  div $t7, $t0
  mflo $t1
  li $t2, 3
  add $t3, $t1, $t2
  move $t4, $t3
  sw $t4, 12($sp)
  lw $t5, 12($sp)
  # print_int
  move $a0, $t5
  li $v0, 1
  syscall
  # print newline
  li $v0, 4
  la $a0, newline
  syscall
  lw $t6, 0($sp)
  neg $t7, $t6
  lw $t0, 4($sp)
  add $t1, $t7, $t0
  lw $t2, 8($sp)
  neg $t3, $t2
  sub $t4, $t1, $t3
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
  lw $t7, 0($sp)
  lw $t0, 4($sp)
  add $t1, $t7, $t0
  lw $t2, 8($sp)
  lw $t3, 12($sp)
  sub $t4, $t2, $t3
  mul $t5, $t1, $t4
  lw $t6, 16($sp)
  li $t7, 1
  add $t0, $t6, $t7
  div $t5, $t0
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

  # Epílogo: exit
  li $v0, 10          # syscall 10 = exit
  syscall
