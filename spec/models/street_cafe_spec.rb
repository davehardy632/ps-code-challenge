require 'rails_helper'

describe StreetCafe, type: :model do
  describe "Validations" do
    it {should validate_presence_of :name}
    it {should validate_presence_of :street_address}
    it {should validate_presence_of :post_code}
    it {should validate_presence_of :number_of_chairs}
  end

  describe "Class Methods" do

      let!(:cafe_1) { StreetCafe.create(name: "Cafe 1", street_address: "12th st", post_code: "LS1 5BN", number_of_chairs: 3, category: "LS1 small") }
      let!(:cafe_2) { StreetCafe.create(name: "Cafe 2", street_address: "13th st", post_code: "LS1 5CN", number_of_chairs: 4, category: "LS1 small") }

      let!(:cafe_3) { StreetCafe.create(name: "Cafe 3", street_address: "14th st", post_code: "LS2 5DN", number_of_chairs: 5, category: "LS1 medium") }
      let!(:cafe_4) { StreetCafe.create(name: "Cafe 4", street_address: "15th st", post_code: "LS2 5DN", number_of_chairs: 6, category: "LS1 medium") }

      let!(:cafe_5) { StreetCafe.create(name: "Cafe 5", street_address: "16th st", post_code: "LS10 5DN", number_of_chairs: 7, category: "LS1 large") }
      let!(:cafe_6) { StreetCafe.create(name: "Cafe 5", street_address: "16th st", post_code: "LS7 5DN", number_of_chairs: 8, category: "LS1 large") }


    it "Returns Cafes based on a prefix" do
binding.pry
      expect(StreetCafe.with_post_code_prefix('LS1')).to eq([cafe_1, cafe_2])
      expect(StreetCafe.with_post_code_prefix('LS2')).to eq([cafe_3, cafe_4])
    end


    it "Returns Cafes without a LS1 or LS2 prefix" do

      expect(StreetCafe.post_code_outliers).to eq([cafe_5, cafe_6])
    end


    it "Calculates the 50th percentile of numbers of chairs in a data set of street cafes" do


      expect(StreetCafe.chair_numbers_percentile_50).to eq(5.5)

      cafe_5 = StreetCafe.create(name: "Cafe 2", street_address: "13th st", post_code: "LS1 5CN", number_of_chairs: 9)

      expect(StreetCafe.chair_numbers_percentile_50).to eq(6)

      cafe_6 = StreetCafe.create(name: "Cafe 2", street_address: "13th st", post_code: "LS1 5CN", number_of_chairs: 10)

      expect(StreetCafe.chair_numbers_percentile_50).to eq(6.5)
    end


    it "Returns Street Cafes by categorical size" do

      expect(StreetCafe.return_by_size("small")).to eq([cafe_1, cafe_2])
      expect(StreetCafe.return_by_size("medium")).to eq([cafe_3, cafe_4])
      expect(StreetCafe.return_by_size("large")).to eq([cafe_5, cafe_6])
    end


    it "Concatenates the category to the beginning of the name on a street cafe dataset" do

      small_cafes = StreetCafe.return_by_size("small")

      concatenated_result = small_cafes.concat_category_and_name

      expect(concatenated_result.first.name).to eq("LS1 small Cafe 1")
      expect(concatenated_result.second.name).to eq("LS1 small Cafe 2")
    end
  end
end
