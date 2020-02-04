require 'rails_helper'

describe StreetCafe, type: :model do
  describe "Validations" do
    it {should validate_presence_of :name}
    it {should validate_presence_of :street_address}
    it {should validate_presence_of :post_code}
    it {should validate_presence_of :number_of_chairs}
  end

  describe "Class Methods" do
    it "Returns Cafes based on a prefix" do
      cafe_1 = StreetCafe.create(name: "Cafe 1", street_address: "12th st", post_code: "LS1 5BN", number_of_chairs: 3)
      cafe_2 = StreetCafe.create(name: "Cafe 2", street_address: "13th st", post_code: "LS1 5CN", number_of_chairs: 3)

      cafe_3 = StreetCafe.create(name: "Cafe 3", street_address: "14th st", post_code: "LS2 5DN", number_of_chairs: 3)
      cafe_4 = StreetCafe.create(name: "Cafe 4", street_address: "15th st", post_code: "LS2 5DN", number_of_chairs: 3)

      cafe_5 = StreetCafe.create(name: "Cafe 5", street_address: "16th st", post_code: "LS10 5DN", number_of_chairs: 3)
      cafe_6 = StreetCafe.create(name: "Cafe 5", street_address: "16th st", post_code: "LS7 5DN", number_of_chairs: 3)

      expect(StreetCafe.with_post_code_prefix('LS1')).to eq([cafe_1, cafe_2])
      expect(StreetCafe.with_post_code_prefix('LS2')).to eq([cafe_3, cafe_4])
    end

    it "Returns Cafes without a LS1 or LS2 prefix" do
      cafe_1 = StreetCafe.create(name: "Cafe 1", street_address: "12th st", post_code: "LS1 5BN", number_of_chairs: 3)
      cafe_2 = StreetCafe.create(name: "Cafe 2", street_address: "13th st", post_code: "LS2 5DN", number_of_chairs: 3)

      cafe_3 = StreetCafe.create(name: "Cafe 3", street_address: "14th st", post_code: "LS10 5DN", number_of_chairs: 3)
      cafe_4 = StreetCafe.create(name: "Cafe 4", street_address: "15th st", post_code: "LS7 5DN", number_of_chairs: 3)

      expect(StreetCafe.post_code_outliers).to eq([cafe_3, cafe_4])
    end
  end
end
