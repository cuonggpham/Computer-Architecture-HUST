.data
    s1: .space 100
    s2: .space 100
    message:  	  .asciiz 	"Enter string: "
    mess_result:  .asciiz 	"Common characters of Strings: "
.text
main:	la	$t1, s1		# l?u ??a ch? chu?i s1 ?? l?u n?i dung chu?i s? ???c nh?p v�o
   	jal	get_input 	# get_input($t1)-> y�u c?u nh?p chu?i t? b�n ph�m v� l?u v�o $t1
   	nop
   	add 	$s1, $t1, $0	# ??a ch? chu?i s1 -> $s1 = $t1

	la	$t1, s2		# l?u ??a ch? chu?i s1 ?? l?u n?i dung chu?i s? ???c nh?p v�o
   	jal	get_input 	# get_input($t1)-> y�u c?u nh?p chu?i t? b�n ph�m v� l?u v�o $t1
   	nop
   	add 	$s2, $t1, $0	# ??a ch? chu?i s2 -> $s2 = $t1 

   	add	$a0, $s1, $0	# g�n ??a ch? chu?i s1($s1) v�o $a0 ?? d�ng h�m common_char
   	add	$a1, $s2,$0	# g�n ??a ch? chu?i s2($s2) v�o $a1 ?? d�ng h�m common_char
   	jal 	common_char	# common_char($a0, $a1) -> t�m c�c k� t? chung v� l?u v�o stack 
   	nop
   	
	jal	count_common	# count_common($a0, $a1, $k1) dem so lan lap cua cac ki tu chung
	nop
end_main:	li $v0, 10      # k?t th�c ch??ng tr�nh
		syscall
		
# function get_input($t1)
# $t1: l?u ??a ch? c?a string
get_input: la $a0, message    	
    	   li $v0, 4		# print string
    	   syscall
    		
   	   li $v0, 8       	# read string
	   add $a0, $t1, $0  	# l?u space c?a string v�o $a0
    	   li $a1, 100      	# ?? d�i l?n nh?t c?a chu?i nh?p v�o
    	   
    	   add $t1, $a0, $0   	# l?u d?a ch? string v?a nh?p v�o $t1
    	   syscall
	   jr $ra		# end func v� tr? l?i main


# function common_char($a0, $a1)
common_char: 	li $t0, 0	# kh?i t?o bi?n ch?y 1 $t0 = i

# loop1: L?p qua c�c k� t? c?a string1 ($a0)
loop1:		add $t2, $a0, $t0	# t2 = a0 + i = address string1[i]
		lb $t3, 0($t2)		# t3 = string1[i]
		beq $t3, 10, end_common_char #  n?u l� k� t? '\n' = 10 thi d?ng v� h?t chu?i
		nop
		li $t1, 0	# bi?n ch?y 2 $t1 = j
		
# loop2: v?i m?i k� t? ??c t? string1($a0) , so s�nh l?n l??t v?i c�c k� t? string2 ($a1)
#	n?u k� t? l� chung th� push v�o stack, n?u kh�ng tr�ng ti?p t?c ??n k� t? ti?p theo ? string1
#	l� v�ng l?p l?ng trong loop1
loop2:		add $t4, $a1, $t1		# t4 = a1 + j = address string2[j]
		lb $t5, 0($t4)			# t5 = string2[j]
		beq $t5, 10, countinue_loop1	# n?u l� k� t? '\n' = 10 thi d?ng v� h?t chu?i
		nop
		beq $t3, $t5, push_to_stack	# n?u string1[i] == string2[j] -> push v�o stack
		nop

		addi $t1,$t1,1			# j++
		j loop2

countinue_loop1:	addi $t0, $t0, 1	# i++
			j loop1

end_common_char: 	jr $ra

#------------------------------------------------------------------------------
# push_to_stack($t3)
# Ki?m tra gi� tr? trong thanh ghi $t3 ?� t?n t?i trong stack hay ch?a.
#	N?u ch?a t?n t?i -> push v�o stack
#	N?u ?� t?n t?i -> d?ng v� tr? l?i lopp1 ?? ??c ti?p k� t?
# $t3: l?u gi� tr? c?a k� t? c?n push v�o stack
# $k1: s? l??ng ph?n t? hi?n t?i c?a stack
#------------------------------------------------------------------------------
push_to_stack:	li $t6, 0		# kh?i t?o bi?n ch?y $t6: k = 0 

# check_loop: duy?t stack v� ki?m tra xem $t3 ?� c� trong stack hay ch?a? 
check_loop:	beq $t6, $k1, push 	# n?u $t6 = $k1 -> duy?t h?t stack -> ch?a c� trong stack -> push
		nop
		
		sll $t7, $t6, 2  		# $t7 = $t6 * 4
		add $t7, $t7, $sp 		# $t7 = $sp + k*4 = address ph?n t? th? k c?a stack
		lb $t8, 0($t7)			# $t8 l?u ph?n t? th? k c?a stack
		beq $t8, $t3, countinue_loop1 	# neu $t8 = $t3 ->  $t3 ?� t?n t?i -> kh�ng push -> tho�t v� quay l?i v�ng l?p ngo�i
		nop

		addi $t6, $t6, 1 		# k++
		j check_loop

