# convert little endian bytes to integer values
def read_value(file_name, offset, length)
  value = 0
  File.open(file_name, 'rb') do |file_io|
    file_io.seek(offset, IO::SEEK_SET)
    (0..length-1).each do |index|
      value += file_io.getbyte << (index * 8)
    end
  end
  value
end

def encrypt_message(message_file, input_image_file, output_image_file)

  # Where does the data start?
  pixel_data_offset = read_value(input_image_file, 10, 4)

  output_image_io   = File.open(output_image_file, 'wb')
  input_image_io    = File.open(input_image_file, 'rb')
  message_file_io   = File.open(message_file, 'rb')

  # write out bytes up to pixel data
  IO.copy_stream(input_image_io, output_image_io, pixel_data_offset)

  message_file_io.bytes do |message_byte|
    
    (0..7).each do |bit|

      input_byte = input_image_io.getbyte
      
      # Replace output image byte LSB with bit
      output_byte = message_byte & (2**(7-bit)) > 0 ? input_byte|1 : input_byte&254
      output_image_io.putc(output_byte)

    end
    
  end

  # complete remaining image data (this is bad spycraft, it's obvious there is a message with all LSB's being 0)
  input_image_io.bytes {|image_byte| output_image_io.putc(image_byte&254)}

  output_image_io.close
  input_image_io.close
  message_file_io.close

end


def decrypt_message(input_image_file, output_message_file)

  # Where does the data start?
  pixel_data_offset = read_value(input_image_file, 10, 4)

  input_image_io    = File.open(input_image_file, 'rb')
  message_file_io   = File.open(output_message_file, 'wb')

  # seek to pixel data
  input_image_io.seek(pixel_data_offset, IO::SEEK_SET)

  input_image_io.bytes do |image_byte|
    message_file_io.putc("#{image_byte&1}")
  end

  input_image_io.close
  message_file_io.close

end

encrypt_message("./input.txt", './input.bmp', './output.bmp')
#encrypt_message("./sample_input.txt", './input.bmp', './my_sample_output.bmp')

#decrypt_message("./sample_output.bmp", 'find_sample_input.txt')
#decrypt_message("./my_sample_output.bmp", 'my_sample_input.txt')
