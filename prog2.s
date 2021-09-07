# -*- mode: text -*-

#
# Nicholas Perry, nperry2, 116635288, 0104
# This is a jacobsthal calculator written in the MIPS assembly langauage.
# The program takes one integer value. It then runs a function to
# calculate the correct jacobsthal number. It will then print out the 
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

      la      $a0, eoln      # printf("\n")
      li      $v0, 4
      syscall

      li      $v0, 10          # quit program
      syscall

                               
jacobsthal:                    # prologue
      sub     $sp, $sp, 24     # set new stack pointer
      sw      $ra, 24($sp)     # save return address in stack
      sw      $fp, 20($sp)     # save old frame pointer in stack
      add     $fp, $sp, 24     # set new frame pointer

      li      $t0, -1          # set ans to -1
      sw      $t0, 16($sp)

      lw      $t0, 4($fp)      # load n into register
      bltz    $t0, endif       # if (n >= 0)

      li      $t1, 1           # load 1 into reg for if statement
      beqz    $t0, inside      # if(n == 0)
      beq     $t0, $t1, inside # if(n == 1)

      li      $t0, 1           # load 1 into reg
      sw      $t0, 16($sp)     # set ans = 1

      li      $t0, 0           # load 0 into reg
      sw      $t0, 12($sp)     # set prev = 0

                               # for the loop
      li      $t0, 2           # load 2 into reg
      sw      $t0, 4($sp)      # set i = 2
loop: lw      $t0, 4($sp)      # load i into reg
      lw      $t1, 4($fp)      # load n into reg
      bgt     $t0, $t1, endif  # while(i <= n)

                               # helper function call
      lw      $t0, 12($sp)     # load prev into reg    
      sw      $t0, ($sp)       # push arg. prev onto stack
      sub     $sp, $sp, 4      # increment stack pointer for arg

      lw      $t1, 20($sp)     # load ans into reg    
      sw      $t1, ($sp)       # push arg. ans onto stack
      sub     $sp, $sp, 4      # increment stack pointer for arg

      jal     helper           # helper(prev, ans)
                               # end of helper function call
      add     $sp, $sp, 8      # reset stack ptr from args
      move    $t0, $v0         # get the return value from the call
      
                               # temp= helper(prev, ans);
      sw      $t0, 8($sp)      # push return value into temp spot on stack                         
      lw      $t1, 16($sp)     # prev= ans;
      sw      $t1, 12($sp)
      lw      $t0, 8($sp)      # ans= temp;
      sw      $t0, 16($sp)

      lw      $t0, 4($sp)      # load i into reg
      add     $t0, $t0, 1      # increment reg of i
      sw      $t0, 4($sp)      # set i to new values
      j       loop
      j       endif

inside:
      lw      $t0, 4($fp)      # load n into reg
      sw      $t0, 16($sp)     # set ans = n
      j       endif

endif:
      lw      $t0, 16($sp)     # set reg to ans
      move    $v0, $t0         # set return to reg
                               
                               # epilogue
      lw      $ra, 24($sp)     # load ret addr from stack
      lw      $fp, 20($sp)     # restore old frame ptr from stack
      add     $sp, $sp, 24     # reset stack ptr
      jr      $ra              # ret to caller using saved ret addr

helper:
                              # prologue
      sub     $sp, $sp, 8     # set new stack pointer
      sw      $ra, 8($sp)     # save return address in stack
      sw      $fp, 4($sp)     # save old frame pointer in stack
      add     $fp, $sp, 8     # set new frame pointer

      lw      $t0, 8($fp)     # get values of x into reg
      lw      $t1, 4($fp)     # get values of y into reg
      mul     $t0, $t0, 2     # x = x * 2
      add     $t0, $t0, $t1   # x = x + y
      move    $v0, $t0        # set return value

                              # epilogue
      lw      $ra, 8($sp)     # load ret addr from stack
      lw      $fp, 4($sp)     # restore old frame ptr from stack
      add     $sp, $sp, 8     # reset stack ptr
      jr      $ra             # ret to caller using saved ret addr