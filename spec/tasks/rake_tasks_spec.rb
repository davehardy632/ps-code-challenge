require 'rails_helper'
require 'rake'
Rails.application.load_tasks

describe "Rake Tasks" do

  let!(:cafe_1) { StreetCafe.create(name: "Cafe 1", street_address: "12th st", post_code: "LS1 5BN", number_of_chairs: 3) }
  let!(:cafe_2) { StreetCafe.create(name: "Cafe 2", street_address: "13th st", post_code: "LS1 5CN", number_of_chairs: 11) }
  let!(:cafe_3) { StreetCafe.create(name: "Cafe 3", street_address: "13th st", post_code: "LS1 5CN", number_of_chairs: 101) }

  let!(:cafe_4) { StreetCafe.create(name: "Cafe 4", street_address: "14th st", post_code: "LS2 5DN", number_of_chairs: 5) }
  let!(:cafe_5) { StreetCafe.create(name: "Cafe 5", street_address: "15th st", post_code: "LS2 5DN", number_of_chairs: 6) }

  let!(:cafe_6) { StreetCafe.create(name: "Cafe 6", street_address: "16th st", post_code: "LS10 5DN", number_of_chairs: 7) }
  let!(:cafe_7) { StreetCafe.create(name: "Cafe 7", street_address: "17th st", post_code: "LS7 5DN", number_of_chairs: 8) }

  describe "categorize:street_cafes" do
    it "Executes each rake task in succession" do

      Rake::Task['categorize:street_cafes'].execute

      expect(cafe_1.reload.category).to eq("ls1 small")
      expect(cafe_2.reload.category).to eq("ls1 medium")
      expect(cafe_3.reload.category).to eq("ls1 large")

      expect(cafe_4.reload.category).to eq("ls2 small")
      expect(cafe_5.reload.category).to eq("ls2 large")

      expect(cafe_6.reload.category).to eq("other")
      expect(cafe_7.reload.category).to eq("other")
    end

    describe "concatenate:med_and_large_cafe_names" do
      it "Concatenates the category to the beginning of the name in medium and large street cafes" do

      Rake::Task['categorize:street_cafes'].execute
      Rake::Task['concatenate:med_and_large_cafe_names'].execute

      expect(cafe_1.reload.name).to eq("Cafe 1")
      expect(cafe_2.reload.name).to eq("ls1 medium Cafe 2")
      expect(cafe_3.reload.name).to eq("ls1 large Cafe 3")
      expect(cafe_4.reload.name).to eq("Cafe 4")
      expect(cafe_5.reload.name).to eq("ls2 large Cafe 5")
      expect(cafe_6.reload.name).to eq("Cafe 6")
      expect(cafe_7.reload.name).to eq("Cafe 7")

      end
    end

    describe "export_and_delete:small_street_cafes" do
      it "Exports the data from small street cafes to a csv file, and then deletes the small cafe records" do

        expect(StreetCafe.count).to eq(7)

        Rake::Task['categorize:street_cafes'].execute
        Rake::Task['export_and_delete:small_street_cafes'].invoke("test_file.csv")

        expect(StreetCafe.count).to eq(5)

        expect(File.exist?("csv_export_files/test_file.csv")).to eq(true)
        contents = CSV.read("csv_export_files/test_file.csv")

        # 2 small cafes plus the headers row makes a length of 3
        expect(contents.length).to eq(3)
        # testing headers in the csv file, when sorted the headers are the last array element
        expect(contents.sort.last).to eq(["ID", "Name", "Street_Address", "Post_Code", "Number_of_chairs", "Category"])
        # testing first small cafe
        # expect(contents.sort[1][1]).to eq("Cafe 1")
        expect(contents.sort[0][5]).to eq("ls1 small")
        # testing second small cafe category
        # expect(contents.sort[2][1]).to eq("Cafe 4")
        expect(contents.sort[1][5]).to eq("ls2 small")

        File.delete("csv_export_files/test_file.csv")
      end
    end
  end
end
