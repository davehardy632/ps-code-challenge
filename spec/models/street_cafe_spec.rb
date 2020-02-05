require 'rails_helper'

describe StreetCafe, type: :model do
  describe "Validations" do
    it {should validate_presence_of :name}
    it {should validate_presence_of :street_address}
    it {should validate_presence_of :post_code}
    it {should validate_presence_of :number_of_chairs}
  end

  describe "Class Methods" do

      let!(:cafe_1) { StreetCafe.create(name: "Cafe 1", street_address: "12th st", post_code: "LS1 5BN", number_of_chairs: 3) }
      let!(:cafe_2) { StreetCafe.create(name: "Cafe 2", street_address: "13th st", post_code: "LS1 5CN", number_of_chairs: 11) }
      let!(:cafe_3) { StreetCafe.create(name: "Cafe 2", street_address: "13th st", post_code: "LS1 5CN", number_of_chairs: 101) }

      let!(:cafe_4) { StreetCafe.create(name: "Cafe 3", street_address: "14th st", post_code: "LS2 5DN", number_of_chairs: 5) }
      let!(:cafe_5) { StreetCafe.create(name: "Cafe 4", street_address: "15th st", post_code: "LS2 5DN", number_of_chairs: 6) }

      let!(:cafe_6) { StreetCafe.create(name: "Cafe 5", street_address: "16th st", post_code: "LS10 5DN", number_of_chairs: 7) }
      let!(:cafe_7) { StreetCafe.create(name: "Cafe 6", street_address: "17th st", post_code: "LS7 5DN", number_of_chairs: 8) }

      let!(:ls1_cafes) { StreetCafe.with_post_code_prefix('LS1')}
      let!(:ls2_cafes) { StreetCafe.with_post_code_prefix('LS2')}

      let!(:categorized_ls1_cafes) {ls1_cafes.categorize_LS1_cafes}
      let!(:categorized_ls2_cafes) {ls2_cafes.categorize_LS2_cafes}

      let!(:concatenated_ls1_cafes) {ls1_cafes.concat_category_and_name}


    it "Returns street cafes when passed a valid prefix parameter" do

      expect(StreetCafe.with_post_code_prefix('LS1')).to eq([cafe_1, cafe_2, cafe_3])
      expect(StreetCafe.with_post_code_prefix('LS2')).to eq([cafe_4, cafe_5])
    end


    it "Categorizes street cafes with a post code prefix of LS1 and LS2" do

      expect(ls1_cafes.categorize_LS1_cafes.first.category).to eq("ls1 small")
      expect(ls1_cafes.categorize_LS1_cafes.second.category).to eq("ls1 medium")
      expect(ls1_cafes.categorize_LS1_cafes.third.category).to eq("ls1 large")

      expect(ls2_cafes.categorize_LS2_cafes.first.category).to eq("ls2 small")
      expect(ls2_cafes.categorize_LS2_cafes.second.category).to eq("ls2 large")
    end


    it "Categorizes street cafes with a post code outlier 'NOT LS1 or LS2'" do

      expect(StreetCafe.categorize_post_code_outliers.first).to eq(cafe_6)
      expect(StreetCafe.categorize_post_code_outliers.first.category).to eq("other")

      expect(StreetCafe.categorize_post_code_outliers.last).to eq(cafe_7)
      expect(StreetCafe.categorize_post_code_outliers.last.category).to eq("other")
    end

    it "Calculates the 50th percentile of numbers of chairs on a street cafe dataset" do


      expect(StreetCafe.with_post_code_prefix('LS2').chair_numbers_percentile_50).to eq(5.5)

      StreetCafe.create(name: "Cafe 2", street_address: "13th st", post_code: "LS2 5CN", number_of_chairs: 7)

      expect(StreetCafe.with_post_code_prefix('LS2').chair_numbers_percentile_50).to eq(6)
    end


    it "Returns street cafes by categorical size" do

      expect(StreetCafe.return_by_size("small").sort).to eq([cafe_1, cafe_4])
      expect(StreetCafe.return_by_size("medium").sort).to eq([cafe_2])
      expect(StreetCafe.return_by_size("large").sort).to eq([cafe_3, cafe_5])
    end


    it "Concatenates the category to the beginning of the name on a street cafe dataset" do

      expect(concatenated_ls1_cafes.sort.first.name).to eq("ls1 small Cafe 1")
      expect(concatenated_ls1_cafes.sort.second.name).to eq("ls1 medium Cafe 2")
      expect(concatenated_ls1_cafes.sort.third.name).to eq("ls1 large Cafe 2")
    end
  end
end
