-- RedefineTables
PRAGMA defer_foreign_keys=ON;
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_User" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "email" TEXT NOT NULL,
    "emailVerified" DATETIME,
    "name" TEXT,
    "image" TEXT,
    "passwordHash" TEXT,
    "goal" TEXT NOT NULL DEFAULT 'RECOMP',
    "weightKg" REAL NOT NULL,
    "heightCm" REAL NOT NULL,
    "bodyFatPct" REAL,
    "age" INTEGER NOT NULL DEFAULT 30,
    "sex" TEXT NOT NULL DEFAULT 'MALE',
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL
);
INSERT INTO "new_User" ("bodyFatPct", "createdAt", "email", "emailVerified", "goal", "heightCm", "id", "image", "name", "passwordHash", "updatedAt", "weightKg") SELECT "bodyFatPct", "createdAt", "email", "emailVerified", "goal", "heightCm", "id", "image", "name", "passwordHash", "updatedAt", "weightKg" FROM "User";
DROP TABLE "User";
ALTER TABLE "new_User" RENAME TO "User";
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");
PRAGMA foreign_keys=ON;
PRAGMA defer_foreign_keys=OFF;
