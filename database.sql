--syntax for Oracle
CREATE TABLE Accounts (
    SIN VARCHAR2 (20) PRIMARY KEY, fullName VARCHAR2 (100), Balance NUMBER DEFAULT 1000 NOT NULL, pswd VARCHAR2 (20)
);

CREATE TABLE Investments (
    InvestmentID NUMBER PRIMARY KEY, Industry VARCHAR2 (100), RiskLevel VARCHAR2 (50), Quantity NUMBER
);

CREATE TABLE CompanyDetails (
    Company VARCHAR2 (50) PRIMARY KEY, Industry VARCHAR2 (100)
);

CREATE TABLE CryptoDetails (
    Company VARCHAR2 (50) PRIMARY KEY, Industry VARCHAR2 (100)
);

CREATE TABLE Stocks (
    InvestmentID NUMBER PRIMARY KEY, Company VARCHAR2 (100), RiskLevel VARCHAR2 (50), Quantity NUMBER, CONSTRAINT fk_stocks_company FOREIGN KEY (Company) REFERENCES CompanyDetails (Company)
);

CREATE TABLE Crypto (
    InvestmentID NUMBER PRIMARY KEY, CurrencyName VARCHAR2 (100), RiskLevel VARCHAR2 (50), Quantity NUMBER, CONSTRAINT fk_crypto_currencyname FOREIGN KEY (CurrencyName) REFERENCES CryptoDetails (Company)
);

CREATE TABLE DependantRatio (
    PERatio NUMBER PRIMARY KEY, PEGRatio NUMBER
);

CREATE TABLE MarketPriceRatio (
    MarketPrice VARCHAR2 (50) PRIMARY KEY, PERatio NUMBER, PBRatio NUMBER, CONSTRAINT fk_marketpriceratio_peratio FOREIGN KEY (PERatio) REFERENCES DependantRatio (PERatio)
);

CREATE TABLE StockData (
    TickerSymbol VARCHAR2 (50), DateOfTicker DATE, MarketPrice VARCHAR2 (50), PRIMARY KEY (TickerSymbol, DateOfTicker), CONSTRAINT fk_stockdata_marketprice FOREIGN KEY (MarketPrice) REFERENCES MarketPriceRatio (MarketPrice)
);

CREATE TABLE Contains (
    SIN VARCHAR2 (20), InvestmentID NUMBER NOT NULL, CONSTRAINT pk_contains PRIMARY KEY (InvestmentID), CONSTRAINT fk_contains_sin FOREIGN KEY (SIN) REFERENCES Accounts (SIN), CONSTRAINT fk_contains_investmentid FOREIGN KEY (InvestmentID) REFERENCES Investments (InvestmentID) ON DELETE CASCADE
);

CREATE TABLE Updates (
    InvestmentID NUMBER, SIN VARCHAR2 (20), CONSTRAINT pk_updates PRIMARY KEY (InvestmentID), CONSTRAINT fk_updates_investmentid FOREIGN KEY (InvestmentID) REFERENCES Investments (InvestmentID), CONSTRAINT fk_updates_sin FOREIGN KEY (SIN) REFERENCES Accounts (SIN) ON DELETE CASCADE
);

CREATE TABLE Fetches (
    SIN VARCHAR2 (20), TickerSymbol VARCHAR2 (50), DateOfFetch DATE, CONSTRAINT pk_fetches PRIMARY KEY (
        SIN, TickerSymbol, DateOfTicker
    ), CONSTRAINT unq_fetches_ticker_date UNIQUE (TickerSymbol, DateOfFetch), CONSTRAINT fk_fetches_sin FOREIGN KEY (SIN) REFERENCES Accounts (SIN), CONSTRAINT fk_fetches_stockdata FOREIGN KEY (TickerSymbol, DateOfFetch) REFERENCES StockData (TickerSymbol, DateOfTicker) ON DELETE CASCADE
);

