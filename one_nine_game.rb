BASE = (1..9).to_a
SEED = BASE.map do |num|
  others = BASE - [num]
end

class OneNine
  attr_accessor :game

  def initialize
    @game = BASE.shuffle
    @value = 0
    @state = 0
    puts @game.inspect
    puts "請輸入要交換哪兩個位置的數字，指令為 obj.change x, y"
  end

  def change(x, y = 0)
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
      @game[x-1] = @value
      @game[y-1] = temp_x
    end

    @value = sum(x, y)
    @game
  end

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

  def solve
    until @state == 1
      if @value == 0
        num1, num2 = BASE.sample 2
        x = @game.index(num1) + 1
        y = @game.index(num2) + 1
        puts "change #{x}, #{y}"
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
        puts "change #{x}"
        change x
      end

      puts @game.inspect
      check_state
    end
  end
end