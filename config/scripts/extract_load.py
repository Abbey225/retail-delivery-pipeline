import os
import json
import psycopg2

def run_extraction_pipeline():
    conn = psycopg2.connect(
        host=os.getenv("DB_HOST", "localhost"),
        database=os.getenv("DB_NAME", "retail_warehouse"),
        user=os.getenv("DB_USER", "data_engineer"),
        password=os.getenv("DB_PASSWORD", "supersecurepassword123"),
        port=os.getenv("DB_PORT", "5432")
    )
    cursor = conn.cursor()

    cursor.execute("""
        CREATE TABLE IF NOT EXISTS raw_transactions (
            id SERIAL PRIMARY KEY,
            raw_data JSONB,
            ingested_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        );
    """)
    conn.commit()

    mock_payload = {
        "transaction_id": "TXN_77491",
        "customer": {"id": "CUST_991", "name": "Emeka Obi", "email": "emeka@example.com"},
        "items": [
            {"product_id": "PROD_44", "name": "Ergonomic Office Chair", "price": 120.00, "qty": 1},
            {"product_id": "PROD_12", "name": "USB-C Hub", "price": 45.00, "qty": 2}
        ],
        "store_id": "STORE_LAGOS_01",
        "purchase_timestamp": "2026-09-24T10:15:00Z"
    }

    cursor.execute(
        "INSERT INTO raw_transactions (raw_data) VALUES (%s);",
        (json.dumps(mock_payload),)
    )
    conn.commit()
    print("🚀 Ingestion phase successful! Raw transaction data stored.")
    
    cursor.close()
    conn.close()

if __name__ == "__main__":
    run_extraction_pipeline()