CREATE TABLE Displays (
    TickerSymbol VARCHAR2 (20), DateOfTicker DATE, InvestmentID NUMBER NOT NULL, CONSTRAINT pk_displays PRIMARY KEY (
        TickerSymbol, DateOfTicker, InvestmentID
    ), CONSTRAINT fk_displays_stockdata FOREIGN KEY (TickerSymbol, DateOfTicker) REFERENCES StockData (TickerSymbol, DateOfTicker) ON DELETE CASCADE, CONSTRAINT fk_displays_investments FOREIGN KEY (InvestmentID) REFERENCES Investments (InvestmentID) ON DELETE CASCADE
);

-- Inserting data into Accounts table
INSERT INTO
    Accounts (SIN, fullName, Balance, pswd)
VALUES (
        '123456789', 'John Smith', 1000.50, 'password123'
    );

INSERT INTO
    Accounts (SIN, fullName, Balance, pswd)
VALUES (
        '987654321', 'Alice Johnson', 2500.75, 'password234'
    );

INSERT INTO
    Accounts (SIN, fullName, Balance, pswd)
VALUES (
        '456789123', 'Michael Brown', 500.00, 'password345'
    );

INSERT INTO
    Accounts (SIN, fullName, Balance, pswd)
VALUES (
        '789123456', 'Emily Davis', 3765.00, 'password456'
    );

INSERT INTO
    Accounts (SIN, fullName, Balance, pswd)
VALUES (
        '321654987', 'David Wilson', 200.00, 'password567'
    );

INSERT INTO
    Accounts (SIN, fullName, Balance, pswd)
VALUES (
        '234567890', 'Olivia Moore', 3200.75, 'oliviaM2024'
    );

INSERT INTO
    Accounts (SIN, fullName, Balance, pswd)
VALUES (
        '345678901', 'Liam Johnson', 4150.50, 'liamJ2024'
    );

INSERT INTO
    Accounts (SIN, fullName, Balance, pswd)
VALUES (
        '456789012', 'Emma Williams', 5275.25, 'emmaW2024'
    );

INSERT INTO
    Accounts (SIN, fullName, Balance, pswd)
VALUES (
        '567890123', 'Noah Smith', 1900.00, 'noahS2024'
    );

INSERT INTO
    Accounts (SIN, fullName, Balance, pswd)
VALUES (
        '678901234', 'Ava Davis', 2850.00, 'avaD2024'
    );

-- Inserting data into Investments table
INSERT INTO
    Investments (
        InvestmentID, Industry, RiskLevel, Quantity
    )
VALUES (1, 'Technology', 'High', 500);

INSERT INTO
    Investments (
        InvestmentID, Industry, RiskLevel, Quantity
    )
VALUES (
        2, 'Healthcare', 'Medium', 300
    );

INSERT INTO
    Investments (
        InvestmentID, Industry, RiskLevel, Quantity
    )
VALUES (3, 'Finance', 'Low', 700);

INSERT INTO
    Investments (
        InvestmentID, Industry, RiskLevel, Quantity
    )
VALUES (4, 'Energy', 'High', 250);

INSERT INTO
    Investments (
        InvestmentID, Industry, RiskLevel, Quantity
    )
VALUES (
        5, 'Consumer Goods', 'Medium', 400
    );

INSERT INTO
    Investments (
        InvestmentID, Industry, RiskLevel, Quantity
    )
VALUES (
        6, 'Technology', 'Medium', 600
    );

INSERT INTO
    Investments (
        InvestmentID, Industry, RiskLevel, Quantity
    )
VALUES (7, 'Energy', 'Low', 800);

INSERT INTO
    Investments (
        InvestmentID, Industry, RiskLevel, Quantity
    )
VALUES (8, 'Healthcare', 'High', 400);

INSERT INTO
    Investments (
        InvestmentID, Industry, RiskLevel, Quantity
    )
VALUES (9, 'Technology', 'High', 300);

INSERT INTO
    Investments (
        InvestmentID, Industry, RiskLevel, Quantity
    )
VALUES (
        10, 'Consumer Goods', 'Low', 500
    );

-- Inserting data into CompanyDetails table
INSERT INTO
    CompanyDetails (Company, Industry)
