class Draft < ActiveRecord::Base
  has_many :reviews
  
  def reviewify
    raw = HTMLEntities.new.decode(self.content)
    preproc = StanfordParser::DocumentPreprocessor.new
    sentences = preproc.getSentencesFromString(raw)
    sentences.each_with_index do |sent, i|
      strt, brk = false, false
      chars = ["?", ",", ".", ":", ";", "...", "''", "'"]
      sent = sentences[i] = sent.join(" ")
      sent = sentences[i] = sent.gsub(/(``[^'']+$)/) {|s| "#{$1}\""}
      sent = sentences[i] = sent.gsub("`` ", ' "').gsub("--", "&mdash;")
      chars.each {|chr| sent = sentences[i] = sent.gsub(" " + chr, chr)}
      if sent.index(/<\/p>\s+<p>/)
        sent = sentences[i] = sent.gsub(/<\/p>\s+<p>/) {|s| ""}
        brk = true
      end
      if sent.index("<p>")
        sent = sentences[i] = sent.gsub("<p>", "")
        strt = true
      end
      sentences[i] = '<a class="sentence" href="#" id="sent-' + i.to_s + '">' + sent.strip + '</a>'
      if brk then sentences[i] = sentences[i].insert(0, "</p><p>") end
      if strt then sentences[i] = sentences[i].insert(0, "<p>") end
    end
    return {:content => sentences.join(" "), :n_sentences => "0" * sentences.length}
  end
end
