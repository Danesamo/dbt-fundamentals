# dbt Fundamentals — Jaffle Shop

Projet réalisé dans le cadre de la formation **dbt Fundamentals** (learn.getdbt.com), adapté pour **PostgreSQL** en local (au lieu de Snowflake).

## Stack technique

- dbt-core 1.11.8 + dbt-postgres 1.10.0
- PostgreSQL 15 (Docker)
- Python 3.12

## Structure du projet

```
models/
├── staging/        # Couche de traduction des sources brutes
│   ├── stg_jaffle_shop_customers.sql
│   └── stg_jaffle_shop_orders.sql
└── marts/          # Modèles finaux exposés pour la BI
    └── dim_customers.sql

seeds/              # Données sources chargées via dbt seed
├── jaffle_shop_customers.csv
├── jaffle_shop_orders.csv
└── stripe_payments.csv
```

## Matérialisations

| Couche   | Type  |
|----------|-------|
| staging  | view  |
| marts    | table |

## Commandes utiles

```bash
# Charger les données sources
dbt seed

# Compiler et exécuter tous les modèles
dbt run

# Exécuter un modèle et ses dépendances upstream
dbt run --select +dim_customers

# Générer et visualiser la documentation + lineage
dbt docs generate
dbt docs serve --port 8081
```

## Lineage

`stg_jaffle_shop_customers` ↘

`stg_jaffle_shop_orders`    ↗  →  `dim_customers`
