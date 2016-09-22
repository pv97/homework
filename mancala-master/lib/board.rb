class Board
  attr_accessor :cups

  def initialize(name1, name2)
    @cups = place_stones
    @player1 = name1
    @player2 = name2
  end

  def place_stones
    # helper method to #initialize every non-store cup with four stones each
    cups = Array.new(14) { [:stone, :stone, :stone, :stone] }
    cups[6],cups[13] = [],[]
    cups
  end

  def valid_move?(start_pos)
    raise "Invalid starting cup" unless start_pos > 0 && start_pos < 15
  end

  def enemy_cup(current_player_name)
    current_player_name == @player1 ? 13 : 6
  end

  def own_cup(current_player_name)
    current_player_name == @player1 ? 6 : 13
  end

  def make_move(start_pos, current_player_name)
    hand = cups[start_pos]
    @cups[start_pos] = []
    enemy_pos = enemy_cup(current_player_name)

    i = start_pos + 1
    until hand.empty?
      @cups[i%14] << hand.pop unless i%14 == enemy_pos
      i+=1
    end
    render
    next_turn((i-1)%14,current_player_name)
  end

  def next_turn(ending_cup_idx,current_player_name)
    # helper method to determine what #make_move returns
    return :prompt if ending_cup_idx == own_cup(current_player_name)
    return ending_cup_idx if @cups[ending_cup_idx].count > 1
    return :switch if @cups[ending_cup_idx].count == 1
  end

  def render
    print "      #{@cups[7..12].reverse.map { |cup| cup.count }}      \n"
    puts "#{@cups[13].count} -------------------------- #{@cups[6].count}"
    print "      #{@cups.take(6).map { |cup| cup.count }}      \n"
    puts ""
    puts ""
  end

  def cups_empty?
    (0..5).to_a.all? { |i| @cups[i].empty? } ||
    (7..12).to_a.all? { |i| @cups[i].empty? }
  end

  def winner
    return :draw if @cups[6] == @cups[13]
    @cups[6].count > @cups[13].count ? @player1 : @player2
  end
end