VALUES ('Apple Inc.', 'Technology');

INSERT INTO
    CompanyDetails (Company, Industry)
VALUES (
        'Amazon.com Inc.', 'E-commerce'
    );

INSERT INTO
    CompanyDetails (Company, Industry)
VALUES ('Tesla Inc.', 'Automotive');

INSERT INTO
    CompanyDetails (Company, Industry)
VALUES (
        'Johnson & Johnson', 'Healthcare'
    );

INSERT INTO
    CompanyDetails (Company, Industry)
VALUES (
        'Procter & Gamble Co.', 'Consumer Goods'
    );

INSERT INTO
    CompanyDetails (Company, Industry)
VALUES (
        'Microsoft Corp.', 'Technology'
    );

INSERT INTO
    CompanyDetails (Company, Industry)
VALUES ('BP plc', 'Energy');

INSERT INTO
    CompanyDetails (Company, Industry)
VALUES ('Pfizer Inc.', 'Healthcare');

INSERT INTO
    CompanyDetails (Company, Industry)
VALUES ('Nvidia Corp.', 'Technology');

INSERT INTO
    CompanyDetails (Company, Industry)
VALUES (
        'Coca-Cola Co.', 'Consumer Goods'
    );

-- Inserting data into CryptoDetails table
INSERT INTO
    CryptoDetails (Company, Industry)
VALUES ('Bitcoin', 'Cryptocurrency');

INSERT INTO
    CryptoDetails (Company, Industry)
VALUES ('Ethereum', 'Cryptocurrency');

INSERT INTO
    CryptoDetails (Company, Industry)
VALUES ('Ripple', 'Cryptocurrency');

INSERT INTO
    CryptoDetails (Company, Industry)
VALUES ('Litecoin', 'Cryptocurrency');

INSERT INTO
    CryptoDetails (Company, Industry)
VALUES ('Cardano', 'Cryptocurrency');

INSERT INTO
    CryptoDetails (Company, Industry)
VALUES ('Polkadot', 'Cryptocurrency');

INSERT INTO
    CryptoDetails (Company, Industry)
VALUES ('Chainlink', 'Cryptocurrency');

INSERT INTO
    CryptoDetails (Company, Industry)
VALUES (
        'Binance Coin', 'Cryptocurrency'
    );

INSERT INTO
    CryptoDetails (Company, Industry)
VALUES ('Solana', 'Cryptocurrency');

INSERT INTO
    CryptoDetails (Company, Industry)
VALUES ('Monero', 'Cryptocurrency');

-- Inserting data into Stocks table
INSERT INTO
    Stocks (
        InvestmentID, RiskLevel, Quantity, Company
    )
VALUES (34, 'Low', 50, 'Apple Inc.');

INSERT INTO
    Stocks (
        InvestmentID, RiskLevel, Quantity, Company
    )
VALUES (
        48, 'Medium', 20, 'Amazon.com Inc.'
    );

INSERT INTO
    Stocks (
        InvestmentID, RiskLevel, Quantity, Company
    )
VALUES (54, 'High', 10, 'Tesla Inc.');

INSERT INTO
    Stocks (
        InvestmentID, RiskLevel, Quantity, Company
    )
VALUES (
        62, 'Low', 30, 'Johnson & Johnson'
    );

INSERT INTO
    Stocks (
        InvestmentID, RiskLevel, Quantity, Company
    )
VALUES (
        71, 'Low', 25, 'Procter & Gamble Co.'
    );

INSERT INTO
    Stocks (
        InvestmentID, Company, RiskLevel, Quantity
    )
VALUES (
        72, 'Microsoft Corp.', 'Medium', 45
    );

INSERT INTO
    Stocks (
        InvestmentID, Company, RiskLevel, Quantity
    )
VALUES (73, 'BP plc', 'Low', 110);

INSERT INTO
    Stocks (
        InvestmentID, Company, RiskLevel, Quantity
    )
VALUES (74, 'Pfizer Inc.', 'High', 90);

