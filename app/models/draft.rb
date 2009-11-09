class Draft < ActiveRecord::Base
  has_many :reviews
  belongs_to :user
  
  def reviewify
    # TODO: contractions, < \/ div > 
    raw = HTMLEntities.new.decode(self.content)
    raw = raw.gsub(/<h(\d)>/) {|s| ".&lt;span style=\"font-weight: bold; font-size: #{22 - ($1.to_i * 2)}px\"&gt;"}
    raw = raw.gsub(/<\/h\d>/) {|s| "&lt;/span&gt;."}
    preproc = StanfordParser::DocumentPreprocessor.new
    sentences = preproc.getSentencesFromString(raw)
    sentences.each_with_index do |sent, i|
      strt, brk, ul, ol, li = false, false, false, false, false
      chars = ["?", ",", ".", ":", ";", "...", "''", "'"]
      sent = sentences[i] = sent.join(" ")
      if sentences[i + 1] and sentences[i + 1].join(" ").index(/<\/p>\s+<p>/)
        sent = sentences[i] = sent.gsub(/([``|''][^'']+$)/) {|s| "#{$1}\""}
      end
      sent = sentences[i] = sent.gsub("`` ", ' "').gsub("--", "&mdash;")
      chars.each {|chr| sent = sentences[i] = sent.gsub(" " + chr, chr)}
      if sent.index(/<\/p>\s+<p>/)
        sent = sentences[i] = sent.gsub(/<\/p>\s+<p>/) {|s| ""}
        brk = true
      end
      if sent.index("<em>") and !sent.index("</em>")
        sent = sentences[i] = sent + "</em>"
      end
      if (sent.index("</em>") and sent.index("<em>") and sent.index("</em>") < sent.index("<em>")) or (sent.index("</em>") and !sent.index("<em>"))
        sent = sentences[i] = sent.gsub(/(<\/em>.*?\s)/, "")
      end
      if sent.index("<p>")
        sent = sentences[i] = sent.gsub("<p>", "")
        strt = true
      end
      if sent.index("<ol>")
        sent = sentences[i] = sent.gsub("<ol>", "")
        ol = true
      end
      if sent.index("<ul>")
        sent = sentences[i] = sent.gsub("<ul>", "")
        ul = true
      end
      if sent.index("<li>")
        sent = sentences[i] = sent.gsub("<li>", "").gsub("</li>", "")
        li = true
      end
      if sent.strip.match(/\w+/)
        sentences[i] = '<a class="sentence" href="#" id="sent-' + (i + 1).to_s + '">' + sent.strip + '</a>'
        if li 
          sentences[i] = sentences[i].insert(0, "<li>")
        end
        if ol then sentences[i] = sentences[i].insert(0, "<ol>") end
        if ul then sentences[i] = sentences[i].insert(0, "<ul>") end
        if brk then sentences[i] = sentences[i].insert(0, "</p><p>") end
        if strt then sentences[i] = sentences[i].insert(0, "<p>") end
      end
    end
    glob = HTMLEntities.new.decode(sentences.compact.join(" "))
    glob = glob.gsub(" n't", "n't")
    glob = glob.gsub(/<em> (.*?) <\/em>/) {|s| "<em>#{$1}</em>"}
    glob = glob.gsub(" !", "!")
    glob = glob.gsub(/<a class="sentence" href="#" id="sent\-\d">\.<\/a>/) {|s| ""}.gsub("</p>.", "</p>")
    glob = glob.gsub("< span style =", "<span class=\"heading\" style=").gsub("< \\\/ span >.", "</span>").gsub("< br >", "<br>").gsub("'' >", "\">")
    glob = glob.gsub("-LRB- ", "(").gsub(" -RRB-", ")")
    glob = glob.gsub("</p></a>", "</a></p>")
    glob = glob.gsub(",'' ", ", \"")
    return {:content => glob, :n_sentences => "0" * (sentences.length + 1)}
  end
end
