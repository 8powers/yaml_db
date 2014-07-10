namespace :db do
  desc "Dump schema and data to db/schema.rb and db/data.yml"
  task(:dump => [ "db:schema:dump", "db:data:dump" ])

  desc "Load schema and data from db/schema.rb and db/data.yml"
  task(:load => [ "db:schema:load", "db:data:load" ])

  namespace :data do
    def db_dump_data_file(path_to_file = 'tmp')
      "#{Rails.root}/#{path_to_file}"
    end

    # def dump_dir(dir = "")
    #   "#{Rails.root}/#{dir}"
    # end

    desc "Dump contents of database to db/data.extension (defaults to yaml)"
    task :dump => :environment do
      format_class = ENV['class'] || "YamlDb::Helper"
      path = ENV['dir'] || "tmp/#{Time.now.strftime('%Y%m%d%H%M%S')}.yml"
      puts db_dump_data_file(path)
      helper = format_class.constantize
      SerializationHelper::Base.new(helper).dump(db_dump_data_file(path))
    end

    # desc "Dump contents of database to curr_dir_name/tablename.extension (defaults to yaml)"
    # task :dump_dir => :environment do
    #   format_class = ENV['class'] || "YamlDb::Helper"
    #   SerializationHelper::Base.new(format_class.constantize).dump_to_dir dump_dir("/tmp/#{dir}")
    # end

    desc "Load contents of db/data.extension (defaults to yaml) into database"
    task :load => :environment do
      format_class = ENV['class'] || "YamlDb::Helper"
      helper = format_class.constantize
      path = ENV['dir'] || ''
      SerializationHelper::Base.new(helper).load(db_dump_data_file(path))
    end

    # desc "Load contents of db/data_dir into database"
    # task :load_dir  => :environment do
    #   dir = ENV['dir'] || "base"
    #   format_class = ENV['class'] || "YamlDb::Helper"
    #   SerializationHelper::Base.new(format_class.constantize).load_from_dir dump_dir("/tmp/#{dir}")
    # end
  end
end
