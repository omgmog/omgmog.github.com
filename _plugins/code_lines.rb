# Wraps every line of a highlighted code block in <span class="line">, so CSS can give wrapped
# lines a hanging indent (the continuation of a long line is indented under its start).
#
# Rouge emits one run of token <span>s with newlines in the text. A token that crosses a newline
# (a multi-line comment or string) is closed at the end of the line and reopened on the next, so
# each line is well-formed on its own. The newline stays inside the line's span, which keeps copy
# and paste intact and adds no blank line (a trailing newline in a block adds no empty line).
module Jekyll
  module CodeLines
    BLOCK = %r{(<pre class="highlight"><code>)(.*?)(</code></pre>)}m
    TOKEN = %r{<span[^>]*>|</span>|[^<]+}m

    def self.wrap(html)
      trailing = html.end_with?("\n")
      html = html.chomp if trailing
      out = +'<span class="line">'
      open_tags = []
      html.scan(TOKEN) do |tok|
        if tok.start_with?('</span')
          open_tags.pop
          out << tok
        elsif tok.start_with?('<span')
          open_tags << tok
          out << tok
        else
          parts = tok.split("\n", -1)
          parts.each_with_index do |part, i|
            out << part
            next if i == parts.length - 1
            out << ("</span>" * open_tags.length) << "\n</span><span class=\"line\">" << open_tags.join
          end
        end
      end
      out << (trailing ? "\n</span>" : "</span>")
    end

    def self.process(content)
      return content unless content.include?('<pre class="highlight"><code>')
      content.gsub(BLOCK) { "#{$1}#{wrap($2)}#{$3}" }
    end
  end

  Hooks.register [:documents, :pages], :post_convert do |doc|
    doc.content = CodeLines.process(doc.content)
  end
end
