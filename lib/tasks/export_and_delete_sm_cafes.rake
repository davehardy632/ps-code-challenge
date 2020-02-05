require 'csv'

namespace :export do
  namespace :delete do
    desc "For street cafes categorized as small, records are exported to a csv and then deleted"
    task small_street_cafes: :environment do

      small_street_cafes = StreetCafe.return_by_size("small")
      small_street_cafes.write_to_csv
      small_street_cafes.delete_all

    end
  end
end
