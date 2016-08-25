# Hide the Luhn-10 algorithm inside a module so that MiniKickstarter can remain
# ignorant of the specifics. Hides the string wrangling, too.
# Also useful if we want to add web-based authentication later.
module CreditCard
  def valid_credit_card_number?(cc_number)
    valid_luhn_10_sequence?(cc_number.to_s.split(//).map(&:to_i))
  end

  private

  def valid_luhn_10_sequence?(digits)
    odd_digits = []
    even_digits = []

    # TODO: Investigate more concise options.
    digits.reverse.each_index do |index|
      if (index+1) % 2 == 0
        even_digits << digits[index]
      else
        odd_digits << digits[index]
      end
    end

    total = odd_digits.reduce(&:+)
    even_digits.each { |ed| total += (2*ed).to_s.split(//).map(&:to_i).reduce(&:+) }

    (total % 10) == 0
  end
end
