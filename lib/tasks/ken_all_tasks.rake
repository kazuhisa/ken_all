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

  namespace :import do
    desc "Silent Download & Import KEN_ALL"
    task :silent => :environment do
      import = KenAll::Import.new(visualize: false)
      import.run
    end
  end

end
