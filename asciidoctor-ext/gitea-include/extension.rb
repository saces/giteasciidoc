class GiteaIncludeProcessor < Asciidoctor::Extensions::IncludeProcessor
    def process doc, reader, target, attributes
      if (target.include? '..' or target.include? '\\' or target.include? ':')
        content = "Invalid include: '#{target}'"
      else
        content = `/scripts/gitinclude.sh "#{target}"`
      end
      reader.push_include content, target, target, 1, attributes
      reader
    end

    def handles? target
      return true
    end
end