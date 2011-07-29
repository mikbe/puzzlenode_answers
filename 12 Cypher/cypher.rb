ASCII_A = 65

cypher_lines = File.readlines("complex_cipher.txt")

def decypher_letter(key_letter, letter)
  key26        = key_letter.ord - ASCII_A
  letter26     = letter.ord - ASCII_A
  new_letter26 = (letter26 - key26) % 26
  new_letter   = (new_letter26 + ASCII_A).chr
  (new_letter26 + ASCII_A).chr
end

def decypher_text(key_word, text)
  new_text = ""
  keyword_array = key_word.split("")
  text.length.times do |letter_index|
    letter = text[letter_index]
    if letter.ord < ASCII_A
      new_text += letter
    else
      new_text += decypher_letter(keyword_array.first, letter)
      keyword_array.rotate!
    end
  end
  new_text
end

encrypted_key = cypher_lines.shift.chomp
cypher_lines.shift

cypher_text = cypher_lines.join
# try different keys
#26.times do |key_letter|
  key_letter = 17 # 11 for simple
  puts
  puts "index: #{key_letter}"
  key = decypher_text((key_letter + ASCII_A).chr, encrypted_key)
  puts key
  #break if key == "GARDEN"
  decyphered_text = decypher_text(key, cypher_text)
  #break
#end


File.open("complex.txt", "w") { |file| file.write decyphered_text }
