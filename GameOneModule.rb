class WordGame
#initialize each wordgame
def initialize
	@player_one
	@player_two
	@again = true
	@invalid_word = true
end

#runs through a word battle game
def start
	while @again == true
		intro

		battle_tag

		sleep 1

		battle

		winner @player_one, @player_two

		play_again @again
	end
end

#displays intro and instructions of the game
def intro
	puts <<-END

			    	        !WORD BATTLE GAME!
==========================================================================================================
				*Welcome to the Word Battle Game* 	
		In this game player one will enter a word and "fire" it at his opponent.
		Player two will then "fire" a word back at player one. The words will
		collide mid-air and if any letters are the same they are destroyed. (ie.. 
		hello collides with lucky.. the l's will be destroyed.) The remaining 
		letters will hit the players for points of damage. The first player to 
		lose all of his life will lose. GOOD LUCK and HAPPY GAMING!
==========================================================================================================
END

puts "\nPress Return when you are ready!"
gets
end

#aquires player info
def battle_tag
	puts "Player one please enter your battle tag: \n\n".blue
	name_one = gets.chomp

	@player_one = Player.new name_one

	puts "Player one your battle tag is:" + " #{@player_one.name}.\n\n".blue

	puts "Player two please enter your battle tag: \n\n".green
	name_two = gets.chomp

	@player_two = Player.new name_two

	puts "Player two your battle tag is:" +" #{@player_two.name}.\n\n".green

	#display life counter on each player
	puts "#{@player_one.name} will start with #{@player_one.life} life.".blue
	puts "#{@player_two.name} will start with #{@player_two.life} life.\n\n".green
end

#gets a word from the user
def get_word invalid_word, name
	puts "#{name.name} please enter your word to fire:\n\n".yellow
	name.word = STDIN.noecho(&:gets).chomp.downcase
	if name.word =~ /\d/ or /[[:blank:]]/ or /[[:punct:]]/
		puts "That is not a valid word.\n".red
	else
		@invalid_word = false
	end
end

#asks the user if they would like to play again
def play_again again
	puts "Would you like to play again? [y/n]".yellow
	rematch = gets.chomp.downcase
	if rematch == "y"
		@again = true
	else
		@again = false
	end
end

#battle sequence
def battle
	sleep 1
	
	puts "NOW TO YOUR BATTLE STATIONS!\n".red
		
	art

	begin
		begin
		get_word @invalid_word, @player_one
		end until @invalid_word ==false
		@invalid_word = true
		begin
		get_word @invalid_word, @player_two
		end until @invalid_word == false

		puts "The words are set...".red
		
		puts "\n#{@player_one.name} has input #{@player_one.word}.".blue
		puts "#{@player_two.name} has input #{@player_two.word}.\n".green

		#subtracts the damage from each player
		damage_calculation @player_one, @player_two
		damage_calculation @player_two, @player_one

		sleep 1
	end until(@player_one.life == 0 || @player_two.life == 0)
end

#calculates the damage between the players
def damage_calculation player_one, player_two
	#stores the character difference of the two words in an array
	left_over_letters = player_one.word.chars.sort - player_two.word.chars.sort
	
	#sets the damage calculation into a variable
	damage = left_over_letters.count
	
	puts "#{player_two.name} has taken #{damage} points of damage.\n\n".red
	
	player_two.life -= damage

	if player_two.life <= 0
		player_two.life = 0
	end

	puts "#{player_two.name} now has #{player_two.life} life left.\n\n" 
end

#calculates winner and asks user if they would like to play again
def winner player_one, player_two
	if @player_one.life == 0
		puts "#{@player_two.name} has WON!".green
	elsif player_two.life == 0
		puts "#{@player_one.name} has WON!".blue
	end
end

#shows text art
def art
	File.open('test.txt', 'r') do |a|  
		while line = a.gets  
			print line .red
		end  
	end
	puts ""
end  
end

#class of player that hold life, name, and word they choose
class Player
	attr_accessor :name, :word, :life
	def initialize name
		@name = name
		@word = word
		@life = 20
	end
end
