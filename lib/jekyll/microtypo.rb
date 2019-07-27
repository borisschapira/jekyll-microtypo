# frozen_string_literal: true

module Jekyll
  module Microtypo
    QUEUE = [
      ["<!-- nomicrotypo -->", "<!-- endnomicrotypo -->", false],
      ["<pre", "</pre>", true],
      ["<style", "</style>", true],
      ["<script", "</script>", true],
      ["<code", "</code>", true],
    ].freeze
    private_constant :QUEUE

    def self.settings(config)
      @settings ||= {}
      @settings[config.hash] ||= config["microtypo"] || {}
    end

    # Example:
    #   {{ content | microtypo: "fr_FR" }}
    def microtypo(input, locale = "en_US")
      bucket = []

      recursive_parser(input, locale, bucket, QUEUE.length, true)

      # Clean empty lines
      bucket.join.tap do |result|
        result.gsub!(%r!\A\s*\n$!, "")
      end
    end

    private

    def recursive_parser(input, locale, bucket, index, fixMicrotypo)
      input = input.to_s
      
      # prefix = " " + (" " * 3 * (QUEUE.size-index))
      # p prefix + 'Recursive_parser for ' + input unless index.zero?
      # p prefix + '     Fix microtypo for ' + input if index.zero?
      # p prefix + '     and place it in the bucket' if index.zero?
      if index.zero?
        if fixMicrotypo
          return fix_microtypo(+input, locale, bucket)
        else
          return bucket << input
        end
      end

      index -= 1
      head, tail, flag = QUEUE[index]

      indexHead = input.index(head)
      indexTail = input.index(tail)

      if indexHead.nil? || indexTail.nil? || indexHead > indexTail
        # p prefix + input
        # p prefix + 'doest not contain '+head+' then '+tail
        return recursive_parser(input, locale, bucket, index, fixMicrotypo)
      end

      # p prefix + input
      # p prefix + 'contains '+head+' and '+tail
      # p prefix + 'cuts the input in parts around '+ head
      input.split(head).each do |item|
        item = item.to_s

        # p prefix + '-----part----'
        # p prefix + item

        if item.include?(tail)
          # p prefix + 'contains '+tail
          end_items = item.split(tail)

          # p prefix + end_items.to_s
          if flag
            bucket << head << end_items[0] << tail
          else
            bucket << end_items[0]
            fixMicrotypo = false
          end

          # p prefix + bucket.to_s
          item = end_items.last
        end

        recursive_parser(item, locale, bucket, index, fixMicrotypo)
      end
    end

    def fix_microtypo_fr(input)
      # Ordinals
      input.gsub!(%r!(\s)(\d)+(e|è)(r|me)?([\s.,])!, '\1\2<sup>\3\4</sup>\5')

      # Num
      input.gsub!(%r!n°\s*(\d)!, 'n<sup>o</sup>&#8239;\1')

      # French Guillemets
      input.gsub!(%r!(&rdquo;|”|»)<a !, "«&#8239;<a ")
      input.gsub!(%r/(&ldquo;|“|«)(?!&#8239;)(\s|&nbsp;| )*/, "«&#8239;")
      input.gsub!(%r/(\s|&nbsp;| )*(?!&#8239;)(&rdquo;|”|»)/, "&#8239;»")

      settings = Microtypo.settings(@context.registers[:site].config)

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

    def fix_microtypo_us(input)
      # Remove useless spaces
      input.gsub!(%r/ (:|%|;|\!|\?)([^\w!]|$)/, '\1\2')

      # Currencies
      input.gsub!(%r!($|€)\s*(\d+)!, '\1\2')
    end

    def fix_microtypo(input, locale, bucket)
      if locale == "fr_FR"
        fix_microtypo_fr(input)
      elsif locale == "en_US"
        fix_microtypo_us(input)
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
      input.gsub!(%r!\([cC]\)!, "©")
      input.gsub!(%r!\([pP]\)!, "℗")
      input.gsub!(%r!\([rR]\)!, "®")
      input.gsub!(%r!\((tm|TM)\)!, "™")
      input.gsub!(%r!\+-!, "±")

      bucket << input
    end
  end
end

Liquid::Template.register_filter(Jekyll::Microtypo)
