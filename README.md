# dbt Fundamentals — Jaffle Shop

Projet réalisé dans le cadre de la formation **dbt Fundamentals** (learn.getdbt.com), adapté pour **PostgreSQL** en local (au lieu de Snowflake).

## Stack technique

- dbt-core 1.11.8 + dbt-postgres 1.10.0
- PostgreSQL 15 (Docker)
- Python 3.12
- Packages : codegen 0.14.1, dbt_utils 1.3.3

## Structure du projet

```
models/
├── staging/
│   ├── jaffle_shop/
│   │   ├── stg_jaffle_shop__customers.sql
│   │   ├── stg_jaffle_shop__orders.sql
│   │   ├── _src_jaffle_shop.yml       # déclaration des sources
│   │   ├── _stg_jaffle_shop.yml       # tests & documentation
│   │   └── _jaffle_shop_docs.md       # doc blocks (order_status)
│   └── stripe/
│       ├── stg_stripe__payments.sql
│       ├── _src_stripe.yml
│       └── _stg_stripe.yml
└── marts/
    ├── finance/
    │   ├── fct_orders.sql
    │   └── _models_finance.yml
    └── marketing/
        ├── dim_customers.sql
        └── _models_marketing.yml

tests/
└── assert_stg_stripe_positive_total_payment.sql  # test singulier
```

## Matérialisations

| Couche   | Type  |
|----------|-------|
| staging  | view  |
| marts    | table |

## Lineage (DAG)

```
jaffle_shop_customers  →  stg_jaffle_shop__customers  ↘
                                                        dim_customers
jaffle_shop_orders     →  stg_jaffle_shop__orders     →  fct_orders  ↗

stripe_payments        →  stg_stripe__payments        ↗
```

## Tests

**Tests génériques** (unique, not_null, accepted_values, relationships) sur tous les modèles staging et marts.

**Test singulier** : vérifie qu'aucun order_id n'a un montant total négatif dans les paiements Stripe.

## Commandes utiles

```bash
# Charger les données sources
dbt seed

# Compiler et exécuter tous les modèles
dbt run

# Exécuter les tests
dbt test

# Exécuter modèles + tests en une commande
dbt build

# Générer et visualiser la documentation + lineage
dbt docs generate
dbt docs serve --port 8081
```

## Adaptations PostgreSQL

Ce projet a été adapté de Snowflake vers PostgreSQL :

- Les colonnes sources sont en MAJUSCULES — elles sont référencées avec des guillemets doubles (`"ID"`, `"FIRST_NAME"`, etc.) dans les modèles staging
- Les montants Stripe sont en centimes — divisés par 100 dans `stg_stripe__payments`
- Les tests génériques dbt ne sont pas appliqués sur les colonnes sources (incompatibilité avec les identifiants en MAJUSCULES) — ils sont appliqués sur les modèles staging après renommage
