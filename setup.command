#!/bin/sh
CWD="$(cd -P -- "$(dirname -- "$0")" && pwd -P)"
PROJ="$(basename -- "${CWD}")"
EXT="xhtml"

cd "${CWD}"

if [ ! -d "${CWD}/.git" ]; then
  curl -fsSL "https://api.github.com/repos/ptb/autokeep/tarball/master" \
    | tar -C "${CWD}" --strip-components 1 -xz
  sh "${CWD}/initialize.command"
fi

cat > "${CWD}/.rubocop.yml" <<-EOF
Style/AlignParameters:
  EnforcedStyle: with_fixed_indentation

Metrics/LineLength:
  Max: 80
EOF

cat > "${CWD}/Gemfile" <<-EOF
ruby '2.3.3', patchlevel: '222'

source 'https://rubygems.org'
source "file:#{Dir.home}/.gem/cache"

gem 'builder', '~> 3.2'
gem 'bundler', '~> 1.13'
gem 'middleman', '~> 4.1'
gem 'middleman-blog', '~> 4.0'
gem 'middleman-minify-html', '~> 3.4'
gem 'nokogiri', '~> 1.6'
gem 'rubocop', '~> 0.46', require: false
gem 'slim', '~> 3.0'
gem 'slim_lint', '~> 0.8'
EOF

1> /dev/null bundle update

mkdir -p "${CWD}/.tmp" "${CWD}/data" "${CWD}/docs" "${CWD}/helpers" \
  "${CWD}/logs" "${CWD}/src/_example" "${CWD}/src/_layouts" \
  "${CWD}/src/_parts" "${CWD}/src/css" "${CWD}/src/fonts" "${CWD}/src/img" \
  "${CWD}/src/js" "${CWD}/src/js/example-tag.tag"

printf "%s\n" '*' '!.gitignore' > "${CWD}/.tmp/.gitignore"
touch "${CWD}/data/.keep" "${CWD}/docs/.keep" "${CWD}/src/.keep"

cat > "${CWD}/localhost.crt" <<-EOF
-----BEGIN CERTIFICATE-----
MIIEmjCCAoICAQEwDQYJKoZIhvcNAQELBQAwEjEQMA4GA1UEAxMHcHRiMi5tZTAe
Fw0xNjExMDExNjAwMDBaFw0xNzExMDExNjAwMDBaMBQxEjAQBgNVBAMTCWxvY2Fs
aG9zdDCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAKtTUxxo6ZJAUCIx
YehDOpxXr/UhsAMSV0jW1qegVjIWoVNOJi90cqbZlKuCVVUpzRhqHRcMmAB7g7fA
Jhzt8qt56T+atNHYV6sMuE4B3APF74lIFqQVfxO4duQWnIKea4jguYoWNXB9LzA4
XkIn104FYjrW71LbDm+7IW+IxaZ3sHh2s4NwGtCUZiKuxkt5JFIUx/Z4HVp0dSXI
1eH7h+b0e6XuE1L4BKkywDPGIxinZq55hgpA5h3I3YfofJs9l8RsJDOh1YkRJ+3g
pGp/RvnM8BwTOZrPV4Ut8b1loIWdMYpzvbgVjM27ayQX37nTwT+8MqQeFUGKdoUJ
TuXb2TaARU5YGfNLM5FQycArOTFuAjHgIOpWjzNKozMX73s2G6X2xUapNAaUfYg2
6UUVEML1+IciYI0/WEQSCgjDs9VYCNpO3DndY1GCAnzs9R/soA8aUNQTQOfuTrRS
0g/HzHXl1F8vldmQVP7qckymFpeTsPQB6sl9yNaUQ/BhrWiJ1gkulw+2fvz00z3D
0o8fGwlbkPRBn+7eqKg6tSfkkbX+pSu6JowDYB4GsOvbEZ0Hf+Sq+zkjRLVehnie
KWIddgzuU/CyFLdxHxzdsUotXuPc6VD1o6LNAH65LmpMNOruBLiZBI0Yj6j6brhR
nDwdJkZsJ8SxTBlWzcaHcaEp/jDVAgMBAAEwDQYJKoZIhvcNAQELBQADggIBAFUE
VbxYKLYPUGrWpx6ZUg3FbC5flGxt5VocAA6pIYDyhxDGVlbh5GS7dtUSw5aaZCtX
6IL/8sI5jGYEA0UiO97kExZ2RfJWw53plQAJM1V6tBAm278E2SwBi2XvIbTc5zNw
gGckRhPbgOtcR8Pgt02pvwJ66XGZn/Uwh3BSlG05mTubUYTEgFM6eU+Y8QLEm6+q
WRz1zfUVX0uQYcVAcUpj+WhXhSErgKvaYp5LHhpNXD8X9WsYODMWcEsgluo5SO/B
9+xR0PZMFzsGjbEbgIF61wtPqSdiWF+Ir9kPOoPbVcgyNbMHqAx2JNE/I7/ixJLw
Gt2Zxc1+GcZWSQcJiVCcJm80aLsCuQyK29n0JSnsBX8qwj7UQWzHHZvQGRHu8vev
VqMTyagmp7XHro+6CIjv7fCENQuxu8LG0V1ZdAVngowqMY/K4VG2Quwh1sHvAre4
59NFu9zP/qESdmU6yTN85gGXethtJaah9OG7V/smia1zSyfPBLk8QDPCPpBynDOC
oaqwf1iP8MH/WDZrJ329gDfnMagSnDUs34KwDICSc6lTX2hrLUguxWa62jFRSAK5
WJWjGd+TfzkxoqVTTXpfnBxWRMhhiMnbfgsuUt1MU2qsLBcdlfDEZSg3qG/fSon7
ARGGl/To+UnJ9SdV1dNtiJfemZ844gN/5c4Z26UR
-----END CERTIFICATE-----
EOF

cat > "${CWD}/localhost.key" <<-EOF
-----BEGIN RSA PRIVATE KEY-----
MIIJKQIBAAKCAgEAq1NTHGjpkkBQIjFh6EM6nFev9SGwAxJXSNbWp6BWMhahU04m
L3RyptmUq4JVVSnNGGodFwyYAHuDt8AmHO3yq3npP5q00dhXqwy4TgHcA8XviUgW
pBV/E7h25Bacgp5riOC5ihY1cH0vMDheQifXTgViOtbvUtsOb7shb4jFpneweHaz
g3Aa0JRmIq7GS3kkUhTH9ngdWnR1JcjV4fuH5vR7pe4TUvgEqTLAM8YjGKdmrnmG
CkDmHcjdh+h8mz2XxGwkM6HViREn7eCkan9G+czwHBM5ms9XhS3xvWWghZ0xinO9
uBWMzbtrJBffudPBP7wypB4VQYp2hQlO5dvZNoBFTlgZ80szkVDJwCs5MW4CMeAg
6laPM0qjMxfvezYbpfbFRqk0BpR9iDbpRRUQwvX4hyJgjT9YRBIKCMOz1VgI2k7c
Od1jUYICfOz1H+ygDxpQ1BNA5+5OtFLSD8fMdeXUXy+V2ZBU/upyTKYWl5Ow9AHq
yX3I1pRD8GGtaInWCS6XD7Z+/PTTPcPSjx8bCVuQ9EGf7t6oqDq1J+SRtf6lK7om
jANgHgaw69sRnQd/5Kr7OSNEtV6GeJ4pYh12DO5T8LIUt3EfHN2xSi1e49zpUPWj
os0Afrkuakw06u4EuJkEjRiPqPpuuFGcPB0mRmwnxLFMGVbNxodxoSn+MNUCAwEA
AQKCAgAzhoXSX4MPpyPyhKOLdNyltIGI2a7T3ao+j85S75e8zK2MHk7BquXoZDug
MTx0tnOmShOhoPn9+yesFa/gt3dqNun9ZQvIqKYFHXg4jbqbr+XQhcu5YXWseqfX
BS3g4sA4lE14yCEeSafteqZugwjvwBLA229yncsDs2Xk419+JzT9pcVrXEXUQS1O
dP3SKQbRYMqax5kcYTXyPSqGIl3HCfQ9/RH2u/y63jaL26UmfwIUqxuy7b3Ha2ek
vjjrf2SrgFKK7LsJ1A0ML6mDFfBEpGv6JZYHhyAtP5oaefwC8zm5CAIg4OpN3XXl
jwCMJLFT98fLL/j4kyn97MS7wJjcm0U1GaPb/6P6h3oTsudqcssFQ1YMqJUElji4
FPDE8lkRHgTLKWT/pegorKFg2PXVDiPAcL28kowBrz0hVrqb8KSYQjtQ1UYNy4k2
FVomP+kRYDZUkKke1Q7VHaKR5YyZD4Ebjt7+LEZWb4YYsrLrQLGTVj3cEg4MEZzq
9caksYr8wetOZ+cmGpUzn4GIjNdgk/vHjHjU5yAaTCCK8ySTdA5Hs9qdZDGA0mvp
u2riDrjI01M3cMBUEYvq5mMvrw91yghU6/rDsCy7m3wwyRcGKtqVpGG5m9r0co3j
55ydIDAcAaW3UZZ/9LQarmCPoxMZ3CQ0zqspoTKLAiaHCDA5aQKCAQEA150S5HDD
mBP7GUpHO0ECtz+pwC/eKhZqCovy+BtCz2pV9Q6qybcwHQAvsyF7ZhlmDUIpBcwT
0F9RT9s/FugpYB/dtj2noN7pCt3e73Rn8FqI1yaFSsM+LBqhr/QfD3M7wLe+BdZN
Bk9qbooAVoJWAZlqkeHLVj88CYml+lBlzjQ9yhONoSjo5uJPscQCcARFdCeXVaI/
LDUWq2jFWcNTjI8wpoM0nC66JQWH5XJUWS9WXnDxx2jkm+tAI5HROlLqedCLCLDA
3RRb5arKyMv+AJXZbdLV7TJGpYZgbjVU6P5bk46RTRLetqMtOT5bwsRo0mP2xnhv
ECIphzx6Qb/2twKCAQEAy2qVta5cQZRm0QMbW1EH9DpB57ytvYeahzlT8u4lgGjK
6gYVBpSXxfe22gxY1iFXTGZ7Wt6licXZY538g10N76SAIZmR5BtsKM9x0pYaR8TE
dbg77+1ygQGftZmnXEfkjPA4vLePgo9TNNq1nCMnhWeSEHOSK6qRA0xtiop2t2BA
YTa+LXlut2wBNMXJxrPhMB2YWmmt7mR70HaBTXtAYc1NG/jxvvTZ8kj2gKQsoZnk
02kSFMN29eJqtroWiLKXuGopUFi4ONvDzCdG0zX9MHRmHRXzRfA+mnHlsCs3nCrB
D4R3TAW4EMaxlhqEykESKUj5cVw/Hh5ZenxdWFDo0wKCAQAmdMyO1BH+yOmLTDVC
O0kpuAAl2CPO6+qD8Qwn9mzHI9cq+y+5BKRfN85KK9mfjz4ldTxt3UVXb/jHvnoV
MtlWXLilrX99cOSt3H7LxL5ZHzyy6xrxB7vKEAHwqSD1F3970wngbqWUT4vTJWgE
BgEjDeL1HAmxW1vw840YBUjzK1wt86jaKrrHm2vNcAFjS0+79OfIDUUpNFrTvb8d
UHpRYqSxvkse5DKtMbxYTzj+IzRLaeelwm6r5Jyu+24O8gUCLxDtPuFXTS9K2liK
0d9+6Ts7nFQtlz8EfOAsJ/T6DYv12ILP9WKlvprtT9L7/R4ZEF1ObuKYRQ+VIFNJ
8NwnAoIBAQCGyyZRsizoOBK5xjlGlbeTm1c43Mq0oTtBCDgc7rpjEQ4FbepY5fZ8
9N1yOGRV4NocgnyThp5jYXvgizxdQDiP6I4Ptdf7NEDD+lMOnPDlRfp5l5AAOXR7
EDxo9lz0xZ8p1bWDOJAckCUvDQ7zXEhAGpWr2SmvTeOyL98WwxJQCbQft0rmj2VS
nnteIQLIbUJ3w+TFZOog4u05Ao5EbbwIEydZtelcBJy39KmELUZ1/6imfyXAJJab
8WGNnFp6Uv4+8fpWh7Pr2ZUxn4VLSKdyiG9yLq16VuzlIzx1NO4wyhQM2FbFRbTn
SQM82G3OKLiEKxtAh0Q8DRh2Fhs0/siJAoIBAQCTjmptTuCAjHUwtg9JSKOdZEBS
Ro8kMvIJWan88XuSgKyHiCSgxb5OVN/DTLKfEzwqiX6ZP30D44SqfHXTovKRej7T
N9a29erDIF3u05CteVQKCQ2f8sZxT5peDgAD6I4ScZICnYX5q8Z/FgPkcExqP+8I
vQR28on9+aRkF1fsUN0j/Wgy8I7vkoVuCdGbK0ZZoWrIFW5GymLebZQl/lfaXOp9
Gw7+8Ze/wC7Lsxeds7jpDxG2bajZTgDs53D7+KNks3itsd3sDU4PHj5XpvbcDxjO
eAfR7m1rtN2dKTJVuXXRnPNuzxLaAWbFkTyx82HyUkaYHskYX1fxb+TjGUAu
-----END RSA PRIVATE KEY-----
EOF

cat > "${CWD}/config.rb" <<-EOF
MIN = config[:environment] == :production
EXT = '${EXT}'.freeze

activate :blog do |blog|
  Time.zone = 'America/New_York'

  blog.sources = "{title}/index.#{EXT}"
  blog.default_extension = '.slim'

  # blog.layout = 'blog'
  blog.permalink = '{title}'

  # blog.generate_tag_pages = true
  blog.tag_template = "articles.#{EXT}"
  blog.taglink = "{tag}/index.#{EXT}"

  blog.calendar_template = "articles.#{EXT}"
  blog.year_link = "{year}/index.#{EXT}"
  blog.month_link = "{year}/{month}/index.#{EXT}"
  blog.day_link = "{year}/{month}/{day}/index.#{EXT}"

  blog.generate_year_pages = false
  blog.generate_month_pages = false
  blog.generate_day_pages = false

  blog.paginate = true
  blog.per_page = 3
  blog.page_link = 'page/{num}'
