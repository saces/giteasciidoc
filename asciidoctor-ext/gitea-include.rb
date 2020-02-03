#
RUBY_ENGINE == 'opal' ? (require 'gitea-include/extension') : (require_relative 'gitea-include/extension')

Asciidoctor::Extensions.register do
    include_processor GiteaIncludeProcessor
end
