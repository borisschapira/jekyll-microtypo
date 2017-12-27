# frozen_string_literal: true

module Jekyll
  module Microtypo
      # Example:
      #   {{ content | microtypo: "fr_FR" }}
      def microtypo(input, locale = nil)
          locale ||= 'en_US'.freeze

          arrayResponse = []

          # <pre></pre> management
          # Replace \n in <pre> by <br />\n in order to keep line break visualy
          preArray = input.to_s.split("<pre".freeze)
          preArray.each do |input|
              endPreArray = input.to_s.split("</pre>".freeze)
              if endPreArray.size == 2
                  arrayResponse.push("<pre".freeze)
                  arrayResponse.push(endPreArray.first)
                  arrayResponse.push("</pre>".freeze)
              end
              input = endPreArray.last

              # <!-- nomicrotypo --><!-- endnomicrotypo --> management
              noFixCommentArray = input.to_s.split("<!-- nomicrotypo -->".freeze)
              noFixCommentArray.each do |input|
                  endNoFixCommentArray = input.to_s.split("<!-- endnomicrotypo -->".freeze)
                  if endNoFixCommentArray.size == 2
                      arrayResponse.push(endNoFixCommentArray.first)
                  end
                  input = endNoFixCommentArray.last

                  # <script></script> management
                  scriptArray = input.to_s.split("<script".freeze)
                  scriptArray.each do |input|
                      endScriptArray = input.to_s.split("</script>".freeze)
                      if endScriptArray.size == 2
                          arrayResponse.push("<script".freeze)
                          arrayResponse.push(endScriptArray.first)
                          arrayResponse.push("</script>".freeze)
                      end
                      input = endScriptArray.last

                      if locale == "fr_FR"

                          # 1er, 3ème, 4ème…
                          input.gsub!(%r!(\d)(e|è)(r|me)?([\s.,])!, '\1<sup>\2\3</sup>\4'.freeze)

                          # Guillemets à la française
                          input.gsub!(%r!(&ldquo;|“|«)(\s|&nbsp;| )*!, "«&#8239;".freeze)
                          input.gsub!(%r!(\s|&nbsp;| )*(&rdquo;|”|»)!, "&#8239;»".freeze)

                          # Special punctuation
                          input.gsub!(%r! \?\!([^\w]|$)!, '&#8239;&#8264;\1'.freeze)
                          input.gsub!(%r! \!\?([^\w]|$)!, '&#8239;&#8265;\1'.freeze)
                          input.gsub!(%r! \!\!\!([^\w]|$)!, '&#8239;&#8252;\1'.freeze)
                          input.gsub!(%r! \!\!([^\w]|$)!, '&#8239;&#8252;\1'.freeze)

                          # Thin non-breaking space before '%', ';', '!', '?', 'px'
                          input.gsub!(%r!(\s)+(\d+)(\s)?(px|%)(\s|.)!, '\1\2&#8239;\4\5'.freeze)
                          input.gsub!(%r! (%|;|\!|\?)([^\w!]$)!, '&#8239;\1\2'.freeze)

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
                          input.gsub!(%r! (:|%|;|\!|\?)([^\w!]|$)!, '\1\2'.freeze)

                          # Currencies
                          input.gsub!(%r!($|€)\s*(\d+)!, '\1\2'.freeze)

                      end

                      # Elipsis
                      input.gsub!("...", "&#8230;".freeze)

                      arrayResponse.push input
                  end
              end
          end

          # Clean empty lines
          arrayResponse.join.gsub(%r!\A\s*\n$!, "".freeze)
      end
  end
end

Liquid::Template.register_filter(Jekyll::Microtypo)
