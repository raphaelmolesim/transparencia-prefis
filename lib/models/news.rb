#encoding : UTF-8
class News
  
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :title, type: String
  field :link, type: String
  field :source, type: Symbol
  
end