end

activate :directory_indexes

activate :external_pipeline,
  command: "node_modules/.bin/gulp build#{MIN ? ' --min' : nil} --silent",
  name: :gulp,
  source: '.tmp'

configure :development do
  if build?
    # url_for('/blog/file.xhtml') or url_for(sitemap.resources[0])
    # Example: link(href="#{url_for('/css/style.css')}" rel='stylesheet')

    activate :relative_assets
    set :relative_links, true
    set :strip_index_file, false
  end
end

configure :production do
  activate :asset_hash
  activate :minify_html, remove_quotes: false, simple_boolean_attributes: false
end

ignore(/.*\.keep/)
ignore(%r{\.tag/.*})

set :build_dir, 'docs'
set :css_dir, 'css' if File.directory? 'src/css/'
set :fonts_dir, 'fonts' if File.directory? 'src/fonts/'
set :images_dir, 'img' if File.directory? 'src/img/'
set :js_dir, 'js' if File.directory? 'src/js/'
set :layouts_dir, '_layouts' if File.directory? 'src/_layouts/'
set :source, 'src' if File.directory? 'src/'

set :https, true
set :ssl_certificate, 'localhost.crt'
set :ssl_private_key, 'localhost.key'

set :index_file, "index.#{EXT}"
set :layout, 'layout'

set :slim,
  attr_quote: "'",
  format: EXT.to_sym,
  pretty: !MIN,
  sort_attrs: true,
  shortcut: {
    '@' => { attr: 'role' },
    '#' => { attr: 'id' },
    '.' => { attr: 'class' },
    '%' => { attr: 'itemprop' },
    '^' => { attr: 'data-is' },
    '&' => { attr: 'type', tag: 'input' }
  }
EOF

cat > "${CWD}/helpers/custom_helpers.rb" <<-EOF
module CustomHelpers
  def article(article, content)
    partial '_parts/article', locals: {
      article: article,
      content: content,
      single: is_blog_article?
    }
  end

  def inline_tag(tag, *files)
    content_tag tag.to_sym do
      content = '/*<![CDATA[*/ '
      files.map do |file|
        content << sitemap.find_resource_by_path(file).render
      end
      content << ' /*]]>*/'
      content
    end
  end

  def page_intro
    if current_page.methods.include? :slug
      if File.exist?("src/_parts/_#{current_page.slug}.slim")
        partial "_parts/#{current_page.slug}"
      end
    elsif !!current_page.locals['tagname']
      if File.exist?("src/_parts/_#{current_page.locals['tagname']}.slim")
        partial "_parts/#{current_page.locals['tagname']}"
      end
    end
  end

  def page_title
    site_name = 'ptb2.me'
    if is_blog_article?
      "#{current_page.title} - #{site_name}"
    else
      d = Date.new(current_page.locals['year'] || 1, current_page.locals['month'] || 1, current_page.locals['day'] || 1)
      case current_page.locals['page_type']
      when 'day'
        "#{site_name} for #{d.strftime('%B')} #{d.strftime('%e').to_i.ordinalize}, #{d.strftime('%Y')}"
      when 'month'
        "#{site_name} for #{d.strftime('%B')} #{d.strftime('%Y')}"
      when 'year'
        "#{site_name} for #{d.strftime('%Y')}"
      when 'tag'
        "#{current_page.locals['tagname'].titleize} - #{site_name}"
      else
        "Welcome to #{site_name}"
      end
    end
  end

  def pagination
    if is_blog_article?
      partial '_parts/pagination', locals: {
        prev_pg: current_page.next_article,
        next_pg: current_page.previous_article,
        page_num: nil,
        total_pg: nil,
        single: true
      }
    else
      partial '_parts/pagination', locals: {
        prev_pg: current_page.locals['prev_page'],
        next_pg: current_page.locals['next_page'],
        page_num: current_page.locals['page_number'],
        total_pg: current_page.locals['num_pages'],
        single: false
      }
    end
  end
end
EOF

cat > "${CWD}/src/_layouts/layout.slim" <<-EOF
doctype 5
html.no-js(lang='en' xml:lang='en' xmlns='http://www.w3.org/1999/xhtml')
  head
    meta(charset='utf-8')/

    title = page_title

    meta(content='initial-scale=1, width=device-width' name='viewport')/

    / link(href="#{url_for('/css/style.css')}" rel='stylesheet')/

    - if content_for? :head
      == yield_content :head

  body(itemscope itemtype='http://www.schema.org/Blog')

    #main@main(class="#{is_blog_article? ? nil : 'hfeed'}")
      == page_intro

      - if is_blog_article?
        == article(current_article, yield)
      - else
        - page_articles.each do |article|
          == article(article, article.summary)

      == pagination

    - if content_for? :foot
      == yield_content :foot

    / script(src='/browser-sync/browser-sync-client.js')
EOF

base64 -D > "${CWD}/src/favicon.ico" <<-EOF
  AAABAAEAEBACAAEAAQCwAAAAFgAAACgAAAAQAAAAIAAAAAEAAQAAAAAAAAAAAAAA
  AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
  AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD//wAA//8AAP//
  AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//
  AAD//wAA
EOF

base64 -D > "${CWD}/src/apple-touch-icon-precomposed.png" <<-EOF
  iVBORw0KGgoAAAANSUhEUgAAALQAAAC0AQMAAAAHA5RxAAAAA1BMVEUmRcn0DMbc
  AAAAAXRSTlMAQObYZgAAABtJREFUeF7twAEJAAAAwjD7pzbHYVscAAAAwAEQ4AAB
  d61H3AAAAABJRU5ErkJggg==
EOF

cat > "${CWD}/src/index.${EXT}.slim" <<-EOF
---
pageable: true
per_page: 3
---
EOF

cd "${CWD}/src" && ln -s index.${EXT}.slim articles.${EXT}.slim && cd "${CWD}"

cat > "${CWD}/src/_parts/_article.slim" <<-EOF
article.hentry%blogPost<>(itemscope itemtype='http://schema.org/BlogPosting')
  header
    - unless article.tags.empty?
      ul.tags@navigation
        - article.tags.each do |tag, articles|
          li
            a%keywords(href="#{tag_path tag}" rel='tag') = tag

  h2.entry-title%headline
    - if single
      = article.title
    - else
      a.permalink%url(href="#{article.url}" rel='bookmark') = article.title

  - if single
    div.entry-content%articleBody
      == content
  - else
    div.entry-summary%description
      == content
EOF

cat > "${CWD}/src/_parts/_pagination.slim" <<-EOF
- if prev_pg || next_pg
  nav.pages@navigation(aria-labelledby='pagination')
    h3#pagination Page Navigation
    div
  - if prev_pg
    span.prev>
      a(href="#{prev_pg.url}" rel='prev')
        = single ? prev_pg.title : 'Newer'
  - if page_num && total_pg
    span.page
      = page_num
      span &#160;of&#160;
      = total_pg
  - if next_pg
    span.next<
      a(href="#{next_pg.url}" rel='next')
        = single ? next_pg.title : 'Older'
EOF

cat > "${CWD}/src/_example/index.${EXT}.slim" <<-EOF
---
title: Example
date: 2016-11-01
tags: examples
---
p
  |
    Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod
    tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim
    veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea
    commodo consequat. Duis aute irure dolor in reprehenderit in voluptate
    velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat
    cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id
    est laborum.

example-tag
div^example-tag
EOF

cat > "${CWD}/src/js/example-tag.tag/example-tag.slim" <<-EOF
p
  a(onclick="{this.add}") {opts.sum}
  | &#32;
  |
    Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod
    tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim
    veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea
    commodo consequat. Duis aute irure dolor in reprehenderit in voluptate
    velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat
    cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id
    est laborum.

div
  p
    |
      Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod
      tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim
      veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea
      commodo consequat. Duis aute irure dolor in reprehenderit in voluptate
      velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint
      occaecat cupidatat non proident, sunt in culpa qui officia deserunt
      mollit anim id est laborum.
EOF

cat > "${CWD}/src/js/example-tag.tag/example-tag.svg" <<-EOF
<svg xmlns="http://www.w3.org/2000/svg">
  <rect height="100" width="100" />
</svg>
EOF

cat > "${CWD}/src/js/example-tag.tag/example-tag.sass" <<-EOF
\\:scope
  display: block

p
  width: 40em
EOF

cat > "${CWD}/src/js/example-tag.tag/example-tag.es6" <<-EOF
this.opts = opts

if (!this.opts.sum) {
  this.opts.sum = 0
}

/**
 * Add two numbers.
 * @param {number} a The first number.
 * @param {number} b The second number.
 * @returns {number} The sum of the two numbers.
 */
this.add = function () {
  this.opts.sum = parseInt(this.opts.sum, 10) + 1
  this.update()
}.bind(this)
EOF

cat > "${CWD}/package.json" <<-EOF
{
  "author": "Peter T Bosse II <ptb@ioutime.com> (http://ptb2.me)",
  "bugs": {
    "url": "https://github.com/ptb/${PROJ}/issues"
  },
  "dependencies": {},
  "description": "web project template",
  "devDependencies": {},
  "homepage": "https://github.com/ptb/${PROJ}#readme",
  "license": "Apache-2.0",
  "name": "${PROJ}",
  "repository": {
    "type": "git",
    "url": "git://github.com/ptb/${PROJ}.git"
  },
  "scripts": {},
  "version": "$(date '+%Y.%-m.%-e')"
}
EOF

1> /dev/null yarn add --dev \
  github:gulpjs/gulp#4.0 \
  gulp-cli \
  gulp-load-plugins \
  gulp-util \
  kexec

cat > "${CWD}/gulpfile.js" <<-EOF
// -- require ---------------------------------------------------------------

const gulp = require("gulp")
const plug = require("gulp-load-plugins")({
  "pattern": "*"
})
const proc = require("child_process")

// -- const -----------------------------------------------------------------

const MIN = typeof plug.util.env.min != "undefined"

// -- opts ------------------------------------------------------------------

const opts = new function () {
  return {
    "restart": {
      "files": ["config.rb", "Gemfile.lock", "gulpfile.js", "package.json",
        "yarn.lock"]
    }
  }
}()

// -- task ------------------------------------------------------------------

const task = {
  "restart": function () {
    if (process.platform === "darwin") {
      proc.spawn("osascript", ["-e", 'activate app "Terminal"', "-e",
        'tell app "System Events" to keystroke "k" using command down'])
    }
    plug.kexec("npm", ["run", MIN ? "build" : "start"])
  }
}

// -- gulp ------------------------------------------------------------------

gulp.task("build", function build (done) {
  done()
})

gulp.task("default", function watch (done) {
  gulp.watch(opts.restart.files, task.restart)
  done()
})
EOF

cat <<-EOF | patch 1> /dev/null
--- package.json
+++ package.json
@@ -22 +22,5 @@
-  "scripts": {},
+  "scripts": {
+    "prestart": "bundle install 1> /dev/null && yarn install 1> /dev/null",
+    "start": "gulp --silent",
+    "build": "gulp --min --silent"
+  },
EOF

1> /dev/null yarn add --dev \
  gulp-changed-in-place \
  gulp-if \
  gulp-trimlines \
  lazypipe

cat <<-EOF | patch 1> /dev/null
--- gulpfile.js
+++ gulpfile.js
@@ -2,6 +2,10 @@

 const gulp = require("gulp")
+const path = require("path")
 const plug = require("gulp-load-plugins")({
-  "pattern": "*"
+  "pattern": "*",
+  "rename": {
+    "gulp-if": "gulpIf"
+  }
 })
 const proc = require("child_process")
@@ -9,4 +13,7 @@
 // -- const -----------------------------------------------------------------

+const CWD = process.cwd()
+const SRC = path.join(CWD, "src")
+
 const MIN = typeof plug.util.env.min != "undefined"

@@ -15,7 +22,19 @@
 const opts = new function () {
   return {
+    "changedInPlace": {
+      "firstPass": true
+    },
+    "ext": {
+      "slim": "*.sl?(i)m"
+    },
+    "path": {
+      "src": path.join(SRC, "**")
+    },
     "restart": {
       "files": ["config.rb", "Gemfile.lock", "gulpfile.js", "package.json",
         "yarn.lock"]
+    },
+    "trimlines": {
+      "leading": false
     }
   }
@@ -31,4 +50,23 @@
     }
     plug.kexec("npm", ["run", MIN ? "build" : "start"])
+  },
+  "save": {
+    "src": function () {
+      return plug.gulpIf(!MIN, gulp.dest(SRC))
+    }
+  },
+  "tidy": {
+    "lines": function () {
+      return plug.trimlines(opts.trimlines)
+    }
+  }
+}
+
+// -- pipe ------------------------------------------------------------------
+
+const pipe = {
+  "slim": function () {
+    return plug.lazypipe()
+      .pipe(task.tidy.lines)
   }
 }
@@ -40,6 +78,19 @@
 })

-gulp.task("default", function watch (done) {
+gulp.task("check", gulp.series(
+  function slim (done) {
+    gulp.src(path.join(opts.path.src, opts.ext.slim), {
+      "since": gulp.lastRun("check")
+    })
+      .pipe(plug.changedInPlace(opts.changedInPlace))
+      .pipe(pipe.slim()())
+      .pipe(task.save.src())
+    done()
+  }
+))
+
+gulp.task("default", gulp.series("check", function watch (done) {
   gulp.watch(opts.restart.files, task.restart)
+  gulp.watch(opts.path.src, gulp.series("check"))
   done()
-})
+}))
EOF

cat > "${CWD}/.slim-lint.yml" <<-EOF
linters:
  TagCase:
    enabled: false

skip_frontmatter: true
EOF

1> /dev/null yarn add --dev \
  gulp-flatmap

