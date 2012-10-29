namespace :ken_all do
  desc "Download & Import KEN_ALL"
  task :import => :environment do
    import = KenAll::Import.new
    import.run
  end
end
