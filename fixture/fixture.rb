require_relative '../xunit/assertions'

class TestLogicaSuite

  def test_verdadero_es_verdadero
    assert_true true
  end

  def test_suma_correcta
    assert_equals 2, 1+1
  end

  def test_suma_fallida
    assert_equals 4, 1+1
  end

end

class TestAndaTodoSuite

  def test_resta_correcta
    assert_equals 2, 3-1
  end

  def test_verdadero_es_verdadero
    assert_true true
  end

end

class TestFallaDivisionSuite

  def test_falla_division
    assert_true 3/0
  end

end

class TestFallaTestSuite

  def test_falla_suma
    assert_equals 3, (2+2)
  end

end

class TestCombinadoSuite

  def test_falso_es_falso
    assert_false false
  end

  def test_falla_multiplicacion
    assert_equals 4, (2*4)
  end

  def test_error_division
    assert_true 3/0
  end

end

class TestConBefore

  attr_accessor :numero

  def before
    self.numero = 3
  end

  def test_assert_multiplicacion
    self.assert_equals 3, self.numero*1
    self.numero = 2
    self.assert_equals 2, self.numero*1
  end

  def test_assert_suma
    self.assert_equals self.numero, 1+1+1
  end

end