cat <<-EOF | patch 1> /dev/null
--- gulpfile.js
+++ gulpfile.js
@@ -44,4 +44,14 @@

 const task = {
+  "lint": {
+    "slim": function () {
+      return plug.flatmap(function (stream, file) {
+        proc.spawn("slim-lint", [file.path], {
+          "stdio": "inherit"
+        })
+        return stream
+      })
+    }
+  },
   "restart": function () {
     if (process.platform === "darwin") {
@@ -69,4 +79,5 @@
     return plug.lazypipe()
       .pipe(task.tidy.lines)
+      .pipe(task.lint.slim)
   }
 }
EOF

cat <<-EOF | patch 1> /dev/null
--- gulpfile.js
+++ gulpfile.js
@@ -26,4 +26,5 @@
     },
     "ext": {
+      "sass": "*.s@(a|c)ss",
       "slim": "*.sl?(i)m"
     },
@@ -76,4 +77,8 @@

 const pipe = {
+  "sass": function () {
+    return plug.lazypipe()
+      .pipe(task.tidy.lines)
+  },
   "slim": function () {
     return plug.lazypipe()
@@ -98,4 +103,13 @@
       .pipe(task.save.src())
     done()
+  },
+  function sass (done) {
+    gulp.src(path.join(opts.path.src, opts.ext.sass), {
+      "since": gulp.lastRun("check")
+    })
+      .pipe(plug.changedInPlace(opts.changedInPlace))
+      .pipe(pipe.sass()())
+      .pipe(task.save.src())
+    done()
   }
 ))
EOF

cat > "${CWD}/.csscomb.json" <<-EOF
{
  "always-semicolon": true,
  "block-indent": "  ",
  "color-case": "lower",
  "color-shorthand": true,
  "element-case": "lower",
  "eof-newline": false,
  "exclude": [
    ".bundle/**",
    ".git/**",
    "node_modules/**"
  ],
  "leading-zero": true,
  "quotes": "double",
  "remove-empty-rulesets": true,
  "sort-order": [
    [
      "-webkit-rtl-ordering",
      "direction",
      "unicode-bidi",
      "writing-mode",
      "text-orientation",
      "glyph-orientation-vertical",
      "text-combine-upright",
      "text-transform",
      "white-space",
      "tab-size",
      "line-break",
      "word-break",
      "hyphens",
      "word-wrap",
      "overflow-wrap",
      "text-align",
      "text-align-last",
      "text-justify",
      "word-spacing",
      "letter-spacing",
      "text-indent",
      "hanging-punctuation",
      "-webkit-nbsp-mode",
      "text-decoration",
      "text-decoration-line",
      "text-decoration-style",
      "text-decoration-color",
      "text-decoration-skip",
      "text-underline-position",
      "text-emphasis",
      "text-emphasis-style",
      "text-emphasis-color",
      "text-emphasis-position",
      "text-shadow",
      "-webkit-text-fill-color",
      "-webkit-text-stroke",
      "-webkit-text-stroke-width",
      "-webkit-text-stroke-color",
      "-webkit-text-security",
      "font",
      "font-style",
      "font-variant",
      "font-weight",
      "font-stretch",
      "font-size",
      "line-height",
      "font-family",
      "src",
      "unicode-range",
      "-webkit-text-size-adjust",
      "font-size-adjust",
      "font-synthesis",
      "font-kerning",
      "font-variant-ligatures",
      "font-variant-position",
      "font-variant-caps",
      "font-variant-numeric",
      "font-variant-alternates",
      "font-variant-east-asian",
      "font-feature-settings",
      "font-language-override",
      "list-style",
      "list-style-type",
      "list-style-position",
      "list-style-image",
      "marker-side",
      "counter-set",
      "counter-increment",
      "caption-side",
      "table-layout",
      "border-collapse",
      "-webkit-border-horizontal-spacing",
      "-webkit-border-vertical-spacing",
      "border-spacing",
      "empty-cells",
      "move-to",
      "quotes",
      "counter-increment",
      "counter-reset",
      "page-policy",
      "content",
      "crop",
      "box-sizing",
      "outline",
      "outline-color",
      "outline-style",
      "outline-width",
      "outline-offset",
      "resize",
      "text-overflow",
      "cursor",
      "caret-color",
      "nav-up",
      "nav-right",
      "nav-down",
      "nav-left",
      "-webkit-appearance",
      "-webkit-user-drag",
      "-webkit-user-modify",
      "-webkit-user-select",
      "-moz-user-select",
      "-ms-user-select",
      "pointer-events",
      "-webkit-dashboard-region",
      "-apple-dashboard-region",
      "-webkit-touch-callout",
      "position",
      "top",
      "right",
      "bottom",
      "left",
      "offset-before",
      "offset-end",
      "offset-after",
      "offset-start",
      "z-index",
      "display",
      "-webkit-margin-collapse",
      "-webkit-margin-top-collapse",
      "-webkit-margin-bottom-collapse",
      "-webkit-margin-start",
      "margin",
      "margin-top",
      "margin-right",
      "margin-bottom",
      "margin-left",
      "-webkit-padding-start",
      "padding",
      "padding-top",
      "padding-right",
      "padding-bottom",
      "padding-left",
      "width",
      "min-width",
      "max-width",
      "height",
      "min-height",
      "max-height",
      "float",
      "clear",
      "overflow",
      "overflow-x",
      "overflow-y",
      "-webkit-overflow-scrolling",
      "overflow-style",
      "marquee-style",
      "marquee-loop",
      "marquee-direction",
      "marquee-speed",
      "visibility",
      "rotation",
      "rotation-point",
      "flex-flow",
      "flex-direction",
      "flex-wrap",
      "order",
      "flex",
      "flex-grow",
      "flex-shrink",
      "flex-basis",
      "justify-content",
      "align-items",
      "align-self",
      "align-content",
      "columns",
      "column-width",
      "column-count",
      "column-gap",
      "column-rule",
      "column-rule-width",
      "column-rule-style",
      "column-rule-color",
      "break-before",
      "break-after",
      "break-inside",
      "column-span",
      "column-fill",
      "grid",
      "grid-template",
      "grid-template-columns",
      "grid-template-rows",
      "grid-template-areas",
      "grid-auto-flow",
      "grid-auto-columns",
      "grid-auto-rows",
      "grid-column",
      "grid-row",
      "grid-area",
      "grid-row-start",
      "grid-column-start",
      "grid-row-end",
      "grid-column-end",
      "grid-gap",
      "grid-column-gap",
      "grid-row-gap",
      "orphans",
      "widows",
      "box-decoration-break",
      "background",
      "background-image",
      "background-position",
      "background-size",
      "background-repeat",
      "background-attachment",
      "background-origin",
      "background-clip",
      "background-color",
      "border",
      "border-width",
      "border-style",
      "border-color",
      "border-top",
      "border-top-width",
      "border-top-style",
      "border-top-color",
      "border-right",
      "border-right-width",
      "border-right-style",
      "border-right-color",
      "border-bottom",
      "border-bottom-width",
      "border-bottom-style",
      "border-bottom-color",
      "border-left",
      "border-left-width",
      "border-left-style",
      "border-left-color",
      "border-radius",
      "border-top-left-radius",
      "border-top-right-radius",
      "border-bottom-right-radius",
      "border-bottom-left-radius",
      "border-image",
      "border-image-source",
      "border-image-slice",
      "border-image-width",
      "border-image-outset",
      "border-image-repeat",
      "box-shadow",
      "color",
      "opacity",
      "-webkit-tap-highlight-color",
      "object-fit",
      "object-position",
      "image-resolution",
      "image-orientation",
      "clip-path",
      "mask",
      "mask-image",
      "mask-mode",
      "mask-repeat",
      "mask-position",
      "mask-clip",
      "mask-origin",
      "mask-size",
      "mask-composite",
      "mask-border",
      "mask-border-source",
      "mask-border-slice",
      "mask-border-width",
      "mask-border-outset",
      "mask-border-repeat",
      "mask-border-mode",
      "mask-type",
      "clip",
      "filter",
      "transition",
      "transition-property",
      "transition-duration",
      "transition-timing-function",
      "transition-delay",
      "transform",
      "transform-origin",
      "transform-style",
      "perspective",
      "perspective-origin",
      "backface-visibility",
      "animation",
      "animation-name",
      "animation-duration",
      "animation-timing-function",
      "animation-delay",
      "animation-iteration-count",
      "animation-direction",
      "animation-fill-mode",
      "animation-play-state",
      "voice-volume",
      "voice-balance",
      "speak",
      "speak-as",
      "pause",
      "pause-before",
      "pause-after",
      "rest",
      "rest-before",
      "rest-after",
      "cue",
      "cue-before",
      "cue-after",
      "voice-family",
      "voice-rate",
      "voice-pitch",
      "voice-range",
      "voice-stress",
      "voice-duration",
      "size",
      "page",
      "zoom",
      "min-zoom",
      "max-zoom",
      "user-zoom",
      "orientation"
    ]
  ],
  "sort-order-fallback": "abc",
  "space-after-colon": " ",
  "space-after-combinator": " ",
  "space-after-opening-brace": "\n",
  "space-after-selector-delimiter": " ",
  "space-before-closing-brace": " ",
  "space-before-colon": "",
  "space-before-combinator": " ",
  "space-before-opening-brace": " ",
  "space-before-selector-delimiter": "",
  "space-between-declarations": "\n",
  "strip-spaces": true,
  "tab-size": true,
  "unitless-zero": true,
  "vendor-prefix-align": false
}
EOF

1> /dev/null yarn add --dev \
  gulp-csscomb

cat <<-EOF | patch 1> /dev/null
--- gulpfile.js
+++ gulpfile.js
@@ -70,4 +70,7 @@
     "lines": function () {
       return plug.trimlines(opts.trimlines)
+    },
+    "sass": function () {
+      return plug.csscomb()
     }
   }
@@ -80,4 +83,5 @@
     return plug.lazypipe()
       .pipe(task.tidy.lines)
