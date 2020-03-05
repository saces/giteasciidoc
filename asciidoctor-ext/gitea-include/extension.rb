class GiteaIncludeProcessor < Asciidoctor::Extensions::IncludeProcessor
    def process doc, reader, target, attributes
      # see docs/include_targets.adoc
      if (target.include? '..' or target.include? '\\' or target.include? ':')
        content = "Invalid include: '#{target}'"
      else
        content = `/scripts/gitinclude.sh "#{target}"`
      end
      reader.push_include content, target, target, 1, attributes
      reader
    end

    def handles? target
      # claim to handle everything to prevent the local file handler to kick in.
      return true
    end
end