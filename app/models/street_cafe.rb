class StreetCafe < ApplicationRecord
  validates_presence_of :name,
                        :street_address,
                        :post_code,
                        :number_of_chairs


  def self.with_post_code_prefix(prefix)
    prefix = prefix + " "
    where("post_code LIKE ?", "#{prefix}%")
  end

  def self.categorize_LS1_cafes
    cafes = self.all
    cafes.each do |cafe|
      if cafe.number_of_chairs < 10
        cafe.update_column(:category, "ls1 small")
      elsif cafe.number_of_chairs >= 10 && cafe.number_of_chairs < 100
        cafe.update_column(:category, "ls1 medium")
      elsif cafe.number_of_chairs >= 100
        cafe.update_column(:category, "ls1 large")
      end
    end
  end

  def self.categorize_LS2_cafes
    cafes = self.all
    num_of_chairs_50th_percentile = cafes.chair_numbers_percentile_50
    cafes.each do |cafe|
      if cafe.number_of_chairs < num_of_chairs_50th_percentile
        cafe.update_column(:category, 'ls2 small')
      elsif cafe.number_of_chairs > num_of_chairs_50th_percentile
        cafe.update_column(:category, 'ls2 large')
      end
    end
  end

  def self.categorize_post_code_outliers
    cafes = where.not("post_code LIKE 'LS1 %' OR post_code LIKE 'LS2 %'")
    cafes.each do |cafe|
      cafe.update_column(:category, 'other')
    end
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

  def self.return_by_size(size)
    where("category LIKE ?", "%#{size}")
  end

  def self.concat_category_and_name
    all.each do |cafe|
      new_name = cafe.category + " " +  cafe.name
      cafe.update_column(:name, new_name)
    end
  end

  def self.to_csv(options = {})
    CSV.generate(options) do |csv_file|
      csv_file << csv_header_row
      all.each do |restaurant|
        csv_file << restaurant.to_csv
      end
    end
  end

  def to_csv
    [id, name, street_address, post_code, number_of_chairs, category]
  end

  def self.csv_header_row
    %w(ID Name Street_Address Post_Code Number_of_chairs Category)
  end


end
