module ReactOnRails
  module TaskHelpers
    # Returns the root folder of the react_on_rails gem
    def gem_root
      File.expand_path("../../.", __FILE__)
    end

    # Returns the folder where examples are located
    def examples_dir
      File.join(gem_root, "examples")
    end

    def dummy_app_dirs
      %w(spec/dummy spec/dummy-react-013).map { |rel_dir| File.join(gem_root, rel_dir) }
    end

    # Executes a string or an array of strings in a shell in the given directory
    def sh_in_dir(dir, shell_commands)
      shell_commands = [shell_commands] if shell_commands.is_a?(String)
      shell_commands.each { |shell_command| sh %(cd #{dir} && #{shell_command.strip}) }
    end

    def bundle_install_in(dir)
      sh_in_dir(dir, "bundle install")
    end

    # Runs bundle exec using that directory's Gemfile
    def bundle_exec(options)
      options[:env_vars] = "" unless options.key?(:env_vars)
      sh_in_dir(options[:dir], "#{options[:env_vars]} #{options[:args]}")
    end

    def generators_source_dir
      File.join(gem_root, "lib/generators/react_on_rails")
    end

    def symbolize_keys(hash)
      hash.each_with_object({}) do |(key, value), new_hash|
        new_key = key.is_a?(String) ? key.to_sym : key
        new_value = value.is_a?(Hash) ? symbolize_keys(value) : value
        new_hash[new_key] = new_value
      end
    end
  end
end
