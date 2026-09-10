CREATE TABLE region (
    region_id INTEGER PRIMARY KEY,
    region_name VARCHAR(50) NOT NULL UNIQUE
);


CREATE TABLE customer (
    customer_id VARCHAR(6) PRIMARY KEY,
    date_of_birth DATE NOT NULL,
    region_id INTEGER NOT NULL,

    CONSTRAINT fk_customer_region
        FOREIGN KEY (region_id)
        REFERENCES region(region_id)
);


CREATE TABLE customer_employment (
    employment_id INTEGER PRIMARY KEY,
    customer_id VARCHAR(6) NOT NULL,
    employment_status VARCHAR(50) NOT NULL,
    monthly_income NUMERIC(12,2) NOT NULL,
    valid_from DATE NOT NULL,
    valid_to DATE,

    CONSTRAINT fk_employment_customer
        FOREIGN KEY (customer_id)
        REFERENCES customer(customer_id),

    CONSTRAINT chk_monthly_income
        CHECK (monthly_income >= 0),

    CONSTRAINT chk_employment_dates
        CHECK (
            valid_to IS NULL
            OR valid_to >= valid_from
        )
);


CREATE TABLE loan_type (
    loan_type_id INTEGER PRIMARY KEY,
    loan_type_name VARCHAR(50) NOT NULL UNIQUE
);


CREATE TABLE loan (
    loan_id VARCHAR(7) PRIMARY KEY,
    customer_id VARCHAR(6) NOT NULL,
    loan_type_id INTEGER NOT NULL,
    original_amount NUMERIC(12,2) NOT NULL,
    current_balance NUMERIC(12,2) NOT NULL,
    interest_rate NUMERIC(5,2) NOT NULL,
    monthly_payment NUMERIC(12,2) NOT NULL,
    late_payments INTEGER NOT NULL,
    default_flag BOOLEAN NOT NULL,

    CONSTRAINT fk_loan_customer
        FOREIGN KEY (customer_id)
        REFERENCES customer(customer_id),

    CONSTRAINT fk_loan_type
        FOREIGN KEY (loan_type_id)
        REFERENCES loan_type(loan_type_id),

    CONSTRAINT chk_original_amount
        CHECK (original_amount > 0),

    CONSTRAINT chk_current_balance
        CHECK (
            current_balance >= 0
            AND current_balance <= original_amount
        ),

    CONSTRAINT chk_interest_rate
        CHECK (
            interest_rate >= 0
            AND interest_rate <= 100
        ),

    CONSTRAINT chk_monthly_payment
        CHECK (monthly_payment >= 0),

    CONSTRAINT chk_late_payments
        CHECK (late_payments >= 0)
);