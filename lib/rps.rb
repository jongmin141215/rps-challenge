module Rps
  RULES = { rock: :scissors,
            paper: :rock,
            scissors: :paper }

  def compare(a, b)
    return :draw if a == b
    return :win if RULES[a] == b
    :lose
  end
end