INSERT INTO
    Stocks (
        InvestmentID, Company, RiskLevel, Quantity
    )
VALUES (
        75, 'Nvidia Corp.', 'High', 30
    );

INSERT INTO
    Stocks (
        InvestmentID, Company, RiskLevel, Quantity
    )
VALUES (
        76, 'Coca-Cola Co.', 'Low', 120
    );

-- Inserting data into Crypto table
INSERT INTO
    Crypto (
        InvestmentID, CurrencyName, RiskLevel, Quantity
    )
VALUES (1, 'Bitcoin', 'High', 2.5);

INSERT INTO
    Crypto (
        InvestmentID, CurrencyName, RiskLevel, Quantity
    )
VALUES (2, 'Ethereum', 'Medium', 5.0);

INSERT INTO
    Crypto (
        InvestmentID, CurrencyName, RiskLevel, Quantity
    )
VALUES (3, 'Cardano', 'Low', 10.0);

INSERT INTO
    Crypto (
        InvestmentID, CurrencyName, RiskLevel, Quantity
    )
VALUES (4, 'Ripple', 'High', 3.8);

INSERT INTO
    Crypto (
        InvestmentID, CurrencyName, RiskLevel, Quantity
    )
VALUES (5, 'Litecoin', 'Medium', 7.2);

INSERT INTO
    Crypto (
        InvestmentID, CurrencyName, RiskLevel, Quantity
    )
VALUES (77, 'Polkadot', 'High', 4.0);

INSERT INTO
    Crypto (
        InvestmentID, CurrencyName, RiskLevel, Quantity
    )
VALUES (
        78, 'Chainlink', 'Medium', 6.5
    );

INSERT INTO
    Crypto (
        InvestmentID, CurrencyName, RiskLevel, Quantity
    )
VALUES (
        79, 'Binance Coin', 'Low', 1.2
    );

INSERT INTO
    Crypto (
        InvestmentID, CurrencyName, RiskLevel, Quantity
    )
VALUES (80, 'Solana', 'High', 2.7);

INSERT INTO
    Crypto (
        InvestmentID, CurrencyName, RiskLevel, Quantity
    )
VALUES (81, 'Monero', 'Medium', 3.5);

-- Inserting data into DependantRatio table
INSERT INTO DependantRatio (PERatio, PEGRatio) VALUES (10.5, 1.2);

INSERT INTO DependantRatio (PERatio, PEGRatio) VALUES (15.2, 1.5);

INSERT INTO DependantRatio (PERatio, PEGRatio) VALUES (8.7, 0.9);

INSERT INTO DependantRatio (PERatio, PEGRatio) VALUES (20.3, 1.8);

INSERT INTO DependantRatio (PERatio, PEGRatio) VALUES (12.6, 1.3);

-- Continuing with additional entries
INSERT INTO DependantRatio (PERatio, PEGRatio) VALUES (22.5, 2.1);

INSERT INTO DependantRatio (PERatio, PEGRatio) VALUES (18.7, 1.9);

INSERT INTO DependantRatio (PERatio, PEGRatio) VALUES (14.3, 1.4);

-- Inserting data into MarketPriceRatio table
INSERT INTO
    MarketPriceRatio (MarketPrice, PERatio, PBRatio)
VALUES ('High', 12.6, 1.3);

INSERT INTO
    MarketPriceRatio (MarketPrice, PERatio, PBRatio)
VALUES ('Medium', 15.2, 1.5);

INSERT INTO
    MarketPriceRatio (MarketPrice, PERatio, PBRatio)
VALUES ('Low', 10.5, 1.2);

INSERT INTO
    MarketPriceRatio (MarketPrice, PERatio, PBRatio)
VALUES ('Very High', 20.3, 1.8);

INSERT INTO
    MarketPriceRatio (MarketPrice, PERatio, PBRatio)
VALUES ('Very Low', 8.7, 0.9);

INSERT INTO
    MarketPriceRatio (MarketPrice, PERatio, PBRatio)
VALUES ('Moderate', 22.5, 2.1);

