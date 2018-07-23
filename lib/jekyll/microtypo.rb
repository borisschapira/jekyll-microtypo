# frozen_string_literal: true

module Jekyll
  module Microtypo
    @settings = []

    def self.settings
      if @settings.none?
        @settings = Jekyll.configuration({})["microtypo"] || {}
      end
      @settings
    end

    # Example:
    #   {{ content | microtypo: "fr_FR" }}
    def microtypo(input, locale = nil, settings = {})
      if settings.none?
        settings = self.settings
      end
      settings["median"] ||= false

      locale ||= "en_US".freeze

      array_response = []

      # <pre></pre> management
      # Replace \n in <pre> by <br />\n in order to keep line break visualy
      pre_array = input.to_s.split("<pre".freeze)
      pre_array.each do |input|
        end_pre_array = input.to_s.split("</pre>".freeze)
        if end_pre_array.size == 2
          array_response.push("<pre".freeze)
          array_response.push(end_pre_array.first)
          array_response.push("</pre>".freeze)
        end
        input = end_pre_array.last

        # <!-- nomicrotypo --><!-- endnomicrotypo --> management
        no_fix_comment_array = input.to_s.split("<!-- nomicrotypo -->".freeze)
        no_fix_comment_array.each do |input|
          endno_fix_comment_array = input.to_s.split("<!-- endnomicrotypo -->".freeze)
          if endno_fix_comment_array.size == 2
            array_response.push(endno_fix_comment_array.first)
          end
          input = endno_fix_comment_array.last

          # <script></script> management
          script_array = input.to_s.split("<script".freeze)
          script_array.each do |input|
            end_script_array = input.to_s.split("</script>".freeze)
            if end_script_array.size == 2
              array_response.push("<script".freeze)
              array_response.push(end_script_array.first)
              array_response.push("</script>".freeze)
            end
            input = end_script_array.last

            if locale == "fr_FR"

              # Ordinals
              input.gsub!(%r!(\d)(e|è)(r|me)?([\s.,])!, '\1<sup>\2\3</sup>\4'.freeze)

              # Num
              input.gsub!(%r!n°\s*(\d)!, 'n<sup>o</sup>&#8239;\1'.freeze)

              # French Guillemets
              input.gsub!(%r!(&ldquo;|“|«)(\s|&nbsp;| )*!, "«&#8239;".freeze)
              input.gsub!(%r!(\s|&nbsp;| )*(&rdquo;|”|»)!, "&#8239;»".freeze)

              # Apostrophe
              input.gsub!(/([[:alpha:]])'([[:alpha:]])/, '\1’\2'.freeze)

              # Point median

              if settings["median"] == true
                input.gsub!(%r!(\p{L}+)(·\p{L}+)((·)(\p{L}+))?!, '\1<span aria-hidden="true">\2\4</span>\5'.freeze)
              end

              # Special punctuation
              input.gsub!(%r!(\s)+\?\!([^\w]|$)!, '&#8239;&#8264;\2'.freeze)
              input.gsub!(%r!(\s)+\!\?([^\w]|$)!, '&#8239;&#8265;\2'.freeze)
              input.gsub!(%r!(\s)+\!\!\!([^\w]|$)!, '&#8239;&#8252;\2'.freeze)
              input.gsub!(%r!(\s)+\!\!([^\w]|$)!, '&#8239;&#8252;\2'.freeze)

              # Thin non-breaking space before '%', ';', '!', '?', 'px'
              input.gsub!(%r!(\s)+(\d+)(\s)?(px|%)(\s|.)!, '\1\2&#8239;\4\5'.freeze)
              input.gsub!(%r! (%|;|\!|\?)([^\w\!]|$)!, '&#8239;\1\2'.freeze)

              # non-breaking space
              input.gsub!(" :".freeze, "&nbsp;:".freeze)

              # Currencies
              input.gsub!(%r!(\d+)\s*($|€)!, '\1&nbsp;\2'.freeze)

              # nbsp after middle dash (dialogs)
              input.gsub!(%r!(—|&mdash;)(\s)!, '\1&nbsp;'.freeze)

              # Times
              input.gsub!(%r!(\s)+(\d+)(\s)*x(\s)*(?=\d)!, '\1\2&nbsp;&times;&nbsp;\5'.freeze)

            elsif locale == "en_US"

              # Remove useless spaces
              input.gsub!(%r! (:|%|;|\!|\?)([^\w\!]|$)!, '\1\2'.freeze)

              # Currencies
              input.gsub!(%r!($|€)\s*(\d+)!, '\1\2'.freeze)

            end

            # Elipsis
            input.gsub!("...", "&#8230;".freeze)

            array_response.push input
          end
        end
      end

      # Clean empty lines
      array_response.join.gsub(%r!\A\s*\n$!, "".freeze)
    end
  end
end

Liquid::Template.register_filter(Jekyll::Microtypo)
