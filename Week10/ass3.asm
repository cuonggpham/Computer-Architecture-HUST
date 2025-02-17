.eqv HEADING 0xffff8010 # integer: an angle between 0 and 359
# 0 : North (up)
# 90: East (right)
# 180: South (down)
# 270: West (left)
.eqv MOVING 0xffff8050 # boolean: whether or not to move
.eqv LEAVETRACK 0xffff8020 # boolean: (0 or non-0)
# whether or not to leave a track
.eqv WHEREX 0xffff8030 # integer: current x-location of Marsbot
.eqv WHEREY 0xffff8040 # integer: current y-location of marsbot
.text
#chuy?n bot v? n?i nh�n r� ???c tam gi�c
main: addi $a0, $0, 130 # Marsbot rotates 180 * running and start running
jal ROTATE
nop
jal GO
nop
sleep: addi $v0, $0, 32 # keep running by sleeping in 1000ms
li $a0, 1000
syscall
#----------------------------------
jal STOP
goline1: addi $a0, $0, 180 # Marsbot rotates 90 * running and start running
jal ROTATE
nop
jal TRACK
nop
jal GO
nop
sleep1: addi $v0, $0, 32 # keep running by sleeping in 3000ms
li $a0, 3000
syscall
#--------------------------------------
jal STOP
goline2: addi $a0, $0, 90 # Marsbot rotates 90 * running and start running
jal ROTATE
nop
jal UNTRACK
nop
jal TRACK
nop
jal GO
nop
sleep2: addi $v0, $0, 32 # keep running by sleeping in 4000ms
li $a0, 4000
syscall
#-------------------------------------
jal STOP
goline3: addi $a0, $0, 310 # Marsbot rotates 90 * running and start running
jal ROTATE
nop
jal UNTRACK
nop
jal TRACK
nop
jal GO
nop
sleep3: addi $v0, $0, 32 # keep running by sleeping in 6100ms
li $a0, 6100
syscall
#---------------------------------
end_main: jal STOP
nop
j end

#-----------------------------------------------------------
# GO procedure, to start running
# param[in] none
#-----------------------------------------------------------
GO: li $at, MOVING # change MOVING port
addi $k0, $zero,1 # to logic 1,
sb $k0, 0($at) # to start running
nop
jr $ra
nop
#-----------------------------------------------------------
# STOP procedure, to stop running
# param[in] none
#-----------------------------------------------------------
STOP: li $at, MOVING # change MOVING port to 0
sb $zero, 0($at) # to stop
nop
jr $ra
nop
#-----------------------------------------------------------
# TRACK procedure, to start drawing line
# param[in] none
#-----------------------------------------------------------
TRACK: li $at, LEAVETRACK # change LEAVETRACK port
addi $k0, $zero,1 # to logic 1,
sb $k0, 0($at) # to start tracking
nop
jr $ra
nop
#-----------------------------------------------------------
# UNTRACK procedure, to stop drawing line
# param[in] none
#-----------------------------------------------------------
UNTRACK:li $at, LEAVETRACK # change LEAVETRACK port to 0
sb $zero, 0($at) # to stop drawing tail
nop
jr $ra
nop
#-----------------------------------------------------------
# ROTATE procedure, to rotate the robot
# param[in] $a0, An angle between 0 and 359
# 0 : North (up)
# 90: East (right)
# 180: South (down)
# 270: West (left)
#-----------------------------------------------------------
ROTATE: li $at, HEADING # change HEADING port
sw $a0, 0($at) # to rotate robot
nop
jr $ra
nop
end: