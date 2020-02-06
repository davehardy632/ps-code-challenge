require 'csv'


namespace :export_and_delete do
  desc "For street cafes categorized as small, records are exported to a csv and then deleted"
  task :small_street_cafes, [:file_name] => :environment do |t, arg|

    small_street_cafes = StreetCafe.return_by_size("small")
    small_street_cafes.write_to_csv(arg)
    small_street_cafes.delete_all

  end
end




# rake 'export_and_delete:small_street_cafes['new_file.csv']'
