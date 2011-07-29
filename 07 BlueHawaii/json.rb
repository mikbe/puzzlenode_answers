begin
  require 'json'
rescue Exception
  # Slower, dangerouser, worser JSON
  class JSON
    def self.parse(content)
      # change colons to =>'s since you can't use the hash shortcut with a string
      cleaned_json = ""
      in_quote = false
      content.each_char do |char|
        char = "=>" if char == ":" and !in_quote
        in_quote = !in_quote if char == "\""
        unless in_quote
          char = "" if [" ", "\b", "\f", "\n", "\r", "\t"].include? char
        end
        cleaned_json += char
      end
      class_eval("#{cleaned_json}")
    end
  end
end
