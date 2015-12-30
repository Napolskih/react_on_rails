module ReactOnRails
  def self.configure
    yield(configuration)
  end

  def self.configuration
    @configuration ||= Configuration.new(
      server_bundle_js_file: "app/assets/javascripts/generated/server.js",
      prerender: false,
      replay_console: true,
      logging_on_server: true,
      generator_function: false,
      raise_on_prerender_error: false,
      trace: Rails.env.development?,
      development_mode: Rails.env.development?,
      server_renderer_pool_size: 1,
      server_renderer_timeout: 20)
  end

  class Configuration
    attr_accessor :server_bundle_js_file, :prerender, :replay_console,
                  :generator_function, :trace, :development_mode,
                  :logging_on_server, :server_renderer_pool_size,
                  :server_renderer_timeout, :raise_on_prerender_error

    def initialize(options)
      if File.exist?(options[:server_bundle_js_file])
        self.server_bundle_js_file = options[:server_bundle_js_file]
      else
        self.server_bundle_js_file = nil
      end

      self.prerender = options[:prerender]
      self.replay_console = options[:replay_console]
      self.logging_on_server = options[:logging_on_server]
      self.generator_function = options[:generator_function]
      if options[:development_mode].nil?
        self.development_mode = Rails.env.development?
      else
        self.development_mode = options[:development_mode]
      end
      self.trace = options[:trace].nil? ? Rails.env.development? : options[:trace]
      self.raise_on_prerender_error = options[:raise_on_prerender_error]

      # Server rendering:
      self.server_renderer_pool_size = self.development_mode ? 1 : options[:server_renderer_pool_size]
      self.server_renderer_timeout = options[:server_renderer_timeout] # seconds
    end
  end
end
