# frozen_string_literal: true

require "minitest/autorun"
require "liquid"
require "jekyll"
require "jekyll/microtypo"

include Jekyll::Microtypo

class MicrotypoTest < Minitest::Test
  def test_all__comment
    assert_equal "Before One ! After", Jekyll::Microtypo.microtypo("Before <!-- nomicrotypo -->One !<!-- endnomicrotypo --> After")
    assert_equal "Avant Hey! Après", Jekyll::Microtypo.microtypo("Avant <!-- nomicrotypo -->Hey!<!-- endnomicrotypo --> Après")
  end

  def test_all__pre_script_nofix
    assert_equal "A!<pre>B !</pre> C!<script>D !</script> E!", Jekyll::Microtypo.microtypo("A !<pre>B !</pre> C !<script>D !</script> E !")
    assert_equal "A&#8239;!<pre>B !</pre> C&#8239;!<script>D !</script> E&#8239;!", Jekyll::Microtypo.microtypo("A !<pre>B !</pre> C !<script>D !</script> E !", "fr_FR")
  end

  def test_fr_fr__thin_nb_space
    assert_equal "Hello&#8239;! 4&nbsp;px, 5&nbsp;%&#8239;?", Jekyll::Microtypo.microtypo("Hello ! 4 px, 5 % ?", "fr_FR")
  end

  def test_fr_fr__median_point_plural_nosetting
    # test when microtypo.median = false
    assert_equal "Il·Elle est intéressé·e.", Jekyll::Microtypo.microtypo("Il·Elle est intéressé·e.", "fr_FR")
  end

  def test_fr_fr__median_point_nosetting
    # test when microtypo.median = false
    assert_equal "Ils·Elles sont intéressé·e·s", Jekyll::Microtypo.microtypo("Ils·Elles sont intéressé·e·s", "fr_FR")
  end

  def test_fr_fr__median_point_plural_setting
    # test when microtypo.median = true
    assert_equal 'Il<span aria-hidden="true">·Elle</span> est intéressé<span aria-hidden="true">·e</span>.', Jekyll::Microtypo.microtypo("Il·Elle est intéressé·e.", "fr_FR", { "median" => true })
  end

  def test_fr_fr__median_point_setting
    # test when microtypo.median = true
    assert_equal 'Ils<span aria-hidden="true">·Elles</span> sont intéressé<span aria-hidden="true">·e·</span>s', Jekyll::Microtypo.microtypo("Ils·Elles sont intéressé·e·s", "fr_FR", { "median" => true })
  end

  def test_fr_fr__num
    assert_equal "Elle porte le n<sup>o</sup>&#8239;3.", Jekyll::Microtypo.microtypo("Elle porte le n°3.", "fr_FR")
  end

  def test_fr_fr__elipsis
    assert_equal "Moi ça va&#8230;", Jekyll::Microtypo.microtypo("Moi ça va...", "fr_FR")
  end

  def test_fr_fr__ordinal
    assert_equal "Si je double le 2<sup>ème</sup>, je deviens 1<sup>er</sup>.", Jekyll::Microtypo.microtypo("Si je double le 2ème, je deviens 1er.", "fr_FR")
  end

  def test_fr_fr__frenchquotes
    assert_equal "On dit «&#8239;en Avignon&#8239;», pas «&#8239;à Avignon&#8239;». Ah, comme dans «&#8239;en Carmélie&#8239;» alors.", Jekyll::Microtypo.microtypo("On dit &ldquo;en Avignon&rdquo;, pas “à Avignon”. Ah, comme dans «&nbsp;en Carmélie » alors.", "fr_FR")
  end

  def test_fr_fr__single_quotes
    # test when microtypo.median = false
    assert_equal "Il compta jusqu’à trois ‘Missisipi’ puis dit&nbsp;: «&#8239;Tu devrais ‘danser', maintenant&#8239;».", Jekyll::Microtypo.microtypo("Il compta jusqu'à trois 'Missisipi' puis dit : “Tu devrais 'danser', maintenant”.", "fr_FR")
  end

  def test_fr_fr__timing_single_quotes
    # test when microtypo.median = false
    assert_equal "Il couru 23’’4’.", Jekyll::Microtypo.microtypo("Il couru 23''4'.", "fr_FR")
  end

  def test_fr_fr__apostrophe
    assert_equal "L’événement démarrera dans trois minutes.", Jekyll::Microtypo.microtypo("L'événement démarrera dans trois minutes.", "fr_FR")
  end

  def test_fr_fr__specialpunc
    assert_equal "© © ® ® ™ ™ ℗ ℗ ±", Jekyll::Microtypo.microtypo("(c) (C) (r) (R) (tm) (TM) (p) (P) +-", "fr_FR")
  end

  def test_fr_fr__copyright
    assert_equal "Non&#8239;&#8264; Si&#8239;&#8252; Je ne te crois pas&#8239;&#8265; Je te jure&#8239;&#8252;", Jekyll::Microtypo.microtypo("Non ?! Si !! Je ne te crois pas !? Je te jure !!!", "fr_FR")
  end

  def test_fr_fr__nbsp
    assert_equal "2001&nbsp;: Space Odyssey", Jekyll::Microtypo.microtypo("2001 : Space Odyssey", "fr_FR")
  end

  def test_fr_fr__currencies
    assert_equal "599$, donc 599&nbsp;€", Jekyll::Microtypo.microtypo("599$, donc 599 €", "fr_FR")
  end

  def test_fr_fr__multiply
    assert_equal "Un poster en 4&nbsp;&times;&nbsp;3.", Jekyll::Microtypo.microtypo("Un poster en 4x3.", "fr_FR")
  end

  def test_fr_fr__units
    assert_equal "Cet image pèse 4&nbsp;Ko une fois compressée", Jekyll::Microtypo.microtypo("Cet image pèse 4 Ko une fois compressée", "fr_FR")
  end

  def test_en_us__removespaces
    assert_equal "So: what are you thinking? Either you’re in at 100% or you’re out.", Jekyll::Microtypo.microtypo("So : what are you thinking ? Either you're in at 100 % or you're out.", "en_US")
  end

  def test_en_us__currencies
    assert_equal "$599, so €599", Jekyll::Microtypo.microtypo("$599, so € 599", "en_US")
  end
end
