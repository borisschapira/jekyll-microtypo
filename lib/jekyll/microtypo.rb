module Jekyll
  module Microtypo
    @@settings = []

    def get_settings
      if @@settings.none?
        @@settings = Jekyll.configuration({})['microtypo'] || {}
      end
      @@settings
    end

    # Example:
    #   {{ content | microtypo: "fr_FR" }}
    def microtypo(input, locale = nil, settings = {})
      if settings.none?
        settings = get_settings
      end
      settings['median'] ||= false

      locale ||= 'en_US'.freeze

      array_response = []

      # <pre></pre> management
      # Replace \n in <pre> by <br />\n in order to keep line break visualy
      pre_array = input.to_s.split('<pre'.freeze)
      pre_array.each do |input|
        end_pre_array = input.to_s.split('</pre>'.freeze)
        if end_pre_array.size == 2
          array_response.push('<pre'.freeze)
          array_response.push(end_pre_array.first)
          array_response.push('</pre>'.freeze)
        end
        input = end_pre_array.last

        # <!-- nomicrotypo --><!-- endnomicrotypo --> management
        no_fix_comment_array = input.to_s.split('<!-- nomicrotypo -->'.freeze)
        no_fix_comment_array.each do |input|
          endno_fix_comment_array = input.to_s.split('<!-- endnomicrotypo -->'.freeze)
          if endno_fix_comment_array.size == 2
            array_response.push(endno_fix_comment_array.first)
          end
          input = endno_fix_comment_array.last

          # <script></script> management
          script_array = input.to_s.split('<script'.freeze)
          script_array.each do |input|
            end_script_array = input.to_s.split('</script>'.freeze)
            if end_script_array.size == 2
              array_response.push('<script'.freeze)
              array_response.push(end_script_array.first)
              array_response.push('</script>'.freeze)
            end
            input = end_script_array.last

            if locale == 'fr_FR'

              # Ordinals
              input.gsub!(/(\s)(\d)+(e|è)(r|me)?([\s.,])/, '\1\2<sup>\3\4</sup>\5'.freeze)

              # Num
              input.gsub!(/n°\s*(\d)/, 'n<sup>o</sup>&#8239;\1'.freeze)

              # French Guillemets
              input.gsub!(/(&rdquo;|”|»)<a /, '«&#8239;<a '.freeze)
              input.gsub!(/(&ldquo;|“|«)(?!&#8239;)(\s|&nbsp;| )*/, '«&#8239;'.freeze)
              input.gsub!(/(\s|&nbsp;| )*(?!&#8239;)(&rdquo;|”|»)/, '&#8239;»'.freeze)

              # Point median

              if settings['median'] == true
                input.gsub!(/(\p{L}+)(·\p{L}+)((·)(\p{L}+))?/, '\1<span aria-hidden="true">\2\4</span>\5'.freeze)
              end

              # Special punctuation
              input.gsub!(/(\s)+\?\!([^\w]|$)/, '&#8239;&#8264;\2'.freeze)
              input.gsub!(/(\s)+\!\?([^\w]|$)/, '&#8239;&#8265;\2'.freeze)
              input.gsub!(/(\s)+\!\!\!([^\w]|$)/, '&#8239;&#8252;\2'.freeze)
              input.gsub!(/(\s)+\!\!([^\w]|$)/, '&#8239;&#8252;\2'.freeze)

              # Times
              input.gsub!(/(\s)+(\d+)(\s)*x(\s)*(?=\d)/, '\1\2&nbsp;&times;&nbsp;\5'.freeze)

              # Non-breaking space before '%' and units (< 4 letters)…
              input.gsub!(/(\s)+(\d+)(\s)+([[:alpha:]]|%)/, '\1\2&nbsp;\4\5'.freeze)

              # Thin non-breaking space before ;', '!', '?'
              input.gsub!(/ (;|\!|\?)([^\w!]|$)/, '&#8239;\1\2'.freeze)

              # non-breaking space
              input.gsub!(' :'.freeze, '&nbsp;:'.freeze)

              # Currencies
              input.gsub!(/(\d+)\s*($|€)/, '\1&nbsp;\2'.freeze)

              # nbsp after middle dash (dialogs)
              input.gsub!(/(—|&mdash;)(\s)/, '\1&nbsp;'.freeze)

            elsif locale == 'en_US'

              # Remove useless spaces
              input.gsub!(/ (:|%|;|\!|\?)([^\w!]|$)/, '\1\2'.freeze)

              # Currencies
              input.gsub!(/($|€)\s*(\d+)/, '\1\2'.freeze)

            end

            # single quotes
            input.gsub!(/(\s)'([[:alpha:]])/, '\1‘\2'.freeze)
            input.gsub!(/([[:alpha:]])'(\s)/, '\1’\2'.freeze)
            input.gsub!(/(\d)''/, '\1’’'.freeze)
            input.gsub!(/(\d)'/, '\1’'.freeze)

            # Apostrophe
            input.gsub!(/([[:alpha:]])'([[:alpha:]])/, '\1’\2'.freeze)

            # Elipsis
            input.gsub!('...', '&#8230;'.freeze)

            # Special characters
            input.gsub!(/\([c|C]\)/, '©'.freeze)
            input.gsub!(/\([p|P]\)/, '℗'.freeze)
            input.gsub!(/\([r|R]\)/, '®'.freeze)
            input.gsub!(/\((tm|TM)\)/, '™'.freeze)
            input.gsub!(/\+-/, '±'.freeze)

            array_response.push input
          end
        end
      end

      # Clean empty lines
      array_response.join.gsub(/\A\s*\n$/, ''.freeze)
    end
  end
end

Liquid::Template.register_filter(Jekyll::Microtypo)
