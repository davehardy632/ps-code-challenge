require 'csv'

namespace :import do
  desc "Categorize street cafes based on number of chairs"
  task categorize_cafes: :environment do

    StreetCafe.with_post_code_prefix('LS1').categorize_LS1_cafes
    StreetCafe.with_post_code_prefix('LS2').categorize_LS2_cafes
    StreetCafe.categorize_post_code_outliers

  end
end
