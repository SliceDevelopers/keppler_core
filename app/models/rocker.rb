# Rocker Model
class Rocker < ActiveRecord::Base
  include ActivityHistory
  include CloneRecord
  require 'csv'
  mount_uploader :avatar, AttachmentUploader
  acts_as_list
  # Fields for the search form in the navbar
  def self.search_field
    :avatar_or_name_cont
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      begin
        Rocker.create! row.to_hash
      rescue => err
      end
    end
  end

  def self.sorter(params)
    params.each_with_index do |id, idx|
      self.find(id).update(position: idx.to_i+1)
    end
  end
end