INSERT INTO
    MarketPriceRatio (MarketPrice, PERatio, PBRatio)
VALUES ('Speculative', 18.7, 1.9);

INSERT INTO
    MarketPriceRatio (MarketPrice, PERatio, PBRatio)
VALUES ('Conservative', 14.3, 1.4);

-- Inserting data into StockData table
INSERT INTO
    StockData (
        TickerSymbol, DateOfTicker, MarketPrice
    )
VALUES (
        'AAPL', TO_DATE ('2024-02-28', 'YYYY-MM-DD'), 'High'
    );

INSERT INTO
    StockData (
        TickerSymbol, DateOfTicker, MarketPrice
    )
VALUES (
        'GOOGL', TO_DATE ('2024-02-28', 'YYYY-MM-DD'), 'Medium'
    );

INSERT INTO
    StockData (
        TickerSymbol, DateOfTicker, MarketPrice
    )
VALUES (
        'MSFT', TO_DATE ('2024-02-28', 'YYYY-MM-DD'), 'High'
    );

INSERT INTO
    StockData (
        TickerSymbol, DateOfTicker, MarketPrice
    )
VALUES (
        'AMZN', TO_DATE ('2024-02-28', 'YYYY-MM-DD'), 'Very High'
    );

INSERT INTO
    StockData (
        TickerSymbol, DateOfTicker, MarketPrice
    )
VALUES (
        'FB', TO_DATE ('2024-02-28', 'YYYY-MM-DD'), 'Medium'
    );

INSERT INTO
    StockData (
        TickerSymbol, DateOfTicker, MarketPrice
    )
VALUES (
        'NVDA', TO_DATE ('2024-03-01', 'YYYY-MM-DD'), 'Speculative'
    );

INSERT INTO
    StockData (
        TickerSymbol, DateOfTicker, MarketPrice
    )
VALUES (
        'PFE', TO_DATE ('2024-03-01', 'YYYY-MM-DD'), 'Moderate'
    );

INSERT INTO
    StockData (
        TickerSymbol, DateOfTicker, MarketPrice
    )
VALUES (
        'BP', TO_DATE ('2024-03-01', 'YYYY-MM-DD'), 'Conservative'
    );

-- Inserting data into Contains table
INSERT INTO Contains (SIN, InvestmentID) VALUES ('123456789', 1);

INSERT INTO Contains (SIN, InvestmentID) VALUES ('987654321', 2);

INSERT INTO Contains (SIN, InvestmentID) VALUES ('456789123', 3);

INSERT INTO Contains (SIN, InvestmentID) VALUES ('789123456', 4);

INSERT INTO Contains (SIN, InvestmentID) VALUES ('321654987', 5);

INSERT INTO Contains (SIN, InvestmentID) VALUES ('234567890', 6);

INSERT INTO Contains (SIN, InvestmentID) VALUES ('345678901', 7);

INSERT INTO Contains (SIN, InvestmentID) VALUES ('456789012', 8);

-- Inserting data into Updates table
INSERT INTO Updates (InvestmentID, SIN) VALUES (1, '123456789');

INSERT INTO Updates (InvestmentID, SIN) VALUES (2, '987654321');

INSERT INTO Updates (InvestmentID, SIN) VALUES (3, '456789123');

INSERT INTO Updates (InvestmentID, SIN) VALUES (4, '789123456');

INSERT INTO Updates (InvestmentID, SIN) VALUES (5, '321654987');

-- Assuming SINs and InvestmentIDs from previous examples
INSERT INTO Updates (InvestmentID, SIN) VALUES (9, '567890123');

INSERT INTO Updates (InvestmentID, SIN) VALUES (10, '678901234');

-- Inserting data into Fetches table
-- Inserting for ticker AAPL
INSERT INTO
    Fetches (
        SIN, TickerSymbol, DateOfFetch
    )
SELECT '123456789', 'AAPL', DATE '2024-02-28'
FROM StockData
WHERE
    TickerSymbol = 'AAPL'
    AND DateOfTicker = DATE '2024-02-28';

