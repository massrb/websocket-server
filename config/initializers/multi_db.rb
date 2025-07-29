ActiveRecord::Base.connects_to shards: {
  writing: :primary,
  cable: :cable
}