module ReactOnRails
  class PrerenderError < RuntimeError
    # err might be nil if JS caught the error
    def initialize(options)
      message = "ERROR in SERVER PRERENDERING\n"
      if options[:err]
        message << <<-MSG
Encountered error: \"#{err}\"
        MSG
        backtrace = options[:err].backtrace.join("\n")
      else
        backtrace = nil
      end
      message << <<-MSG
when prerendering #{options[:component_name]} with props: #{options[:props]}
js_code was:
#{options[:js_code]}
      MSG

      if options[:console_messages]
        message << <<-MSG
console messages:
#{options[:console_messages]}
        MSG
      end

      super([message, backtrace].compact.join("\n"))
    end
  end
end
