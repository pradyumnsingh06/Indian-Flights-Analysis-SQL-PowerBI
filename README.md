Indian Domestic Flights Analysis (SQL & Power BI)

Project Overview
This project is an end-to-end analysis of a large dataset containing over 300,000 domestic Indian flight records. The primary goal was to perform a complete data cleaning and preparation process using MySQL and then build an interactive two-page dashboard in Power BI to answer key business questions about airline pricing and operational efficiency.

The analysis focuses on two core questions:

Pricing & Competitiveness: What are the key drivers of flight prices, and how do airlines compare?

Route & Efficiency: What are the busiest routes, and which airlines are the most time-efficient?

Dashboard Preview
Here is a preview of the final two-page interactive dashboard built in Power BI.

[Page 1: Pricing & Competitiveness Analysis](https://raw.githubusercontent.com/pradyumnsingh06/Indian-Flights-Analysis-SQL-PowerBI/main/Screenshot%202025-07-28%20181038.png)

[Page 2: Route & Efficiency Analysis](https://raw.githubusercontent.com/pradyumnsingh06/Indian-Flights-Analysis-SQL-PowerBI/main/Screenshot%202025-07-28%20181027.png)

The SQL Data Cleaning Process
The raw dataset was split into two messy CSV files (economy.csv and business.csv) and required significant cleaning and transformation in MySQL before it could be used for analysis. The following steps were performed:

Combine Datasets: Used UNION ALL to merge the two tables into a single master table (combined_flights), creating a new class column to preserve the distinction.

Clean price Column: Used a combination of REPLACE, TRIM, and CAST to remove non-numeric characters (commas, spaces) and convert the price from a text string to a numeric data type.

Clean stop Column: Implemented a robust CASE statement to handle multiple inconsistent text formats (e.g., "non-stop", "1-stop ", "2+ stops") and convert them into clean integers (0, 1, 2).

Clean time_taken Column: This was the most complex cleaning task. An advanced query using REGEXP_SUBSTR was developed to parse complex text strings (e.g., "2h 50m", "1.03h", "50m") and calculate a single, clean duration_minutes value for each flight.

Clean Date/Time Columns: Used STR_TO_DATE and CAST to convert text-based dates and times into proper DATE and TIME formats, enabling time-based analysis.

Feature Engineering: Created a new flight_number column by concatenating the ch_code and num_code columns to provide a unique flight identifier.

Key Findings & Recommendations
Finding 1: Price is Driven by a Clear Hierarchy of Class, Stops, and Route
Analysis: The dashboard clearly shows that Business class is significantly more expensive than Economy. Each additional stop adds a predictable and substantial cost to the ticket. The most expensive routes are all between major metro hubs like Delhi, Mumbai, and Bangalore.

Recommendation: Travelers can find the best prices by booking non-stop, economy tickets on budget carriers. Airlines' pricing models are well-defined, and they should focus on either a low-cost or premium-service strategy.

Finding 2: Airlines Compete on Schedule, Not Speed
Analysis: While initial analysis suggested large differences in flight times, a deeper look at non-stop flights revealed that all major airlines have nearly identical in-air durations on the same routes. The key differentiator is not speed, but which airline offers the most non-stop options on the busiest routes.

Recommendation: For airlines, the competitive advantage on high-traffic routes comes from offering a greater frequency of non-stop flights at convenient times. For travelers, the choice between direct flights should be based on price and schedule, not perceived speed.

Tools Used
MySQL: For all data cleaning, transformation, and initial analysis.

Power BI: For creating the final interactive dashboard and visualizations.

DAX: For creating calculated columns (e.g., Route) within Power BI.
