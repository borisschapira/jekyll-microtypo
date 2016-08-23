module Jekyll
  module Microtypo
    # Example:
    #   {{ content | microtypo: "fr_FR" }}
    def microtypo(input, locale=nil)
      locale='en_US' unless locale

      if locale == 'fr_FR'
        # Thin non-breaking space before '%', ';', '!', '?'
        fr_Fr_thin_nb_space = Regexp.new ' (%|;|\!|\?)([^\w!]|$)'
        input.gsub! fr_Fr_thin_nb_space, '&#8239;\1\2'

        # Elipsis
        input.gsub! '...', '&#8230;'
      end
      input
    end
  end
end

Liquid::Template.register_filter(Jekyll::Microtypo)
