require 'csv'

namespace :import do
  desc "Categorize street cafes based on number of chairs"
  task categorize_cafes: :environment do
    ls1_small = 'ls1 small'
    ls1_medium = 'ls1 medium'
    ls1_large = 'ls1 large'

    ls2_small = 'ls2 small'
    ls2_large = 'ls2 large'

    other = 'other'

    ls1_cafes = StreetCafe.with_post_code_prefix('LS1')
    ls2_cafes = StreetCafe.with_post_code_prefix('LS2')
    other_cafes = StreetCafe.post_code_outliers

    # other_cafes.each do |cafe|
    #   cafe.update_column(:category, 'other')
    # end
    #
    # ls1_cafes.each do |cafe|
    #   if cafe.number_of_chairs < 10
    #     cafe.update_column(:category, "ls1 small")
    #   elsif cafe.number_of_chairs >= 10 && cafe.number_of_chairs < 100
    #     cafe.update_column(:category, "ls1 medium")
    #   elsif cafe.number_of_chairs >= 100
    #     cafe.update_column(:category, "ls1 large")
    #   end
    # end

    ls2_cafes.each do |cafe|
      if cafe.number_of_chairs < percentile
        cafe.update_column(:category, 'ls2 small')
      elsif cafe.number_of_chairs > percentile
        cafe.update_column(:category, 'ls2 large')
      end
    end

  end
end
