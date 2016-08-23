require 'minitest/autorun'
require 'liquid'
require 'jekyll/microtypo'

include Jekyll::Microtypo

class MicrotypoTest < Minitest::Test
	def test_fr_Fr_thin_nb_space
		assert_equal 'Hello&#8239;! Je suis Boris&#8239;! Ça va&#8239;? Moi ça va&#8230;', Jekyll::Microtypo.microtypo('Hello ! Je suis Boris ! Ça va ? Moi ça va...', 'fr_FR')
	end
	def test_fr_Fr_elipsis
		assert_equal 'Moi ça va&#8230;', Jekyll::Microtypo.microtypo('Moi ça va...', 'fr_FR')
	end
end
