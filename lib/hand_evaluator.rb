class HandEvaluator

	#Call all functions for the right hand
	def function_caller_right_hand(right)
		points_right = 0
		points_right += straigth_or_royal_flush(right)
		points_right += four_of_a_kind(right)
		points_right += full_house(right)
		if points_right == 0
			points_right += flush(right)
			points_right += straight(right)
		end
		if points_right == 0
			points_right += three_of_a_kind(right)
			points_right += pair(right)
		end
		return points_right
	end

	#Call all functions for the left hand
	def function_caller_left_hand(left)
		points_left = 0
		points_left += straigth_or_royal_flush(left)
		points_left += four_of_a_kind(left)
		points_left += full_house(left)
		if points_left == 0
			points_left += flush(left)
			points_left += straight(left)
		end
		if points_left == 0
			points_left += three_of_a_kind(left)
			points_left += pair(left)
		end
		return points_left
	end

	#Check if the hand has the same suit
	def same_suit(hand)
		suit = hand[0][1]
		counter = 0
		for digit in hand[1..-1]
			if digit[1] == suit
				counter += 1
			end
		end

		if counter == hand.length() - 1
			return true
		end
		return false
	end

	#Check if the hand consists of consecutive integers
	def check_consecutive(hand)
		hand = hand.sort
		hand[0..-2].each_with_index do |digit,index|
			if (hand[index + 1] - hand[index]) != 1 #Checks if the difference between two consecutive array cells is 1 (consecutive integer)
				return false
			end
		end		
		return true
	end

	#Converts the letters in the cards into integers
	def check_num(hand)
		hand_num = Array.new()

		hand.each.with_index do |digit, index|
			case digit[0]
			when "T"
				hand_num[index] = 10
			when "J"
				hand_num[index] = 11
			when "Q"
				hand_num[index] = 12
			when "K"
				hand_num[index] = 13
			when "A"
				hand_num[index] = 14
			else
				hand_num[index] = digit[0].to_i
			end
		end
		return hand_num
	end

	#Returns highest ranked card
	def high_card(hand)
		hand_num = check_num(hand)
		return hand_num.max
	end

	#Check if the hand is a Royal Flush or a Straigth Flush (8 points for straigth flush, 9 points for royal flush)
	def straigth_or_royal_flush(hand)
		hand_num = check_num(hand)
		hand_num = hand_num.sort
		royal_flush_counter = 10
		counter = 0

		for digit in hand_num
			if digit == royal_flush_counter
				royal_flush_counter += 1
				counter += 1
			else
				break
			end
		end

		if counter == 5
			return 9
		end
			
		if check_consecutive(hand_num) and same_suit(hand)
			return 8
		end
		return 0
	end

	#Check if the hand has a four of a kind (7 points)
	def four_of_a_kind(hand)
		hand_num = check_num(hand)
		i = 0
		while i < hand_num.size
			if hand_num.count(hand_num[i]) == 4
				return 7
			end
			i += 1
		end
		return 0
	end

	#Check if the hand is a full house, checks with pair and three of a kind functions (6 points)
	def full_house(hand)
		if (pair(hand) > 0 and three_of_a_kind(hand) > 0)
			return 6
		end
		return 0
	end

	#Check if the hand is a Flush (5 points)
	def flush(hand)
		hand_num = check_num(hand)
		if !check_consecutive(hand_num) and same_suit(hand)
			return 5
		end
		return 0
	end

	#Check if the hand is a Straight (4 points)
	def straight(hand)
		hand_num = check_num(hand)
		if check_consecutive(hand_num) and !same_suit(hand)
			return 4
		end
		return 0
	end

	#Check if the hand has a three of a kind (3 points)
	def three_of_a_kind(hand)
		hand_num = check_num(hand)
		i = 0
		while i < hand_num.size
			if hand_num.count(hand_num[i]) == 3
				return 3
			end
			i += 1
		end
		return 0
	end

	#Check if the hand has a pair (1 point), if it has two, it returns 2 points
	def pair(hand)
		hand_num = check_num(hand)
		i = 0
		hand_aux = Array.new()
		while i < hand_num.size
			hand_aux[i] = hand_num.count(hand_num[i])
			i += 1
		end

		sum = 0
		for twos in hand_aux
			if twos == 2
				sum += 2
			end
		end
		return sum / 4
	end

	def return_stronger_hand(left, right)
		points_left = function_caller_left_hand(left)
		points_right = function_caller_right_hand(right)

		if points_left > points_right
			return left
		elsif points_left < points_right
			return right
		else
			if high_card(left) > high_card(right)
				return left
			elsif high_card(left) < high_card(right)
				return right
			else
				return "tie"
			end
		end
	end
end

#main
hand_1 = %w(2S 2D AH 3S 5S)
hand_2 = %w(2H 2C KH 5H 9C)

print HandEvaluator.new.return_stronger_hand(hand_1, hand_2)
  # => ["2S", "2D", "AH", "3S", "5S"]