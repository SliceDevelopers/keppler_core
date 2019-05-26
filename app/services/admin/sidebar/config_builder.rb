# frozen_string_literal: true

module Admin
  module Sidebar
    MENU_PATH = "#{Rails.root}/config/menu.yml"
    ROCKET_PATHS = Dir[File.join("#{Rails.root}/rockets", '*')]

    class ConfigBuilder

      def self.config
        @config ||= self.build
      end

      private

      def self.build
        @mapping = deep_symbolize_keys(MENU_PATH)

        ROCKET_PATHS.each do |path|
          path_menu = "#{path}/config/menu.yml"

          next if !File.file?(path_menu)

          rocket_menu = deep_symbolize_keys(path_menu)

          @mapping = @mapping.merge(rocket_menu)
        end

        sort_menu(@mapping)
      end

      def self.deep_symbolize_keys(path)
        YAML.load_file(path).values.each(&:deep_symbolize_keys!).first
      end

      def self.sort_menu(config)
        config.keys.sort_by { |_, v| v&.dig(:position) || 0 }
              .each_with_object({}) { |k, h| h[k] = config[k] }
      end
    end
  end
end