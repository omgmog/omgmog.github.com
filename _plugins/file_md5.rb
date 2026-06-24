require 'digest'

module Jekyll
  module FileMd5Filter
    def file_md5(path)
      full_path = File.join(@context.registers[:site].source, path)
      Digest::MD5.file(full_path).hexdigest[0, 8]
    rescue Errno::ENOENT
      ''
    end
  end
end

Liquid::Template.register_filter(Jekyll::FileMd5Filter)
