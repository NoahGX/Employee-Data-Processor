# Employee Data Processor

## Overview
This Prolog program is designed to manipulate and query employee data stored in CSV format. It includes a variety of predicates that perform specific tasks such as computing salaries, determining job titles, and checking employee details based on various criteria like location, department, and demographic attributes.

## Features
  - **CSV Integration**: Read and process employee data directly from CSV files.
  - **Data Querying**: Various predicates to query data such as checking if an employee works in Seattle or is a senior manager in IT.
  - **Advanced Data Manipulation**: Calculate total salary, determine years until retirement, and check demographic-specific attributes.
  - **Dynamic Rule Application**: Use employee data to apply rules dynamically for reporting and insights.

## Usage
To run this project:
  - Open the Prolog environment
    ```
    swipl
    ```
  - Load the Prolog program in your Prolog environment.
  - Ensure a CSV file with the appropriate structure is available.
  - Call the `read_csv_and_store` predicate to load and process the CSV data into Prolog rules.
  - Use any of the provided predicates to query or manipulate the employee data as required.

## Prerequisites
  - **Prolog Environment**: SWI-Prolog or compatible environment capable of using the `library(csv)` module.
  - **CSV File**: A CSV file with employee data structured in the following columns: `EEID, FullName, JobTitle, Department, BusinessUnit, Gender, Ethnicity, Age, HireDate, AnnualSalary, BonusPercent, Country, City, ExitDate`.

## Input
**CSV File**: The input CSV file should contain headers matching the order and names described in the Prerequisites section. Ensure the file does not have formatting errors such as extra commas or missing data in required fields.

## Output
  - **Query Results**: Depending on the predicate used, the output could range from printed messages (e.g., greetings to employees) to computed values (e.g., total salary, years until retirement).
  - **Data Assertions**: Employee data from the CSV is asserted into the Prolog database, allowing dynamic queries and manipulation.

## Notes
  - Ensure that the employee data used complies with data privacy laws and regulations applicable to your region or industry.
  - For large datasets, the processing and querying performance may vary. Consider optimizing the CSV file size and structure if performance issues arise.
  - Minimal error handling is implemented. Users should ensure that the input data format strictly follows the expected schema to avoid runtime errors.