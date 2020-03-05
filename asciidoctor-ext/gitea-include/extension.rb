require 'net/http'
require 'uri'

class GiteaIncludeProcessor < Asciidoctor::Extensions::IncludeProcessor
    def process doc, reader, target, attributes
      # check for invalid unicode
      if target != target.scrub
        content = "Include error: filename contains invalid characters."
      # see docs/include_targets.adoc
      elsif (target.include? '..' or target.include? '\\' or target.include? ':' or target.include? '%')
        content = "Invalid include: '#{target}'"
      else
        http = Net::HTTP.new('gitea', 3000)
        http.use_ssl = false
        case target
          when /\A\/\//         # //path
            a = target.split('/', 5)
            path = "/#{a[2]}/#{a[3]}/raw/#{a[4]}"
          when /\A\//           # /path
            a = ENV['GITEA_PREFIX_RAW'].split('/')
            path = "/#{a[1]}/#{a[2]}/raw/#{a[4]}/#{a[5]}#{target}"
          else
            path = "#{ENV['GITEA_PREFIX_RAW']}/#{target}"
        end
        #content = path

        response = http.get(path, { 'Cookie' => "i_like_gitea=#{ENV['SESSION_TOKEN']}" })
        if (response.code == '200')
          content = response.body
        else
          content = "#{response.code}: #{response.message} [#{target}] -> [#{path}]"
        end
      end
      reader.push_include content, target, target, 1, attributes
      reader
    end

    def handles? target
      # claim to handle everything to prevent the local file handler to kick in.
      return true
    end
end
