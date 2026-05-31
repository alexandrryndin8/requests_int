CREATE TABLE "stock_threshold_counters" (
    "id" SERIAL NOT NULL,
    "product_name" TEXT NOT NULL,
    "current_count" INTEGER NOT NULL DEFAULT 0,
    "threshold" INTEGER NOT NULL DEFAULT 1000,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "stock_threshold_counters_pkey" PRIMARY KEY ("id")
);

CREATE UNIQUE INDEX "stock_threshold_counters_product_name_key"
ON "stock_threshold_counters"("product_name");

CREATE TABLE "admin_notifications" (
    "id" SERIAL NOT NULL,
    "message" TEXT NOT NULL,
    "is_read" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "read_at" TIMESTAMPTZ(6),
    "read_by" TEXT,

    CONSTRAINT "admin_notifications_pkey" PRIMARY KEY ("id")
);

CREATE INDEX "admin_notifications_is_read_created_at_idx"
ON "admin_notifications"("is_read", "created_at");
