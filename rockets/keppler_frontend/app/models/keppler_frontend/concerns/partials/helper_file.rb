# frozen_string_literal: true

# HtmlFile Module
module KepplerFrontend
  module Concerns
    module Partials
      module HelperFile
        extend ActiveSupport::Concern

        def create_helper
          file = "#{url_front}/app/helpers/keppler_frontend/app/frontend_helper.rb"
          index_html = File.readlines(file)
          head_idx = 0
          index_html.each do |i|
            head_idx = index_html.find_index(i) if i.include?(" module App::FrontendHelper")
          end
          index_html.insert(head_idx.to_i + 1, "    def #{name}(hash = {})\n")
          index_html.insert(head_idx.to_i + 2, "      render 'keppler_frontend/app/partials/#{name}'\n")
          index_html.insert(head_idx.to_i + 3, "    end\n")
          index_html = index_html.join('')
          File.write(file, index_html)
          true
        end

        def delete_helper
          file = "#{url_front}/app/helpers/keppler_frontend/app/frontend_helper.rb"
          index_html = File.readlines(file)
          begin_idx = 0
          end_idx = 0
          index_html.each do |i|
            begin_idx = index_html.find_index(i) if i.include?("    def #{name}(hash = {})\n")
            end_idx = index_html.find_index(i) if i.include?("    end\n")
          end
          return if begin_idx==0
          index_html.slice!(begin_idx..end_idx)
          index_html = index_html.join('')
          File.write(file, index_html)
          true
        end

        def update_helper(helper)
          obj = Partial.find(id)
          file = "#{url_front}/app/helpers/keppler_frontend/app/frontend_helper.rb"
          index_html = File.readlines(file)
          begin_idx = 0
          end_idx = 0
          index_html.each do |i|
            begin_idx = index_html.find_index(i) if i.include?("    def #{name}(hash = {})\n")
            end_idx = index_html.find_index(i) if i.include?("    end\n")
          end
          return if begin_idx==0
          index_html[begin_idx] = "    def #{helper[:name]}(hash = {})\n"
          index_html[begin_idx+1] = "      render 'keppler_frontend/app/partials/#{helper[:name]}'\n"
          index_html = index_html.join('')
          File.write(file, index_html)
          true
        end

        private

        def url_front
          "#{Rails.root}/rockets/keppler_frontend"
        end
      end
    end
  end
end