# push: l?u gi� tr? c?a k� t? $t3 v�o stack $sp
push: 		addi $sp, $sp, -4	# d?ch con tr? stack
		sw   $t3, 0($sp)	# l?u $t3 v�o stack
		addi $k1, $k1, 1	# c?p nh?t ph?n t? c?a stack $k1++
		j countinue_loop1

#------------------------------------------------------------------------------
#------------------------------------------------------------------------------
# function count_common($a0, $a1, $sp)
# ??m c�c s? l?n l?p c?a k� t? chung c?a 2 chu?i v� in ra k?t qu?
# 	$a1, $a0: ??a ch? c?a chu?i ??a v�o
# 	$sp -> stack c�c k� t? chung
#	$k1 -> s? l??ng k� t? chung hay s? l??ng hi?n t?i c?a stack
# Tr? v? k?t qu? l?u trong: $s7
#------------------------------------------------------------------------------
count_common:	li $t1, 0	 # bi?n l?p i = 0
		add $t9, $ra, $0 # l?u ??a ch? tr? v? $t9 = $ra

# loop_stack: duy?t c�c ph?n t? c?a stack 
loop_stack:	beq $t1, $k1, print_result 	# n?u i == s? l??ng ph?n t? stack -> d?ng v� in k?t qu?
		nop

		sll $t2, $t1, 2  	# t2 = t1 * 4 = 4i
		add $t2, $t2, $sp 	# t2 = sp + i*4 = address ph?n t? th? i c?a stack
		lb $s3, 0($t2)		# load ph?n t? th? i c?a Stack v�o $s3
		

		add $a2, $s1, $0 	# g�n ??a ch? string s1(?ang l?u trong $s1) vao $a2 ?? d�ng h�m count_in_string
		jal count_in_string	# count_in_string($s3, $a2) ??m s? k� t? $s3 trong string $a2		
		nop			# return k?t qu? ra $k0

		add $s5, $k0, $0 	# g�n count v?a t�m ???c trong string s1 vao $s5

		add $a2, $s2, $0	# g�n ??a ch? string s2(?ang l?u trong $s2) vao $a2 ?? d�ng h�m count_in_string
		jal count_in_string	

		add $s6, $k0, $0 	# g�n count v?a t�m ???c trong string s2 vao $s6

# result: so s�nh $s5, $s6 l?y gi� tr? nh? h?n v� c?ng d?n v�o k?t qu? $s7
result:		slt  $t3, $s5, $s6	# n?u $s5 < $s6 -> ?�ng $t3 = 1, ng??c l?i $t3 = 0
		beqz $t3, update	# n?u $t3 = 0 -> $s6 < $s5 c?p nh?t $s7 b?ng $s6 

		add $s7, $s7, $s5	# TH $t3 = 1 -> $s5 < $s6 -> c?p nh?t $s7

countinue_loop:	addi $t1, $t1, 1 	# i++
		j loop_stack		# ti?p t?c l�ng l?p c�c k� t? ?ang ch?a trong stack

# printf_result: in ra m�n h�nh k?t qu? ???c l?u trong $s7
print_result: 	li, $v0, 4		# In String
		la $a0, mess_result
		syscall

		li $v0, 1		# In ra Integer
		add $a0, $s7, $0
		syscall
		
		add $ra, $t9, $0 	# Kh�i ph?c ??a ch? tr? v? $ra = $t9 -> Tho�t ra main
		jr $ra

# update: c?p nh?t $s7 b?ng $s6 
update:		add $s7, $s7, $s6

		j countinue_loop

#------------------------------------------------------------------------------
# function count_in_string($s3, $a2) ??m s? k� t? $s3 trong string $a2
# 	$s3 -> ch?a k� t? c?n ??m trong $a2
# 	$a2: ??a ch? c?a chu?i ??a v�o
#	$k1 -> s? l??ng k� t? chung hay s? l??ng hi?n t?i c?a stack
# Tr? v?: $k0 -> ch?a count t�m ???c
#------------------------------------------------------------------------------
count_in_string:	li $t3, 0 	# bi?n ch?y i = 0
			li $k0, 0 	# kh?i t?o $k0 = 0 (count = 0)
			
# loop_string: duy?t string v� t?ng ??m $k0 n?u c� k� t? tr�ng v?i $s3
loop_string:		add $t4, $a2, $t3	# $t4 = $a2 + i = address string[i]
			lb $t5, 0($t4)		# $t5 ch?a gi� tr? string[i]
			
			beq $t5, 10, end_count_in_string	# n?u k� t? l� '\0' -> d?ng l?p string -> tho�t h�m

			bne $s3, $t5, countinue_count 		# N?u k� t? dang duy?t = k� t? $s3 -> t?ng count $k0 
								# -> ng??c l?i ti?p t?c duy?t ??n k� t? ti?p theo

			addi $k0, $k0,1 			# count++

countinue_count:	addi $t3, $t3,1 	# i++
			j loop_string

end_count_in_string: 	jr $ra	# Tho�t ra h�m count_common