-- Inserting for ticker GOOGL
INSERT INTO
    Fetches (
        SIN, TickerSymbol, DateOfFetch
    )
SELECT '987654321', 'GOOGL', DATE '2024-02-28'
FROM StockData
WHERE
    TickerSymbol = 'GOOGL'
    AND DateOfTicker = DATE '2024-02-28';

-- Inserting for ticker MSFT
INSERT INTO
    Fetches (
        SIN, TickerSymbol, DateOfFetch
    )
SELECT '456789123', 'MSFT', DATE '2024-02-28'
FROM StockData
WHERE
    TickerSymbol = 'MSFT'
    AND DateOfTicker = DATE '2024-02-28';

-- Inserting for ticker AMZN
INSERT INTO
    Fetches (
        SIN, TickerSymbol, DateOfFetch
    )
SELECT '789123456', 'AMZN', DATE '2024-02-28'
FROM StockData
WHERE
    TickerSymbol = 'AMZN'
    AND DateOfTicker = DATE '2024-02-28';

-- Inserting for ticker FB
INSERT INTO
    Fetches (
        SIN, TickerSymbol, DateOfFetch
    )
SELECT '321654987', 'FB', DATE '2024-02-28'
FROM StockData
WHERE
    TickerSymbol = 'FB'
    AND DateOfTicker = DATE '2024-02-28';

-- Assuming SINs and TickerSymbols from previous examples
INSERT INTO
    Fetches (
        SIN, TickerSymbol, DateOfFetch
    )
VALUES (
        '234567890', 'NVDA', TO_DATE ('2024-03-01', 'YYYY-MM-DD')
    );

INSERT INTO
    Fetches (
        SIN, TickerSymbol, DateOfFetch
    )
VALUES (
        '345678901', 'PFE', TO_DATE ('2024-03-01', 'YYYY-MM-DD')
    );

INSERT INTO
    Fetches (
        SIN, TickerSymbol, DateOfFetch
    )
VALUES (
        '456789012', 'BP', TO_DATE ('2024-03-01', 'YYYY-MM-DD')
    );

-- Inserting data into Displays table
INSERT INTO
    Displays (
        TickerSymbol, DateOfTicker, InvestmentID
    )
VALUES (
        'AAPL', TO_DATE ('2024-02-28', 'YYYY-MM-DD'), 1
    );

INSERT INTO
    Displays (
        TickerSymbol, DateOfTicker, InvestmentID
    )
VALUES (
        'GOOGL', TO_DATE ('2024-02-28', 'YYYY-MM-DD'), 2
    );

INSERT INTO
    Displays (
        TickerSymbol, DateOfTicker, InvestmentID
    )
VALUES (
        'MSFT', TO_DATE ('2024-02-28', 'YYYY-MM-DD'), 3
    );

INSERT INTO
    Displays (
        TickerSymbol, DateOfTicker, InvestmentID
    )
VALUES (
        'AMZN', TO_DATE ('2024-02-28', 'YYYY-MM-DD'), 4
    );

INSERT INTO
    Displays (
        TickerSymbol, DateOfTicker, InvestmentID
    )
VALUES (
        'FB', TO_DATE ('2024-02-28', 'YYYY-MM-DD'), 5
    );

-- Assuming TickerSymbols, DateOfTickers, and InvestmentIDs from previous examples
INSERT INTO
    Displays (
        TickerSymbol, DateOfTicker, InvestmentID
    )
VALUES (
        'NVDA', TO_DATE ('2024-03-01', 'YYYY-MM-DD'), 6
    );

INSERT INTO
    Displays (
        TickerSymbol, DateOfTicker, InvestmentID
    )
VALUES (
        'PFE', TO_DATE ('2024-03-01', 'YYYY-MM-DD'), 7
    );

INSERT INTO
    Displays (
        TickerSymbol, DateOfTicker, InvestmentID
    )
VALUES (
        'BP', TO_DATE ('2024-03-01', 'YYYY-MM-DD'), 8
    );