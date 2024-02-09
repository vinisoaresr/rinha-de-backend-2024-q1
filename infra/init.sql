CREATE TABLE IF NOT EXISTS "users" (
    "id" INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    "limit" int NOT NULL DEFAULT 0,
    "balance" int NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS "transactions" (
    "id" INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    "user_id" int NOT NULL,
    "value" int NOT NULL,
    "description" text NOT NULL,
    "realized_at" text NOT NULL DEFAULT now(),
    "type" text NOT NULL,
    FOREIGN KEY("user_id") REFERENCES "users"("id")
);

CREATE INDEX IF NOT EXISTS "transactions_user_id_index" ON "transactions" ("user_id");

TRUNCATE TABLE users CASCADE;

ALTER SEQUENCE users_id_seq RESTART WITH 1;

INSERT INTO "users" ("limit")
  VALUES
    (1000 * 100),
    (800 * 100),
    (10000 * 100),
    (100000 * 100),
    (5000 * 100);
