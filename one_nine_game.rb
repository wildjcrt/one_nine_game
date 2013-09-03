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
  attr_accessor :game, :failures, :state, :value, :count

  def initialize
    @game = BASE.shuffle
    @value = 0
    @state = 0
    @count = 0
    @failures = []
    puts @game.inspect
    puts "請輸入要交換哪兩個數字，指令為 game.c x, y"
  end

  alias_method :g, :game
  alias_method :y, :value

  def change(x, y = 0)
    return puts "數字只能是 1 ~ 9" if x < 1 or x > 10
    return puts "只能輸入一個數字，另一個數字已是 \"#{@value}\"" if @value != 0 && y != 0
    return puts "上一回合已經是 \"#{@value}\"" if x == @value

    @count += 1

    if @value == 0
      pos_x = @game.index x
      pos_y = @game.index y
      @game[pos_x] = y
      @game[pos_y] = x
    else
      y = @value
      pos_x = @game.index x
      pos_y = @game.index y
      @game[pos_x] = y
      @game[pos_y] = x
    end

    @value = sum(x, y)

    if @game == BASE
      puts "恭喜破關！您總共換了 #{@count} 次。"
      @count = 0
      @game = BASE.shuffle
      puts "新題目： #{@game.inspect}"
    else
      puts "y = #{@value}"
      @game
    end
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
    @count = 0

    until @state == 1
      @count += 1
      game = @game

      if @value == 0
        x, y = BASE.sample 2
        # puts "change #{x}, #{y}"
        change x, y
      else
        others = []
        BASE.each do |num|
          next if num == @value
          others << num unless @game[num-1] == num
        end
        x = others.sample
        # puts "change #{x}"
        change x
      end

      # puts @game.inspect
      check_state

      if @count > limit
        @failures << game
        @state = 1
      end
    end

    # puts count
  end
end