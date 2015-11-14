module Rps
  RULES = { rock: :scissors,
            paper: :rock,
            scissors: :paper }

  WEAPONS = [:rock, :paper, :scissors]

  def random_rps
    WEAPONS.sample
  end

  def compare(a, b)
    return :draw if a == b
    return :win if RULES[a] == b
    :lose
  end

end
