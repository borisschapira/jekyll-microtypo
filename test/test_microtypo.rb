# frozen_string_literal: true

require "minitest/autorun"
require "liquid"
require "jekyll"
require "jekyll/microtypo"

class FilterMock
  include Jekyll::Microtypo

  def initialize(opts = {})
    opts  = { "microtypo" => opts } unless opts.empty?
    opts  = Jekyll::Configuration.from(opts)
    @site = Jekyll::Site.new(
      opts.merge(
        "source"            => File.expand_path(__dir__),
        "destination"       => File.expand_path("_site", __dir__),
        "skip_config_files" => true
      )
    )
    @context = Liquid::Context.new(@site.site_payload, {}, :site => @site)
  end
end

class MicrotypoTest < Minitest::Test
  def test_all__comment
    assert_equal "Before One ! After", FilterMock.new.microtypo("Before <!-- nomicrotypo -->One !<!-- endnomicrotypo --> After")
    assert_equal "Avant Hey! Après", FilterMock.new.microtypo("Avant <!-- nomicrotypo -->Hey!<!-- endnomicrotypo --> Après")
  end

  def test_all__style
    assert_equal "Before <style>margin: 0 0 calc(0.9rem + 0.5vw);</style> After", FilterMock.new.microtypo("Before <style>margin: 0 0 calc(0.9rem + 0.5vw);</style> After")
  end

  def test_all__script
    assert_equal "Before <script>const test = 'foo' != 'bar'</script> After", FilterMock.new.microtypo("Before <script>const test = 'foo' != 'bar'</script> After")
  end

  def test_all__pre
    assert_equal "Before <pre>const test = 'foo' != 'bar'</pre> After", FilterMock.new.microtypo("Before <pre>const test = 'foo' != 'bar'</pre> After")
  end

  def test_all__code
    assert_equal "Before <code>const test = 'foo' != 'bar'</code> After", FilterMock.new.microtypo("Before <code>const test = 'foo' != 'bar'</code> After")
  end

  def test_all__pre_script_code_nofix
    assert_equal "A!<pre>B !</pre> C!<script>D !</script> E! <code>F !</code> Test", FilterMock.new.microtypo("A !<pre>B !</pre> C !<script>D !</script> E ! <code>F !</code> Test")
    assert_equal "A&#8239;!<pre>B !</pre> C&#8239;!<script>D !</script> E&#8239;! <code>F !</code> Test", FilterMock.new.microtypo("A !<pre>B !</pre> C !<script>D !</script> E ! <code>F !</code> Test", "fr_FR")
  end

  def test_fr_fr__thin_nb_space
    assert_equal "Hello&#8239;! 4&nbsp;px, 5&nbsp;%&#8239;?", FilterMock.new.microtypo("Hello ! 4 px, 5 % ?", "fr_FR")
  end

  def test_fr_fr__median_point_plural_nosetting
    # test when microtypo.median = false
    assert_equal "Il·Elle est intéressé·e.", FilterMock.new.microtypo("Il·Elle est intéressé·e.", "fr_FR")
  end

  def test_fr_fr__median_point_nosetting
    # test when microtypo.median = false
    assert_equal "Ils·Elles sont intéressé·e·s", FilterMock.new.microtypo("Ils·Elles sont intéressé·e·s", "fr_FR")
  end

  def test_fr_fr__median_point_plural_setting
    # test when microtypo.median = true
    assert_equal 'Il<span aria-hidden="true">·Elle</span> est intéressé<span aria-hidden="true">·e</span>.', FilterMock.new("median" => true).microtypo("Il·Elle est intéressé·e.", "fr_FR")
  end

  def test_fr_fr__median_point_setting
    # test when microtypo.median = true
    assert_equal 'Ils<span aria-hidden="true">·Elles</span> sont intéressé<span aria-hidden="true">·e·</span>s', FilterMock.new("median" => true).microtypo("Ils·Elles sont intéressé·e·s", "fr_FR")
  end

  def test_fr_fr__num
    assert_equal "Elle porte le n<sup>o</sup>&#8239;3.", FilterMock.new.microtypo("Elle porte le n°3.", "fr_FR")
  end

  def test_fr_fr__elipsis
    assert_equal "Moi ça va&#8230;", FilterMock.new.microtypo("Moi ça va...", "fr_FR")
  end

  def test_fr_fr__ordinal
    assert_equal "pour la 150<sup>e</sup> fois (ok, la 1<sup>ere</sup>)", FilterMock.new.microtypo("pour la 150e fois (ok, la 1ere)", "fr_FR")
  end

  def test_fr_fr__ordinal_not
    assert_equal "a15642th", FilterMock.new.microtypo("a15642th", "en_US")
  end

  def test_en_us__ordinal
    assert_equal "for the 150<sup>th</sup> time (or at least, the 1<sup>st</sup>, 2<sup>nd</sup> or 3<sup>rd</sup>)", FilterMock.new.microtypo("for the 150th time (or at least, the 1st, 2nd or 3rd)", "en_US")
  end

  def test_en_us__ordinal_not
    assert_equal "a15642e", FilterMock.new.microtypo("a15642e", "fr_FR")
  end

  def test_fr_fr__ordinal_bug_nhoizey_1
    assert_equal "https://nicolas-hoizey.com/assets/components/footer-c73885d83bce23c897e4cb9831e0733eedcf64c3d6655782b3a898b53e15831e.css", FilterMock.new.microtypo("https://nicolas-hoizey.com/assets/components/footer-c73885d83bce23c897e4cb9831e0733eedcf64c3d6655782b3a898b53e15831e.css", "fr_FR")
  end

  def test_fr_fr__ordinal_bug_nhoizey_2
    assert_equal "Si je double le 2<sup>ème</sup>, je deviens 1<sup>er</sup>.", FilterMock.new.microtypo("Si je double le 2ème, je deviens 1er.", "fr_FR")
  end

  def test_fr_fr__frenchquotes
    assert_equal "On dit «&#8239;en Avignon&#8239;», pas «&#8239;à Avignon&#8239;». Ah, comme dans «&#8239;en Carmélie&#8239;» alors.", FilterMock.new.microtypo("On dit &ldquo;en Avignon&rdquo;, pas “à Avignon”. Ah, comme dans «&nbsp;en Carmélie » alors.", "fr_FR")
  end

  def test_fr_fr__frenchquotes_links
    assert_equal "«&#8239;<a href=\"#\">Œuvre</a>&#8239;», Autrice", FilterMock.new.microtypo("&ldquo;<a href=\"#\">Œuvre</a>&rdquo;, Autrice", "fr_FR")

    assert_equal "«&#8239;<a href=\"#\">Livre</a>&#8239;», Auteur", FilterMock.new.microtypo("”<a href=\"#\">Livre</a>”, Auteur", "fr_FR")
  end

  def test_fr_fr__single_quotes
    # test when microtypo.median = false
    assert_equal "Il compta jusqu’à trois ‘Missisipi’ puis dit&nbsp;: «&#8239;Tu devrais ‘danser', maintenant&#8239;».", FilterMock.new.microtypo("Il compta jusqu'à trois 'Missisipi' puis dit : “Tu devrais 'danser', maintenant”.", "fr_FR")
  end

  def test_fr_fr__timing_single_quotes
    # test when microtypo.median = false
    assert_equal "Il couru 23’’4’.", FilterMock.new.microtypo("Il couru 23''4'.", "fr_FR")
  end

  def test_fr_fr__apostrophe
    assert_equal "L’événement démarrera dans trois minutes.", FilterMock.new.microtypo("L'événement démarrera dans trois minutes.", "fr_FR")
  end

  def test_fr_fr__specialpunc
    assert_equal "© © ® ® ™ ™ ℗ ℗ ±", FilterMock.new.microtypo("(c) (C) (r) (R) (tm) (TM) (p) (P) +-", "fr_FR")
  end

  def test_fr_fr__copyright
    assert_equal "Non&#8239;&#8264; Si&#8239;&#8252; Je ne te crois pas&#8239;&#8265; Je te jure&#8239;&#8252;", FilterMock.new.microtypo("Non ?! Si !! Je ne te crois pas !? Je te jure !!!", "fr_FR")
  end

  def test_fr_fr__nbsp
    assert_equal "2001&nbsp;: Space Odyssey", FilterMock.new.microtypo("2001 : Space Odyssey", "fr_FR")
  end

  def test_fr_fr__currencies
    assert_equal "599$, donc 599&nbsp;€", FilterMock.new.microtypo("599$, donc 599 €", "fr_FR")
  end

  def test_fr_fr__multiply
    assert_equal "Un poster en 4&nbsp;&times;&nbsp;3.", FilterMock.new.microtypo("Un poster en 4x3.", "fr_FR")
  end

  def test_fr_fr__units
    assert_equal "Cet image pèse 4&nbsp;Ko une fois compressée", FilterMock.new.microtypo("Cet image pèse 4 Ko une fois compressée", "fr_FR")
  end

  def test_fr_fr__units_antitest
    assert_equal "Le qualificateur 480w signale une image de 480&nbsp;pixels de large.", FilterMock.new.microtypo("Le qualificateur 480w signale une image de 480 pixels de large.", "fr_FR")
  end

  def test_en_us__removespaces
    assert_equal "So: what are you thinking? Either you’re in at 100% or you’re out.", FilterMock.new.microtypo("So : what are you thinking ? Either you're in at 100 % or you're out.", "en_US")
  end

  def test_en_us__currencies
    assert_equal "$599, so €599", FilterMock.new.microtypo("$599, so € 599", "en_US")
  end

  def test_fr_fr__fix_after_endmicrotypo
    source = "<!-- nomicrotypo -->Aujourd'hui sur <!-- endnomicrotypo -->l'ile."

    target = "Aujourd'hui sur l’ile."

    assert_equal target, FilterMock.new.microtypo(source, "fr_FR")
  end

  def test_all__pre_bis
    source = <<~TEXT
    <pre><code>A</code></pre><pre><code>B</code></pre>
    TEXT

    target = <<~TEXT
    <pre><code>A</code></pre><pre><code>B</code></pre>
    TEXT

    assert_equal target, FilterMock.new.microtypo(source, "fr_FR")
  end

  def test_all__pre_bis
    source = <<~TEXT
    <!-- nomicrotypo -->
    <link rel="preload" as="style" href='/assets/styles/critical.css' data-proofer-ignore="">
    <link rel="preload" as="style" href="/assets/styles/critical.css" data-proofer-ignore="">
    <!-- endnomicrotypo -->
    TEXT

    target = <<~TEXT

    <link rel="preload" as="style" href='/assets/styles/critical.css' data-proofer-ignore="">
    <link rel="preload" as="style" href="/assets/styles/critical.css" data-proofer-ignore="">
    
    TEXT

    assert_equal target, FilterMock.new.microtypo(source, "fr_FR")
  end

  def test_all__nomicrotypo_containing_script
    source = <<~TEXT
    <!-- nomicrotypo -->
    <script>console.log("Hello Wordl");</script>
    <link rel='preconnect dns-prefetch' href='https://res.cloudinary.com'>
    <!-- endnomicrotypo -->
    TEXT

    target = <<~TEXT
    
    <script>console.log("Hello Wordl");</script>
    <link rel='preconnect dns-prefetch' href='https://res.cloudinary.com'>
    
    TEXT

    assert_equal target, FilterMock.new.microtypo(source, "fr_FR")
  end

  def test_all__multiple_exclusions
    source = "<script>Aujourd'hui</script><script>Aujourd'hui</script>"
    target = "<script>Aujourd'hui</script><script>Aujourd'hui</script>"

    assert_equal target, FilterMock.new.microtypo(source, "fr_FR")
  end
end
