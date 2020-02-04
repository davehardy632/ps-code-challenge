require 'csv'

namespace :export do
  desc "Export small cafes to a csv, then delete the records"
  task small_street_cafes: :environment do

    small_street_cafes = StreetCafe.return_by_size("small")
    file_name = 'small_street_cafes.csv'
    csv_data = small_street_cafes.to_csv
    File.write(file_name, csv_data)

    small_street_cafes.delete_all
  end
end
