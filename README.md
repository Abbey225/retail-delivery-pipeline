# End-to-End Modern Retail ELT Pipeline (SSIS Migration Project)

This project serves as a showcase migration pattern, moving traditional on-premise transactional processes into a modern code-first engineering architecture.

## 🏗️ Architecture Layout
1. **Extract & Load:** Python pipelines ingest semi-structured JSON transactional streams and land them inside a staging engine.
2. **Transform (ELT):** Post-load parsing engine denormalizes records out of JSON variants to build a Star Schema warehouse footprint.
3. **Infrastructure:** Contained and containerized environments matching target staging clouds.

## 🛠️ Stack Configuration
* **Database Staging Environment:** PostgreSQL 15 (Inside Docker Container)
* **Ingestion Layer:** Python 3 (psycopg2 engine)
* **Modeling & Schema Design:** SQL DDL/DML (Dimensional Fact/Dimension Modeling)
