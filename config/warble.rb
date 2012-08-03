Warbler::Config.new do |config|
  config.jar_name = "rollup"
  config.bundle_without = %w{ development test deploy }
end
