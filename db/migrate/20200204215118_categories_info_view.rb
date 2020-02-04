class CategoriesInfoView < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      dir.up do
        execute <<-SQL
        CREATE VIEW categories_info
              AS
                SELECT street_cafes.category              AS category,
                       Count(street_cafes.post_code)      AS total_places,
                       Sum(street_cafes.number_of_chairs) AS total_chairs
                FROM   street_cafes
                GROUP  BY street_cafes.category;
        SQL
      end

      dir.down do
        execute <<-SQL
          DROP VIEW IF EXISTS categories_info;
        SQL
      end
    end
  end
end
