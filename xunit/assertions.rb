module Assertions
  def assert_true(is_true)
    unless is_true
      raise AssertionException
    end
  end

  def assert_false(value)
    self.assert_true !value
  end

  def assert_equals(expected, value)
    self.assert_true (expected == value)
  end
end