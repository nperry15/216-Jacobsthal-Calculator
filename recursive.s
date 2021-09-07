# -*- mode: text -*-

#
# Nicholas Perry, nperry2, 116635288, 0104
# This is a jacobsthal calculator written in the MIPS assembly langauage.
# The program takes one integer value. It then runs a recursive function
# to calculate the correct jacobsthal number. It will then print out the 
# jacobsthal number and then a newline character.
#

      .data

number:       .word 0
result:       .word 0
eoln:         .asciiz "\n"

      .text

main: li      $v0, 5           # scanf("%d", &number);
      syscall
      move    $t0, $v0
      sw      $t0, number

      lw      $t0, number      # load number into reg    
      sw      $t0, ($sp)       # push arg. number onto stack
      sub     $sp, $sp, 4

      jal     jacobsthal       # jacobsthal(number)

      add     $sp, $sp, 4

      sw      $v0, result      # result = jacobsthal call return
      lw      $a0, result      # printf("%d", result)
      li      $v0, 1
      syscall

      la      $a0, eoln        # printf("\n")
      li      $v0, 4
      syscall

      li      $v0, 10          # quit program
      syscall

                               
jacobsthal:                    # prologue
      sub     $sp, $sp, 20     # set new stack pointer
      sw      $ra, 20($sp)     # save return address in stack
      sw      $fp, 16($sp)     # save old frame pointer in stack
      add     $fp, $sp, 20     # set new frame pointer

      li      $t0, -1          # set ans to -1
      sw      $t0, 12($sp)

      lw      $t0, 4($fp)      # load n into register
      bltz    $t0, endif       # if (n >= 0)

      li      $t1, 1           # load 1 into reg for if statement
      beqz    $t0, inside      # if(n == 0)
      beq     $t0, $t1, inside # if(n == 1)

      li      $t0, 1           # load 1 into reg
      sw      $t0, 12($sp)     # set ans = 1

                               # recursive for  temp1 = jacobsthal(n - 2)
      lw      $t2, 4($fp)      # loading reg 2 with n value
      sub     $t3, $t2, 2      # make value for n - 2
      sw      $t3, ($sp)       # set it for new stack n value

      sub     $sp, $sp, 4      # increment the pointer for new stack
      jal     jacobsthal       # call jacobsthal(n - 2)
      add     $sp, $sp, 4      # decrement the pointer from new stack

      move    $t0, $v0         # get return value
      mul     $t0, $t0, 2      # multiply return by 2
      sw      $t0, 8($sp)      # store the value in temp1

                               # recursive for  temp1 = jacobsthal(n - 2)
      lw      $t2, 4($fp)      # loading reg 2 with n value
      sub     $t3, $t2, 1      # make value for n - 1
      sw      $t3, ($sp)       # set it for new stack n value

      sub     $sp, $sp, 4      # increment the pointer for new stack
      jal     jacobsthal       # call jacobsthal(n - 1)
      add     $sp, $sp, 4      # decrement the pointer from new stack

      move    $t0, $v0         # get return value
      sw      $t0, 4($sp)      # store the value in temp2

                               # ans = temp1 + temp2
      lw      $t0, 8($sp)      # load the value in temp1
      lw      $t1, 4($sp)      # load the value in temp2
      add     $t0, $t0, $t1    # add temp1 and temp2
      sw      $t0, 12($sp)     # store ans in stack


      j       endif

inside:
      lw      $t0, 4($fp)      # load n into reg
      sw      $t0, 12($sp)     # set ans = n
      j       endif

endif:
      lw      $t0, 12($sp)     # set reg to ans
      move    $v0, $t0         # set return to reg
                               
                               # epilogue
      lw      $ra, 20($sp)     # load ret addr from stack
      lw      $fp, 16($sp)     # restore old frame ptr from stack
      add     $sp, $sp, 20     # reset stack ptr
      jr      $ra              # ret to caller using saved ret addr
