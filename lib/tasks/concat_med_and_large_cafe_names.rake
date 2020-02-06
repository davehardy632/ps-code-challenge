require 'csv'

namespace :concatenate do
  desc "For all medium and large cafes, the category is concatenated to the beginning of the cafe name"
  task med_and_large_cafe_names: :environment do

    StreetCafe.return_by_size("medium").concat_category_and_name
    StreetCafe.return_by_size("large").concat_category_and_name

  end
end
