require 'csv'

namespace :import do
  desc "For all medium and large cafes, the category name is concatenated to the beginning of the cafe name"
  task update_med_and_large_cafes: :environment do

    StreetCafe.return_by_size("medium").concat_category_and_name
    StreetCafe.return_by_size("large").concat_category_and_name
    
  end
end
