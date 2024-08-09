-- Represent the property listed for sale on the market
CREATE TABLE "property" (
    "id" INTEGER,
    "address" TEXT NOT NULL UNIQUE,
    "listing price" INTEGER NOT NULL,
    "bedrooms" INTEGER NOT NULL,
    "bathrooms" REAL NOT NULL,
    "type" TEXT NOT NULL CHECK("type" IN ('single family home', 'townhome', 'condo','land','multiple family','mobile','co-op','other')),
    "year" INTEGER NOT NULL CHECK("year" > 1799 AND "year" <2025),
    "status" TEXT NOT NULL CHECK("status" IN ('For Sale - Active', 'Under Contract', 'Bids Received','Others')),
    "description" TEXT,
    PRIMARY KEY("id")
);

-- Represent buyers choosing the real estate brokerage company
CREATE TABLE "buyer" (
    "id" INTEGER,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    "phone number" INTEGER NOT NULL UNIQUE CHECK("phone number" LIKE '__________'), --10 digit number, pattern set for 10 _
    "email_id" TEXT NOT NULL UNIQUE CHECK("email_id" LIKE '%@%.com'),
    PRIMARY KEY("id")
);

-- Represent mortgage agent hired by the buyer
CREATE TABLE "mortgage_agent" (
    "id" INTEGER,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    "buyer_id" INTEGER,
    PRIMARY KEY("id"),
    FOREIGN KEY("buyer_id") REFERENCES "buyer"("id"),
);

-- Represent lead buyer agent assigned to the buyer
CREATE TABLE "buyer_lead_agent" (
    "id" INTEGER,
    "buyer_id" INTEGER,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    "phone number" INTEGER NOT NULL UNIQUE CHECK("phone number" LIKE '__________'), --10 digit number, pattern set for 10 _
    PRIMARY KEY("id"),
    FOREIGN KEY("student_id") REFERENCES "students"("id"),
);

-- Represent hierarchy of associate agents under lead agents
CREATE TABLE "buyer_associate_agent" (
    "id" INTEGER,
    "lead_agent_id" INTEGER,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    "phone number" INTEGER NOT NULL UNIQUE CHECK("phone number" LIKE '__________'), --10 digit number, pattern set for 10 _
    PRIMARY KEY("id"),
    FOREIGN KEY("lead_agent_id") REFERENCES "buyer_lead_agent"("id")
    );

-- Represent tours booked by buyers
CREATE TABLE "tours" (
    "id" INTEGER,
    "date" DATETIME NOT NULL,
    "property_id" INTEGER,
    "buyer_id" INTEGER,
    "associate_agent_id" INTEGER,
    PRIMARY KEY("id"),
    FOREIGN KEY("property_id") REFERENCES "property"("id"),
    FOREIGN KEY("buyer_id") REFERENCES "buyer"("id"),
    FOREIGN KEY("associate_agent_id") REFERENCES "buyer_associate_agent"("id")
);

-- Represent the tax and sale records of the property
CREATE TABLE "tax_and_sale_records" (
    "id" INTEGER,
    "property_id" INTEGER,
    "tax_year" INTEGER CHECK("tax_year" LIKE '19__' OR "tax_year" LIKE '20__'),
    "tax_amount" INTEGER,
    "sale_date" DATETIME,
    "sale_amount" INTEGER,
    PRIMARY KEY("id"),
    FOREIGN KEY("property_id") REFERENCES "property"("id")
);

-- Represent sellers choosing the real estate brokerage company
CREATE TABLE "seller" (
    "id" INTEGER,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    "phone number" INTEGER NOT NULL UNIQUE CHECK("phone number" LIKE '__________'), --10 digit number, pattern set for 10 _
    "email_id" TEXT NOT NULL UNIQUE CHECK("email_id" LIKE '%@%.com'),
    PRIMARY KEY("id")
);

-- Represent seller agent assigned to the buyer
CREATE TABLE "seller_agent" (
    "id" INTEGER,
    "seller_id" INTEGER,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    "phone number" INTEGER NOT NULL UNIQUE CHECK("phone number" LIKE '__________'), --10 digit number, pattern set for 10 _
    PRIMARY KEY("id"),
    FOREIGN KEY("seller_id") REFERENCES "seller"("id")
);

-- Create indexes to speed common searches
CREATE INDEX "property_filter" ON "property" ("listing price", "type","year","status");
CREATE INDEX "tour_plan" ON "tours" ("date");
CREATE INDEX "agent_hierarchy" ON "buyer_associate_agent" ("lead_agent_id");

CREATE VIEW "tour_plan" AS
SELECT "buyer"."first_name", "buyer"."last_name", "buyer"."phone_number", "property"."address", "tours"."date",
    "buyer_associate_agent"."first_name","buyer_associate_agent"."last_name","buyer_associate_agent"."phone_number"
    AS "buyer_fname","buyer_lname","buyer_phone","address","date","agent_fname","agent_lname","agent_phone"
    FROM "buyer" JOIN "tours" ON "buyer"."id" = "tours"."buyer_id"
    JOIN "property" ON "tours"."property_id" = "property"."id"
    JOIN "tours"."associate_agent_id" = "buyer_associate_agent"."id";
