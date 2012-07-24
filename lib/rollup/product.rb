class Product < Struct.new(:name, :url)
  def to_s
    "#{self.name} (#{self.url})"
  end
end