+      .pipe(task.tidy.sass)
   },
   "slim": function () {
EOF

cat > "${CWD}/.sass-lint.yml" <<-EOF
rules:
  bem-depth: 0
  border-zero:
    - 1
    -
      convention: 0
  brace-style: 0
  class-name-format:
    - 1
    -
      allow-leading-underscore: false
      convention: hyphenatedlowercase
  clean-import-paths:
    - 1
    -
      leading-underscore: true
      filename-extension: true
  empty-args:
    - 1
    -
      include: true
  empty-line-between-blocks: 0
  extends-before-declarations: 1
  extends-before-mixins: 1
  final-newline: 0
  force-attribute-nesting: 1
  force-element-nesting: 1
  force-pseudo-nesting: 1
  function-name-format:
    - 1
    -
      allow-leading-underscore: false
      convention: hyphenatedlowercase
  hex-length:
    - 1
    -
      style: short
  hex-notation:
    - 1
    -
      style: lowercase
  id-name-format:
    - 1
    -
      allow-leading-underscore: false
      convention: hyphenatedlowercase
  indentation: 0
  leading-zero:
    - 1
    -
      include: true
  mixin-name-format:
    - 1
    -
      allow-leading-underscore: false
      convention: hyphenatedlowercase
  mixins-before-declarations: 1
  nesting-depth:
    - 1
    -
      max-depth: 3
  no-color-keywords: 1
  no-color-literals: 1
  no-css-comments: 1
  no-debug: 1
  no-duplicate-properties: 0
  no-empty-rulesets: 1
  no-extends: 0
  no-ids: 1
  no-important: 1
  no-invalid-hex: 1
  no-mergeable-selectors: 1
  no-misspelled-properties: 1
  no-qualifying-elements:
    - 1
    -
      allow-element-with-attribute: true
      allow-element-with-class: false
      allow-element-with-id: false
  no-trailing-zero: 1
  no-transition-all: 1
  no-url-protocols: 1
  no-vendor-prefixes: 0
  no-warn: 1
  one-declaration-per-line: 1
  placeholder-in-extend: 0
  placeholder-name-format:
    - 1
    -
      allow-leading-underscore: false
      convention: hyphenatedlowercase
  property-sort-order:
    - 1
    -
      order:
        - -webkit-rtl-ordering
        - direction
        - unicode-bidi
        - writing-mode
        - text-orientation
        - glyph-orientation-vertical
        - text-combine-upright
        - text-transform
        - white-space
        - tab-size
        - line-break
        - word-break
        - hyphens
        - word-wrap
        - overflow-wrap
        - text-align
        - text-align-last
        - text-justify
        - word-spacing
        - letter-spacing
        - text-indent
        - hanging-punctuation
        - -webkit-nbsp-mode
        - text-decoration
        - text-decoration-line
        - text-decoration-style
        - text-decoration-color
        - text-decoration-skip
        - text-underline-position
        - text-emphasis
        - text-emphasis-style
        - text-emphasis-color
        - text-emphasis-position
        - text-shadow
        - -webkit-text-fill-color
        - -webkit-text-stroke
        - -webkit-text-stroke-width
        - -webkit-text-stroke-color
        - -webkit-text-security
        - font
        - font-style
        - font-variant
        - font-weight
        - font-stretch
        - font-size
        - line-height
        - font-family
        - src
        - unicode-range
        - -webkit-text-size-adjust
        - font-size-adjust
        - font-synthesis
        - font-kerning
        - font-variant-ligatures
        - font-variant-position
        - font-variant-caps
        - font-variant-numeric
        - font-variant-alternates
        - font-variant-east-asian
        - font-feature-settings
        - font-language-override
        - list-style
        - list-style-type
        - list-style-position
        - list-style-image
        - marker-side
        - counter-set
        - counter-increment
        - caption-side
        - table-layout
        - border-collapse
        - -webkit-border-horizontal-spacing
        - -webkit-border-vertical-spacing
        - border-spacing
        - empty-cells
        - move-to
        - quotes
        - counter-increment
        - counter-reset
        - page-policy
        - content
        - crop
        - box-sizing
        - outline
        - outline-color
        - outline-style
        - outline-width
        - outline-offset
        - resize
        - text-overflow
        - cursor
        - caret-color
        - nav-up
        - nav-right
        - nav-down
        - nav-left
        - -webkit-appearance
        - -webkit-user-drag
        - -webkit-user-modify
        - -webkit-user-select
        - -moz-user-select
        - -ms-user-select
        - pointer-events
        - -webkit-dashboard-region
        - -apple-dashboard-region
        - -webkit-touch-callout
        - position
        - top
        - right
        - bottom
        - left
        - offset-before
        - offset-end
        - offset-after
        - offset-start
        - z-index
        - display
        - -webkit-margin-collapse
        - -webkit-margin-top-collapse
        - -webkit-margin-bottom-collapse
        - -webkit-margin-start
        - margin
        - margin-top
        - margin-right
        - margin-bottom
        - margin-left
        - -webkit-padding-start
        - padding
        - padding-top
        - padding-right
        - padding-bottom
        - padding-left
        - width
        - min-width
        - max-width
        - height
        - min-height
        - max-height
        - float
        - clear
        - overflow
        - overflow-x
        - overflow-y
        - -webkit-overflow-scrolling
        - overflow-style
        - marquee-style
        - marquee-loop
        - marquee-direction
        - marquee-speed
        - visibility
        - rotation
        - rotation-point
        - flex-flow
        - flex-direction
        - flex-wrap
        - order
        - flex
        - flex-grow
        - flex-shrink
        - flex-basis
        - justify-content
        - align-items
        - align-self
        - align-content
        - columns
        - column-width
        - column-count
        - column-gap
        - column-rule
        - column-rule-width
        - column-rule-style
        - column-rule-color
        - break-before
        - break-after
        - break-inside
        - column-span
        - column-fill
        - grid
        - grid-template
        - grid-template-columns
        - grid-template-rows
        - grid-template-areas
        - grid-auto-flow
        - grid-auto-columns
        - grid-auto-rows
        - grid-column
        - grid-row
        - grid-area
        - grid-row-start
        - grid-column-start
        - grid-row-end
        - grid-column-end
        - grid-gap
        - grid-column-gap
        - grid-row-gap
        - orphans
        - widows
        - box-decoration-break
        - background
        - background-image
        - background-position
        - background-size
        - background-repeat
        - background-attachment
        - background-origin
        - background-clip
        - background-color
        - border
        - border-width
        - border-style
        - border-color
        - border-top
        - border-top-width
        - border-top-style
        - border-top-color
        - border-right
        - border-right-width
        - border-right-style
        - border-right-color
        - border-bottom
        - border-bottom-width
        - border-bottom-style
        - border-bottom-color
        - border-left
        - border-left-width
        - border-left-style
        - border-left-color
        - border-radius
        - border-top-left-radius
        - border-top-right-radius
        - border-bottom-right-radius
        - border-bottom-left-radius
        - border-image
        - border-image-source
        - border-image-slice
        - border-image-width
        - border-image-outset
        - border-image-repeat
        - box-shadow
        - color
        - opacity
        - -webkit-tap-highlight-color
        - object-fit
        - object-position
        - image-resolution
        - image-orientation
        - clip-path
        - mask
        - mask-image
        - mask-mode
        - mask-repeat
        - mask-position
        - mask-clip
        - mask-origin
        - mask-size
        - mask-composite
        - mask-border
        - mask-border-source
        - mask-border-slice
        - mask-border-width
        - mask-border-outset
        - mask-border-repeat
        - mask-border-mode
        - mask-type
        - clip
        - filter
        - transition
        - transition-property
        - transition-duration
        - transition-timing-function
        - transition-delay
        - transform
        - transform-origin
        - transform-style
        - perspective
        - perspective-origin
        - backface-visibility
        - animation
        - animation-name
        - animation-duration
        - animation-timing-function
        - animation-delay
        - animation-iteration-count
        - animation-direction
        - animation-fill-mode
        - animation-play-state
        - voice-volume
        - voice-balance
        - speak
        - speak-as
        - pause
        - pause-before
        - pause-after
        - rest
        - rest-before
        - rest-after
        - cue
        - cue-before
        - cue-after
        - voice-family
        - voice-rate
        - voice-pitch
        - voice-range
        - voice-stress
        - voice-duration
        - size
        - page
        - zoom
        - min-zoom
        - max-zoom
        - user-zoom
        - orientation
  property-units: 1
  quotes:
    - 1
    -
      style: double
  shorthand-values: 1
  single-line-per-selector: 0
  space-after-bang: 1
  space-after-colon: 1
  space-after-comma: 1
  space-around-operator: 1
  space-before-bang: 1
  space-before-brace: 1
  space-before-colon: 1
  space-between-parens: 1
  trailing-semicolon: 0
  url-quotes: 1
  variable-for-property: 0
  variable-name-format:
    - 1
    -
      allow-leading-underscore: false
      convention: hyphenatedlowercase
  zero-unit: 1
EOF

1> /dev/null yarn add --dev \
  gulp-sass-lint

cat <<-EOF | patch 1> /dev/null
--- gulpfile.js
+++ gulpfile.js
@@ -46,4 +46,7 @@
 const task = {
   "lint": {
+    "sass": plug.lazypipe()
+      .pipe(plug.sassLint)
+      .pipe(plug.sassLint.format),
     "slim": function () {
       return plug.flatmap(function (stream, file) {
@@ -84,4 +87,5 @@
       .pipe(task.tidy.lines)
       .pipe(task.tidy.sass)
+      .pipe(task.lint.sass)
   },
   "slim": function () {
EOF

cat > "${CWD}/.caniuse.json" <<-EOF
{
  "dataByBrowser": {
    "and_chr": {
      "55": 0.94975
    },
    "and_ff": {
      "50": 0
    },
    "and_uc": {
      "11": 0
    },
    "android": {
      "3": 0,
      "4": 0,
      "53": 0,
      "2.1": 0,
      "2.2": 0,
      "2.3": 0,
      "4.1": 0,
      "4.2-4.3": 0,
      "4.4": 0,
      "4.4.3-4.4.4": 0
    },
    "bb": {
      "7": 0,
      "10": 0
    },
    "chrome": {
      "4": 0,
      "5": 0,
      "6": 0,
      "7": 0,
      "8": 0,
      "9": 0,
      "10": 0,
      "11": 0,
      "12": 0,
      "13": 0,
      "14": 0,
      "15": 0,
      "16": 0,
      "17": 0,
      "18": 0,
      "19": 0,
      "20": 0,
      "21": 0,
      "22": 0,
      "23": 0,
      "24": 0.03063,
      "25": 0,
      "26": 0,
      "27": 0.03063,
      "28": 0,
      "29": 0,
      "30": 0.09191,
      "31": 0.18382,
      "32": 0.73529,
      "33": 0,
      "34": 0.09191,
      "35": 0.12254,
      "36": 0.49019,
      "37": 0,
      "38": 0,
      "39": 0.06127,
      "40": 1.5625,
      "41": 0.03063,
      "42": 0.21446,
      "43": 0.09191,
      "44": 0.03063,
      "45": 0.24509,
      "46": 0.09191,
      "47": 0.82720,
      "48": 0.24509,
      "49": 0.73529,
      "50": 1.43995,
      "51": 19.27083,
      "52": 13.32720,
      "53": 15.56372,
      "54": 19.57720,
      "55": 3.33946,
      "56": 0.24509,
      "57": 0.03063,
      "58": 0
    },
    "edge": {
      "12": 0,
      "13": 0.30637,
      "14": 0.24509,
      "15": 0.03063
    },
    "firefox": {
      "2": 0,
      "3": 0,
      "4": 0,
      "5": 0,
      "6": 0.12254,
      "7": 0,
      "8": 0,
      "9": 0,
      "10": 0,
      "11": 0,
      "12": 0,
      "13": 0,
      "14": 0,
      "15": 0,
      "16": 0,
      "17": 0,
      "18": 0,
      "19": 0,
      "20": 0,
      "21": 0.06127,
      "22": 0,
      "23": 0,
      "24": 0,
      "25": 0.09191,
      "26": 0,
      "27": 0,
      "28": 0.06127,
      "29": 0.09191,
      "30": 0,
      "31": 0,
      "32": 0,
      "33": 0,
      "34": 0.03063,
      "35": 0,
      "36": 0.03063,
      "37": 0,
      "38": 0.09191,
      "39": 0,
      "40": 0,
      "41": 0,
      "42": 0.24509,
      "43": 0.30637,
      "44": 0.06127,
      "45": 0.21446,
      "46": 0.06127,
      "47": 3.43137,
      "48": 2.11397,
      "49": 2.69607,
      "50": 1.37867,
      "51": 0.33700,
      "52": 0.15318,
      "53": 0,
      "3.5": 0,
      "3.6": 0
    },
    "ie": {
      "6": 0.09191,
      "7": 0,
      "8": 0.03063,
      "9": 0.06127,
      "10": 0.06127,
      "11": 0.58210
    },
    "ie_mob": {
      "10": 0,
      "11": 0
    },
    "ios_saf": {
      "8": 0.45955,
      "10-10.1": 0.73529,
      "3.2": 0,
      "4.0-4.1": 0,
      "4.2-4.3": 0,
      "5.0-5.1": 0.06127,
      "6.0-6.1": 0.06127,
      "7.0-7.1": 0.12254,
      "8.1-8.4": 0,
      "9.0-9.2": 0.03063,
      "9.3": 0.73529
    },
    "op_mini": {
      "all": 0
    },
    "op_mob": {
      "12": 0,
      "37": 0,
      "12.1": 0
    },
    "opera": {
      "15": 0,
      "16": 0,
      "17": 0,
      "18": 0,
      "19": 0,
      "20": 0,
      "21": 0,
      "22": 0,
      "23": 0,
      "24": 0,
      "25": 0,
      "26": 0,
      "27": 0,
      "28": 0,
      "29": 0,
      "30": 0,
      "31": 0,
      "32": 0,
      "33": 0,
      "34": 0,
      "35": 0,
      "36": 0,
      "37": 0,
      "38": 0.30637,
      "39": 0.12254,
      "40": 0,
      "41": 0.09191,
      "42": 0,
      "43": 0,
      "44": 0,
      "10.0-10.1": 0,
      "11.5": 0,
      "12.1": 0.09191
    },
    "safari": {
      "4": 0,
      "5": 0.03063,
      "6": 0,
      "7": 0.09191,
      "8": 0.03063,
      "9": 0.12254,
      "10": 1.31740,
      "3.1": 0,
      "3.2": 0,
      "5.1": 0.09191,
      "6.1": 0,
      "7.1": 0,
      "9.1": 1.25612,
      "TP": 0
    },
    "samsung": {
      "4": 0
    }
  },
  "id": "71568934|undefined",
  "meta": {
    "end_date": "2016-12-20",
    "start_date": "2016-06-20"
  },
  "name": "ptb2.me",
  "source": "google_analytics",
  "type": "custom",
  "uid": "custom.71568934|undefined"
}
EOF

1> /dev/null yarn add --dev \
  browserslist \
  gulp-autoprefixer \
  gulp-sass

cat <<-EOF | patch 1> /dev/null
--- gulpfile.js
+++ gulpfile.js
@@ -22,4 +22,11 @@
 const opts = new function () {
   return {
+    "autoprefixer": {
+      "browsers": plug.browserslist([">0.25% in my stats"], {
+        "stats": ".caniuse.json"
+      }),
+      "cascade": false,
+      "remove": true
+    },
     "changedInPlace": {
       "firstPass": true
@@ -36,4 +43,7 @@
         "yarn.lock"]
     },
+    "sass": {
+      "outputStyle": MIN ? "compressed" : "expanded"
+    },
     "trimlines": {
       "leading": false
@@ -45,4 +55,9 @@

 const task = {
+  "compile": {
+    "sass": plug.lazypipe()
+      .pipe(plug.sass, opts.sass)
+      .pipe(plug.autoprefixer, opts.autoprefixer)
+  },
   "lint": {
     "sass": plug.lazypipe()
@@ -119,4 +134,5 @@
       .pipe(pipe.sass()())
       .pipe(task.save.src())
+      .pipe(task.compile.sass())
     done()
   }
EOF

1> /dev/null yarn add --dev \
  gulp-cssbeautify \

cat <<-EOF | patch 1> /dev/null
--- gulpfile.js
+++ gulpfile.js
@@ -32,4 +32,8 @@
       "firstPass": true
     },
+    "cssbeautify": {
+      "autosemicolon": true,
+      "indent": "  "
+    },
     "ext": {
       "sass": "*.s@(a|c)ss",
@@ -86,4 +90,7 @@
   },
   "tidy": {
+    "css": function () {
+      return plug.gulpIf(!MIN, plug.cssbeautify(opts.cssbeautify))
+    },
     "lines": function () {
       return plug.trimlines(opts.trimlines)
@@ -98,4 +105,8 @@

 const pipe = {
+  "css": function () {
+    return plug.lazypipe()
+      .pipe(task.tidy.css)
+  },
   "sass": function () {
     return plug.lazypipe()
@@ -135,4 +146,5 @@
       .pipe(task.save.src())
       .pipe(task.compile.sass())
+      .pipe(pipe.css()())
     done()
   }
EOF

1> /dev/null yarn add --dev \
  gulp-csslint

cat <<-EOF | patch 1> /dev/null
--- gulpfile.js
+++ gulpfile.js
@@ -36,4 +36,38 @@
       "indent": "  "
     },
+    "csslint": {
+      "adjoining-classes": false,
+      "box-model": true,
+      "box-sizing": false,
+      "bulletproof-font-face": true,
+      "compatible-vendor-prefixes": false,
+      "display-property-grouping": true,
+      "duplicate-background-images": true,
+      "duplicate-properties": true,
+      "empty-rules": true,
+      "fallback-colors": true,
+      "floats": true,
+      "font-faces": true,
+      "font-sizes": true,
+      "gradients": true,
+      "ids": true,
+      "import": true,
+      "important": true,
+      "known-properties": true,
+      "order-alphabetical": false,
+      "outline-none": true,
+      "overqualified-elements": true,
+      "qualified-headings": true,
+      "regex-selectors": true,
+      "shorthand": true,
+      "star-property-hack": true,
+      "text-indent": true,
+      "underscore-property-hack": true,
+      "unique-headings": true,
+      "universal-selector": true,
+      "unqualified-attributes": true,
+      "vendor-prefix": true,
+      "zero-units": true
+    },
     "ext": {
       "sass": "*.s@(a|c)ss",
@@ -65,4 +99,7 @@
   },
   "lint": {
+    "css": plug.lazypipe()
+      .pipe(plug.csslint, opts.csslint)
+      .pipe(plug.csslint.formatter, "compact"),
     "sass": plug.lazypipe()
       .pipe(plug.sassLint)
@@ -108,4 +145,5 @@
     return plug.lazypipe()
       .pipe(task.tidy.css)
+      .pipe(task.lint.css)
   },
   "sass": function () {
EOF

cat <<-EOF | patch 1> /dev/null
--- gulpfile.js
+++ gulpfile.js
@@ -71,4 +71,5 @@
     },
     "ext": {
+      "es6": "*.@(e|j)s?(6|x)",
       "sass": "*.s@(a|c)ss",
       "slim": "*.sl?(i)m"
@@ -147,4 +148,8 @@
       .pipe(task.lint.css)
   },
+  "es6": function () {
+    return plug.lazypipe()
+      .pipe(task.tidy.lines)
+  },
   "sass": function () {
     return plug.lazypipe()
@@ -186,4 +191,13 @@
       .pipe(pipe.css()())
     done()
+  },
+  function es6 (done) {
+    gulp.src(path.join(opts.path.src, opts.ext.es6), {
+      "since": gulp.lastRun("check")
+    })
+      .pipe(plug.changedInPlace(opts.changedInPlace))
+      .pipe(pipe.es6()())
+      .pipe(task.save.src())
+    done()
   }
 ))
EOF

1> /dev/null yarn add --dev \
  gulp-jsbeautifier

cat <<-EOF | patch 1> /dev/null
--- gulpfile.js
+++ gulpfile.js
@@ -75,4 +75,22 @@
       "slim": "*.sl?(i)m"
     },
+    "jsbeautifier": {
+      "js": {
+        "file_types": [
+          ".es6",
+          ".js",
+          ".json"
+        ],
+        "break_chained_methods": true,
+        "end_with_newline": true,
+        "indent_size": 2,
+        "jslint_happy": true,
+        "keep_array_indentation": true,
+        "keep_function_indentation": true,
+        "max_preserve_newlines": 2,
+        "space_after_anon_function": true,
+        "wrap_line_length": 78
+      }
+    },
     "path": {
       "src": path.join(SRC, "**")
@@ -131,4 +149,11 @@
       return plug.gulpIf(!MIN, plug.cssbeautify(opts.cssbeautify))
     },
+    "es6": plug.lazypipe()
+      .pipe(function () {
+        return plug.gulpIf(!MIN, plug.jsbeautifier(opts.jsbeautifier))
+      })
+      .pipe(function () {
+        return plug.gulpIf(!MIN, plug.jsbeautifier.reporter())
+      }),
     "lines": function () {
       return plug.trimlines(opts.trimlines)
@@ -151,4 +176,5 @@
     return plug.lazypipe()
       .pipe(task.tidy.lines)
+      .pipe(task.tidy.es6)
   },
   "sass": function () {
EOF

cat > "${CWD}/.eslintignore" <<-EOF
!.eslintrc.js
!*.json
*.min.js
/docs/**/*.js
EOF

cat > "${CWD}/.eslintrc.js" <<-EOF
const INDENT_SIZE = 2

module.exports = {
  "env": {
    "amd": true,
    "browser": true,
    "commonjs": true,
    "es6": true,
    "mocha": true,
    "node": true,
    "shared-node-browser": true
  },
  "globals": {
    "document": false,
    "navigator": false,
    "window": false
  },
  "parserOptions": {
    "ecmaFeatures": {
      "experimentalObjectRestSpread": true,
      "jsx": false
    },
    "ecmaVersion": 6,
    "sourceType": "module"
  },
  "plugins": [
    "json",
    "promise",
    "standard"
  ],
  "rules": {
    "accessor-pairs": "error",
    "array-bracket-spacing": [
      "error",
      "never"
    ],
    "array-callback-return": "error",
    "arrow-body-style": [
      "error",
      "as-needed"
    ],
    "arrow-parens": [
      "error",
      "always"
    ],
    "arrow-spacing": [
      "error",
      {
        "after": true,
        "before": true
      }
    ],
    "block-scoped-var": "error",
    "block-spacing": [
      "error",
      "always"
    ],
    "brace-style": [
      "error",
      "1tbs",
      {
        "allowSingleLine": true
      }
    ],
    "callback-return": "error",
    "camelcase": [
      "error",
      {
        "properties": "always"
      }
    ],
    "comma-dangle": [
      "error",
      "never"
    ],
    "comma-spacing": [
      "error",
      {
        "after": true,
        "before": false
      }
    ],
    "comma-style": [
      "error",
      "last"
    ],
    "complexity": "off",
    "computed-property-spacing": [
      "error",
      "never"
    ],
    "consistent-return": "error",
    "consistent-this": [
      "warn",
      "self"
    ],
    "constructor-super": "error",
    "curly": [
      "error",
      "all"
    ],
    "default-case": "error",
    "dot-location": [
      "error",
      "property"
    ],
    "dot-notation": [
      "error",
      {
        "allowKeywords": false
      }
    ],
    "eol-last": [
      "error",
      "unix"
    ],
    "eqeqeq": [
      "error",
      "smart"
    ],
    "func-names": "off",
    "func-style": [
      "error",
      "expression"
    ],
    "generator-star-spacing": [
      "error",
      {
        "after": true,
        "before": true
      }
    ],
    "global-require": "error",
    "guard-for-in": "error",
    "handle-callback-err": [
      "error",
      "^(err|error)$"
    ],
    "id-blacklist": "off",
    "id-length": "off",
    "id-match": "off",
    "indent": [
      "error",
      INDENT_SIZE,
      {
        "SwitchCase": 1,
        "VariableDeclarator": 1
      }
    ],
    "init-declarations": "off",
    "jsx-quotes": [
      "error",
      "prefer-double"
    ],
    "key-spacing": [
      "error",
      {
        "afterColon": true,
        "beforeColon": false,
        "mode": "strict"
      }
    ],
    "keyword-spacing": [
      "error",
      {
        "after": true,
        "before": true
      }
    ],
    "linebreak-style": [
      "error",
      "unix"
    ],
    "lines-around-comment": [
      "error",
      {
        "afterBlockComment": false,
        "afterLineComment": false,
        "allowArrayEnd": true,
        "allowArrayStart": true,
        "allowBlockEnd": true,
        "allowBlockStart": true,
        "allowObjectEnd": true,
        "allowObjectStart": true,
        "beforeBlockComment": true,
        "beforeLineComment": true
      }
    ],
    "max-depth": "off",
    "max-len": [
      "warn",
      {
        "code": 78,
        "ignoreUrls": true
      }
    ],
    "max-nested-callbacks": "off",
    "max-params": "off",
    "max-statements": [
      "warn",
      {
        "max": 10
      }
    ],
    "max-statements-per-line": [
      "error",
      {
        "max": 1
      }
    ],
    "new-cap": [
      "error",
      {
        "capIsNew": true,
        "newIsCap": true
      }
    ],
    "new-parens": "error",
    "newline-after-var": [
      "error",
      "always"
    ],
    "newline-before-return": "off",
    "newline-per-chained-call": "error",
    "no-alert": "error",
    "no-array-constructor": "error",
    "no-bitwise": "error",
    "no-caller": "error",
    "no-case-declarations": "error",
    "no-catch-shadow": "off",
    "no-class-assign": "error",
    "no-cond-assign": "error",
    "no-confusing-arrow": [
      "error",
      {
        "allowParens": true
      }
    ],
    "no-console": "warn",
    "no-const-assign": "error",
    "no-constant-condition": "error",
    "no-continue": "error",
    "no-control-regex": "error",
    "no-debugger": "error",
    "no-delete-var": "error",
    "no-div-regex": "error",
    "no-dupe-args": "error",
    "no-dupe-class-members": "error",
    "no-dupe-keys": "error",
    "no-duplicate-case": "error",
    "no-duplicate-imports": [
      "error",
      {
        "includeExports": true
      }
    ],
    "no-else-return": "error",
    "no-empty": [
      "error",
      {
        "allowEmptyCatch": true
      }
    ],
    "no-empty-character-class": "error",
    "no-empty-function": "warn",
    "no-empty-pattern": "error",
    "no-eq-null": "error",
    "no-eval": "error",
    "no-ex-assign": "error",
    "no-extend-native": "error",
    "no-extra-bind": "error",
    "no-extra-boolean-cast": "error",
    "no-extra-label": "error",
    "no-extra-parens": [
      "error",
      "all",
      {
        "returnAssign": false
      }
    ],
    "no-extra-semi": "error",
    "no-fallthrough": "error",
    "no-floating-decimal": "error",
    "no-func-assign": "error",
    "no-implicit-coercion": "error",
    "no-implicit-globals": "error",
    "no-implied-eval": "error",
    "no-inline-comments": "error",
    "no-inner-declarations": [
      "error",
      "both"
    ],
    "no-invalid-regexp": "error",
    "no-invalid-this": "error",
    "no-irregular-whitespace": "error",
    "no-iterator": "error",
    "no-label-var": "error",
    "no-labels": [
      "error",
      {
        "allowLoop": false,
        "allowSwitch": false
      }
    ],
    "no-lone-blocks": "error",
    "no-lonely-if": "error",
    "no-loop-func": "error",
    "no-magic-numbers": [
      "warn",
      {
        "enforceConst": true,
        "ignoreArrayIndexes": true
      }
    ],
    "no-mixed-requires": [
      "error",
      {
        "allowCall": true,
        "grouping": true
      }
    ],
    "no-mixed-spaces-and-tabs": "error",
    "no-multi-spaces": "error",
    "no-multi-str": "error",
    "no-multiple-empty-lines": [
      "error",
      {
        "max": 1
      }
    ],
    "no-native-reassign": "error",
    "no-negated-condition": "error",
    "no-negated-in-lhs": "error",
    "no-nested-ternary": "error",
    "no-new": "error",
    "no-new-func": "error",
    "no-new-object": "error",
    "no-new-require": "error",
    "no-new-symbol": "error",
    "no-new-wrappers": "error",
    "no-obj-calls": "error",
    "no-octal": "error",
    "no-octal-escape": "error",
    "no-param-reassign": "error",
    "no-path-concat": "error",
    "no-plusplus": [
      "error",
      {
        "allowForLoopAfterthoughts": true
      }
    ],
    "no-process-env": "error",
    "no-process-exit": "error",
    "no-proto": "error",
    "no-redeclare": [
      "error",
      {
        "builtinGlobals": true
      }
    ],
    "no-regex-spaces": "error",
    "no-restricted-globals": "off",
    "no-restricted-imports": "off",
    "no-restricted-modules": "off",
    "no-restricted-syntax": "off",
    "no-return-assign": [
      "error",
      "always"
    ],
    "no-script-url": "error",
    "no-self-assign": "warn",
    "no-self-compare": "error",
    "no-sequences": "error",
    "no-shadow": [
      "error",
      {
        "builtinGlobals": true,
        "hoist": "all"
      }
    ],
    "no-shadow-restricted-names": "error",
    "no-spaced-func": "error",
    "no-sparse-arrays": "error",
    "no-sync": "off",
    "no-ternary": "off",
    "no-this-before-super": "error",
    "no-throw-literal": "error",
    "no-trailing-spaces": "error",
    "no-undef": "error",
    "no-undef-init": "error",
    "no-undefined": "error",
    "no-underscore-dangle": "off",
    "no-unexpected-multiline": "error",
    "no-unmodified-loop-condition": "error",
    "no-unneeded-ternary": [
      "error",
      {
        "defaultAssignment": false
      }
    ],
    "no-unreachable": "error",
    "no-unsafe-finally": "error",
    "no-unused-expressions": [
      "error",
      {
        "allowShortCircuit": true,
        "allowTernary": true
      }
    ],
    "no-unused-labels": "error",
    "no-unused-vars": [
      "error",
      {
        "args": "all",
        "argsIgnorePattern": "^_",
        "vars": "all"
      }
    ],
    "no-use-before-define": "error",
    "no-useless-call": "error",
    "no-useless-computed-key": "error",
    "no-useless-concat": "error",
    "no-useless-constructor": "error",
    "no-useless-escape": "error",
    "no-var": "off",
    "no-void": "error",
    "no-warning-comments": "warn",
    "no-whitespace-before-property": "error",
    "no-with": "error",
    "object-curly-spacing": [
      "error",
      "always",
      {
        "arraysInObjects": true,
        "objectsInObjects": true
      }
    ],
    "object-property-newline": "off",
    "object-shorthand": [
      "error",
      "always",
      {
        "avoidQuotes": true
      }
    ],
    "one-var": [
      "error",
      {
        "initialized": "never",
        "uninitialized": "always"
      }
    ],
    "one-var-declaration-per-line": "off",
    "operator-assignment": [
      "error",
      "always"
    ],
    "operator-linebreak": [
      "error",
      "after",
      {
        "overrides": {
          ":": "before",
          "?": "before"
        }
      }
    ],
    "padded-blocks": [
      "error",
      "never"
    ],
    "prefer-arrow-callback": "off",
    "prefer-const": "warn",
    "prefer-reflect": "off",
    "prefer-rest-params": "warn",
    "prefer-spread": "warn",
    "prefer-template": "error",
    "promise/param-names": "error",
    "quote-props": [
      "error",
      "always"
    ],
    "quotes": [
      "error",
      "double",
      {
        "allowTemplateLiterals": true,
        "avoidEscape": true
      }
    ],
    "radix": [
      "error",
      "always"
    ],
    "require-jsdoc": "warn",
    "require-yield": "off",
    "semi": [
      "error",
      "never"
    ],
    "semi-spacing": [
      "error",
      {
        "after": true,
        "before": false
      }
    ],
    "sort-imports": "error",
    "sort-vars": [
      "warn",
      {
        "ignoreCase": true
      }
    ],
    "space-before-blocks": [
      "error",
      "always"
    ],
    "space-before-function-paren": [
      "error",
      "always"
    ],
    "space-in-parens": [
      "error",
      "never"
    ],
    "space-infix-ops": "error",
    "space-unary-ops": [
      "error",
      {
        "nonwords": false,
        "words": true
      }
    ],
    "spaced-comment": [
      "error",
      "always",
      {
        "markers": [
          "global",
          "globals",
          "eslint",
          "eslint-disable",
          "*package",
          "!",
          ","
        ]
      }
    ],
    "standard/array-bracket-even-spacing": [
      "error",
      "either"
    ],
    "standard/computed-property-even-spacing": [
      "error",
      "even"
    ],
    "standard/object-curly-even-spacing": [
      "error",
      "either"
    ],
    "strict": [
      "error",
      "safe"
    ],
    "template-curly-spacing": [
      "error",
      "never"
    ],
    "use-isnan": "error",
    "valid-jsdoc": "warn",
    "valid-typeof": "error",
    "vars-on-top": "error",
    "wrap-iife": [
      "error",
      "any"
    ],
    "wrap-regex": "error",
    "yield-star-spacing": [
      "error",
      "both"
    ],
    "yoda": [
      "error",
      "never"
    ]
  }
}
EOF

1> /dev/null yarn add --dev \
  eslint \
  eslint-plugin-json \
  eslint-plugin-promise \
  gulp-eslint
1> /dev/null yarn add --dev \
  eslint-plugin-standard

cat <<-EOF | patch 1> /dev/null
--- gulpfile.js
+++ gulpfile.js
@@ -6,4 +6,5 @@
   "pattern": "*",
   "rename": {
+    "eslint": "Eslint",
     "gulp-if": "gulpIf"
   }
@@ -70,4 +71,7 @@
       "zero-units": true
     },
+    "eslint": {
+      "fix": true
+    },
     "ext": {
       "es6": "*.@(e|j)s?(6|x)",
@@ -121,4 +125,7 @@
       .pipe(plug.csslint, opts.csslint)
       .pipe(plug.csslint.formatter, "compact"),
+    "es6": plug.lazypipe()
+      .pipe(plug.eslint, opts.eslint)
+      .pipe(plug.eslint.format),
     "sass": plug.lazypipe()
       .pipe(plug.sassLint)
@@ -177,4 +184,5 @@
       .pipe(task.tidy.lines)
       .pipe(task.tidy.es6)
+      .pipe(task.lint.es6)
   },
   "sass": function () {
EOF

cat <<-EOF | patch 1> /dev/null
--- gulpfile.js
+++ gulpfile.js
@@ -71,4 +71,5 @@
       "zero-units": true
     },
+    "env": MIN ? "production" : "development",
     "eslint": {
       "fix": true
@@ -116,4 +117,10 @@

 const task = {
+  "build": function (done) {
+    proc.execSync(\`bundle exec middleman build -e \${opts.env}\`, {
+      "stdio": "inherit"
+    })
+    done()
+  },
   "compile": {
     "sass": plug.lazypipe()
@@ -239,5 +246,5 @@
 gulp.task("default", gulp.series("check", function watch (done) {
   gulp.watch(opts.restart.files, task.restart)
-  gulp.watch(opts.path.src, gulp.series("check"))
+  gulp.watch(opts.path.src, gulp.series("check", task.build))
   done()
 }))
EOF

1> /dev/null yarn add --dev \
  ptb/browser-sync

cat <<-EOF | patch 1> /dev/null
--- gulpfile.js
+++ gulpfile.js
@@ -16,5 +16,7 @@
 const CWD = process.cwd()
 const SRC = path.join(CWD, "src")
+const OUT = path.join(CWD, "docs")
 
+const EXT = "xhtml"
 const MIN = typeof plug.util.env.min != "undefined"
 
@@ -30,4 +32,26 @@
       "remove": true
     },
+    "browserSync": {
+      "files": path.join(OUT, "**", "*"),
+      "https": {
+        "cert": "localhost.crt",
+        "key": "localhost.key"
+      },
+      "logConnections": true,
+      "notify": false,
+      "open": false,
+      "reloadDebounce": 100,
+      "reloadOnRestart": true,
+      "server": {
+        "baseDir": OUT,
+        "index": \`index.\${EXT}\`
+      },
+      "snippetOptions": {
+        "rule": {
+          "match": /qqq/
+        }
+      },
+      "ui": false
+    },
     "changedInPlace": {
       "firstPass": true
@@ -245,6 +269,8 @@
 
 gulp.task("default", gulp.series("check", function watch (done) {
-  gulp.watch(opts.restart.files, task.restart)
-  gulp.watch(opts.path.src, gulp.series("check", task.build))
-  done()
+  plug.browserSync.init(opts.browserSync, function () {
+    gulp.watch(opts.restart.files, task.restart)
+    gulp.watch(opts.path.src, gulp.series("check", task.build))
+    done()
+  })
 }))
EOF

cat <<-EOF | patch 1> /dev/null
--- gulpfile.js
+++ gulpfile.js
@@ -183,4 +183,10 @@
     }
   },
+  "tail": {
+    "log": function () {
+      proc.exec(\`tail -f -n0 "\${path.join(CWD, "logs", "access.log")}"\`)
+        .stdout.pipe(process.stdout)
+    }
+  },
   "tidy": {
     "css": function () {
@@ -272,4 +278,5 @@
     gulp.watch(opts.restart.files, task.restart)
     gulp.watch(opts.path.src, gulp.series("check", task.build))
+    task.tail.log()
     done()
   })
EOF

1> /dev/null yarn add --dev \
  del

cat <<-EOF | patch 1> /dev/null
--- gulpfile.js
+++ gulpfile.js
@@ -16,4 +16,5 @@
 const CWD = process.cwd()
 const SRC = path.join(CWD, "src")
+const TMP = path.join(CWD, ".tmp")
 const OUT = path.join(CWD, "docs")
 
@@ -238,7 +239,10 @@
 // -- gulp ------------------------------------------------------------------
 
-gulp.task("build", function build (done) {
-  done()
-})
+gulp.task("build", gulp.series(
+  function del (done) {
+    plug.del.sync(path.join(TMP, "*"))
+    done()
+  }
+))
 
 gulp.task("check", gulp.series(
EOF

1> /dev/null yarn add --dev \
  streamqueue

cat <<-EOF | patch 1> /dev/null
--- gulpfile.js
+++ gulpfile.js
@@ -1,4 +1,5 @@
 // -- require ---------------------------------------------------------------
 
+const fs = require("fs")
 const gulp = require("gulp")
 const path = require("path")
@@ -102,4 +103,5 @@
     "ext": {
       "es6": "*.@(e|j)s?(6|x)",
+      "riot": /\.tag$/,
       "sass": "*.s@(a|c)ss",
       "slim": "*.sl?(i)m"
@@ -153,4 +155,22 @@
       .pipe(plug.autoprefixer, opts.autoprefixer)
   },
+  "each": {
+    "folder": function (a, b, c) {
+      const d = function (e, f, g) {
+        return fs.readdirSync(f)
+          .reduce(function (h, i) {
+            const j = [path.join(f, i), e, path.relative(e, f), i]
+
+            if (fs.statSync(j[0])
+              .isDirectory()) {
+              return h.concat(g.test(i) ? [j] : [], d(e, j[0], g))
+            }
+            return h
+          }, [])
+      }
+
+      return d(a, b, c)
+    }
+  },
   "lint": {
     "css": plug.lazypipe()
@@ -243,4 +263,15 @@
     plug.del.sync(path.join(TMP, "*"))
     done()
+  },
+  function riot (done) {
+    return task.each.folder(SRC, SRC, opts.ext.riot)
+      .map(function () {
+        return plug.streamqueue({
+          "objectMode": true
+        })
+          .on("end", function () {
+            done()
+          })
+      })
   }
 ))
EOF

1> /dev/null yarn add --dev \
  gulp-slim

cat <<-EOF | patch 1> /dev/null
--- gulpfile.js
+++ gulpfile.js
@@ -135,4 +135,14 @@
       "outputStyle": MIN ? "compressed" : "expanded"
     },
+    "slim": {
+      "chdir": true,
+      "options": ["attr_quote='\"'", \`format=:\${EXT}\`, "shortcut={ " +
+        "'@' => { attr: 'role' }, '#' => { attr: 'id' }, " +
+        "'.' => { attr: 'class' }, '%' => { attr: 'itemprop' }, " +
+        "'^' => { attr: 'data-is' }, '&' => { attr: 'type', tag: 'input' } }",
+        "sort_attrs=true"],
+      "pretty": !MIN,
+      "require": "slim/include"
+    },
     "trimlines": {
       "leading": false
@@ -153,5 +163,8 @@
     "sass": plug.lazypipe()
       .pipe(plug.sass, opts.sass)
-      .pipe(plug.autoprefixer, opts.autoprefixer)
+      .pipe(plug.autoprefixer, opts.autoprefixer),
+    "slim": function () {
+      return plug.slim(opts.slim)
+    }
   },
   "each": {
@@ -266,8 +279,11 @@
   function riot (done) {
     return task.each.folder(SRC, SRC, opts.ext.riot)
-      .map(function () {
+      .map(function (dir) {
         return plug.streamqueue({
           "objectMode": true
-        })
+        },
+            gulp.src(path.join(dir[0], opts.ext.slim))
+            .pipe(task.compile.slim())
+          )
           .on("end", function () {
             done()
EOF

1> /dev/null yarn add --dev \
  gulp-rename

cat <<-EOF | patch 1> /dev/null
--- gulpfile.js
+++ gulpfile.js
@@ -128,4 +128,9 @@
       "src": path.join(SRC, "**")
     },
+    "rename": {
+      "html": {
+        "extname": \`.\${EXT}\`
+      }
+    },
     "restart": {
       "files": ["config.rb", "Gemfile.lock", "gulpfile.js", "package.json",
@@ -205,4 +210,9 @@
     }
   },
+  "rename": {
+    "html": function () {
+      return plug.rename(opts.rename.html)
+    }
+  },
   "restart": function () {
     if (process.platform === "darwin") {
@@ -215,4 +225,7 @@
     "src": function () {
       return plug.gulpIf(!MIN, gulp.dest(SRC))
+    },
+    "tmp": function () {
+      return gulp.dest(TMP)
     }
   },
@@ -257,4 +270,8 @@
       .pipe(task.lint.es6)
   },
+  "html": function () {
+    return plug.lazypipe()
+      .pipe(task.rename.html)
+  },
   "sass": function () {
     return plug.lazypipe()
@@ -285,5 +302,7 @@
             gulp.src(path.join(dir[0], opts.ext.slim))
             .pipe(task.compile.slim())
+            .pipe(pipe.html()())
           )
+          .pipe(task.save.tmp())
           .on("end", function () {
             done()
EOF

1> /dev/null yarn add --dev \
  gulp-htmltidy

cat <<-EOF | patch 1> /dev/null
--- gulpfile.js
+++ gulpfile.js
@@ -107,4 +107,17 @@
       "slim": "*.sl?(i)m"
     },
+    "htmltidy": {
+      "doctype": "html5",
+      "indent": true,
+      "indent-spaces": 2,
+      "input-xml": true,
+      "logical-emphasis": true,
+      "new-blocklevel-tags": "",
+      "output-xhtml": true,
+      "quiet": true,
+      "sort-attributes": "alpha",
+      "tidy-mark": false,
+      "wrap": 78
+    },
     "jsbeautifier": {
       "js": {
@@ -247,4 +260,7 @@
         return plug.gulpIf(!MIN, plug.jsbeautifier.reporter())
       }),
+    "html": function () {
+      return plug.gulpIf(!MIN, plug.htmltidy(opts.htmltidy))
+    },
     "lines": function () {
       return plug.trimlines(opts.trimlines)
@@ -273,4 +289,5 @@
     return plug.lazypipe()
       .pipe(task.rename.html)
+      .pipe(task.tidy.html)
   },
   "sass": function () {
EOF

1> /dev/null yarn add --dev \
  gulp-w3cjs

cat <<-EOF | patch 1> /dev/null
--- gulpfile.js
+++ gulpfile.js
@@ -211,4 +211,7 @@
       .pipe(plug.eslint, opts.eslint)
       .pipe(plug.eslint.format),
+    "html": function (lint) {
+      return plug.gulpIf(lint, plug.w3cjs())
+    },
     "sass": plug.lazypipe()
       .pipe(plug.sassLint)
@@ -286,8 +289,9 @@
       .pipe(task.lint.es6)
   },
-  "html": function () {
+  "html": function (tag) {
     return plug.lazypipe()
       .pipe(task.rename.html)
       .pipe(task.tidy.html)
+      .pipe(task.lint.html, !tag)
   },
   "sass": function () {
@@ -319,5 +323,5 @@
             gulp.src(path.join(dir[0], opts.ext.slim))
             .pipe(task.compile.slim())
-            .pipe(pipe.html()())
+            .pipe(pipe.html(true)())
           )
           .pipe(task.save.tmp())
EOF

1> /dev/null yarn add --dev \
  gulp-htmlmin

cat <<-EOF | patch 1> /dev/null
--- gulpfile.js
+++ gulpfile.js
@@ -107,4 +107,13 @@
       "slim": "*.sl?(i)m"
     },
+    "htmlmin": {
+      "collapseWhitespace": MIN,
+      "keepClosingSlash": true,
+      "minifyURLs": true,
+      "removeComments": true,
+      "removeScriptTypeAttributes": true,
+      "removeStyleLinkTypeAttributes": true,
+      "useShortDoctype": true
+    },
     "htmltidy": {
       "doctype": "html5",
@@ -226,4 +235,9 @@
     }
   },
+  "minify": {
+    "html": function () {
+      return plug.htmlmin(opts.htmlmin)
+    }
+  },
   "rename": {
     "html": function () {
@@ -294,4 +308,5 @@
       .pipe(task.tidy.html)
       .pipe(task.lint.html, !tag)
+      .pipe(task.minify.html)
   },
   "sass": function () {
EOF

1> /dev/null yarn add --dev \
  gulp-indent

cat <<-EOF | patch 1> /dev/null
--- gulpfile.js
+++ gulpfile.js
@@ -213,4 +213,7 @@
     }
   },
+  "indent": function (tag) {
+    return plug.gulpIf(tag, plug.indent())
+  },
   "lint": {
     "css": plug.lazypipe()
@@ -309,4 +312,5 @@
       .pipe(task.lint.html, !tag)
       .pipe(task.minify.html)
+      .pipe(task.indent, tag)
   },
   "sass": function () {
EOF

cat <<-EOF | patch 1> /dev/null
--- gulpfile.js
+++ gulpfile.js
@@ -105,5 +105,6 @@
       "riot": /\.tag$/,
       "sass": "*.s@(a|c)ss",
-      "slim": "*.sl?(i)m"
+      "slim": "*.sl?(i)m",
+      "svg": "*.svg"
     },
     "htmlmin": {
@@ -324,4 +325,8 @@
       .pipe(task.tidy.lines)
       .pipe(task.lint.slim)
+  },
+  "svg": function () {
+    return plug.lazypipe()
+      .pipe(task.tidy.html)
   }
 }
@@ -342,5 +347,7 @@
             gulp.src(path.join(dir[0], opts.ext.slim))
             .pipe(task.compile.slim())
-            .pipe(pipe.html(true)())
+            .pipe(pipe.html(true)()),
+            gulp.src(path.join(dir[0], opts.ext.svg))
+            .pipe(pipe.svg()())
           )
           .pipe(task.save.tmp())
EOF

1> /dev/null yarn add --dev \
  gulp-svgmin

cat <<-EOF | patch 1> /dev/null
--- gulpfile.js
+++ gulpfile.js
@@ -242,4 +242,7 @@
     "html": function () {
       return plug.htmlmin(opts.htmlmin)
+    },
+    "svg": function () {
+      return plug.gulpIf(MIN, plug.svgmin())
     }
   },
@@ -326,7 +329,9 @@
       .pipe(task.lint.slim)
   },
-  "svg": function () {
+  "svg": function (tag) {
     return plug.lazypipe()
       .pipe(task.tidy.html)
+      .pipe(task.minify.svg)
+      .pipe(task.indent, tag)
   }
 }
@@ -349,5 +354,5 @@
             .pipe(pipe.html(true)()),
             gulp.src(path.join(dir[0], opts.ext.svg))
-            .pipe(pipe.svg()())
+            .pipe(pipe.svg(true)())
           )
           .pipe(task.save.tmp())
EOF

1> /dev/null yarn add --dev \
  gulp-cssnano

cat <<-EOF | patch 1> /dev/null
--- gulpfile.js
+++ gulpfile.js
@@ -97,4 +97,12 @@
       "zero-units": true
     },
+    "cssnano": {
+      "autoprefixer": {
+        "add": true,
+        "browsers": plug.browserslist([">0.25% in my stats"], {
+          "stats": ".caniuse.json"
+        })
+      }
+    },
     "env": MIN ? "production" : "development",
     "eslint": {
@@ -240,4 +248,7 @@
   },
   "minify": {
+    "css": function (min) {
+      return plug.gulpIf(min, plug.cssnano(opts.cssnano))
+    },
     "html": function () {
       return plug.htmlmin(opts.htmlmin)
@@ -299,8 +310,10 @@
 
 const pipe = {
-  "css": function () {
+  "css": function (tag) {
     return plug.lazypipe()
       .pipe(task.tidy.css)
       .pipe(task.lint.css)
+      .pipe(task.indent, tag)
+      .pipe(task.minify.css, MIN)
   },
   "es6": function () {
@@ -354,5 +367,8 @@
             .pipe(pipe.html(true)()),
             gulp.src(path.join(dir[0], opts.ext.svg))
-            .pipe(pipe.svg(true)())
+            .pipe(pipe.svg(true)()),
+            gulp.src(path.join(dir[0], opts.ext.sass))
+            .pipe(task.compile.sass())
+            .pipe(pipe.css(true)())
           )
           .pipe(task.save.tmp())
EOF

1> /dev/null yarn add --dev \
  gulp-inject-string

cat <<-EOF | patch 1> /dev/null
--- gulpfile.js
+++ gulpfile.js
@@ -138,4 +138,10 @@
       "wrap": 78
     },
+    "inject": {
+      "css": {
+        "above": "<style>",
+        "below": "</style>"
+      }
+    },
     "jsbeautifier": {
       "js": {
@@ -304,4 +310,15 @@
       return plug.csscomb()
     }
+  },
+  "wrap": {
+    "above": function (min) {
+      return plug.gulpIf(min, plug.injectString.prepend("\n"))
+    },
+    "below": function (min) {
+      return plug.gulpIf(min, plug.injectString.append("\n"))
+    },
+    "css": plug.lazypipe()
+      .pipe(plug.injectString.prepend, opts.inject.css.above)
+      .pipe(plug.injectString.append, opts.inject.css.below)
   }
 }
@@ -316,4 +333,14 @@
       .pipe(task.indent, tag)
       .pipe(task.minify.css, MIN)
+      .pipe(function () {
+        return plug.gulpIf(tag, task.wrap.above(!MIN))
+      })
+      .pipe(function () {
+        return plug.gulpIf(tag, task.wrap.css())
+      })
+      .pipe(function () {
+        return plug.gulpIf(tag, task.wrap.below(!MIN))
+      })
+      .pipe(task.indent, tag)
   },
   "es6": function () {
EOF

1> /dev/null yarn add --dev \
  babel-preset-es2015 \
  gulp-babel

cat <<-EOF | patch 1> /dev/null
--- gulpfile.js
+++ gulpfile.js
@@ -34,4 +34,20 @@
       "remove": true
     },
+    "babel": {
+      "plugins": ["check-es2015-constants",
+        "transform-es2015-arrow-functions",
+        "transform-es2015-block-scoped-functions",
+        "transform-es2015-block-scoping", "transform-es2015-classes",
+        "transform-es2015-computed-properties",
+        "transform-es2015-destructuring", "transform-es2015-duplicate-keys",
+        "transform-es2015-for-of", "transform-es2015-function-name",
+        "transform-es2015-literals", "transform-es2015-object-super",
+        "transform-es2015-parameters",
+        "transform-es2015-shorthand-properties", "transform-es2015-spread",
+        "transform-es2015-sticky-regex",
+        "transform-es2015-template-literals",
+        "transform-es2015-typeof-symbol", "transform-es2015-unicode-regex",
+        "transform-regenerator"]
+    },
     "browserSync": {
       "files": path.join(OUT, "**", "*"),
@@ -203,4 +219,7 @@
   },
   "compile": {
+    "es6": function () {
+      return plug.babel(opts.babel)
+    },
     "sass": plug.lazypipe()
       .pipe(plug.sass, opts.sass)
@@ -397,5 +416,7 @@
             gulp.src(path.join(dir[0], opts.ext.sass))
             .pipe(task.compile.sass())
-            .pipe(pipe.css(true)())
+            .pipe(pipe.css(true)()),
+            gulp.src(path.join(dir[0], opts.ext.es6))
+            .pipe(task.compile.es6())
           )
           .pipe(task.save.tmp())
EOF

1> /dev/null yarn add --dev \
  gulp-jsbeautifier

cat <<-EOF | patch 1> /dev/null
--- gulpfile.js
+++ gulpfile.js
@@ -377,4 +377,8 @@
       .pipe(task.indent, tag)
   },
+  "js": function () {
+    return plug.lazypipe()
+      .pipe(task.tidy.es6)
+  },
   "sass": function () {
     return plug.lazypipe()
@@ -419,4 +423,5 @@
             gulp.src(path.join(dir[0], opts.ext.es6))
             .pipe(task.compile.es6())
+            .pipe(pipe.js()())
           )
           .pipe(task.save.tmp())
EOF

cat <<-EOF | patch 1> /dev/null
--- gulpfile.js
+++ gulpfile.js
@@ -184,4 +184,7 @@
       "html": {
         "extname": \`.\${EXT}\`
+      },
+      "js": {
+        "extname": ".js"
       }
     },
@@ -286,4 +289,7 @@
     "html": function () {
       return plug.rename(opts.rename.html)
+    },
+    "js": function () {
+      return plug.rename(opts.rename.js)
     }
   },
@@ -377,7 +383,9 @@
       .pipe(task.indent, tag)
   },
-  "js": function () {
+  "js": function (tag) {
     return plug.lazypipe()
       .pipe(task.tidy.es6)
+      .pipe(task.rename.js)
+      .pipe(task.indent, tag)
   },
   "sass": function () {
@@ -423,5 +431,5 @@
             gulp.src(path.join(dir[0], opts.ext.es6))
             .pipe(task.compile.es6())
-            .pipe(pipe.js()())
+            .pipe(pipe.js(true)())
           )
           .pipe(task.save.tmp())
EOF

1> /dev/null yarn add --dev \
  gulp-uglify

cat <<-EOF | patch 1> /dev/null
--- gulpfile.js
+++ gulpfile.js
@@ -282,4 +282,7 @@
       return plug.htmlmin(opts.htmlmin)
     },
+    "js": function (min) {
+      return plug.gulpIf(min, plug.uglify())
+    },
     "svg": function () {
       return plug.gulpIf(MIN, plug.svgmin())
@@ -388,4 +391,5 @@
       .pipe(task.rename.js)
       .pipe(task.indent, tag)
+      .pipe(task.minify.js, MIN)
   },
   "sass": function () {
EOF

cat <<-EOF | patch 1> /dev/null
--- gulpfile.js
+++ gulpfile.js
@@ -158,4 +158,8 @@
         "above": "<style>",
         "below": "</style>"
+      },
+      "js": {
+        "above": "<script>",
+        "below": "</script>"
       }
     },
@@ -348,5 +352,8 @@
     "css": plug.lazypipe()
       .pipe(plug.injectString.prepend, opts.inject.css.above)
-      .pipe(plug.injectString.append, opts.inject.css.below)
+      .pipe(plug.injectString.append, opts.inject.css.below),
+    "js": plug.lazypipe()
+      .pipe(plug.injectString.prepend, opts.inject.js.above)
+      .pipe(plug.injectString.append, opts.inject.js.below)
   }
 }
@@ -392,4 +399,14 @@
       .pipe(task.indent, tag)
       .pipe(task.minify.js, MIN)
+      .pipe(function () {
+        return plug.gulpIf(tag, task.wrap.above(!MIN))
+      })
+      .pipe(function () {
+        return plug.gulpIf(tag, task.wrap.js())
+      })
+      .pipe(function () {
+        return plug.gulpIf(tag, task.wrap.below(!MIN))
+      })
+      .pipe(task.indent, tag)
   },
   "sass": function () {
EOF

1> /dev/null yarn add --dev \
  gulp-concat

cat <<-EOF | patch 1> /dev/null
--- gulpfile.js
+++ gulpfile.js
@@ -236,4 +236,7 @@
     }
   },
+  "concat": function (folder) {
+    return plug.concat(folder)
+  },
   "each": {
     "folder": function (a, b, c) {
@@ -294,4 +297,9 @@
   },
   "rename": {
+    "dir": function (dir) {
+      return plug.rename({
+        "dirname": dir
+      })
+    },
     "html": function () {
       return plug.rename(opts.rename.html)
@@ -355,5 +363,14 @@
     "js": plug.lazypipe()
       .pipe(plug.injectString.prepend, opts.inject.js.above)
-      .pipe(plug.injectString.append, opts.inject.js.below)
+      .pipe(plug.injectString.append, opts.inject.js.below),
+    "tag": {
+      "above": function (folder) {
+        return plug.injectString.prepend(
+          \`<\${folder.split(".").shift()}>\n\`)
+      },
+      "below": function (folder) {
+        return plug.injectString.append(\`</\${folder.split(".").shift()}>\`)
+      }
+    }
   }
 }
@@ -410,4 +427,12 @@
       .pipe(task.indent, tag)
   },
+  "riot": function (dir) {
+    return plug.lazypipe()
+      .pipe(task.concat, dir[3])
+      .pipe(task.rename.dir, dir[2])
+      .pipe(task.wrap.below, MIN)
+      .pipe(task.wrap.tag.above, dir[3])
+      .pipe(task.wrap.tag.below, dir[3])
+  },
   "sass": function () {
     return plug.lazypipe()
@@ -454,4 +479,5 @@
             .pipe(pipe.js(true)())
           )
+          .pipe(pipe.riot(dir)())
           .pipe(task.save.tmp())
           .on("end", function () {
EOF

1> /dev/null yarn add --dev \
  gulp-riot
1> /dev/null yarn add \
  riot

cat <<-EOF | patch 1> /dev/null
--- gulpfile.js
+++ gulpfile.js
@@ -8,5 +8,6 @@
   "rename": {
     "eslint": "Eslint",
-    "gulp-if": "gulpIf"
+    "gulp-if": "gulpIf",
+    "riot": "Riot"
   }
 })
@@ -197,4 +198,7 @@
         "yarn.lock"]
     },
+    "riot": {
+      "compact": MIN
+    },
     "sass": {
       "outputStyle": MIN ? "compressed" : "expanded"
@@ -229,4 +233,7 @@
       return plug.babel(opts.babel)
     },
+    "riot": function () {
+      return plug.riot(opts.riot)
+    },
     "sass": plug.lazypipe()
       .pipe(plug.sass, opts.sass)
@@ -434,4 +441,6 @@
       .pipe(task.wrap.tag.above, dir[3])
       .pipe(task.wrap.tag.below, dir[3])
+      .pipe(task.compile.riot)
+      .pipe(task.minify.js, true)
   },
   "sass": function () {
EOF

cat <<-EOF | patch 1> /dev/null
--- gulpfile.js
+++ gulpfile.js
@@ -163,5 +163,7 @@
         "above": "<script>",
         "below": "</script>"
-      }
+      },
+      "license": "/*! github.com/ptb, @license Apache-2.0 */\n",
+      "riot": \`import * as riot from "riot"\${MIN ? ";" : "\n"}\`
     },
     "jsbeautifier": {
@@ -371,4 +373,10 @@
       .pipe(plug.injectString.prepend, opts.inject.js.above)
       .pipe(plug.injectString.append, opts.inject.js.below),
+    "license": function () {
+      return plug.injectString.prepend(opts.inject.license)
+    },
+    "riot": function () {
+      return plug.injectString.prepend(opts.inject.riot)
+    },
     "tag": {
       "above": function (folder) {
@@ -443,4 +451,6 @@
       .pipe(task.compile.riot)
       .pipe(task.minify.js, true)
+      .pipe(task.wrap.riot)
+      .pipe(task.wrap.license)
   },
   "sass": function () {
EOF

cat <<-EOF | patch 1> /dev/null
--- config.rb
+++ config.rb
@@ -54,2 +54,4 @@
 ignore(/.*\.keep/)
+ignore(/\.es6/)
+ignore(/\.sass/)
 ignore(%r{\.tag/.*})
EOF

cat <<-EOF | patch 1> /dev/null
--- gulpfile.js
+++ gulpfile.js
@@ -186,4 +186,5 @@
     },
     "path": {
+      "exclude": \`!\${path.join("**", "@(_*|*.tag)", "*")}\`,
       "src": path.join(SRC, "**")
     },
@@ -504,4 +505,19 @@
           })
       })
+  },
+  function assets () {
+    return plug.streamqueue({
+      "objectMode": true
+    },
+        gulp.src([path.join(opts.path.src, opts.ext.svg), opts.path.exclude])
+        .pipe(pipe.svg(false)()),
+        gulp.src([path.join(opts.path.src, opts.ext.sass), opts.path.exclude])
+        .pipe(task.compile.sass())
+        .pipe(pipe.css(false)()),
+        gulp.src([path.join(opts.path.src, opts.ext.es6), opts.path.exclude])
+        .pipe(task.compile.es6())
+        .pipe(pipe.js(false)())
+      )
+      .pipe(task.save.tmp())
   }
 ))
EOF

1> /dev/null yarn add --dev \
  webpack-stream \
  webpack@beta

cat > "${CWD}/src/js/index.es6" <<-EOF
import * as riot from "riot"

import "./example-tag"

riot.mount("*")
EOF

cat <<-EOF | patch 1> /dev/null
--- gulpfile.js
+++ gulpfile.js
@@ -219,4 +219,40 @@
     "trimlines": {
       "leading": false
+    },
+    "webpack": {
+      "context": path.join(TMP, "js"),
+      "entry": {
+        "script": "./index"
+      },
+      "output": {
+        "filename": path.join("js", "[name].js")
+      },
+      "plugins": [
+        new plug.webpack.SourceMapDevToolPlugin({
+          "filename": path.join("js", "[name].map"),
+          "moduleFilenameTemplate": function (info) {
+            if (!MIN && fs.existsSync(info.absoluteResourcePath)) {
+              return \`file://\${encodeURI(info.absoluteResourcePath)}\`
+            }
+            return \`\${path.basename(info.resourcePath)}?\${info.hash}\`
+          }
+        }),
+        new plug.webpack.optimize.AggressiveMergingPlugin(),
+        new plug.webpack.optimize.UglifyJsPlugin({
+          "compress": {
+            "warnings": false
+          },
+          "mangle": MIN,
+          "output": {
+            "beautify": !MIN,
+            "comments": false,
+            "indent_level": 2
+          },
+          "sourceMap": true
+        })
+      ],
+      "resolve": {
+        "extensions": [".js", ".json"]
+      }
     }
   }
@@ -244,4 +280,7 @@
     "slim": function () {
       return plug.slim(opts.slim)
+    },
+    "webpack": function () {
+      return plug.webpackStream(opts.webpack, plug.webpack)
     }
   },
@@ -471,4 +510,8 @@
       .pipe(task.minify.svg)
       .pipe(task.indent, tag)
+  },
+  "webpack": function () {
+    return plug.lazypipe()
+      .pipe(task.compile.webpack)
   }
 }
@@ -520,4 +563,9 @@
       )
       .pipe(task.save.tmp())
+  },
+  function webpack () {
+    return gulp.src(path.join(TMP, "js", "index.js"))
+      .pipe(pipe.webpack()())
+      .pipe(task.save.tmp())
   }
 ))
EOF

1> /dev/null yarn add --dev \
  ptb/riot-hot-reload \
  tag-loader

cat <<-EOF | patch 1> /dev/null
--- config.rb
+++ config.rb
@@ -33,3 +33,3 @@
 activate :external_pipeline,
-  command: "node_modules/.bin/gulp build#{MIN ? ' --min' : nil} --silent",
+  command: "node_modules/.bin/gulp build#{MIN ? ' --min' : nil} --silent --wpk",
   name: :gulp,
EOF

cat <<-EOF | patch 1> /dev/null
--- gulpfile.js
+++ gulpfile.js
@@ -23,4 +23,5 @@
 const EXT = "xhtml"
 const MIN = typeof plug.util.env.min != "undefined"
+const WPK = typeof plug.util.env.wpk != "undefined"
 
 // -- opts ------------------------------------------------------------------
@@ -228,4 +229,15 @@
         "filename": path.join("js", "[name].js")
       },
+      "module": {
+        "rules": [
+          {
+            "loader": "tag-loader",
+            "options": {
+              "compact": true
+            },
+            "test": /\.tag$/
+          }
+        ]
+      },
       "plugins": [
         new plug.webpack.SourceMapDevToolPlugin({
@@ -253,5 +265,5 @@
       ],
       "resolve": {
-        "extensions": [".js", ".json"]
+        "extensions": [".js", ".json", ".tag"]
       }
     }
@@ -489,8 +501,8 @@
       .pipe(task.wrap.tag.above, dir[3])
       .pipe(task.wrap.tag.below, dir[3])
-      .pipe(task.compile.riot)
-      .pipe(task.minify.js, true)
-      .pipe(task.wrap.riot)
-      .pipe(task.wrap.license)
+      .pipe(plug.gulpIf, !WPK, task.compile.riot())
+      .pipe(plug.gulpIf, !WPK, task.minify.js(true))
+      .pipe(plug.gulpIf, !WPK, task.wrap.riot())
+      .pipe(plug.gulpIf, !WPK, task.wrap.license())
   },
   "sass": function () {
EOF

cp "${CWD}/node_modules/riot/riot.js" "${CWD}/src/js/riot.js"
cp "${CWD}/node_modules/riot-hot-reload/riot-hot-reload.js" \
  "${CWD}/src/js/riot-hot-reload.js"

cat <<-EOF | patch -p0 1> /dev/null
--- src/_layouts/layout.slim
+++ src/_layouts/layout.slim
@@ -29,3 +29,16 @@
       == yield_content :foot

+    script(src="#{url_for('/js/riot.js')}")
+    script(src="#{url_for('/js/riot-hot-reload.js')}")
+    script(src="#{url_for('/js/example-tag.js')}")
+    script
+      |
+        /*<![CDATA[*/
+        riot.observable(riotHotReload)
+        riot.util.hotReloader = riotHotReload
+
+        riot.mount("*")
+        /*]]>*/
+    / = inline_tag 'script', '/js/script.js'
+
     / script(src='/browser-sync/browser-sync-client.js')
EOF

cat > "${CWD}/nginx.conf" <<-EOF
daemon off;

events {
  worker_connections 8000;
}

http {
  charset utf-8;
  charset_types
    application/javascript
    application/json
    application/rss+xml
    application/xhtml+xml
    application/xml
    text/css
    text/plain
    text/vnd.wap.wml;

  default_type application/octet-stream;

  gzip on;
  gzip_comp_level 9;
  gzip_min_length 256;
  gzip_proxied any;
  gzip_static on;
  gzip_vary on;

  gzip_types
    application/atom+xml
    application/javascript
    application/json
    application/ld+json
    application/manifest+json
    application/rss+xml
    application/vnd.geo+json
    application/vnd.ms-fontobject
    application/x-font-ttf
    application/x-web-app-manifest+json
    application/xhtml+xml
    application/xml
    font/opentype
    image/bmp
    image/svg+xml
    image/x-icon
    text/cache-manifest
    text/css
    text/plain
    text/vcard
    text/vnd.rim.location.xloc
    text/vtt
    text/x-component
    text/x-cross-domain-policy;

  keepalive_timeout 20s;

  log_format default '"\$request" \$status \$body_bytes_sent "\$http_referer" '
    '\$remote_addr';

  sendfile on;
  server_tokens off;

  server {
    listen 80;
    listen [::]:80;
    listen 443 ssl http2;
    listen [::]:443 ssl http2;

    location / {
      access_log /dev/stdout default;
      error_log stderr;
      # index index.html index.xhtml;
      proxy_http_version 1.1;
      proxy_pass https://localhost:3000;
      proxy_set_header Connection "Upgrade";
      proxy_set_header Upgrade \$http_upgrade;
      # root "${CWD}/docs";
    }

    server_name localhost;

    ssl_certificate "${CWD}/localhost.crt";
    ssl_certificate_key "${CWD}/localhost.key";

    ssl_ciphers "EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH";
    ssl_prefer_server_ciphers on;
    ssl_protocols TLSv1.2;
    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 24h;
  }

  server {
    listen 80 default_server;
    listen [::]:80 default_server;
    listen 443 ssl http2 default_server;
    listen [::]:443 ssl http2;

    location / {
      access_log off;
      error_log off;
      return 444;
    }
  }

  tcp_nopush on;

  types {
    application/atom+xml atom;
    application/font-woff woff;
    application/font-woff2 woff2;
    application/java-archive ear jar war;
    application/javascript js;
    application/json json map topojson;
    application/ld+json jsonld;
    application/mac-binhex40 hqx;
    application/manifest+json webmanifest;
    application/msword doc;
    application/octet-stream bin deb dll dmg exe img iso msi msm msp safariextz;
    application/pdf pdf;
    application/postscript ai eps ps;
    application/rss+xml rss;
    application/rtf rtf;
    application/vnd.geo+json geojson;
    application/vnd.google-earth.kml+xml kml;
    application/vnd.google-earth.kmz kmz;
    application/vnd.ms-excel xls;
    application/vnd.ms-fontobject eot;
    application/vnd.ms-powerpoint ppt;
    application/vnd.openxmlformats-officedocument.presentationml.presentation pptx;
    application/vnd.openxmlformats-officedocument.spreadsheetml.sheet xlsx;
    application/vnd.openxmlformats-officedocument.wordprocessingml.document docx;
    application/vnd.wap.wmlc wmlc;
    application/x-7z-compressed 7z;
    application/x-bb-appworld bbaw;
    application/x-bittorrent torrent;
    application/x-chrome-extension crx;
    application/x-cocoa cco;
    application/x-font-ttf ttc ttf;
    application/x-java-archive-diff jardiff;
    application/x-java-jnlp-file jnlp;
    application/x-makeself run;
    application/x-opera-extension oex;
    application/x-perl pl pm;
    application/x-pilot pdb prc;
    application/x-rar-compressed rar;
    application/x-redhat-package-manager rpm;
    application/x-sea sea;
    application/x-shockwave-flash swf;
    application/x-stuffit sit;
    application/x-tcl tcl tk;
    application/x-web-app-manifest+json webapp;
    application/x-x509-ca-cert crt der pem;
    application/x-xpinstall xpi;
    application/xhtml+xml xhtml;
    application/xml rdf xml;
    application/xslt+xml xsl;
    application/zip zip;
    audio/midi mid midi kar;
    audio/mp4 aac f4a f4b m4a;
    audio/mpeg mp3;
    audio/ogg oga ogg opus;
    audio/x-realaudio ra;
    audio/x-wav wav;
    font/opentype otf;
    image/bmp bmp;
    image/gif gif;
    image/jpeg jpeg jpg;
    image/png png;
    image/svg+xml svg svgz;
    image/tiff tif tiff;
    image/vnd.wap.wbmp wbmp;
    image/webp webp;
    image/x-icon cur ico;
    image/x-jng jng;
    text/cache-manifest appcache;
    text/css css;
    text/html htm html shtml;
    text/mathml mml;
    text/plain txt;
    text/vcard vcard vcf;
    text/vnd.rim.location.xloc xloc;
    text/vnd.sun.j2me.app-descriptor jad;
    text/vnd.wap.wml wml;
    text/vtt vtt;
    text/x-component htc;
    video/3gpp 3gp 3gpp;
    video/mp4 f4p f4v m4v mp4;
    video/mpeg mpeg mpg;
    video/ogg ogv;
    video/quicktime mov;
    video/webm webm;
    video/x-flv flv;
    video/x-mng mng;
    video/x-ms-asf asf asx;
    video/x-ms-wmv wmv;
    video/x-msvideo avi;
  }
}

worker_processes auto;
worker_rlimit_nofile 8192;
EOF

ln -s template.org readme.org
git add --all && git reset -- docs/* && git add docs/.keep

LABEL="localhost.nginx"
PLIST="/Library/LaunchDaemons/${LABEL}.plist"

/bin/echo
sudo launchctl unload "${PLIST}" &> /dev/null

sudo tee "${PLIST}" > /dev/null <<-EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>${LABEL}</string>
  <key>ProgramArguments</key>
  <array>
    <string>/usr/local/bin/nginx</string>
    <string>-c</string>
    <string>${CWD}/nginx.conf</string>
  </array>
  <key>RunAtLoad</key>
  <true/>
  <key>StandardErrorPath</key>
  <string>${CWD}/logs/error.log</string>
  <key>StandardOutPath</key>
  <string>${CWD}/logs/access.log</string>
  <key>WatchPaths</key>
  <array>
    <string>${CWD}/nginx.conf</string>
  </array>
</dict>
</plist>
EOF

sudo plutil -convert xml1 "${PLIST}"
sudo launchctl load "${PLIST}"
