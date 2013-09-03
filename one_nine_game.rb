# require "#{Dir.pwd}/one_nine_game"

##################################
# Test failure
# SEED = BASE.permutation(9).to_a;1
# SEED -= [BASE];1
# object = OneNine.new
# SEED.each_with_index {|game, i| object.state = 0; object.game = game; object.solve(1000); puts i if i % 1000 == 0};1
# object.failures.size
# failures = object.failures;1
# failures -= [BASE];1
# object = OneNine.new
# failures.each_with_index {|game, i| object.state = 0; object.game = game; object.solve(1000); puts i if i % 1000 == 0};1
##################################

BASE = (1..9).to_a

class OneNine
  attr_accessor :game, :failures, :state, :value

  def initialize
    @game = BASE.shuffle
    @value = 0
    @state = 0
    @failures = []
    puts @game.inspect
    puts "請輸入要交換哪兩個位置的數字，指令為 obj.change x, y"
  end

  alias_method :g, :game
  alias_method :v, :value

  def change(x, y = 0)
    return puts "位置只能是 1 ~ 9" if x < 1 or x > 10
    return puts "只能輸入一個位置，另一個位置已是 \"#{@game.index(@value)+1}\"" if @value != 0 && y != 0
    return puts "上一回合已經是 \"#{@value}\"" if @game[x-1] == @value

    if @value == 0
      temp_x = @game[x-1]
      temp_y = @game[y-1]
      @game[x-1] = temp_y
      @game[y-1] = temp_x
    else
      y = @game.index(@value) + 1
      temp_x = @game[x-1]
      temp_y = @value
      @game[x-1] = @value
      @game[y-1] = temp_x
    end

    @value = sum(temp_x, temp_y)
    puts "y = #{@value}"
    @game
  end
  alias_method :c, :change

  def sum(x, y)
    result = x + y

    until result < 10
      second_num = result % 10
      first_num  = (result - second_num) / 10
      result = first_num + second_num
    end

    result
  end

  def check_state
    if @game == BASE
      @state = 1
    else
      @state = 0
    end

    return @state
  end

  def solve(limit = 1_000_000)
    count = 0

    until @state == 1
      count += 1
      game = @game

      if @value == 0
        num1, num2 = BASE.sample 2
        x = @game.index(num1) + 1
        y = @game.index(num2) + 1
        # puts "change #{x}, #{y}"
        change x, y
      else
        others = []
        BASE.each do |num|
          others << num unless @game[num-1] == num
        end
        num1 = others.sample
        while @value == num1
          num1 = others.sample
        end
        x = @game.index(num1) + 1
        # puts "change #{x}"
        change x
      end

      # puts @game.inspect
      check_state

      if count > limit
        @failures << game
        @state = 1
      end
    end

    # puts count
  end
end