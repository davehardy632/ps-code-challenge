require 'csv'

namespace :categorize do
  desc "Categorize street cafes based on their post code prefix, and number of chairs"
  task street_cafes: :environment do

    StreetCafe.with_post_code_prefix('LS1').categorize_LS1_cafes
    StreetCafe.with_post_code_prefix('LS2').categorize_LS2_cafes
    StreetCafe.categorize_post_code_outliers

  end
end
