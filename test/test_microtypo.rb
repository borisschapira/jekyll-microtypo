# frozen_string_literal: true

require "minitest/autorun"
require "liquid"
require "jekyll/microtypo"

include Jekyll::Microtypo

class MicrotypoTest < Minitest::Test
  def test_all_comment
    assert_equal "Before One ! After", Jekyll::Microtypo.microtypo("Before <!-- nomicrotypo -->One !<!-- endnomicrotypo --> After")
    assert_equal "Avant Hey! Après", Jekyll::Microtypo.microtypo("Avant <!-- nomicrotypo -->Hey!<!-- endnomicrotypo --> Après")
  end

  def test_all_pre_script_nofix
    assert_equal "A!<pre>B !</pre> C!<script>D !</script> E!", Jekyll::Microtypo.microtypo("A !<pre>B !</pre> C !<script>D !</script> E !")
    assert_equal "A&#8239;!<pre>B !</pre> C&#8239;!<script>D !</script> E&#8239;!", Jekyll::Microtypo.microtypo("A !<pre>B !</pre> C !<script>D !</script> E !", "fr_FR")
  end

  def test_fr_fr_thin_nb_space
    assert_equal "Hello&#8239;! 4&#8239;px, 5&#8239;%&#8239;?", Jekyll::Microtypo.microtypo("Hello ! 4 px, 5 % ?", "fr_FR")
  end

  def test_fr_fr_elipsis
    assert_equal "Moi ça va&#8230;", Jekyll::Microtypo.microtypo("Moi ça va...", "fr_FR")
  end

  def test_fr_fr_ordinal
    assert_equal "Si je double le 2<sup>ème</sup>, je deviens 1<sup>er</sup>.", Jekyll::Microtypo.microtypo("Si je double le 2ème, je deviens 1er.", "fr_FR")
  end

  def test_fr_fr_frenchquotes
    assert_equal "On dit «&#8239;en Avignon&#8239;», pas «&#8239;à Avignon&#8239;». Ah, comme dans «&#8239;en Carmélie&#8239;» alors.", Jekyll::Microtypo.microtypo("On dit &ldquo;en Avignon&rdquo;, pas “à Avignon”. Ah, comme dans «&nbsp;en Carmélie » alors.", "fr_FR")
  end

  def test_fr_fr_specialpunc
    assert_equal "Non&#8239;&#8264; Si&#8239;&#8252; Je ne te crois pas&#8239;&#8265; Je te jure&#8239;&#8252;", Jekyll::Microtypo.microtypo("Non ?! Si !! Je ne te crois pas !? Je te jure !!!", "fr_FR")
  end

  def test_fr_fr_nbsp
    assert_equal "2001&nbsp;: l'odysée de l'espace", Jekyll::Microtypo.microtypo("2001 : l'odysée de l'espace", "fr_FR")
  end

  def test_fr_fr_currencies
    assert_equal "599$, donc 599&nbsp;€", Jekyll::Microtypo.microtypo("599$, donc 599 €", "fr_FR")
  end

  def test_fr_fr_multiply
    assert_equal "C'est un poster en 4&nbsp;&times;&nbsp;3.", Jekyll::Microtypo.microtypo("C'est un poster en 4x3.", "fr_FR")
  end

  def test_en_us_removespaces
    assert_equal "So: what are you thinking? Either you're in at 100% or you're out.", Jekyll::Microtypo.microtypo("So : what are you thinking ? Either you're in at 100 % or you're out.", "en_US")
  end

  def test_en_us_currencies
    assert_equal "$599, so €599", Jekyll::Microtypo.microtypo("$599, so € 599", "en_US")
  end
end
