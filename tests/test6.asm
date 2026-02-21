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
  lw $t0, 8($sp)
  # print_int
  move $a0, $t0
  li $v0, 1
  syscall
  # print newline
  li $v0, 4
  la $a0, newline
  syscall

  # Epílogo: exit
  li $v0, 10          # syscall 10 = exit
  syscall
