class StreetCafe < ApplicationRecord
  validates_presence_of :name,
                        :street_address,
                        :post_code,
                        :number_of_chairs


  def self.with_post_code_prefix(prefix)
    add_whitespace = prefix + " "
    where("post_code LIKE ?", "#{add_whitespace}%")
  end

  def self.post_code_outliers
    where.not("post_code LIKE 'LS1 %' OR post_code LIKE 'LS2 %'")
  end

  def self.chair_numbers_percentile_50
    sorted_number_of_chairs = pluck(:number_of_chairs).sort
    index = (sorted_number_of_chairs.length * 0.5)
    if index.floor == index
      (sorted_number_of_chairs[index.to_i - 1] + sorted_number_of_chairs[index.to_i]) / 2.0
    else
      sorted_number_of_chairs[index.ceil - 1]
    end
  end



end
