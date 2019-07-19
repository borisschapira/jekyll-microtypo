# frozen_string_literal: true

module Jekyll
  module Microtypo

    def self.settings(config)
      @settings ||= {}
      @settings[config.hash] ||= config["microtypo"] || {}
    end

    # Example:
    #   {{ content | microtypo: "fr_FR" }}
    def microtypo(input, locale = "en_US")
      settings = Microtypo.settings(@context.registers[:site].config)
      array_response = []

      array_exclude = [
        ["<!-- nomicrotypo -->", "<!-- endnomicrotypo -->", false],
        ["<pre", "</pre>", true],
        ["<style", "</style>", true],
        ["<script", "</script>", true],
        ["<code", "</code>", true],
      ]

      recursive_parser(array_exclude, array_response, input, locale, settings)

      # Clean empty lines
      array_response.join.gsub(%r!\A\s*\n$!, "")
    end

    private

    def recursive_parser(array_exclude, array_response, input, locale, settings)
      if array_exclude.empty?
        fix_microtypo(array_response, input, locale, settings)
      else
        to_exclude = array_exclude.pop
        array = input.to_s.split(to_exclude[0])
        array.each do |input_item|
          end_item_array = input_item.to_s.split(to_exclude[1])
          if end_item_array.size == 2
            if !to_exclude[2]
              array_response.push(end_item_array.first)
            else
              array_response.push(to_exclude[0])
              array_response.push(end_item_array.first)
              array_response.push(to_exclude[1])
            end
          end
          input_item = end_item_array.last
          recursive_parser(array_exclude, array_response, input_item, locale, settings)
        end
      end
    end

    def fix_microtypo_fr(_array_response, input, settings)
      # Ordinals
      input.gsub!(%r!(\s)(\d)+(e|è)(r|me)?([\s.,])!, '\1\2<sup>\3\4</sup>\5')

      # Num
      input.gsub!(%r!n°\s*(\d)!, 'n<sup>o</sup>&#8239;\1')

      # French Guillemets
      input.gsub!(%r!(&rdquo;|”|»)<a !, "«&#8239;<a ")
      input.gsub!(%r/(&ldquo;|“|«)(?!&#8239;)(\s|&nbsp;| )*/, "«&#8239;")
      input.gsub!(%r/(\s|&nbsp;| )*(?!&#8239;)(&rdquo;|”|»)/, "&#8239;»")

      # Point median

      if settings["median"]
        input.gsub!(%r!(\p{L}+)(·\p{L}+)((·)(\p{L}+))?!, '\1<span aria-hidden="true">\2\4</span>\5')
      end

      # Special punctuation
      input.gsub!(%r!(\s)+\?\!([^\w]|$)!, '&#8239;&#8264;\2')
      input.gsub!(%r!(\s)+\!\?([^\w]|$)!, '&#8239;&#8265;\2')
      input.gsub!(%r!(\s)+\!\!\!([^\w]|$)!, '&#8239;&#8252;\2')
      input.gsub!(%r!(\s)+\!\!([^\w]|$)!, '&#8239;&#8252;\2')

      # Times
      input.gsub!(%r!(\s)+(\d+)(\s)*x(\s)*(?=\d)!, '\1\2&nbsp;&times;&nbsp;\5')

      # Non-breaking space before '%' and units (< 4 letters)
      input.gsub!(%r!(\s)+(\d+)(\s)+([[:alpha:]]|%)!, '\1\2&nbsp;\4\5')

      # Thin non-breaking space before ;', '!', '?'
      input.gsub!(%r/ (;|\!|\?)([^\w!]|$)/, '&#8239;\1\2')

      # non-breaking space
      input.gsub!(" :", "&nbsp;:")

      # Currencies
      input.gsub!(%r!(\d+)\s*($|€)!, '\1&nbsp;\2')

      # nbsp after middle dash (dialogs)
      input.gsub!(%r!(—|&mdash;)(\s)!, '\1&nbsp;')
    end

    def fix_microtypo_us(_array_response, input, _settings)
      # Remove useless spaces
      input.gsub!(%r/ (:|%|;|\!|\?)([^\w!]|$)/, '\1\2')

      # Currencies
      input.gsub!(%r!($|€)\s*(\d+)!, '\1\2')
    end

    def fix_microtypo(array_response, input, locale, settings)
      if locale == "fr_FR"
        fix_microtypo_fr(array_response, input, settings)
      elsif locale == "en_US"
        fix_microtypo_us(array_response, input, settings)
      end

      # single quotes
      input.gsub!(%r!(\s)'([[:alpha:]])!, '\1‘\2')
      input.gsub!(%r!([[:alpha:]])'(\s)!, '\1’\2')
      input.gsub!(%r!(\d)''!, '\1’’')
      input.gsub!(%r!(\d)'!, '\1’')

      # Apostrophe
      input.gsub!(%r!([[:alpha:]])'([[:alpha:]])!, '\1’\2')

      # Elipsis
      input.gsub!("...", "&#8230;")

      # Special characters
      input.gsub!(%r!\([c|C]\)!, "©")
      input.gsub!(%r!\([p|P]\)!, "℗")
      input.gsub!(%r!\([r|R]\)!, "®")
      input.gsub!(%r!\((tm|TM)\)!, "™")
      input.gsub!(%r!\+-!, "±")

      array_response.push input
    end
  end
end

Liquid::Template.register_filter(Jekyll::Microtypo)
