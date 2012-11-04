namespace :ken_all do
  desc "Initialize KenAll"
  task :init => :environment do
    Rake::Task["ken_all:install:migrations"].invoke
  end

  desc "Download & Import KEN_ALL"
  task :import => :environment do
    import = KenAll::Import.new
    import.run
  end
end
