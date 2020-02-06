# GoSpotCheck Code Challenge

#### This challenge was completed using PostgreSQL version 12.1 and Rails 5.2.4.1

## Views

### Post Code Info View

*I was able to verify the post_code_info view by comparing queries run on both the street_cafes table, and the post code info view and then comparing the return values.*

**SQL Below**

```
CREATE VIEW post_code_info
              AS
              WITH summary AS (
                SELECT
                    c.post_code,
                    c.number_of_chairs,
                    c.name,
                    ROW_NUMBER() OVER(PARTITION BY c.post_code ORDER BY c.number_of_chairs DESC) as ck
                 FROM street_cafes c)
              SELECT s.post_code, agg_tbl.total_places, agg_tbl.total_chairs, agg_tbl.chairs_pct, s.name as place_with_max_chairs, s.number_of_chairs as max_chairs
              FROM summary s
              INNER JOIN (SELECT post_code,
                                   SUM(number_of_chairs) as total_chairs,
                                   CAST((CAST(sum(street_cafes.number_of_chairs) as Float) / CAST((SELECT SUM(number_of_chairs) FROM street_cafes) as Float) * 100) as DECIMAL(10,2)) as chairs_pct,
                                   count(street_cafes.post_code) as total_places
                                   FROM street_cafes GROUP BY post_code) agg_tbl ON (agg_tbl.post_code = s.post_code)
              WHERE s.ck = 1;
```
### Categories Info View

**SQL Below**

```
CREATE VIEW categories_info
              AS
                SELECT street_cafes.category              AS category,
                       Count(street_cafes.post_code)      AS total_places,
                       Sum(street_cafes.number_of_chairs) AS total_chairs
                FROM   street_cafes
                GROUP  BY street_cafes.category;
```

## Scripts / Rake Tasks

*Each script is written and executed within a rake task.*
*They are tested at Unit and Integration levels*
*The methods used in each script are located in the StreetCafe Model*

Unit Testing

*Each individual method is tested independently in a model spec located at the file path below*

```/spec/models/street_cafe_spec.rb```

Integration Testing

*The rake tasks are tested and run in succession at the file path below*

```spec/tasks/rake_tasks_spec.rb```

### Importing The Street Cafes CSV

Rake Task Name

```import:street_cafe_csv```

### Categorizing Street Cafes Based on Post Code Prefix and Number of Chairs

Methods Used

 ```with_post_code_prefix()``` 

 ```categorize_LS1_cafes```

 ```categorize_LS2_cafes```

 ```categorize_post_code_outliers```
 
Rake Task Name
 
 ```categorize:street_cafes```

### Exporting and Deleting Street Cafes Categorized as Small

Methods Used

```return_by_size()```

```write_to_csv```

Rake Task Name

```export_and_delete:small_street_cafes```

### Concatenating the Category to the Beginning of the Name on all Street Cafes Categorized as Medium or Large

Methods Used

```return_by_size```

```concat_category_and_name```

Rake Task Name

```concatenate:med_and_large_cafe_names```

## Instructions

1. Clone the Repository

2. Run ```bundle``` for gems and dependencies

3. Run ```rails g rspec:install``` for the RSpec test suite

4. Run ```rails db:create``` then ```rails db:migrate``` 

5. At this point run ```rake import:street_cafe_csv``` to populate the database with the street cafe csv data

6. The post_code_info view can now be accessed and queried via ``psql ps-code-challenge_development```

7. Run ```categorize:street_cafes``` to categorize street cafes based on post_code prefix and number of chairs

8. The categories_info view can now be accessed and queried via ```psql ps-code-challenge_development```

9. Run ```export_and_delete:small_street_cafes``` to export the street cafes categorized as 'small' to a csv file, and then delete the records. The csv will generate within the ```csv_export_files``` folder. The full path will be ```csv_export_files/small_street_cafes``` 

> Additionally, you can pass in an optional argument when running this task, this argument allows the exported csv file to be renamed, as long as it is followed by ```.csv``` and is wrapped in single quotes. EX: ```rake 'export_and_delete:small_street_cafes['new_file.csv']'```

10. Run ```concatenate:med_and_large_cafe_names``` to concatenate the category to the beginning of the name on all street cafes categorized as medium or large

## Testing

The testing suite can be run in its entirety by running ```rspec```

For individual test files you can run ```rspec spec/<FILE_PATH>```
