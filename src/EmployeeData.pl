:- use_module(library(csv)).

% Predicate to read data from a CSV file and store it as rules
read_csv_and_store(Filename) :-
    csv_read_file(Filename, Rows, []),
    process_rows(Rows).

% Process each row in the CSV file and store data as rules
process_rows([]).
process_rows([Row|Rows]) :-
    process_row(Row),
    process_rows(Rows).

% Store data from a row as a rule
process_row(row(EEID, FullName, JobTitle, Department, BusinessUnit, Gender, Ethnicity, Age, HireDate, AnnualSalary, BonusPercent, Country, City, ExitDate)) :-
    assert(employee(EEID, FullName, JobTitle, Department, BusinessUnit, Gender, Ethnicity, Age, HireDate, AnnualSalary, BonusPercent, Country, City, ExitDate)).

% Rule to determine if an employee is working in Seattle
is_seattle_employee(Name) :-
    employee(_, Name, _, _, _, _, _, _, _, _, _, _, 'Seattle', _).

% Rule to determine if an employee is Senior Manager in the IT department
is_senior_manager_in_IT(Name) :-
    employee(_, Name, 'Sr. Manger', 'IT', _, _, _, _, _, _, _, _, _, _).

% Rule to determine if an employee is Director in the Finance department and works in Miami
is_director_finance_miami(Name) :-
    employee(_, Name, 'Director', 'Finance', _, _, _, _, _, _, _, _, 'Miami', _).

% Rule to determine if an employee is from the United States, works in manufacturing, Asian, Male, and older than 40
is_asian_US_manufacturing_40M(Name, BusinessUnit, Gender, Ethnicity, Age) :-
    employee(_, Name, _, _, BusinessUnit, Gender, Ethnicity, Age, _, _, _, 'United States', _, _),
    BusinessUnit = 'Manufacturing',
    Gender = 'Male',
    Ethnicity = 'Asian',
    Age > 40.

% Rule to greet an employee
greet(EEID) :-
    employee(EEID, Name, JobTitle, Department, BusinessUnit, _, _, _, _, _, _, _, _, _),
    format('Hello, ~w, ~w of ~w, ~w!~n', [Name, JobTitle, Department, BusinessUnit]).

% Rule to remove header row with column names
retract_header :-
    retract(employee('EEID', _, _, _, _, _, _, _, _, _, _, _, _, _)).

% Rule to compute years until retirement
years_until_retirement(Name, Age, Years_to_retire) :-
    employee(_, Name, _, _, _, _, _, Age, _, _, _, _, _, _),
    Years_to_retire is 65 - Age.

% Rule to determine Research & Development employees with Black ethnicity, within ages of 25-50
is_rd_black_midAge(Name, BusinessUnit, Ethnicity, Age) :-
    employee(_, Name, _, _, BusinessUnit, _, Ethnicity, Age, _, _, _, _, _, _),
    BusinessUnit = 'Research & Development',
    Ethnicity = 'Black',
    Age >= 25,
    Age =< 50.

% Rule to determine if employee is from IT or Finance, AND from Phoenix or Miami or Austin
is_ITorFin_PHXorMIAorAUS(Name, Department, City) :-
    employee(_, Name, _, Department, _, _, _, _, _, _, _, _, City, _),
    (Department = 'IT' ; Department = 'Finance'),
    (City = 'Phoenix' ; City = 'Miami' ; City = 'Austin').

% Rule to determine female employees in senior roles
is_female_senior_role(Name, JobTitle) :-
    employee(_, Name, JobTitle, _, _, 'Female', _, _, _, _, _, _, _, _),
    atom_concat('Sr.', _, JobTitle).

% Rule to determine if employee is highly paid Senior Manager
is_highly_paid_senior_manager(Name, Salary) :-
    employee(_, Name, 'Sr. Manger', _, _, _, _, _, _, AnnualSalary, _, _, _, _),
    extract_salary(AnnualSalary, Salary),
    Salary > 120000.

% Helper predicate extracts salary
extract_salary(AnnualSalary, Salary) :-
    string_chars(AnnualSalary, Chars),
    exclude(bad_chars, Chars, Ints),
    string_chars(String, Ints),
    atom_number(String, Salary).
bad_chars(Chars) :-
    member(Chars, [',', '$', ' ']).

% Rule to determine if employees age is prime number
is_prime_age(Name, Age) :-
    employee(_, Name, _, _, _, _, _, Age, _, _, _, _, _, _),
    is_prime(Age).
is_prime(X) :-
    X > 2,
    X mod 2 =\= 0,
    \+ divisible(X, 3).
divisible(X, Y) :-
    X mod Y =:= 0.
divisible(X, Y) :-
    Y * Y < X,
    Y1 is Y + 2,
    divisible(X, Y1).

% Rule to determine average salary for specified job title
average_salary(JobTitle, Salary) :-
    findall(NumSalary, (employee(_, _, JobTitle, _, _, _, _, _, _, AnnualSalary, _, _, _, _),
       extract_salary(AnnualSalary, NumSalary)), AnnualSalaries),
    sum_list(AnnualSalaries, SalaryTotal),
    length(AnnualSalaries, ListLength),
    ListLength > 0,
    Salary is SalaryTotal / ListLength.

% Rule to compute total salary of person
total_salary(Name, Salary) :-
    employee(_, Name, _, _, _, _, _, _, _, AnnualSalaryS, BonusPercentS, _, _, _),
    extract_salary(AnnualSalaryS, AnnualSalary),
    extract_bonus(BonusPercentS, BonusPercent),
    TotalSalary is AnnualSalary + (AnnualSalary * (BonusPercent / 100)),
    Salary is TotalSalary.

% Helper predicate extracts bonus
extract_bonus(BonusPercentS, BonusPercent) :-
    string_chars(BonusPercentS, Chars),
    exclude(bad_char, Chars, Ints),
    string_chars(String, Ints),
    atom_number(String, BonusPercent).
bad_char(Char) :-
    member(Char, ['%']).

% Rule to determine take-home salary after tax
takehome_salary(Name, JobTitle, TakeHomeSalary) :-
    total_salary(Name, AnnualSalary),
    tax_percentage(AnnualSalary, TaxPercent),
    TotalSalary is AnnualSalary,
    TakeHomeSalary is TotalSalary - (TotalSalary * (TaxPercent / 100)).

% Helper predicate determines tax percentage
tax_percentage(AnnualSalary, TaxPercent) :-
    ( AnnualSalary =< 50000 -> TaxPercent = 20 ;
    AnnualSalary > 50000, AnnualSalary =< 100000 -> TaxPercent = 25 ;
    AnnualSalary > 100000, AnnualSalary =< 200000 -> TaxPercent = 30 ;
    AnnualSalary > 200000 -> TaxPercent = 35 ).

% Rule to determine total years of service
total_years(Name, Years) :-
    employee(_, Name, _, _, _, _, _, _, HireDate, _, _, _, _, ExitDate),
    extract_year(HireDate, HireYear),
    ( ExitDate = '' -> extract_current_year(CurrentYear), Years is CurrentYear - HireYear ;
    extract_year(ExitDate, ExitYear), Years is ExitYear - HireYear ).

% Helper predicate extracts year
extract_year(Date, Year) :-
    sub_string(Date, _, 2, 0, String),
    atom_number(String, FullYear),
    ( FullYear >= 50 -> Year is FullYear + 1900 ;
    Year is FullYear + 2000 ).

% Helper predicate extracts current year
extract_current_year(CurrentYear) :-
    get_time(Stamp),
    stamp_date_time(Stamp, DateTime, local),
    date_time_value(year, DateTime, CurrentYear).



