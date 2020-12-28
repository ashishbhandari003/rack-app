class User
  include Mongoid::Document

  field :name, type: String, default: ""

end

