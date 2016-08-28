module Jekyll
    module Microtypo
        # Example:
        #   {{ content | microtypo: "fr_FR" }}
        def microtypo(input, locale = nil)
            locale = 'en_US'.freeze unless locale

            arrayResponse = []

            # <pre></pre> management
            # Replace \n in <pre> by <br />\n in order to keep line break visualy
            preArray = input.to_s.split('<pre'.freeze)
            preArray.each do |input|
                endPreArray = input.to_s.split('</pre>'.freeze)
                if endPreArray.size == 2
                    arrayResponse.push('<pre'.freeze)
                    arrayResponse.push(endPreArray.first.gsub(/\n/, "<br />\n".freeze))
                    arrayResponse.push('</pre>'.freeze)
                end
                input = endPreArray.last

                if locale == 'fr_FR'

                    # 1er, 3ème, 4ème…
                    input.gsub!(/(\d)(e|è)(r|me)?([\s.,])/, '\1<sup>\2\3</sup>\4'.freeze)

                    # Guillemets à la française
                    input.gsub!(/(&ldquo;|“|«)(\s|&nbsp;| )*/, '«&#8239;'.freeze)
                    input.gsub!(/(\s|&nbsp;| )*(&rdquo;|”|»)/, '&#8239;»'.freeze)

                    # Special punctuation
                    input.gsub!(/ \?\!([^\w]|$)/, '&#8239;&#8264;\1'.freeze)
                    input.gsub!(/ \!\?([^\w]|$)/, '&#8239;&#8265;\1'.freeze)
                    input.gsub!(/ \!\!\!([^\w]|$)/, '&#8239;&#8252;\1'.freeze)
                    input.gsub!(/ \!\!([^\w]|$)/, '&#8239;&#8252;\1'.freeze)

                    # Thin non-breaking space before '%', ';', '!', '?', 'px'
                    input.gsub!(/(\s)+(\d+)(\s)?(px|%)(\s|.)/, '\1\2&#8239;\4\5'.freeze)
                    input.gsub!(/ (%|;|\!|\?)([^\w!]|$)/, '&#8239;\1\2'.freeze)

                    # non-breaking space
                    input.gsub!(' :'.freeze, '&nbsp;:'.freeze)

                    # Currencies
                    input.gsub!(/(\d+)\s*($|€)/, '\1&nbsp;\2'.freeze)

                    # nbsp after middle dash (dialogs)
                    input.gsub!(/(—|&mdash;)(\s)/, '\1&nbsp;'.freeze)

                    # Times
                    input.gsub!(/(\s)+(\d+)(\s)*x(\s)*(?=\d)/, '\1\2&nbsp;&times;&nbsp;\5'.freeze)

                elsif locale == 'en_US'

                    # Remove useless spaces
                    input.gsub!(/ (:|%|;|\!|\?)([^\w!]|$)/, '\1\2'.freeze)

                    # Currencies
                    input.gsub!(/($|€)\s*(\d+)/, '\1\2'.freeze)

                end

                # Elipsis
                input.gsub!('...', '&#8230;'.freeze)

                arrayResponse.push input
            end

            # Clean empty lines
            arrayResponse.join.gsub(/\A\s*\n$/, ''.freeze)
        end
    end
end

Liquid::Template.register_filter(Jekyll::Microtypo)
