class PostCodeInfoView < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      dir.up do
        execute <<-SQL
        CREATE VIEW post_code_info
              AS
              WITH summary AS (
                SELECT
                    c.post_code,
                    c.number_of_chairs,
                    c.name,
                    ROW_NUMBER() OVER(PARTITION BY c.post_code ORDER BY c.number_of_chairs DESC) as ck
                 FROM street_cafes c)
              SELECT s.post_code, agg_tbl.total_places, agg_tbl.total_chairs, agg_tbl.chairs_pct, s.name as max_chairs, s.number_of_chairs as place_with_max_chairs
              FROM summary s
              INNER JOIN (SELECT post_code,
                                   SUM(number_of_chairs) as total_chairs,
                                   CAST((CAST(sum(street_cafes.number_of_chairs) as Float) / CAST((SELECT SUM(number_of_chairs) FROM street_cafes) as Float) * 100) as DECIMAL(10,2)) as chairs_pct,
                                   count(street_cafes.post_code) as total_places
                                   FROM street_cafes GROUP BY post_code) agg_tbl ON (agg_tbl.post_code = s.post_code)
              WHERE s.ck = 1;
        SQL
      end

      dir.down do
        execute <<-SQL
          DROP VIEW IF EXISTS post_code_info;
        SQL
      end
    end
  end
end
