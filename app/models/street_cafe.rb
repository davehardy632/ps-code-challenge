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



end
