require 'minitest/autorun'
require 'liquid'
require 'jekyll/microtypo'

include Jekyll::Microtypo

class MicrotypoTest < Minitest::Test
	def test_all__pre_br
		assert_equal "Avant <pre><code>One<br />\nTwo</code></pre> Après", Jekyll::Microtypo.microtypo("Avant <pre><code>One\nTwo</code></pre> Après")
	end
	def test_fr_Fr__thin_nb_space
		assert_equal 'Hello&#8239;! 4&#8239;px, 5&#8239;%&#8239;?', Jekyll::Microtypo.microtypo('Hello ! 4 px, 5 % ?', 'fr_FR')
	end
	def test_fr_Fr__elipsis
		assert_equal 'Moi ça va&#8230;', Jekyll::Microtypo.microtypo('Moi ça va...', 'fr_FR')
	end
	def test_fr_Fr__ordinal
		assert_equal 'Si je double le 2<sup>ème</sup>, je deviens 1<sup>er</sup>.', Jekyll::Microtypo.microtypo('Si je double le 2ème, je deviens 1er.', 'fr_FR')
	end
	def test_fr_Fr__frenchquotes
		assert_equal 'On dit «&#8239;en Avignon&#8239;», pas «&#8239;à Avignon&#8239;».', Jekyll::Microtypo.microtypo('On dit &ldquo;en Avignon&rdquo;, pas “à Avignon”.', 'fr_FR')
	end
	def test_fr_Fr__specialpunc
		assert_equal 'Non&#8239;&#8264; Si&#8239;&#8252; Je ne te crois pas&#8239;&#8265; Je te jure&#8239;&#8252;', Jekyll::Microtypo.microtypo('Non ?! Si !! Je ne te crois pas !? Je te jure !!!', 'fr_FR')
	end
	def test_fr_Fr__nbsp
		assert_equal "2001&nbsp;: l'odysée de l'espace", Jekyll::Microtypo.microtypo("2001 : l'odysée de l'espace", 'fr_FR')
	end
	def test_fr_Fr__currencies
		assert_equal "599$, donc 599&nbsp;€", Jekyll::Microtypo.microtypo("599$, donc 599 €", 'fr_FR')
	end
	def test_en_US__removespaces
		assert_equal "So: what are you thinking? Either you're in at 100% or you're out.", Jekyll::Microtypo.microtypo("So : what are you thinking ? Either you're in at 100 % or you're out.", 'en_US')
	end
end
