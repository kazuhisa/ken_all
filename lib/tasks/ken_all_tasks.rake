namespace :ken_all do
  desc "Download & Import KEN_ALL"
  task :import => :environment do
    import = KenAll::Import.new
    import.from_net
  end

  namespace :import do
    desc "Silent Download & Import KEN_ALL"
    task :silent => :environment do
      import = KenAll::Import.new(visualize: false)
      import.from_net
    end

    desc "Import from file"
    task :file => :environment do
      import = KenAll::Import.new(visualize: false)
      import.from_file
    end
  end
end
