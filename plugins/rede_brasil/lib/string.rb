class String

  def downcase
    self.mb_chars.downcase.to_s
  end

  def upcase
    self.mb_chars.upcase.to_s
  end

end
