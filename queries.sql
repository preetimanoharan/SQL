-- Find all properties built after 1978 and listed for less than $400k in Illinois
SELECT *
FROM "property"
WHERE "year" > 1978 AND "listing price" < 400000 AND "address" LIKE '%,IL';

-- Find all associate agents working for a particular lead agent
SELECT *
FROM "buyer_associate_agent"
WHERE "lead_agent_id" = (
    SELECT "id"
    FROM "buyer_lead_agent"
    WHERE "first_name" = 'Jennifer' AND "last_name" = 'Engel'
);

-- Find all the buyers who booked tours for a particular property
SELECT *
FROM "buyer"
WHERE "id" = (
    SELECT "buyer_id"
    FROM "tours"
    WHERE "property_id" = (
        SELECT "id"
        FROM "property"
        WHERE "address" = '9300 S Trumbull Ave, Evergreen Park, IL 60805'
));

-- Find all the buyers who have not hired a mortgage agent
SELECT *
FROM "buyer"
WHERE "id" != (
    SELECT "buyer_id"
    FROM "mortgage_agent"
);

-- Add 2023 tax information for a property
INSERT INTO "tax_and_sale_records" ("property_id", "tax_year","tax_amount")
VALUES ('456789', '2023', '6975');

-- Add a new property
INSERT INTO "property" ("address", "listing price","bedrooms","bathrooms","type","year","status")
VALUES ('9300 S Trumbull Ave, Evergreen Park, IL 60805', '379900','4','1.5','single family home','1893','For Sale - Active');

-- Add a new tour booked by a buyer
INSERT INTO "tours" ("date", "property_id", "buyer_id", "associate_agent_id")
VALUES ('2024-08-07 10:00:00.000', '456789', '356', '78');

--Lower the listed price of a property
UPDATE "property"
SET "listing price" = '360000'
WHERE "address" = '9300 S Trumbull Ave, Evergreen Park, IL 60805';

--cancel a tour booked by buyer
DELETE FROM "tours"
WHERE "date" = '2024-08-07 10:00:00.000'
AND "buyer_id" = (SELECT "id" FROM "buyer" WHERE "phone number" = 5516097283);
